import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:sabay_ka/common/theme.dart';
import 'package:sabay_ka/common/utils/size_utils.dart';
import 'package:sabay_ka/common/utils/snackbar_utils.dart';
import 'package:sabay_ka/common/widget/common_container.dart';
import 'package:sabay_ka/common/widget/custom_button.dart';
import 'package:sabay_ka/common/widget/custom_text_field.dart';
import 'package:sabay_ka/feature/auth/login/login_page.dart';

class SignUpWidget extends StatefulWidget {
  const SignUpWidget({super.key});

  @override
  State<SignUpWidget> createState() => _SignUpWidgetState();
}

class _SignUpWidgetState extends State<SignUpWidget> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final _fromKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return CommonContainer(
      appBarTitle: "Sign Up",
      title: "Sign up with your email or phone number",
      body: Form(
        key: _fromKey,
        child: Column(
          children: [
            ReusableTextField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              controller: nameController,
              hintText: "Name",
              validator: ValidationBuilder().required().build(),
            ),
            ReusableTextField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              controller: emailController,
              hintText: "Email",
              validator: ValidationBuilder().email().required().build(),
            ),
            ReusableTextField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              controller: phoneNumberController,
              hintText: "Phone Number",
              validator: ValidationBuilder().phone().required().build(), 
            ),
            CustomRoundedButtom(
                title: "Sign Up",
                onPressed: () {
                  if (_fromKey.currentState!.validate()) {
                    SnackBarUtils.showErrorBar(
                        context: context,
                        message: "This feature is still in progress.");
                  }
                }),
            Stack(
              alignment: Alignment.center,
              children: [
                const Divider(
                  thickness: 2,
                ),
                Container(
                  color: CustomTheme.lightColor,
                  width: 30.wp,
                  child: const Text(
                    "or",
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            CustomRoundedButtom(
              onPressed: () {},
              title: "Sign up with Gmail",
              color: Colors.transparent,
              textColor: CustomTheme.darkColor.withOpacity(0.6),
              borderColor: CustomTheme.appColor,
            ),
            Center(
              child: InkWell(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginWidget(),
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

  final gederList = ["Male", "Female", "Other"];
}
