import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phone_auth_with_bloc/constants/strings.dart';
import 'package:phone_auth_with_bloc/logic/cubit/cubit/phone_auth_cubit.dart';

class ThirdScreen extends StatelessWidget {
  ThirdScreen({Key? key, required this.phoneNumber}) : super(key: key);

  String? phoneNumber;

  @override
  Widget build(BuildContext context) {
    // ignore: prefer_const_constructors
    return Scaffold(
      appBar: AppBar(
        title: const Text("Success"),
        actions: [
          IconButton(
              onPressed: () {
                BlocProvider.of<PhoneAuthCubit>(context).logOut();
                Navigator.pushReplacementNamed(context, phoneNumberScreen);
              },
              icon: const Icon(Icons.logout_outlined))
        ],
      ),
      body: Center(
        child: Text(
          "Phone Authentication Success for Number $phoneNumber!",
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
