import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/Model/ChatUserModel/ChatUserModel.dart';

class FirebaseServices {

    static FirebaseAuth auth = FirebaseAuth.instance;

    static FirebaseFirestore firestore = FirebaseFirestore.instance;

    //to return current uer
    static User get user => auth.currentUser!;

    //check user exist or not
    static Future<bool> userExist()async{
      return (await firestore.collection('user').doc(user.uid).get()).exists;
    }

    //create a new user
    static Future<void> createUser()async{
      //for create_at value time
      final time =  DateTime.now().millisecondsSinceEpoch.toString();

      final chatUser = ChatuserModel(
        about: "My name is Moiz khan",
        createdAt: time,
        email: user.email.toString(),
        id: user.uid.toString(),
        image: user.photoURL.toString(),
        isOnline: false,
        lastActive: time,
        name: user.displayName.toString(),
        pushToken: ''
      );

      //create a user of which signIn from GoogleSignIn and this user Id which gen this Uid is for Doc Uid
      return firestore.collection('user').doc(user.uid).set(chatUser.toJson()); 
    }
}