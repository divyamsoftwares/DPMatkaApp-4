import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dp_matka_3/Splash/splash_screen.dart';
import 'package:dp_matka_3/Api_Calling/Data_Model/dependency_injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dp_matka_3/Controller/network_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final ConnectivityResult initialConnectivity =
      await Connectivity().checkConnectivity();

  runApp(MyApp(initialConnectivity: initialConnectivity));
  DependencyInjection.init();
}

class MyApp extends StatelessWidget {
  final ConnectivityResult initialConnectivity;
  const MyApp({super.key, required this.initialConnectivity});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    if (initialConnectivity == ConnectivityResult.none) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: NoInternetScreen(),
      );
    }
    final textTheme = Theme.of(context).textTheme;
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DP Matka',
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(textTheme).copyWith(
          bodyMedium: GoogleFonts.poppins(textStyle: textTheme.bodyMedium),
        ),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}

//flutter build apk --no-tree-shake-icons
//
