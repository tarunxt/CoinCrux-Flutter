import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerDialog {
  static void imagePickerDialog({
    required BuildContext context,
    required double myHeight,
    required double myWidth,
    required Function(File) setFile,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Container(
          height: myHeight / 4,
          width: myWidth,
          child: Column(
            children: [
              Text(
                'Select Image Source',
                style: TextStyle(
                  fontSize: (myHeight / 4) / 10,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'segoe',
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: myWidth / 10),
                child: Divider(
                  thickness: 2,
                ),
              ),
              SizedBox(height: (myHeight / 4) / 8),
              InkWell(
                onTap: () {
                  pickImage(ImageSource.camera, setFile);
                  Navigator.pop(context);
                },
                child: _buildOptionContainer(
                  context,
                  myHeight,
                  myWidth,
                  'Camera',
                ),
              ),
              SizedBox(height: (myHeight / 4) / 10),
              InkWell(
                onTap: () {
                  pickImage(ImageSource.gallery, setFile);
                  Navigator.pop(context);
                },
                child: _buildOptionContainer(
                  context,
                  myHeight,
                  myWidth,
                  'Gallery',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _buildOptionContainer(
    BuildContext context,
    double myHeight,
    double myWidth,
    String text,
  ) {
    return Container(
      height: (myHeight / 4) / 4,
      width: myWidth / 1.5,
      decoration: BoxDecoration(
        color: Colors.blue, // Replace with your desired color
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 3),
            color: Colors.grey.withOpacity(0.4),
            blurRadius: 1,
            spreadRadius: 1,
          ),
        ],
        borderRadius: BorderRadius.all(
          Radius.circular(((myHeight / 4) / 4) / 10),
        ),
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontSize: ((myHeight / 4) / 4) / 3,
            fontWeight: FontWeight.w600,
            fontFamily: 'segoe',
          ),
        ),
      ),
    );
  }

  static void pickImage(ImageSource source, Function(File) addFile) async {
    var image = await ImagePicker().pickImage(source: source);
    if (image != null) {
      File file = File(image.path);
      addFile(file);
    } else {
      print('image is null');
    }
  }
}
