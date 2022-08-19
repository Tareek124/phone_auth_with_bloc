// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:phone_auth_with_bloc/presentation/widgets/screens_widgets.dart';

@immutable
class PhoneNumberScreen extends StatelessWidget {
  PhoneNumberScreen({Key? key}) : super(key: key);

  ScreensWidgets screensWidgets = ScreensWidgets();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screensWidgets.buildPhoneNumberPage(context),
    );
  }
}
