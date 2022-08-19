import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:phone_auth_with_bloc/logic/cubit/cubit/phone_auth_cubit.dart';
import '../../constants/strings.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class ScreensWidgets {
  final TextEditingController _controller = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  String? otpCode;

  Widget buildPhoneNumberPage(BuildContext context) {
    return SafeArea(
      child: Form(
        key: _key,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 25),
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 3,
                child: _askingForNumbersText(),
              ),
              Expanded(
                flex: 4,
                child: _buildTextFormField(),
              ),
              Expanded(
                flex: 0,
                child: _buildButton(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildOTPScreen({BuildContext? context, String? phoneNumber}) {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          children: [
            Expanded(flex: 3, child: _askingOTPCodeText(phoneNumber!)),
            Expanded(flex: 4, child: _buildOTPTextField(context!)),
            Expanded(flex: 0, child: _buildOTPVerificationButton(context))
          ],
        ),
      ),
    );
  }

  Widget _askingOTPCodeText(String phoneNumber) {
    return Padding(
      padding: const EdgeInsets.only(top: 80),
      child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            text: "Enter SMS Code For Number:- ",
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.black, fontSize: 24),
            children: [
              TextSpan(
                  text: "\n$phoneNumber",
                  style: TextStyle(
                      color: Colors.black.withOpacity(0.5), fontSize: 20))
            ],
          )),
    );
  }

  Widget _askingForNumbersText() {
    return Padding(
      padding: const EdgeInsets.only(top: 100),
      child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            text: "Enter Phone Number :- ",
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.black, fontSize: 24),
            children: [
              TextSpan(
                  text: "\nPhone Number Must Be Correct",
                  style: TextStyle(
                      color: Colors.black.withOpacity(0.5), fontSize: 20))
            ],
          )),
    );
  }

  Widget _buildTextFormField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: TextFormField(
        controller: _controller,
        validator: (value) {
          if (value!.isEmpty) {
            return "Enter Valid Phone Number";
          } else {
            if (value.length <= 10) {
              return "Phone Number Is Too Short";
            } else if (value.length > 11) {
              return "Number shouldn't be bigger than usual!!";
            }
            return null;
          }
        },
        keyboardType: TextInputType.phone,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          hintText: 'Phone Number',
        ),
      ),
    );
  }

  _showSnackBar(BuildContext context, String errorMsg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(errorMsg),
      duration: const Duration(seconds: 3),
      action: SnackBarAction(
        label: 'Error',
        onPressed: () {
          // Some code to undo the change.
        },
      ),
    ));
  }

  _showDialog() {
    return const AlertDialog(
      elevation: 0,
      backgroundColor: Colors.transparent,
      content: Center(
        child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.black)),
      ),
    );
  }

  Widget _buildButton(BuildContext context) {
    return Row(
      children: [
        Expanded(
            flex: 6,
            child: BlocListener<PhoneAuthCubit, PhoneAuthState?>(
              listenWhen: (previous, current) {
                return current != previous;
              },
              listener: (context, state) {
                if (state is ErrorState) {
                  Navigator.pop(context);
                  _showSnackBar(context, state.error!);
                } else if (state is LoadingState) {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return _showDialog();
                      });
                } else if (state is PhoneNumberSubmittedState) {
                  Navigator.pop(context);

                  Navigator.pushNamed(context, phoneOTP,
                      arguments: _controller.text);
                }
              },
              child: const SizedBox(),
            )),
        Expanded(
          flex: 4,
          child: Container(
              width: 150,
              height: 70,
              margin: const EdgeInsets.only(bottom: 60, right: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(70),
                color: Colors.black,
              ),
              child: TextButton(
                onPressed: () async {
                  if (_key.currentState!.validate()) {
                    BlocProvider.of<PhoneAuthCubit>(context)
                        .submitPhoneNumber(phoneNumber: _controller.text);
                  } else {
                    print("Not Valid");
                  }
                },
                child: const Text(
                  "Verify",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 19,
                      fontWeight: FontWeight.bold),
                ),
              )),
        ),
      ],
    );
  }

  Widget _buildOTPTextField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: PinCodeTextField(
        appContext: context,
        autoFocus: true,
        cursorColor: Colors.black,
        keyboardType: TextInputType.number,
        length: 6,
        obscureText: false,
        animationType: AnimationType.scale,
        pinTheme: PinTheme(
          shape: PinCodeFieldShape.box,
          borderRadius: BorderRadius.circular(5),
          fieldHeight: 50,
          fieldWidth: 40,
          borderWidth: 1,
          activeColor: Colors.blue,
          inactiveColor: Colors.blue,
          inactiveFillColor: Colors.white,
          activeFillColor: Colors.white60,
          selectedColor: Colors.blue,
          selectedFillColor: Colors.white,
        ),
        animationDuration: const Duration(milliseconds: 300),
        backgroundColor: Colors.white,
        enableActiveFill: true,
        onCompleted: (submitedCode) {
          otpCode = submitedCode;
        },
        onChanged: (value) {
          print(value);
        },
      ),
    );
  }

  Widget _buildOTPVerificationButton(BuildContext context) {
    return Row(
      children: [
        Expanded(
            flex: 6,
            child: BlocListener<PhoneAuthCubit, PhoneAuthState?>(
              listenWhen: (previous, current) {
                return current != previous;
              },
              listener: (context, state) {
                if (state is LoadingState) {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return _showDialog();
                      });
                } else if (state is ErrorState) {
                  Navigator.pop(context);
                  _showSnackBar(context, state.error!);
                } else if (state is OTPVerifiedState) {
                  Navigator.pop(context);
                  Navigator.pushReplacementNamed(context, mapsScreen,
                      arguments: _controller.text);
                }
              },
              child: SizedBox(),
            )),
        Expanded(
          flex: 4,
          child: Container(
              width: 150,
              height: 70,
              margin: const EdgeInsets.only(bottom: 60),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(70),
                color: Colors.black,
              ),
              child: TextButton(
                onPressed: () {
                  BlocProvider.of<PhoneAuthCubit>(context)
                      .submitOtpCode(otpCode!);
                },
                child: const Text(
                  "Start",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 19,
                      fontWeight: FontWeight.bold),
                ),
              )),
        ),
      ],
    );
  }
}
