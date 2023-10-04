import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:green_cycle/theme/app_colors.dart';
import 'package:green_cycle/theme/app_images.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerWidget extends StatefulWidget {
  final Function(XFile image) onSelected;
  const ImagePickerWidget({
    required this.onSelected,
    super.key,
  });

  @override
  State<ImagePickerWidget> createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  XFile? image;
  openCamera() async {
    final image = await ImagePicker().pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        this.image = image;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await openCamera();
        if (image != null) {
          widget.onSelected(image!);
        }
      },
      child: Container(
        height: 160.h,
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.greyVeryLighF5,
          borderRadius: BorderRadius.circular(20.sp),
        ),
        child: image != null
            ? Image.file(File(image!.path))
            : Column(
                children: [
                  SizedBox(height: 12.h),
                  const Text(
                    "اضغط هنا لرفع صورة توضيحية",
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 18.h),
                  SvgPicture.asset(AppImages.gallery,
                      height: 80.h, fit: BoxFit.scaleDown),
                ],
              ),
      ),
    );
  }
}
