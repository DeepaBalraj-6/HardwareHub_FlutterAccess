import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationTrackingPage extends StatefulWidget {
  const LocationTrackingPage({super.key});

  @override
  State<LocationTrackingPage> createState() => _LocationTrackingPageState();
}

class _LocationTrackingPageState extends State<LocationTrackingPage> {
  GoogleMapController? _controller;
  LatLng? _currentLatLng;
  @override
  void initState() {
    super.initState();
    currentLocation();
  }
  Future<void> currentLocation() async{
    final status = await Permission.location.request();
    if (status.isPermanentlyDenied) {
      await openAppSettings();
      return;
    }
    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    setState(() {
      _currentLatLng = LatLng(position.latitude, position.longitude);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  GoogleMap(
          initialCameraPosition: CameraPosition(
            target: _currentLatLng!,
            zoom: 16,
          ),
          onMapCreated: (controller) {
            _controller = controller;
            if (_currentLatLng != null) {
              _controller!.animateCamera(
                CameraUpdate.newLatLngZoom(_currentLatLng!, 16),
              );
            }
          },
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          markers: {
            Marker(
              markerId: MarkerId("my_location"),
              position: _currentLatLng!,
              infoWindow: InfoWindow(title: "You Are Here"),
            ),
          },
        ),

      floatingActionButton: (_controller != null)
          ? FloatingActionButton(
        onPressed: () async {
          await currentLocation();
          if (_controller != null && _currentLatLng != null) {
            _controller!.animateCamera(
              CameraUpdate.newLatLngZoom(_currentLatLng!, 16),
            );
          }
        },
        child: Icon(Icons.location_searching),
      )
          : null,
    );

  }
}
