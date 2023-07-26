import 'dart:developer';
import 'dart:io';

import 'package:flutter_application_1/Screens/Helper/DialogBox.dart';
import 'package:flutter_application_1/Screens/homeScreen/homeScreen.dart';
import 'package:flutter_application_1/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../FirebaseService/FirebaseService.dart';
import '../../../Widgets/TextStylee.dart';
import '../../../const/const.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  bool _isanimate = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(const Duration(milliseconds: 500),
    (){
        setState(() {
          _isanimate = true;
        });
    });
  }
  _handleGoggleAuthBtnClick(){
    //for showing progress bar
    DialogboX.showProgressBar(context);
    //for hiding rogress bar after showing google signin option
      Navigator.pop(context);
    _signInWithGoogle().then((user)async{
      if(user != null){
              log('\nUser : ${user.user}');
              log('\nadditionalUserInfo : ${user.additionalUserInfo}');

              //checking here if user exist so go on homescreen
              if ((await FirebaseServices.userExist())) {
                  // ignore: use_build_context_synchronously
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomeScreen(),));  
              } 
              //if user not exist to first it create user then go on homescreen
              else {
                await FirebaseServices.createUser().then((value){
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomeScreen(),));
                });
              }
              
      }
    });
  }


  Future<UserCredential?> _signInWithGoogle() async {
      try {
        //if a user have a internet exception and to handle a internet exception
        await InternetAddress.lookup('google.com');
          // Trigger the authentication flow
  final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

  // Obtain the auth details from the request
  final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

  // Create a new credential
  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth?.accessToken,
    idToken: googleAuth?.idToken,
  );

  // Once signed in, return the UserCredential
  return await FirebaseServices.auth.signInWithCredential(credential); 
      } catch (e) {
        log('\n_signInWithGoogle : $e');
        DialogboX.showSnackBar(context, "Some thing went wrong check internet");
        return null;
      }
}
  /**
   * signIn out Function
   * _signout()async{
   *   await firebaseAuth.instance.signOut();
   * await GoolgeSignIn().signOut();  
   * }
   */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        elevation: 0,
        centerTitle: true,
        title: normalText(color: white,size: 20.0,title: "Wellcome To Moiz Chat"),
        ),
        body: Stack(
          children: [
            AnimatedPositioned(
              top: mq.height*0.15,
              right:_isanimate ? mq.width*0.21 : -mq.width*.5,
              width: mq.width*0.6,
              duration: Duration(seconds: 1),
              child: Image.asset("assets/message.png")),

              Positioned(
              bottom: mq.height*.15,
              left: mq.width*.05,
              width: mq.width*.9,
              height: mq.height*.06,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.greenAccent,
                  shape: const StadiumBorder(),
                  elevation: 1
                ),
                onPressed: (){
                  _handleGoggleAuthBtnClick();
                }, 
                icon: Image.asset("assets/google.png",height: mq.height*.03,), 
                label: RichText(
                  text: const TextSpan(
                    style: TextStyle(color: Colors.black,fontSize: 20),
                    children: [
                      TextSpan(text: "Login With "),
                      TextSpan(text: "Google",
                      style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ])))
              ),
          ]),
        
    );
  }
}