import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coincrux/base/resizer/fetch_pixels.dart';
import 'package:coincrux/base/widget_utils.dart';
import 'package:coincrux/dialog/imagePicker.dart';
import 'package:coincrux/routes/app_routes.dart';
import 'package:coincrux/screens/auth/personalise_feed/personlise_feed.dart';
import 'package:coincrux/screens/auth/provider/auth_provider.dart';
import 'package:coincrux/screens/dashboard/news_feed/profile/likedPosts.dart';
import 'package:coincrux/screens/dashboard/settings/pages/your_feed.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../../../../resources/resources.dart';

class ProfileView extends StatefulWidget {
  ProfileView({Key? key}) : super(key: key);
  

  @override
  State<ProfileView> createState() => _ProfileViewState();
  
}

class _ProfileViewState extends State<ProfileView> {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirebaseStorage storage = FirebaseStorage.instance;

  List<String> pagesNames = [
    "Name/Email",
    "Bookmarks",
    "Liked Posts",
    "Personalise your feed",
    // "Delete Account",
  ];



  @override
  Widget build(BuildContext context) {
    
    return Consumer<AuthProviderApp>(
      builder: (context, auth, child) {
        return Align(
          alignment: Alignment.topCenter,
          child: Container(
            padding:
                EdgeInsets.symmetric(vertical: FetchPixels.getPixelHeight(20)),
            width: FetchPixels.width,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  FetchPixels.getPixelHeight(5),
                  
                ),
                color: R.colors.bgColor),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                      width: FetchPixels.width,
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          Consumer<AuthProviderApp>(
                            builder: (context, auth, child) {
                              return Container(
                                  height: FetchPixels.getPixelHeight(120),
                                  width: FetchPixels.getPixelWidth(120),
                                  child: Stack(
                                    children: [
                                      Align(
                                        alignment: Alignment.center,
                                        child: auth.userM.image == null ||
                                                auth.userM.image!.isEmpty
                                            ? Container(
                                                height:
                                                    FetchPixels.getPixelHeight(
                                                        125),
                                                width:
                                                    FetchPixels.getPixelWidth(
                                                        125),
                                                decoration: BoxDecoration(
                                                  color: R.colors.isDarkTheme?
                                                  R.colors.whiteColor.withOpacity(0.1):
                                                  R.colors.blackColor.withOpacity(0.1),

                                                  
                                                      borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(20)),
                                                ),
                                              )
                                            : Container(
                                                height:
                                                    FetchPixels.getPixelHeight(
                                                        100),
                                                width:
                                                    FetchPixels.getPixelWidth(
                                                        100),
                                                decoration: BoxDecoration(
                                                    color:
                                                        R.colors.imageBgColor,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(5)),
                                                    image: DecorationImage(
                                                        image: NetworkImage(
                                                            auth.userM.image!),
                                                        fit: BoxFit.fill)),
                                              ),
                                      ),
                                      
                                      Material(
                                          color: Colors.transparent,




                                          child: InkWell(
                                         
                                            onTap: () {

                                              ImagePickerDialog
                                                  .imagePickerDialog(
                                                      context: context,
                                                      myHeight:
                                                          FetchPixels.height,
                                                      myWidth:
                                                          FetchPixels.width,
                                                      setFile: (f) async {
                                                        Reference ref =
                                                            storage.ref(
                                                                'pic/${f.path}');
                                                        await ref.putFile(f);
                                                        String downloadURL =
                                                            await ref
                                                                .getDownloadURL();
                                                        firebaseFirestore
                                                            .collection("users")
                                                            .doc(firebaseAuth
                                                                .currentUser!
                                                                .uid)
                                                            .update({
                                                          "image": downloadURL
                                                        }).then((value) {
                                                          auth.update();
                                                        });
                                                      });
                                            },
                                            child: Container(
                                                padding: EdgeInsets.all(3),
                                                decoration: BoxDecoration(
                                                    color: R.colors.whiteColor
                                                        .withOpacity(0.1),
                                                    shape: BoxShape.circle),
                                                child: Icon(
                                                  Icons.change_circle,
                                                  color: R.colors.whiteColor,
                                                )),
                                          ))
                                    ],
                                  ));
                            },
                          ),
                          SizedBox(height: FetchPixels.getPixelHeight(75)),
                          Text(
                            auth.userM.name ?? '',
                            style: R.textStyle.mediumLato().copyWith(
                                  fontSize: FetchPixels.getPixelHeight(17),
                                ),
                          ),
                          SizedBox(height: FetchPixels.getPixelHeight(3)),
                          Text(
                            auth.userM.phone ?? '',
                            style: R.textStyle.regularLato().copyWith(
                                  fontSize: FetchPixels.getPixelHeight(14),
                                ),
                          ),
                        ],
                      )),
                  SizedBox(height: FetchPixels.getPixelHeight(40)),

                  Expanded(
                    
                    child: ListView.builder(
                      padding: EdgeInsets.symmetric(
                        vertical: FetchPixels.getPixelHeight(10),
                      ),
                      itemCount: pagesNames.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.only(top: 25),
                          child: pagesName(index),
                        );
                      },
                    ),
                  ),
                ]),
          ),
        );
      
      },
    );
  }

Widget pagesName(int index) {
  // Define the pagesNames and images excluding the delete option
  List<String> images = [R.images.profile,R.images.save, R.images.like,R.images.feed];

 return GestureDetector(
      onTap: () {
         
         if (index ==1 ) {
          Get.toNamed(Routes.bookmark);
        }
         else if (index == 2) {
          Get.to(() => LikedPosts());
        }
        
       
        else if(index==3){
          Get.to(() => PersonaliseFeed());
          //or feed
        }
        
      },
      // for name/email well use the same widget as the delete account like shown below




    child: Container(
  margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
  padding: EdgeInsets.all(16.0),
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(8.0),
    color: Colors.white,
    boxShadow: [
      BoxShadow(
        color: Colors.grey.withOpacity(0.3),
        spreadRadius: 2,
        blurRadius: 6,
        offset: Offset(0, 4),
      ),
    ],
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
         Color(0xFF3A7BD5).withOpacity(0.8), 
        Color(0xFF3A7BD5).withOpacity(0.5), 
        Color(0xFF2196F3).withOpacity(0.3)
      ],
    ),
  ),

      child: Row(
        children: [
          Container(

            width: FetchPixels.getPixelWidth(35),
            height: FetchPixels.getPixelHeight(30),
            child: getAssetImage(images[index], scale:30 ),
          ),
          SizedBox(width: FetchPixels.getPixelWidth(10)),
          Text(
            pagesNames[index],

            style: R.textStyle.regularLato().copyWith(
              fontSize: FetchPixels.getPixelHeight(16),
              color:Color.fromARGB(255, 120, 120, 120),
            ),
          ),
        ],
      ),
    ),
  );
}
}

