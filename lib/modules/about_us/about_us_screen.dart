import 'package:flutter/material.dart';
import 'package:green_cycle/modules/home_layout/widgets/home_app_bar.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: returnHomeAppBar('من نحن'),
    );
  }
}
