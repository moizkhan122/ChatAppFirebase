import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_application_1/Model/ChatUserModel/ChatUserModel.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_application_1/Model/MessageModel/MessageModel.dart';
import 'package:http/http.dart' as http;

class FirebaseServices {

    static FirebaseAuth auth = FirebaseAuth.instance;

    //for accessing cloud firestore  
    static FirebaseFirestore firestore = FirebaseFirestore.instance;
    
    //for accessing firebase storage
    static FirebaseStorage storage = FirebaseStorage.instance;

    //to return current uer
    static User get user => auth.currentUser!;

    //for storing self data
    static late ChatuserModel me;

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

    //getting all users from firestore database
    static Stream<QuerySnapshot<Map<String, dynamic>>> getALlUsers(){
      return firestore.collection('user')
      //this line is for only those user get whose id was not login those not show whose id currently loggin
      .where('id', isNotEqualTo: user.uid)
      .snapshots();
    }

    //for getting current user info
    static Future<void> getSelfUserInfo()async{
      await firestore.collection('user').doc(user.uid).get().then((user)async{
          if (user.exists){
            me = ChatuserModel.fromJson(user.data()!);
            await getFirebaseMessageToken(); 
          updateActiveStatus(true);
          } else {
            await createUser().then((value) => getSelfUserInfo());
          }
      });
    }

    //upload image to firebase storage and update user profile image in real time
    static Future<void> updateProfilePicture(File file)async{

      //getting image file extension
      final ext = file.path.split('.').last;
      log('Extention $ext');

      //storage file ref with path and picture jo hogi vo folder ma vo user 
      //ki uid se se hogi uska name takay folder ma pta chalay ka kis user ki pic uska Uid sa
      final ref =  storage.ref().child('profile_Picture/${user.uid}.$ext');

      //uploading image to firebase storage
      await ref.putFile(file, SettableMetadata(contentType: 'image/$ext')).then((p0){
        log('Data transfer ${p0.bytesTransferred/1000} kb');
      });

      //updating image in firetore database
      me.image = await ref.getDownloadURL();
      await firestore.collection('user')
      .doc(user.uid)
      .update({"image" : me.image});

    }

    ///*********** Chat screen related APi***************** */

   

     //getting conversation id mean both who chatting each other have generate a ID of them unique id for both of those chats
     static String getConversationID(String id) => user.uid.hashCode <= id.hashCode
            ? '${user.uid}_$id'
            : '${id}_${user.uid}'; 

         //getting all messages of a specific conversation from firestore database
     static Stream<QuerySnapshot<Map<String, dynamic>>> getALlmessages(ChatuserModel user){
      return firestore.collection('Chats/${getConversationID(user.id)}/Messages')
      .orderBy('sent', descending: true)
      .snapshots();
    }

    //for sending message
    static Future<void> sendingMessage(ChatuserModel chatuser, String msg, Type typee)async{
      //message sending time (also used as ID)
      final time = DateTime.now().millisecondsSinceEpoch.toString();

      //message to send
      final MessagesModel message = MessagesModel(
        toId: chatuser.id, 
        msg: msg, 
        read: '', 
        type: typee, 
        sent: time, 
        fromId: user.uid
        );

        final ref =  firestore.collection('Chats/${getConversationID(chatuser.id)}/Messages');
        await ref.doc(time).set(message.toJson()).then((value) => sendPushNotification(chatuser,typee == Type.text ? msg : 'image'));
    }

    //for updating read status when user read our message
    static Future<void> updateReadStatus(MessagesModel message)async{
      firestore.collection('Chats/${getConversationID(message.fromId)}/Messages')
      .doc(message.sent).update({
        'read' :DateTime.now().millisecondsSinceEpoch.toString()
      });
    }

    //get only last message of a specific chat
    static Stream<QuerySnapshot<Map<String, dynamic>>> getOnlyLastMessage(
      ChatuserModel chatuser){
      return firestore.collection('Chats/${getConversationID(chatuser.id)}/Messages')
      .orderBy('sent', descending: true)
      .limit(1)
      .snapshots();
    }

    //send chat image
    static Future<void> sendChatImage(ChatuserModel chatuserModel, File file) async {
      //getting image file extension
      final ext = file.path.split('.').last;

      //storage file ref with path and picture jo hogi vo folder ma vo user 
      //ki uid se se hogi uska name takay folder ma pta chalay ka kis user ki pic uska Uid sa
      final ref =  storage.ref().child
      ('images/${getConversationID(
        chatuserModel.id)}/${DateTime.now().millisecondsSinceEpoch}.$ext');

      //uploading image to firebase storage
      await ref.putFile(file, SettableMetadata(contentType: 'image/$ext')).then((p0){
        log('Data transfer ${p0.bytesTransferred/1000} kb');
      });

      //updating image in firetore database
      final imgUrl = await ref.getDownloadURL();
      await sendingMessage(chatuserModel, imgUrl, Type.image);
    }

    //getting user from firestore database for  checking user online ofline status
    static Stream<QuerySnapshot<Map<String, dynamic>>> getUserInfoForOfOnCheck(ChatuserModel chatUser){
      return firestore.collection('user')
      //this line is for only those user get whose id was not login those not show whose id currently loggin
      .where('id', isEqualTo: chatUser.id)
      .snapshots();
    }

    //update active status of user
    static Future<void> updateActiveStatus(bool isOnline)async{
      firestore.collection('user')
      .doc(user.uid).update({
        'is_online' : isOnline,
        'last_Active' :DateTime.now().millisecondsSinceEpoch.toString(),
        'push_token' : me.pushToken,
      });
    }

    //firebase push notification messages

    //for accessing firebase messages (push notification)
    static FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

    //for getting firebase token
    static Future<void> getFirebaseMessageToken()async{
        await firebaseMessaging.requestPermission();

        await firebaseMessaging.getToken().then((t){
          if (t != null) {
            me.pushToken = t;
            log('push token : $t');
          }
        });
        // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        // log('Got a message whilst in the foreground!');
        // log('Message data: ${message.data}');

        // if (message.notification != null) {
        //   log('Message also contained a notification: ${message.notification}');
        // }
        // });
    }

    //sending push notification
    static Future<void> sendPushNotification(ChatuserModel chatuser, String msg)async{

     try {
        final body = {
        'to' : chatuser.pushToken,
        'notification' : {'title': chatuser.name,
         'body' : msg,         
          "android_channel_id": "chats",
         },
         "data": {
          "some_Data" : "user_Id : ${me.id}",
        },
      };
    var res = await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
     headers: {
      HttpHeaders.contentTypeHeader : 'application/json',
      HttpHeaders.authorizationHeader : 'key=AAAA2enmeP4:APA91bGwdBRvsV_KZSeaMi4hJJaqFWzCipKjXOT4UFTpos3GLIoxPOI_Dmyyglx9atd5-7RRu1S0awwes9_8kLNWGPbkwerKqHzaKMIXmLgzwWBfKgzjahFpQkx1qM25n-pKPJpPz_Db'
     },
     body: jsonEncode(body));
    log('Response status: ${res.statusCode}');
    log('Response body: ${res.body}');
     } catch (e) {
       log('PushNotification : $e');
     }
    }

    //delete msg on ontap dialog in chat screen
    static Future<void> deleteMessageFromChat(MessagesModel message)async{
      await firestore.collection('Chats/${getConversationID(message.toId)}/Messages')
      .doc(message.sent).
      delete();
      
      // if we want to delete a image from chat
      if (message.type == Type.image) {
        await storage.refFromURL(message.msg).delete();  
      }
    }
}