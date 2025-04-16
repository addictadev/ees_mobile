import 'dart:async';
import 'package:app_settings/app_settings.dart';
import 'package:ees/app/utils/show_toast.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../../app/widgets/app_button.dart';
import '../../../app/widgets/global_app_bar.dart';
import '../../../controllers/auth_controller.dart';

class SelectLocationScreen extends StatefulWidget {
  const SelectLocationScreen({super.key});

  @override
  State<SelectLocationScreen> createState() => _SelectLocationScreenState();
}

class _SelectLocationScreenState extends State<SelectLocationScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  LatLng? selectedLocation;
  LatLng? currentLocation;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      showCustomedToast(
          "Location services are disabled.".tr(), ToastType.error);
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        showCustomedToast(
            "Location permissions are denied.".tr(), ToastType.error);
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      showCustomedToast(
          "Location permissions are permanently denied. Enable them in settings."
              .tr(),
          ToastType.error);
      await AppSettings.openAppSettings();
      return;
    }

    final Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    setState(() {
      currentLocation = LatLng(position.latitude, position.longitude);
      selectedLocation = currentLocation;
      _isLoading = false;
    });

    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newLatLng(currentLocation!));
  }

  void _onMapTap(LatLng position) {
    setState(() {
      selectedLocation = position;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: sharedAppBar(
        context,
        "تحديد الموقع",
      ),
      body: Stack(
        children: [
          GoogleMap(
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            onTap: _onMapTap,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
            initialCameraPosition: CameraPosition(
              target: currentLocation ?? const LatLng(30.06263, 31.24967),
              zoom: 19,
            ),
            markers: selectedLocation != null
                ? {
                    Marker(
                      markerId: const MarkerId('selected-location'),
                      position: selectedLocation!,
                    ),
                  }
                : (currentLocation != null
                    ? {
                        Marker(
                          markerId: const MarkerId('current-location'),
                          position: currentLocation!,
                        ),
                      }
                    : {}),
          ),
          if (_isLoading)
            Center(
              child: loadingIndicator,
            ),
          if (selectedLocation != null && currentLocation != null)
            Positioned(
              bottom: 20,
              left: 15.w,
              right: 15.w,
              child: AppButton('تأكيد الموقع', onTap: () {
                Provider.of<AuthController>(context, listen: false)
                    .locationReisterController
                    .text = selectedLocation.toString();
                Navigator.pop(context, selectedLocation);
              }),
            ),
        ],
      ),
    );
  }
}
