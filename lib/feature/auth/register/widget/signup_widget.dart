import 'dart:io';

import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:sabay_ka/common/theme.dart';
import 'package:sabay_ka/common/utils/snackbar_utils.dart';
import 'package:sabay_ka/common/widget/common_container.dart';
import 'package:sabay_ka/common/widget/custom_button.dart';
import 'package:sabay_ka/common/widget/custom_text_field.dart';
import 'package:sabay_ka/feature/auth/welcomeScreen/widget/welcome_widget.dart';
import 'package:sabay_ka/feature/dashboard/dashboard_widget.dart';
import 'package:sabay_ka/main.dart';
import 'package:sabay_ka/services/pocketbase_service.dart';

class SignUpWidget extends StatefulWidget {
  const SignUpWidget({super.key});

  @override
  State<SignUpWidget> createState() => _SignUpWidgetState();
}

class _SignUpWidgetState extends State<SignUpWidget> {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneNumberController = TextEditingController();
  String _vehicleType = "Car";
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  // Image picker
  final _picker = ImagePicker();
  List<XFile>? _vehicleImages;
  XFile? _plateNumber;

  Future<void> signUpWithGoogle(
      BuildContext context,
      GlobalKey<FormState> formKey,
      String firstName,
      String lastName,
      String phoneNumber,
      XFile? plateNumber,
      List<XFile>? vehicleImages,
      String vehicleType) async {
    if (!formKey.currentState!.validate()) return;
    if (plateNumber == null) {
      SnackBarUtils.showErrorBar(
          context: context, message: "Please upload your plate number");
      return;
    }
    if (vehicleImages == null) {
      SnackBarUtils.showErrorBar(
          context: context, message: "Please upload your vehicle images");
      return;
    }

    try {
      await locator<PocketbaseService>().signUpWithGoogle(
        firstName: firstName,
        lastName: lastName,
        phoneNumber: phoneNumber,
        plateNumber: plateNumber,
        vehicleImages: vehicleImages,
        vehicleType: vehicleType,
      );
      if (!context.mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const DashboardWidget(),
        ),
        (route) => false,
      );
    } on ClientException catch (e) {
      if (!context.mounted) return;
      SnackBarUtils.showErrorBar(
          context: context, message: e.response.cast()["message"]);
    }
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CommonContainer(
      appBarTitle: "Sign Up",
      title: "Sign up with your Google account",
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            ReusableTextField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              controller: firstNameController,
              hintText: "First Name",
              validator: ValidationBuilder().required().build(),
            ),
            ReusableTextField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              controller: lastNameController,
              hintText: "Last Name",
              validator: ValidationBuilder().required().build(),
            ),
            ReusableTextField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              controller: phoneNumberController,
              hintText: "Phone Number",
              validator: ValidationBuilder().phone().required().build(),
            ),
            FilledButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(CustomTheme.appColor),
                ),
                child: const Text("Upload Plate Number"),
                onPressed: () async {
                  final XFile? image =
                      await _picker.pickImage(source: ImageSource.gallery);
                  if (image == null) return;
                  setState(() {
                    _plateNumber = image;
                  });
                }),
            // Preview image
            if (_plateNumber != null)
              Image.file(
                File(_plateNumber!.path),
                width: 100,
                height: 100,
              ),
            FilledButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(CustomTheme.appColor),
                ),
                child: const Text("Upload Vehicle Images"),
                onPressed: () async {
                  final List<XFile> images = await _picker.pickMultiImage();
                  setState(() {
                    _vehicleImages = images;
                  });
                }),
            if (_vehicleImages != null)
              SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _vehicleImages!.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.file(
                        File(_vehicleImages![index].path),
                        width: 100,
                        height: 100,
                      ),
                    );
                  },
                ),
              ),
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    RadioListTile<String>(
                      title: Row(
                        children: const [
                          Icon(Icons.motorcycle),
                          SizedBox(width: 8),
                          Text("Motorcycle")
                        ],
                      ),
                      value: 'Tricycle',
                      groupValue: _vehicleType,
                      onChanged: (String? value) {
                        if (value == null) return;
                        setState(() {
                          _vehicleType = value;
                        });
                      },
                    ),
                  ],
                )),
            CustomRoundedButtom(
                title: "Sign Up",
                onPressed: () {
                  setState(() {
                    _isLoading = true;
                  });
                  _SignUpWidgetState().signUpWithGoogle(
                      context,
                      _formKey,
                      firstNameController.text,
                      lastNameController.text,
                      phoneNumberController.text,
                      _plateNumber,
                      _vehicleImages,
                      _vehicleType);
                  setState(() {
                    _isLoading = false;
                  });
                }),
            if (_isLoading) const CircularProgressIndicator(),
            Center(
              child: InkWell(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const WelcomeWidget(),
                    ),
                  );
                },
                child: RichText(
                  text: const TextSpan(
                    text: 'Already have an account? ',
                    style: TextStyle(color: Colors.black),
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Sign in',
                        style: TextStyle(color: CustomTheme.appColor),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
