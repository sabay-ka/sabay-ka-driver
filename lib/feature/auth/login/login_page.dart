import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:sabay_ka/common/theme.dart';
import 'package:sabay_ka/common/utils/size_utils.dart';
import 'package:sabay_ka/common/utils/snackbar_utils.dart';
import 'package:sabay_ka/common/widget/common_container.dart';
import 'package:sabay_ka/common/widget/custom_button.dart';
import 'package:sabay_ka/common/widget/custom_text_field.dart';
import 'package:sabay_ka/feature/auth/register/screen/signup_page.dart';
import 'package:sabay_ka/feature/dashboard/dashboard_widget.dart';
import 'package:sabay_ka/main.dart';
import 'package:sabay_ka/services/pocketbase_service.dart';

class LoginWidget extends StatefulWidget {
  const LoginWidget({super.key});

  @override
  State<LoginWidget> createState() => _LoginWidget();
}

class _LoginWidget extends State<LoginWidget> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<void> signInWithEmailAndPassword(BuildContext context, GlobalKey<FormState> formKey) async {
    if (formKey.currentState!.validate()) {
      try {
        await locator<PocketbaseService>().signInWithEmailAndPassword(
            email: emailController.text, password: passwordController.text);

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
  }

  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      await locator<PocketbaseService>().signInWithGoogle();
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
  Widget build(BuildContext context) {
    return CommonContainer(
      appBarTitle: "Sign In",
      title: "Sign in with your email or phone number",
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            ReusableTextField(
              validator: ValidationBuilder().email().required().build(),
              controller: emailController,
              hintText: "Email",
            ),
            ReusableTextField(
              validator: ValidationBuilder().required().build(),
              controller: passwordController,
              hintText: "Password",
              obscureText: true,
            ),
            CustomRoundedButtom(
                title: "Sign In",
                onPressed: () => _LoginWidget().signInWithEmailAndPassword(context, _formKey), 
            ),
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
              onPressed: () => _LoginWidget().signInWithGoogle(context),
              title: "Sign in with Gmail",
              color: Colors.transparent,
              textColor: CustomTheme.darkColor.withOpacity(0.6),
              borderColor: CustomTheme.appColor,
            ),
            Center(
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SignUpPage(),
                    ),
                  );
                },
                child: RichText(
                  text: const TextSpan(
                    text: 'Don’t have an account? ',
                    style: TextStyle(color: Colors.black),
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Sign Up',
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
