
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/Screens/ChatScreen/ChatScreen.dart';
import 'package:flutter_application_1/Screens/Helper/DialogBox.dart';
import 'package:flutter_application_1/Widgets/TextStylee.dart';
import 'package:flutter_application_1/Widgets/loadingIndicator.dart';
import '../../FirebaseService/FirebaseService.dart';
import '../../Model/ChatUserModel/ChatUserModel.dart';
import '../../Widgets/chatUserCard.dart';
import '../../const/const.dart';
import 'package:flutter_application_1/Screens/Userprofile/Userprofile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

   //stored all users and _ this sign shows the private keyword for variable where this var call only in this class only
   List<ChatuserModel> _items = [];
   
   //stored searched items
   final List<ChatuserModel> _searcheditems = [];

   //
   bool _issearching = false;

   @override
  void initState() {
    super.initState();

    FirebaseServices.getSelfUserInfo();
    //for active user active status according to life cycle event
    //resume active/online
    //pause inActive/offline
    SystemChannels.lifecycle.setMessageHandler((message){
      log('message : $message');
      if (message.toString().contains('resume')) FirebaseServices.updateActiveStatus(true);
      if (message.toString().contains('pause')) FirebaseServices.updateActiveStatus(false);

      return Future.value(message);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      //for hiding keyboard on press anywhere on screen
      onTap: () => FocusScope.of(context).unfocus(),
      child: WillPopScope(
        //if search is on & back button is press then close Search
          //or else simple close screen on press on back button
        onWillPop: () {
          if (_issearching) {
            setState(() {
              _issearching = !_issearching;
            });
            return Future.value(false);
          }else{
            return Future.value(true);
          }
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.green,
            elevation: 0,
            centerTitle: true,
            leading: IconButton(
                onPressed: (){}, 
                icon: const Icon(Icons.home,color: white,size: 25,)),
            title: _issearching ?   TextField(
              style: const TextStyle(fontSize: 18,color: white),
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: "search Chat"),
                autofocus: true,
                onChanged: (value) {
                  _searcheditems.clear();
                  for (var i in _items) {
                    if(i.name.toLowerCase().contains(value) || i.email.toLowerCase().contains(value)){
                      _searcheditems.add(i);
                    }
                    setState(() {
                      _searcheditems;
                    });
                  }
                },
                )  :normalText(color: white,size: 22.0,title: "Moiz Chat"),
            actions: [
              IconButton(
                onPressed: (){
                  setState(() {
                    _issearching = !_issearching;
                  });
                }, 
                icon: Icon(_issearching ? CupertinoIcons.clear_circled_solid : Icons.search,color: white,size: 25,)),
                
              IconButton(
                onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) =>  UserProfile(userdata: FirebaseServices.me),));
                }, 
                icon: const Icon(Icons.more_vert,color: white,size: 25,))
            ]),
            //get id pf only known users
            body: StreamBuilder(
              stream: FirebaseServices.getMyUsersIds(),
              builder: (context, snapshot) {

             switch (snapshot.connectionState) {
                //if data is loading or comming
                 // ignore: constant_pattern_never_matches_value_type
                 case ConnectionState.waiting :
                 // ignore: constant_pattern_never_matches_value_type
                 case ConnectionState.none :
                 return Center(child: loadingIndicator(),);
          
                 //if data is come
                 // ignore: constant_pattern_never_matches_value_type
                 case ConnectionState.active :
                 // ignore: constant_pattern_never_matches_value_type
                 case ConnectionState.done :
                return StreamBuilder(
              stream: FirebaseServices.getALlUsers(
                snapshot.data?.docs.map((e) => e.id).toList() ?? []
              ),
              builder: (context, snapshot) {
               switch (snapshot.connectionState) {
                //if data is loading or comming
                 // ignore: constant_pattern_never_matches_value_type
                 case ConnectionState.waiting :
                 // ignore: constant_pattern_never_matches_value_type
                 case ConnectionState.none :
                //  return Center(child: loadingIndicator(),);
          
                 //if data is come
                 // ignore: constant_pattern_never_matches_value_type
                 case ConnectionState.active :
                 // ignore: constant_pattern_never_matches_value_type
                 case ConnectionState.done :
                  final data = snapshot.data?.docs;
                  log('$data');
                  _items = data?.map((e) => ChatuserModel.fromJson(e.data())).toList() ?? [];
                if(_items.isNotEmpty){
                  return ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount:_issearching ? _searcheditems.length :_items.length,
              itemBuilder: (context, index){
                //return Text('${items[index]}',style: TextStyle(color: white,fontSize: 30),);
                return ChatUserCard(user:_issearching ? _searcheditems[index] : _items[index],
                onpress: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) =>  ChatScreen(user: _items[index]),));
                },
                );
                });
                }else{
                  return Center(child: boldText(title: "No user found",color: white,size: 40.0),);
                }
               }
              },);
              }
            },),
              floatingActionButton: FloatingActionButton(
                onPressed: (){
                  _showMessageUpdateDialog();
                },
                backgroundColor: Colors.green,
                child: const Icon(Icons.person,color: Colors.white,),
                ),
        ),
      ),
    );
  }

    // Show add user dialog
    void _showMessageUpdateDialog(){
    String email ='';

    showDialog(
      context: context, 
      builder: (context) =>  AlertDialog(
        backgroundColor: Colors.green,
        shape: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
        title: const Row(
          children: [
            Icon(Icons.person_2,color: Colors.white,),
            Text("Add User",style: TextStyle(fontSize: 20,color: Colors.white),)
          ],
        ),
        content: TextFormField(
          maxLines: null,
          onChanged: (value) => email = value,
          decoration: InputDecoration(
            suffixIcon: const Icon(Icons.email,color: Colors.green,size: 25,),
            hintText: 'Email',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(15))),),
        actions: [
          MaterialButton(onPressed: (){
            Navigator.pop(context);
          },child: const Center(child:  Text("Cancel",style: TextStyle(fontSize: 18,color: Colors.white),)),),
          MaterialButton(
            onPressed: () async {
            Navigator.pop(context);
            if (email.isNotEmpty) {
             await FirebaseServices.addChatUser(email).then((value){
             if (!value) {
                DialogboX.showSnackBar(context, 'User does Not Exist');
             }
             }); 
            }
          },child: const Center(child:  Text("Add",style: TextStyle(fontSize: 18,color: Colors.white),)),)
        ],
        ),
        );
  }
}