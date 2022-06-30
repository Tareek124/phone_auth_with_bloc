import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../constants/strings.dart';
import '../../helper/geo_location_helper.dart';
import '../../logic/cubit/cubit/phone_auth_cubit.dart';

class ThirdScreen extends StatefulWidget {
  ThirdScreen({Key? key, required this.phoneNumber}) : super(key: key);

  String? phoneNumber;

  @override
  State<ThirdScreen> createState() => _ThirdScreenState();
}

class _ThirdScreenState extends State<ThirdScreen> {
  Position? _position;

  Future<void> _getMyCurrentLocation() async {
    _position = await LocationHelper.determinePosition()
        .whenComplete(() => setState(() {}));
  }

  @override
  void initState() {
    super.initState();
    _getMyCurrentLocation();
  }

  late final CameraPosition _myPosition = CameraPosition(
      target: LatLng(_position!.latitude, _position!.longitude), zoom: 18);

  final Completer<GoogleMapController> _controller = Completer();

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
      body: _position == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : GoogleMap(
              mapType: MapType.normal,
              zoomControlsEnabled: false,
              myLocationButtonEnabled: false,
              initialCameraPosition: _myPosition,
              myLocationEnabled: true,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
                setState(() {});
              },
            ),
    );
  }
}
