import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coincrux/repository/signin_firebase.dart';
import 'package:coincrux/screens/LatestLandingScreen.dart';
import 'package:coincrux/screens/auth/personalise_feed/personlise_feed.dart';
import 'package:coincrux/screens/auth/provider/auth_provider.dart';
import 'package:coincrux/screens/dashboard/dashboard_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import '../../base/resizer/fetch_pixels.dart';
import '../../base/widget_utils.dart';
import '../../resources/resources.dart';
import '../../routes/app_routes.dart';
import '../../widgets/my_button.dart';

class LoginView extends StatefulWidget {
  LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  final TextEditingController controller = TextEditingController();
  String initialCountry = 'IN';
  PhoneNumber number = PhoneNumber(isoCode: 'IN');

  TextEditingController emailCT = TextEditingController();

  TextEditingController passCT = TextEditingController();

  FocusNode passFN = FocusNode();

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
                        child: getAssetImage(
                          R.images.logo,
                          height: FetchPixels.getPixelHeight(150),
                          width: FetchPixels.getPixelWidth(200),
                        ),
                      ),
                      getVerSpace(FetchPixels.getPixelHeight(50)),
                      Text(
                        "Enter your mobile number",
                        style: R.textStyle.mediumLato().copyWith(
                              fontSize: 18,
                            ),
                      ),
                      getVerSpace(FetchPixels.getPixelHeight(10)),
                      Text(
                        "We will send you a confirmation code",
                        style: R.textStyle
                            .mediumLato()
                            .copyWith(fontSize: 12, color: R.colors.blackColor),
                      ),
                      getVerSpace(FetchPixels.getPixelHeight(30)),
                      InternationalPhoneNumberInput(
                        onInputChanged: (PhoneNumber number) {
                          auth.phoneNumber = number.phoneNumber!;
                        },
                        onInputValidated: (bool value) {
                          print(value);
                        },
                        selectorConfig: SelectorConfig(
                          selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                        ),
                        ignoreBlank: false,
                        // validator: (value)=> FieldValidator.validatePhoneNumber(value!),
                        autoValidateMode: AutovalidateMode.onUserInteraction,
                        selectorTextStyle:
                            TextStyle(color: R.colors.whiteColor),
                        inputDecoration: R.decorations
                            .textFormFieldDecoration(null, "phone number"),
                        initialValue: number,
                        textFieldController: controller,
                        formatInput: true,
                        keyboardType: TextInputType.numberWithOptions(
                            signed: true, decimal: true),
                        inputBorder: OutlineInputBorder(),
                        onSaved: (PhoneNumber number) {
                          print('On Saved: $number');
                        },
                        textStyle: TextStyle(
                          color: R.colors.whiteColor,
                        ),
                      ),
                      getVerSpace(FetchPixels.getPixelHeight(50)),
                      MyButton(
                        color: R.colors.theme,
                        onTap: () {
                          if (formKey.currentState!.validate()) {
                            SignInFirebase.signInWithPhone(
                                auth.phoneNumber, context);
                            // auth.isLogin = true;
                            Get.toNamed(Routes.oTPView);
                            // auth.update();
                          }
                        },
                        buttonText: "Send OTP",
                      ),
                      getVerSpace(FetchPixels.getPixelHeight(20)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: FetchPixels.getPixelHeight(1),
                            color: R.colors.borderColor,
                            width: FetchPixels.getPixelWidth(150),
                          ),
                          Center(
                            child: Text(
                              "Or",
                              style: R.textStyle
                                  .mediumLato()
                                  .copyWith(fontSize: 13, color: R.colors.fill),
                            ),
                          ),
                          Container(
                            height: FetchPixels.getPixelHeight(1),
                            color: R.colors.borderColor,
                            width: FetchPixels.getPixelWidth(150),
                          ),
                        ],
                      ),
                      getVerSpace(FetchPixels.getPixelHeight(20)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () async {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return Center(
                                        child: CircularProgressIndicator(
                                      color: R.colors.theme,
                                    ));
                                  });
                              UserCredential userCredential =
                                  await SignInFirebase.signInWithGoogle();
                              bool isNewUser =
                                  userCredential.additionalUserInfo!.isNewUser;
                              Navigator.pop(context);
                              if (isNewUser) {
                                auth.email = userCredential.user!.email ?? '';
                                auth.phoneNumber =
                                    userCredential.user!.phoneNumber ?? '';
                                auth.name =
                                    userCredential.user!.displayName ?? '';
                                Get.to(PersonaliseFeed());
                              } else {
                                auth.isLogin = true;
                                auth.dashCurrentPage = 0;
                                Get.offAll(DashBoardPage());
                              }
                            },
                            child: Container(
                              height: FetchPixels.getPixelHeight(50),
                              width: FetchPixels.getPixelWidth(110),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                      FetchPixels.getPixelHeight(5)),
                                  border: Border.all(color: R.colors.theme)),
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    getAssetImage(R.images.mails,
                                        scale: FetchPixels.getPixelHeight(30)),
                                    Text(
                                      "Gmail",
                                      style:
                                          TextStyle(color: R.colors.whiteColor),
                                    )
                                  ]),
                            ),
                          ),
                          SizedBox(
                            width: FetchPixels.getPixelWidth(50),
                          ),
                          Container(
                            height: FetchPixels.getPixelHeight(50),
                            width: FetchPixels.getPixelWidth(110),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                    FetchPixels.getPixelHeight(5)),
                                border: Border.all(color: R.colors.theme)),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  getAssetImage(R.images.facebook,
                                      scale: FetchPixels.getPixelHeight(26)),
                                  Text(
                                    "Facebook",
                                    style:
                                        TextStyle(color: R.colors.whiteColor),
                                  )
                                ]),
                          ),
                          Platform.isIOS
                              ? Container(
                                  height: FetchPixels.getPixelHeight(50),
                                  width: FetchPixels.getPixelWidth(110),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                          FetchPixels.getPixelHeight(5)),
                                      border:
                                          Border.all(color: R.colors.theme)),
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        getAssetImage(R.images.apple,
                                            scale:
                                                FetchPixels.getPixelHeight(25)),
                                        Text(
                                          "Apple",
                                          style: R.textStyle
                                              .regularLato()
                                              .copyWith(
                                                  fontSize: 12,
                                                  color: R.colors.blackColor),
                                        )
                                      ]),
                                )
                              : SizedBox()
                        ],
                      )
                    ]),
              ),
            ),
          ),
        );
      },
    );
  }

  void getPhoneNumber(String phoneNumber) async {
    PhoneNumber number =
        await PhoneNumber.getRegionInfoFromPhoneNumber(phoneNumber, 'US');

    setState(() {
      this.number = number;
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
