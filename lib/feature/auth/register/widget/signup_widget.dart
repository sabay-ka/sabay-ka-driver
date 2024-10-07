import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
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
  final _formKey = GlobalKey<FormState>();

  Future<void> signUpWithGoogle(BuildContext context, GlobalKey<FormState> formKey, String firstName, String lastName, String phoneNumber) async {
    if (!formKey.currentState!.validate()) return;

    try {
      await locator<PocketbaseService>().signUpWithGoogle(
        firstName: firstName,
        lastName: lastName,
        phoneNumber: phoneNumber,
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
      SnackBarUtils.showErrorBar(context: context, message: e.response.cast()["message"]);
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
            CustomRoundedButtom(
                title: "Sign Up",
                onPressed: () => _SignUpWidgetState().signUpWithGoogle(context, _formKey,
                    firstNameController.text, lastNameController.text, phoneNumberController.text),
            ),
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
