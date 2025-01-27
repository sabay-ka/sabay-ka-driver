import 'package:flutter/material.dart';
import 'package:sabay_ka/app/text_style.dart';
import 'package:sabay_ka/common/constant/assets.dart';
import 'package:sabay_ka/common/theme.dart';
import 'package:sabay_ka/common/utils/size_utils.dart';
import 'package:sabay_ka/common/widget/common_container.dart';
import 'package:sabay_ka/common/widget/common_popup_box.dart';
import 'package:sabay_ka/common/widget/custom_text_field.dart';
import 'package:sabay_ka/common/widget/form_validator.dart';
import 'package:sabay_ka/feature/dashboard/dashboard_widget.dart';

class ContactUsWidget extends StatelessWidget {
  ContactUsWidget({super.key});
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final remarksController = TextEditingController();

  final phoneNumberController = TextEditingController();
  final _fromKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return CommonContainer(
        onButtonPressed: () {
          if (_fromKey.currentState!.validate()) {
            showCommonPopUpDialog(
                imageUrl: Assets.successAlertImage,
                context: context,
                title: "Success",
                message:
                    "Thank you for your feedback. We will contact you soon. Please contact office for any information.",
                enableButtonName: "Done",
                onEnablePressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DashboardWidget(),
                    ),
                    (route) => false,
                  );
                });
          }
        },
        buttonName: "Send Message",
        appBarTitle: "Contact Us",
        body: Form(
          key: _fromKey,
          child: Column(
            children: [
              SizedBox(height: 10.hp),
              Text(
                "Contact us for Ride share \n\nAddress",
                textAlign: TextAlign.center,
                style: PoppinsTextStyles.headlineMediumRegular,
              ),
              SizedBox(height: 5.hp),
              Text(
                "House# 72, Road# 21, Banani, Dhaka-1213 (near Banani\nBidyaniketon School &\nCollege, beside University of South Asia)",
                textAlign: TextAlign.center,
                style: PoppinsTextStyles.bodySmallRegular
                    .copyWith(color: CustomTheme.darkGray.withOpacity(0.5)),
              ),
              SizedBox(height: 10.hp),
              Text(
                textAlign: TextAlign.center,
                "Call : 13301 (24/7)\nEmail : support@pathao.com",
                style: PoppinsTextStyles.bodySmallRegular
                    .copyWith(color: CustomTheme.darkGray.withOpacity(0.5)),
              ),
              SizedBox(height: 10.hp),
              Text(
                textAlign: TextAlign.center,
                "Send Message",
                style: PoppinsTextStyles.bodyLargeRegular
                    .copyWith(fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 10.hp),
              ReusableTextField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: nameController,
                hintText: "Name",
                validator: (value) =>
                    FormValidator.validateFieldNotEmpty(value, "Name"),
              ),
              ReusableTextField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: emailController,
                hintText: "Email",
                validator: (value) => FormValidator.validateEmail(value),
              ),
              ReusableTextField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: phoneNumberController,
                hintText: "Phone Number",
                validator: (value) => FormValidator.validatePhoneNumber(value),
              ),
              ReusableTextField(
                maxLine: 4,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: remarksController,
                hintText: "Weite your text",
                validator: (value) =>
                    FormValidator.validateFieldNotEmpty(value, "This"),
              ),
            ],
          ),
        ));
  }
}
