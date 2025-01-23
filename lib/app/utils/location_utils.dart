import 'dart:developer';
import 'dart:io';
import 'package:app_settings/app_settings.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class LocationUtils {
  static LatLng? cachedLocation;

  static Future<LatLng?> getLocation({bool forceUpdate = false}) async {
    if (cachedLocation != null && !forceUpdate) {
      return cachedLocation;
    }

    final Location location = Location();
    if (Platform.isIOS) {
      location.enableBackgroundMode(enable: true);
    }

    try {
      bool serviceEnabled = await location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await location.requestService();
        if (!serviceEnabled) {
          log('Location services not enabled');
          return null;
        }
      }

      PermissionStatus permissionGranted = await location.hasPermission();
      if (permissionGranted == PermissionStatus.denied ||
          permissionGranted == PermissionStatus.deniedForever) {
        permissionGranted = await location.requestPermission();
        if (permissionGranted != PermissionStatus.granted) {
          log('Location permission denied');
          AppSettings.openAppSettings();
          return null;
        }
      }

      final LocationData locationData = await location.getLocation();
      final double lat = locationData.latitude!;
      final double lng = locationData.longitude!;

      // Cache the location for future requests
      cachedLocation = LatLng(lat, lng);
      log('Location fetched: Latitude: $lat, Longitude: $lng');

      return cachedLocation;
    } catch (e) {
      log('Location Error: $e');
      AppSettings.openAppSettings();
      return null;
    }
  }

  static Future<dynamic> checkMockLocation() async {
    try {
      final Position position = await Geolocator.getCurrentPosition();
      if (position.isMocked) {
        log('Mock location detected!');
      } else {
        log('Mock location not detected.');
      }
      return position.isMocked;
    } catch (e) {
      log('Mock Location Check Error: $e');
    }
  }

  static Future<void> requestLocationPermission() async {
    final Location location = Location();

    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        log('Location services not enabled');
        return;
      }
    }

    PermissionStatus permissionStatus = await location.hasPermission();
    if (permissionStatus == PermissionStatus.denied) {
      permissionStatus = await location.requestPermission();
      if (permissionStatus != PermissionStatus.granted) {
        log('Location permission not granted');
      }
    }
  }
}
