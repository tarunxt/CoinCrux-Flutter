import 'package:coincrux/screens/dashboard/dashboard_view.dart';
import 'package:coincrux/utils/validator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../../base/resizer/fetch_pixels.dart';
import '../../../base/widget_utils.dart';
import '../../../resources/resources.dart';
import '../../../widgets/my_button.dart';
import '../../dashboard/settings/pages/your_feed.dart';
import '../personalise_feed/personlise_feed.dart';
import '../provider/auth_provider.dart';

class NameDialog extends StatefulWidget {
  const NameDialog({
    Key? key,
  }) : super(key: key);

  @override
  State<NameDialog> createState() => _NameDialogState();
}

class _NameDialogState extends State<NameDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> scaleAnimation;
  TextEditingController nameCT = TextEditingController();
  @override
  void initState() {
    super.initState();

    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    scaleAnimation =
        CurvedAnimation(parent: controller, curve: Curves.easeInOut);

    controller.addListener(() {
      setState(() {});
    });

    controller.forward();
  }

  var horSpace = FetchPixels.getPixelHeight(20);

  @override
  Widget build(BuildContext context) {
    FetchPixels(context);
    AuthProviderApp auth = Provider.of<AuthProviderApp>(context, listen: false);
    return ScaleTransition(
      alignment: Alignment.center,
      scale: scaleAnimation,
      child: Dialog(
        insetPadding:
            EdgeInsets.symmetric(horizontal: FetchPixels.getPixelWidth(20)),
        shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(FetchPixels.getPixelHeight(22))),
        child: getPaddingWidget(
          EdgeInsets.symmetric(horizontal: FetchPixels.getPixelWidth(40)),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.min,
            children: [
              getVerSpace(FetchPixels.getPixelHeight(30)),
              Text(
                "Welcome to CoinCrux!",
                style: R.textStyle.mediumLato().copyWith(
                    fontSize: FetchPixels.getPixelHeight(25),
                    color: R.colors.blackColor),
              ),
              getVerSpace(FetchPixels.getPixelHeight(20)),
              // getMultilineCustomFont(widget.text, 16, R.colors.unSelectedIcon,
              //     fontWeight: FontWeight.w400,
              //     txtHeight: FetchPixels.getPixelHeight(1.5),
              //     textAlign: TextAlign.center),
              TextFormField(
                controller: nameCT,
                keyboardType: TextInputType.name,
                textInputAction: TextInputAction.done,
                validator: (v) => FieldValidator.validateName(v!),
                decoration: R.decorations
                    .textFormFieldDecoration(null, "Enter your full name"),
              ),
              getVerSpace(FetchPixels.getPixelHeight(25)),
              MyButton(
                onTap: () {
                  auth.name = nameCT.text;
                  Get.to(PersonaliseFeed());
                },
                buttonText: "Save",
                color: R.colors.theme,
              ),
              getVerSpace(FetchPixels.getPixelHeight(30)),
            ],
          ),
        ),
      ),
    );
  }
}
