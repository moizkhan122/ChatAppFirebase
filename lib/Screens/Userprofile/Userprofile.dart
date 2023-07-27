

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_application_1/Model/ChatUserModel/ChatUserModel.dart';
import 'package:flutter_application_1/Screens/Helper/DialogBox.dart';
import 'package:flutter_application_1/Widgets/TextStylee.dart';
import 'package:flutter_application_1/Widgets/customTextField_Widget.dart';
import 'package:flutter_application_1/Widgets/ourButton.dart';
import 'package:flutter_application_1/main.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../FirebaseService/FirebaseService.dart';
import '../../const/const.dart';
import '../AuthScreens/LoginScreen/LoginScreen.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key, required this.userdata});

  final ChatuserModel  userdata;
  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: green,
        centerTitle: true,
        elevation: 0,
        title: normalText(title: "User Details",color: white,size: 20.0),),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: mq.height*.035,),
                ClipRRect(
             borderRadius: BorderRadius.circular(mq.height*.12),
            child: Stack(
              children: [
                CachedNetworkImage(
                      width: mq.height * .22,
                      height:  mq.height * .22,
                      fit: BoxFit.fill,
                      imageUrl: widget.userdata.image.toString(),
                      placeholder: (context, url) => const CircularProgressIndicator(color: white,),
                      errorWidget: (context, url, error) => const Icon(Icons.error),
                   ),
                   Positioned(
                    bottom: 10,
                    left: 80,
                     child: MaterialButton(
                      onPressed: (){},
                      color: white,
                      shape: CircleBorder(),
                      child: Icon(Icons.edit,color: green,),
                      )
                   )
              ],
            ),
          ),
                SizedBox(height: mq.height*.025,),
                boldText(title: widget.userdata.email,color: white,size: 16.0),
                SizedBox(height: mq.height*.015,),
                customTextField(titleHint: "Name Here",initailvalue: widget.userdata.name),
                customTextField(titleHint: "About Here",initailvalue: widget.userdata.about),
                SizedBox(height: mq.height*.03,),
                ourButton(bgColor:green,title: "Update",onpress: (){}),
        SizedBox(height: mq.height*.05,),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
           ourButton(bgColor:red,title: "Logout",onpress: () async {
            DialogboX.showProgressBar(context);
            await FirebaseServices.auth.signOut().then((value) async {
              await GoogleSignIn().signOut().then((value){
                //FOR Stop loading progress bar
                Navigator.pop(context);
                //for moving to the home screen
                Navigator.pop(context);
                //replace home screen with login screen
                // // ignore: use_build_context_synchronously
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen(),));
              });
            });
            
           }),
          ],
        ),
              ]),
          ),
        ),
    );
  }
}