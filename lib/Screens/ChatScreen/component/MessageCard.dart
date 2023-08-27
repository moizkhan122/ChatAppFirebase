import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_application_1/FirebaseService/FirebaseService.dart';
import 'package:flutter_application_1/Model/MessageModel/MessageModel.dart';
import 'package:flutter_application_1/Screens/Helper/MyTimeFormat.dart';
import 'package:flutter_application_1/Widgets/TextStylee.dart';
import 'package:flutter_application_1/const/const.dart';
import 'package:flutter_application_1/main.dart';

class MessageCard extends StatefulWidget {
  const MessageCard({super.key, required this.message});

  final MessagesModel message;
  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  @override
  Widget build(BuildContext context) {
    return FirebaseServices.user.uid == widget.message.fromId ? _greenMessage() : _blueMessage();
  }

  //sender or another user message
  // ignore: unused_element
  Widget _blueMessage(){

    //update last read message if sender and receiver are different
    if (widget.message.read.isEmpty) {
      FirebaseServices.updateReadStatus(widget.message);
      log('message read successfully');
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Flexible(//flexible is use for make a container dynamic like how long message it will manage it self
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: mq.width*0.01,vertical: mq.width*0.01),
            padding: EdgeInsets.only(top: mq.width*0.025,left: mq.width*0.025,bottom : mq.width*0.008,right: mq.width*0.008),
            decoration:  BoxDecoration(
              border: Border.all(color: Colors.grey,width: 2),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
                bottomRight: Radius.circular(12),
                ),
              color: Colors.grey.withOpacity(0.7)
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                widget.message.type == Type.text ?
                boldText(title: widget.message.msg,size: 20.0) : 
                CachedNetworkImage(
                    width: mq.height * .055,
                    height:  mq.height * .055,
                    imageUrl: widget.message.msg.toString(),
                    placeholder: (context, url) => const CircularProgressIndicator(color: white,),
                    errorWidget: (context, url, error) => const Icon(Icons.image,size: 70,),
                 ),
                
                SizedBox(height: mq.height*0.005,),
                boldText(title: MyTimeFormat.getFormatTime(context: context, time: widget.message.sent),size: 15.0,color: Colors.white),
                // const Icon(Icons.done_all_rounded,color: Colors.blue,),
              ],
            ),),
        ),
      ],
    );
  }
  //our or user message
  // ignore: unused_element
  Widget _greenMessage(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Flexible(//flexible is use for make a container dynamic like how long message it will manage it self
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: mq.width*0.01,vertical: mq.width*0.01),
            padding: EdgeInsets.only(top: mq.width*0.025,left: mq.width*0.025,bottom : mq.width*0.008,right: mq.width*0.008),
            decoration:  BoxDecoration(
              border: Border.all(color: Colors.green,width: 2),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
                bottomLeft: Radius.circular(12),
                ),
              color: Colors.green.withOpacity(0.6)
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                widget.message.type == Type.text ?
                boldText(title: widget.message.msg,size: 20.0) : 
                CachedNetworkImage(
                    imageUrl: widget.message.msg.toString(),
                    placeholder: (context, url) => const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(color: white,),
                    ),
                    errorWidget: (context, url, error) => const Icon(Icons.image,size: 70,),
                 ),
                SizedBox(height: mq.height*0.005,),
                boldText(title: MyTimeFormat.getFormatTime(context: context, time: widget.message.sent),size: 15.0,color: Colors.white),
                
                //if user watch your message than only blue will be shown
                if(widget.message.read.isNotEmpty)
                const Icon(Icons.done_all_rounded,color: Colors.blue,),

              ],
            ),),
        ),
      ],
    );
  }
}