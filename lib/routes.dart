import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'logic/cubit/cubit/phone_auth_cubit.dart';
import 'constants/strings.dart';
import 'presentation/screens/otp_screen.dart';
import 'presentation/screens/phone_nimber_screen.dart';
import 'presentation/screens/maps_screen.dart';

class AppRoutes {
  PhoneAuthCubit? _phoneAuthCubit;

  AppRoutes() {
    _phoneAuthCubit = PhoneAuthCubit();
  }
  Route? route(RouteSettings settings) {
    switch (settings.name) {
      case phoneNumberScreen:
        return MaterialPageRoute(
            builder: (_) => BlocProvider<PhoneAuthCubit>.value(
                  value: _phoneAuthCubit!,
                  child: PhoneNumberScreen(),
                ));

      case phoneOTP:
        final String phoneNumber = settings.arguments as String;
        return MaterialPageRoute(
            builder: (_) => BlocProvider<PhoneAuthCubit>.value(
                  value: _phoneAuthCubit!,
                  child: OTPScreen(
                    phoneNumber: phoneNumber,
                  ),
                ));

      case mapsScreen:
        final String phoneNumber = settings.arguments as String;

        return MaterialPageRoute(
            builder: (_) => BlocProvider<PhoneAuthCubit>.value(
                  value: _phoneAuthCubit!,
                  child: ThirdScreen(
                    phoneNumber: phoneNumber,
                  ),
                ));
    }
  }
}
