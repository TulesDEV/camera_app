import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

late List<CameraDescription> _cameras;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock orientation to portrait
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  _cameras = await availableCameras();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late CameraController _controller;

  @override
  void initState() {
    // TODO: implement initState
    initCamera();
    super.initState();
  }

  initCamera() {
    _controller = CameraController(_cameras[0], ResolutionPreset.max);
    _controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_controller.value.isInitialized) {
      return Container(
        color: Colors.black,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final screenHeight = constraints.maxHeight;

        // Get the correct aspect ratio for the camera preview
        final cameraAspectRatio = _controller.value.aspectRatio;

        // For portrait orientation, we invert the aspect ratio of the camera
        final adjustedAspectRatio = screenHeight > screenWidth
            ? (1 / cameraAspectRatio)
            : cameraAspectRatio;

        return OverflowBox(
          maxWidth: screenHeight * adjustedAspectRatio,
          maxHeight: screenHeight,
          child: CameraPreview(_controller),
        );
      },
    );
  }
}
