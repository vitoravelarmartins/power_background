import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:geolocator/geolocator.dart';
import 'dart:ui' as ui;



void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Background Location',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String status = "Pause";

  @override
  void initState() {
    runPermission();
       
    
  }

  runPermission() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.whileInUse) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        _showDialog();
      }
    }
  }

  void _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Permissão para acessar localização negada"),
          content: const Text(
              "Acessar configurações do dispositivo e permitir acesso desse app a localização."),
          actions: <Widget>[
            TextButton(
              child: Text("OK"),
              onPressed: () async {
                Navigator.of(context).pop;
              },
            ),
          ],
        );
      },
    );
  }


  void serviceInPlatForm(String nameService) async {
    if (Platform.isAndroid) {
      var methodChannel = const MethodChannel("com.powerback.message");
      await methodChannel.invokeListMethod(nameService);
    }
  }
 
  
  void changeStatus(String newStatus) {
    setState(() {
      status = newStatus;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 150,
        backgroundColor: Color.fromARGB(255, 230, 229, 229),
        centerTitle: true,
        title: GradientText(
          'Background Location',
          style: const TextStyle(fontSize: 40),
          gradient: LinearGradient(colors: [
            Colors.blue.shade400,
            Color.fromARGB(255, 144, 13, 161),
          ]),
        ),
      ),
      floatingActionButton: Row(

          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              '$status',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 40,
                color: Color.fromARGB(65, 0, 0, 0),
              ),
              textAlign: TextAlign.left,
            ),
            const SizedBox(
              width: 20,
            ),
            FloatingActionButton(
              backgroundColor: Color.fromARGB(255, 230, 229, 229),
              onPressed: () {
                serviceInPlatForm("startService");
                changeStatus("Running");
              },
              tooltip: 'Start background location',
              child: const Icon(
                Icons.play_arrow,
                color: Color.fromARGB(139, 0, 0, 0),
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            FloatingActionButton(
                backgroundColor: Color.fromARGB(255, 230, 229, 229),
                onPressed: () {
                  serviceInPlatForm("stopService");
                  changeStatus("Paused");
                },
                tooltip: 'Stop background location',
                child: const Icon(
                  Icons.pause,
                  color: Color.fromARGB(139, 0, 0, 0)
                )),
      ]
        )
    );
  }
}

class GradientText extends StatelessWidget {
  const GradientText(
    this.text, {
    required this.gradient,
    this.style,
  });

  final String text;
  final TextStyle? style;
  final Gradient gradient;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) => gradient.createShader(
        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
      ),
      child: Text(text, style: style),
    );
  }
}
