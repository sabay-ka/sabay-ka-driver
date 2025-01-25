import 'package:flutter/material.dart';
import 'package:sabay_ka/app/text_style.dart';
import 'package:sabay_ka/common/constant/assets.dart';
import 'package:sabay_ka/common/theme.dart';
import 'package:sabay_ka/common/utils/size_utils.dart';
import 'package:sabay_ka/common/widget/custom_button.dart';
import 'package:sabay_ka/common/widget/page_wrapper.dart';
import 'package:sabay_ka/feature/auth/register/screen/signup_page.dart';
import 'package:sabay_ka/feature/dashboard/dashboard_widget.dart';
import 'package:sabay_ka/main.dart';
import 'package:sabay_ka/services/pocketbase_service.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:sabay_ka/common/utils/snackbar_utils.dart';

class WelcomeWidget extends StatelessWidget {
  const WelcomeWidget({super.key});

  void signInWithGoogle(BuildContext context) async {
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
    return PageWrapper(
      padding: const EdgeInsets.all(22),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: _buildPage(
                imageAsset: Assets.welcomeScreenImage,
                title: "Sabay Ka? Driver",
                description: "The driver app for Sabay Ka? platform",
              ),
            ),
            CustomRoundedButtom(
              title: "Create an account",
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SignUpPage(),
                    ));
              },
            ),
            CustomRoundedButtom(
              color: Colors.transparent,
              title: "Sign in with Google",
              textColor: CustomTheme.primaryColor,
              borderColor: CustomTheme.primaryColor,
              onPressed: () => WelcomeWidget().signInWithGoogle(context) 
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPage(
      {required String imageAsset,
      required String title,
      required String description}) {
    return Column(
      children: [
        Image.asset(imageAsset),
        Padding(
          padding: const EdgeInsets.all(56.0),
          child: Column(
            children: [
              Text(
                title,
                style: PoppinsTextStyles.titleMediumRegular
                    .copyWith(color: CustomTheme.darkerBlack),
              ),
              SizedBox(height: 10.hp),
              Text(
                description,
                style: PoppinsTextStyles.subheadSmallRegular,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
