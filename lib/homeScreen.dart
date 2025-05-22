import 'package:flutter/material.dart';
import 'biometric.dart';
import 'flashLight.dart';
import 'location.dart';

class MyApp extends StatelessWidget{
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        // Cream background color for scaffold and general app
        scaffoldBackgroundColor:   const Color(0xff969696),// cream color

        // Primary color set to blue
        primaryColor:  Color(0xff555555),

        // AppBar theme
        appBarTheme: const AppBarTheme(
          backgroundColor:  Color(0xff555555),
          foregroundColor: Colors.white,
          elevation: 2,
        ),

        // ElevatedButton theme - blue background with white text
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor:  Color(0xffe86565),
            foregroundColor: Colors.white,
            textStyle: const TextStyle(fontSize: 16),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            elevation: 11,             // shadow elevation
            shadowColor: Colors.red,
          ),
        ),

        // Text theme to harmonize with cream background
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.black87),
        ),
      ),
      home: const MyHomePage(),
      debugShowCheckedModeBanner: false,
    );

  }
}

class MyHomePage extends StatefulWidget{
  const MyHomePage({super.key});
  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: (){
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => FlashLightPage()),);
                },
                child: Text('Flash Light'),
            ),
            SizedBox(height: 45),
            ElevatedButton(
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>LocationTrackingPage()),);
              },
              child: Text('Location Tracking'),
            ),
            SizedBox(height: 45),
            ElevatedButton(
              onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context)=>BiometricPage()),
                );
              },
              child: Text('Biometric'),
            ),

          ],
        ),
      ),
    );
  }
}