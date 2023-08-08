import 'dart:convert';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_application_1/Model/ChatUserModel/ChatUserModel.dart';
import 'package:flutter_application_1/Widgets/TextStylee.dart';
import 'package:flutter_application_1/const/const.dart';

import '../../FirebaseService/FirebaseService.dart';
import '../../Widgets/loadingIndicator.dart';
import '../../main.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, required this.user});

   final ChatuserModel user; 
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Expanded(
                child: StreamBuilder(
                stream: FirebaseServices.getALlmessages(),
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
                    final data = snapshot.data?.docs;
                    log('data is here : ${jsonEncode(data![0].data())}');
                    final _items = ["Hi","hello"];
                    //_items = data?.map((e) => ChatuserModel.fromJson(e.data())).toList() ?? [];
                  if(_items.isNotEmpty){
                    return ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount:_items.length,
                itemBuilder: (context, index){
                  //return Text('${items[index]}',style: TextStyle(color: white,fontSize: 30),);
                  return boldText(title: _items[index],color: white,size: 30.0);
                  });
                  }else{
                    return Center(child: normalText(title: "Say Hiii 🖐️",size: 40.0,color: white),);
                  }
                 }
                },),
              ),
              _inputChatField(),
            ]),
        ),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          flexibleSpace: _appbar(),
        ),
      ),
    );
  }
  // ignore: unused_element
  Widget _inputChatField(){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: Card(
              color: Colors.black,
              child: Row(
                children: [
                  IconButton(
                    onPressed: (){}, 
                    icon: const Icon(Icons.emoji_emotions,color: green,size: 25,)),
                    Expanded(
                      child: TextFormField(
                                    style: const TextStyle(color: white),
                                    keyboardType: TextInputType.multiline,
                                    maxLines: null,
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Type Message...",
                                      hintStyle: TextStyle(color: white),
                                    ),
                                  ),
                    ),
                    IconButton(
                    onPressed: (){}, 
                    icon: const Icon(Icons.photo_size_select_actual_outlined,color: green,size: 25,)),
                    IconButton(
                    onPressed: (){}, 
                    icon: const Icon(Icons.camera_alt_outlined,color: green,size: 25,)),
                ],
              ),
            ),
          ),
          CircleAvatar(
                        backgroundColor: green,
                        child: IconButton(
                          onPressed: (){}, 
                          icon: const Icon(Icons.send,color: white,size: 20,)),
                      ),
        ],
      ),
    );
  }

  Widget _appbar(){
    return InkWell(
      onTap: (){},
      child: Row(
        children: [
            IconButton(
              //arrow back icon
              onPressed: (){
                Navigator.pop(context);
              }, 
              icon: const Icon(Icons.arrow_back_ios,color: white,size: 20,)),
            
            // user profile picture
            ClipOval(
              clipBehavior: Clip.antiAlias,
              child: CachedNetworkImage(
                    width: mq.height * .055,
                    height:  mq.height * .055,
                    imageUrl: widget.user.image.toString(),
                    placeholder: (context, url) => const CircularProgressIndicator(color: white,),
                    errorWidget: (context, url, error) => const Icon(Icons.error),
                 ),
            ),
    
            SizedBox(width: mq.height* .02,),
            //user name and last seen
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                boldText(title: widget.user.name,color: white,size: 20.0),
                SizedBox(width: mq.height* .03,),
                normalText(title: "last seen not available",color: white,size: 15.0)
              ],)
        ],),
    );
  }
}

/**Expanded(
                child: Container(
                  padding: const EdgeInsets.all(10.0),
                  width: mq.width,
                  color: Colors.black,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        height: mq.height* .06,
                        width: mq.width*.3,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15),
                            bottomLeft: Radius.circular(15),
                            ),
                          border: Border.all(color: green,width: 5)),
                          child: Center(child: normalText(title: "Moiz khan",color: white,size: 18.0)),
                      )
                    ]),
                  ),
              ),
                SizedBox(height: mq.height*.01,),
              Container(
                height: mq.height*.07,
                width: mq.width,
                color: Colors.black,
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        style: const TextStyle(color: white),
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Type Message...",
                          hintStyle: const TextStyle(color: white),
                          suffixIcon: IconButton(
                            onPressed: (){}, 
                            icon: const Icon(Icons.photo,color: green,)),
                          prefixIcon: IconButton(
                            onPressed: (){}, 
                            icon: const Icon(Icons.emoji_emotions,color: green,))
                        ),
                      )),
                    CircleAvatar(
                      backgroundColor: green,
                      child: IconButton(
                        onPressed: (){}, 
                        icon: const Icon(Icons.send,color: white,size: 20,)),
                    ),
                    SizedBox(width: mq.height*.01,)
                  ]),
                ), */
