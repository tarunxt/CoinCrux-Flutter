import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coincrux/screens/auth/provider/auth_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

import '../../base/resizer/fetch_pixels.dart';
import '../../base/widget_utils.dart';
import '../../repository/signin_firebase.dart';
import '../../resources/resources.dart';
import '../../routes/app_routes.dart';
import '../../widgets/my_button.dart';
import '../dashboard/dashboard_view.dart';
import 'dialog/name_dialog.dart';

class OTPView extends StatefulWidget {
  const OTPView({super.key});

  @override
  State<OTPView> createState() => _OTPViewState();
}

class _OTPViewState extends State<OTPView> {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController phoneCtr = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProviderApp>(
      builder: (context, auth, child) {
        return Scaffold(
          backgroundColor: R.colors.bgColor,
          body: getPaddingWidget(
            EdgeInsets.symmetric(horizontal: FetchPixels.getPixelWidth(20)),
            SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      getVerSpace(FetchPixels.getPixelHeight(50)),
                      Align(
                        alignment: Alignment.center,
                        child: getAssetImage(R.images.logo,
                            height: FetchPixels.getPixelHeight(150),
                            width: FetchPixels.getPixelWidth(200)),
                      ),
                      getVerSpace(FetchPixels.getPixelHeight(50)),
                      Text(
                        "Enter OTP",
                        style: R.textStyle.mediumLato().copyWith(
                              fontSize: 18,
                            ),
                      ),
                      getVerSpace(FetchPixels.getPixelHeight(10)),
                      Text(
                        "We sent a code to the number ${auth.phoneNumber}",
                        style: R.textStyle
                            .mediumLato()
                            .copyWith(fontSize: 12, color: R.colors.blackColor),
                      ),
                      getVerSpace(FetchPixels.getPixelHeight(30)),
                      PinCodeTextField(
                        controller: phoneCtr,
                        length: 6,
                        obscureText: false,

                        animationType: AnimationType.fade,
                        animationDuration: Duration(milliseconds: 300),
                        // errorAnimationController: errorController, // Pass it here
                        onChanged: (value) {
                          setState(() {
                            // currentText = value;
                          });
                        },
                        appContext: context,
                      ),
                      getVerSpace(FetchPixels.getPixelHeight(50)),
                      MyButton(
                        color: R.colors.theme,
                        onTap: () async {
                          if (formKey.currentState!.validate()) {
                            try {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return Center(
                                        child: CircularProgressIndicator(
                                      color: R.colors.theme,
                                    ));
                                  });
                              var phone = await SignInFirebase.verifySmsCode(
                                  context: context, smsCode: phoneCtr.text);
                              bool isNewUser =
                                  phone.additionalUserInfo!.isNewUser;
                              Navigator.pop(context);
                              if (isNewUser) {
                                auth.isLogin = true;
                                Get.dialog(NameDialog());
                                auth.update();
                              } else {
                                auth.isLogin = true;
                                Get.offAll(DashBoardPage());
                              }
                            } catch (exception) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text('Incorrect pin'),
                              ));
                            }
                          }
                        },
                        buttonText: "Submit",
                      ),
                      getVerSpace(FetchPixels.getPixelHeight(20)),
                      Text(
                        "By entering the OTP, you agree with our Terms and Conditions and Privacy Policy",
                        style: R.textStyle
                            .mediumLato()
                            .copyWith(fontSize: 12, color: R.colors.blackColor),
                      ),
                    ]),
              ),
            ),
          ),
        );
      },
    );
  }
}
