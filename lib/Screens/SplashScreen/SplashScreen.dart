import 'dart:developer';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/Screens/homeScreen/homeScreen.dart';
import 'package:flutter_application_1/main.dart';

import '../../../const/const.dart';
import '../../FirebaseService/FirebaseService.dart';
import '../AuthScreens/LoginScreen/LoginScreen.dart';

class SPlashScreen extends StatefulWidget {
  const SPlashScreen({super.key});

  @override
  State<SPlashScreen> createState() => _SPlashScreenState();
}

class _SPlashScreenState extends State<SPlashScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(const Duration(milliseconds: 2000),
    (){ 
        //Exit ful screen
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
        SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
        
        //checking for if user already logIn so go on HomeScreen else Login Screen
        if (FirebaseServices.auth.currentUser != null) {
          log('\n_signInWithGoogle : ${FirebaseServices.auth.currentUser}');
          Navigator.push(context, MaterialPageRoute(builder: (context) => const HomeScreen(),));  
        } else {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen(),));
        }
        
    });
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return Scaffold(
        body: Stack(
          children: [
            Positioned(
              top: mq.height*0.15,
              right:mq.width*0.21,
              width: mq.width*0.6,
              child: Image.asset("assets/message.png")),

              Positioned(
              bottom: mq.height*.15,
              width: mq.width,
              child: const Text("Chat App By Moiz Khan",textAlign: TextAlign.center,style: TextStyle(color: white,fontSize: 30),),
              ),
          ]),
        
    );
  }
}