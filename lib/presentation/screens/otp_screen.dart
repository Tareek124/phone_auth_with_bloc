import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import '../widgets/screens_widgets.dart';

class OTPScreen extends StatelessWidget {
  final String phoneNumber;

  OTPScreen({Key? key, required this.phoneNumber}) : super(key: key);

  final ScreensWidgets screensWidgets = ScreensWidgets();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screensWidgets.buildOTPScreen(
          context: context, phoneNumber: phoneNumber),
    );
  }
}
