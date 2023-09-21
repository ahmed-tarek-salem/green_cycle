import 'package:flutter/material.dart';
import 'package:green_cycle/theme/app_colors.dart';

AppBar returnHomeAppBar(String title) {
  return AppBar(
    backgroundColor: AppColors.primary,
    centerTitle: true,
    title: Text(
      title,
      style: const TextStyle(fontWeight: FontWeight.w400),
    ),
  );
}
