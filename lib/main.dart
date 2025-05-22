import 'package:flutter/material.dart';
import 'homeScreen.dart';

void main() {
  runApp(MyApp());
}
///////////////////////////////////////////////////////////////////////////////////
//////////////////// biometric/////////////////////////////////

// import 'package:flutter/material.dart';
// import 'package:local_auth/local_auth.dart';
//
// void main() {
//   runApp(const MaterialApp(home: BiometricAuth()));
// }
//
// class BiometricAuth extends StatefulWidget {
//   const BiometricAuth({super.key});
//
//   @override
//   State<BiometricAuth> createState() => _BiometricAuthState();
// }
//
// class _BiometricAuthState extends State<BiometricAuth> {
//   final LocalAuthentication auth = LocalAuthentication();
//   String _message = "Not Authenticated";
//
//   Future<void> _authenticate() async {
//     try {
//       bool authenticated = await auth.authenticate(
//         localizedReason: "Scan your fingerprint to authenticate",
//         options: const AuthenticationOptions(
//           biometricOnly: true,
//           stickyAuth: true,
//         ),
//       );
//
//       setState(() {
//         _message = authenticated ? "Authenticated Successfully!" : "Authentication Failed";
//       });
//     } catch (e) {
//       setState(() {
//         _message = "Error: $e";
//       });
//     }
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     _authenticate(); // Auto-authenticate on start
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Biometric Authentication")),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(_message),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: _authenticate,
//               child: const Text("Retry Authentication"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }








//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////flash //////////////////////////////////////////////


// import 'package:flutter/material.dart';
// import 'package:torch_light/torch_light.dart';
// import 'package:permission_handler/permission_handler.dart';
//
// void main() {
//   runApp(MaterialApp(home: FlashLightApp()));
// }
//
// class FlashLightApp extends StatefulWidget {
//   @override
//   State<FlashLightApp> createState() => _FlashLightAppState();
// }
//
// class _FlashLightAppState extends State<FlashLightApp> {
//   bool _isOn = false;
//
//   Future<void> toggleFlashlight() async {
//     try {
//       var status = await Permission.camera.request();
//       if (status.isGranted) {
//         if (_isOn) {
//           await TorchLight.disableTorch();
//         } else {
//           await TorchLight.enableTorch();
//         }
//         setState(() {
//           _isOn = !_isOn;
//         });
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("Camera permission not granted.")),
//         );
//       }
//     } catch (e) {
//       print("Error: $e");
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Torch error: $e")),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Flashlight Toggle')),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: toggleFlashlight,
//           child: Text(_isOn ? 'Turn OFF' : 'Turn ON'),
//         ),
//       ),
//     );
//   }
// }




////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////live-location/////////////////////////////////////////////////


// import 'dart:async';
//
// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:permission_handler/permission_handler.dart';
//
// void main() => runApp(MyApp());
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Live Location Tracker',
//       home: MapScreen(),
//     );
//   }
// }
//
// class MapScreen extends StatefulWidget {
//   @override
//   _MapScreenState createState() => _MapScreenState();
// }
//
// class _MapScreenState extends State<MapScreen> {
//   GoogleMapController? _controller;
//   LatLng? _currentLatLng;
//   StreamSubscription<Position>? _positionStreamSubscription;
//
//   @override
//   void initState() {
//     super.initState();
//     _startLiveLocation();
//   }
//
//   Future<void> _startLiveLocation() async {
//     // Request location permission
//     final status = await Permission.location.request();
//     if (status.isPermanentlyDenied) {
//       await openAppSettings();
//       return;
//     }
//     if (!status.isGranted) return;
//
//     // Get initial position
//     final position = await Geolocator.getCurrentPosition(
//       desiredAccuracy: LocationAccuracy.high,
//     );
//
//     setState(() {
//       _currentLatLng = LatLng(position.latitude, position.longitude);
//     });
//
//     // Listen to position updates
//     _positionStreamSubscription =
//         Geolocator.getPositionStream(locationSettings: LocationSettings(
//           accuracy: LocationAccuracy.high,
//           distanceFilter: 10,
//         )).listen((Position position) {
//           final newLatLng = LatLng(position.latitude, position.longitude);
//
//           setState(() {
//             _currentLatLng = newLatLng;
//           });
//
//           if (_controller != null) {
//             _controller!.animateCamera(
//               CameraUpdate.newLatLng(newLatLng),
//             );
//           }
//         });
//   }
//
//   @override
//   void dispose() {
//     _positionStreamSubscription?.cancel();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final fallbackLatLng = LatLng(12.9716, 77.5946); // Bangalore fallback
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Live Location Tracker'),
//       ),
//       body: _currentLatLng == null
//           ? Center(child: CircularProgressIndicator())
//           : GoogleMap(
//         initialCameraPosition: CameraPosition(
//           target: _currentLatLng ?? fallbackLatLng,
//           zoom: 16,
//         ),
//         onMapCreated: (controller) {
//           _controller = controller;
//         },
//         myLocationEnabled: true,
//         myLocationButtonEnabled: true,
//         markers: {
//           Marker(
//             markerId: MarkerId("current_location"),
//             position: _currentLatLng!,
//             infoWindow: InfoWindow(title: "You Are Here"),
//           )
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         child: Icon(Icons.my_location),
//         onPressed: () async {
//           // Manual refresh button, re-center to current location
//           if (_currentLatLng != null && _controller != null) {
//             _controller!.animateCamera(
//               CameraUpdate.newLatLng(_currentLatLng!),
//             );
//           }
//         },
//       ),
//     );
//   }
// }




////////////////////////////////////////////////////////////////////////////////////////
////////////////////////location///////////////////////////////////////////

// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:permission_handler/permission_handler.dart';
//
// void main() => runApp(MyApp());
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Map Location',
//       home: MapScreen(),
//     );
//   }
// }
//
// class MapScreen extends StatefulWidget {
//   @override
//   _MapScreenState createState() => _MapScreenState();
// }
//
// class _MapScreenState extends State<MapScreen> {
//   GoogleMapController? _controller;
//   LatLng? _currentLatLng;
//
//   @override
//   void initState() {
//     super.initState();
//     _getCurrentLocation();
//   }
//
//   Future<void> _getCurrentLocation() async {
//     final status = await Permission.location.request();
//     if (status.isPermanentlyDenied) {
//       await openAppSettings(); // Ask user to manually allow
//       return;
//     }
//
//     print("_controller: $_controller");
//     print("_currentLatLng: $_currentLatLng");
//     print("Getting current location...");
//
//     print("Permission status: $status");
//     if (!status.isGranted) {
//       print("Permission denied");
//       return;
//     }
//
//     final position = await Geolocator.getCurrentPosition(
//       desiredAccuracy: LocationAccuracy.high,
//     );
//     print("Position: ${position.latitude}, ${position.longitude}");
//     setState(() {
//       _currentLatLng = LatLng(position.latitude, position.longitude);
//     });
//
//      }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("My Location on Map")),
//       body: _currentLatLng == null
//           ? Center(child: CircularProgressIndicator())
//           : GoogleMap(
//         initialCameraPosition: CameraPosition(
//           target: _currentLatLng!,
//           zoom: 16,
//         ),
//         onMapCreated: (controller) {
//           _controller = controller;
//           if (_currentLatLng != null) {
//             _controller!.animateCamera(CameraUpdate.newLatLngZoom(_currentLatLng!, 16));
//           }
//         },
//         myLocationEnabled: true,
//         myLocationButtonEnabled: true,
//         markers: {
//           Marker(
//             markerId: MarkerId("my_location"),
//             position: _currentLatLng!,
//             infoWindow: InfoWindow(title: "You Are Here"),
//           ),
//         },
//       ),
//       floatingActionButton: (_controller != null)
//           ? FloatingActionButton(
//         onPressed: () async {
//           await _getCurrentLocation();
//           if (_controller != null && _currentLatLng != null) {
//             _controller!.animateCamera(CameraUpdate.newLatLngZoom(_currentLatLng!, 16));
//           }
//         },
//         child: Icon(Icons.location_searching),
//       )
//           : null,
//
//     );
//   }
// }
//
//




///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////lat &long/////////////////////////////////


// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:permission_handler/permission_handler.dart';
//
// void main() => runApp(MyApp());
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Location Demo',
//       home: LocationPage(),
//     );
//   }
// }
//
// class LocationPage extends StatefulWidget {
//   @override
//   _LocationPageState createState() => _LocationPageState();
// }
//
// class _LocationPageState extends State<LocationPage> {
//   String locationMessage = "Location not available";
//
//   Future<void> _getLocation() async {
//     // Request location permission
//     var status = await Permission.location.request();
//     if (status.isGranted) {
//       bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//       if (!serviceEnabled) {
//         setState(() {
//           locationMessage = "Location services are disabled.";
//         });
//         return;
//       }
//
//       LocationPermission permission = await Geolocator.checkPermission();
//       if (permission == LocationPermission.denied) {
//         permission = await Geolocator.requestPermission();
//         if (permission == LocationPermission.denied) {
//           setState(() {
//             locationMessage = "Location permission denied";
//           });
//           return;
//         }
//       }
//
//       if (permission == LocationPermission.deniedForever) {
//         setState(() {
//           locationMessage =
//           "Location permission permanently denied. Please enable it from settings.";
//         });
//         return;
//       }
//
//       Position position = await Geolocator.getCurrentPosition(
//           desiredAccuracy: LocationAccuracy.high);
//
//       setState(() {
//         locationMessage =
//         "Latitude: ${position.latitude}, Longitude: ${position.longitude}";
//       });
//     } else {
//       setState(() {
//         locationMessage = "Permission denied";
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Get My Location')),
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text(locationMessage, textAlign: TextAlign.center),
//               SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: _getLocation,
//                 child: Text('Get Location'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
