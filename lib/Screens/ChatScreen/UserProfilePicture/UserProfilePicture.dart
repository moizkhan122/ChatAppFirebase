import 'package:flutter/cupertino.dart';
import 'package:flutter_application_1/const/const.dart';

import '../../../Model/ChatUserModel/ChatUserModel.dart';
import '../../../main.dart';

class UserProfilePicture extends StatefulWidget {
  const UserProfilePicture({super.key, required this.user});
  final ChatuserModel user;
  @override
  State<UserProfilePicture> createState() => _UserProfilePictureState();
}

class _UserProfilePictureState extends State<UserProfilePicture> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.green,
        title:  Text(widget.user.name),),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('User Details',style: TextStyle(fontSize: 25,color: Colors.green),), 
          SizedBox(height: mq.height*0.05,),
          Center(
            child: CircleAvatar(
              radius: 80,
              backgroundImage: NetworkImage(widget.user.image),),
          ),
          SizedBox(height: mq.height*0.05,),
          Text(widget.user.about,style: const TextStyle(fontSize: 20,color: Colors.green),),
          SizedBox(height: mq.height*0.03,),
          Text(widget.user.name,style: const TextStyle(fontSize: 25,color: Colors.green),),
          SizedBox(height: mq.height*0.02,),
          Text(widget.user.email,style: const TextStyle(fontSize: 25,color: Colors.green),),
        ]),
    );
  }
}