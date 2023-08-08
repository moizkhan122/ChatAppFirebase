import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/const/colors.dart';
import 'Screens/SplashScreen/SplashScreen.dart';
import 'firebase_options.dart';
//import 'Screens/homeScreen/homeScreen.dart';
//import 'const/styles.dart';

//global objext for accessing the screen size
late Size mq;
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  //systeem full screen mode
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  //for setting orientation to portrait only
  SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp,DeviceOrientation.portraitDown
    ]
    ).then((value){
        //initialize firebase in project
        _initializedFirebase();
        runApp(const MyApp());
    });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Moiz Chat',
      theme: ThemeData(
      appBarTheme: AppBarTheme(color: green),
      scaffoldBackgroundColor: Colors.black),
      debugShowCheckedModeBanner: false,
      home: const SPlashScreen(),
    );
  }
}
_initializedFirebase() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);
}
