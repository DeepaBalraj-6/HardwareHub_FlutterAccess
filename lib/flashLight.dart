import 'package:flutter/material.dart';
import 'package:torch_light/torch_light.dart';
import 'package:permission_handler/permission_handler.dart';

class FlashLightPage extends StatefulWidget {
  @override
  _FlashLightPageState createState() => _FlashLightPageState();
}

class _FlashLightPageState extends State<FlashLightPage> {
  bool isOn = false;

  Future<void> toggleFlash() async {
    try {
      var status = await Permission.camera.request();
      if (status.isGranted) {
        if (isOn) {
          await TorchLight.disableTorch();
        } else {
          await TorchLight.enableTorch();
        }
        setState(() {
          isOn = !isOn;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Camera permission not granted.")),
        );
      }
    } catch (e) {
      print("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Torch error: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.redAccent, // background color
            shape: BoxShape.circle, // makes it round
          ),
          padding: EdgeInsets.all(8), // padding around the icon button
          child: IconButton(
            icon: Icon(
              isOn ? Icons.flashlight_on_outlined : Icons.flashlight_off_outlined,
            ),
            iconSize: 40,
            color: Colors.black,
            onPressed: toggleFlash,
          ),
        ),
      ),
    );

  }
}
