import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/FirebaseService/FirebaseService.dart';
import 'package:flutter_application_1/Model/MessageModel/MessageModel.dart';
import 'package:flutter_application_1/Screens/Helper/DialogBox.dart';
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
    bool isME = FirebaseServices.user.uid == widget.message.fromId;
    return  InkWell(
      onLongPress: () {
        _showModelBottomSheet(isME);
      },
      child:isME ? _greenMessage() : _blueMessage(),
    );
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

  //model bottom sheet for message detail
    void _showModelBottomSheet(bool isMe){
     showModalBottomSheet(
      backgroundColor: green,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20))),
      context: context, 
      builder: (context) {
        return ListView(
          shrinkWrap: true,
          children: [
            Container(
              margin: EdgeInsets.symmetric(
                vertical: mq.height*.015,
                horizontal: mq.width*.4
              ),
              height: 4,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.black
              ),
            ),
            widget.message.type == Type.text ?
               //Copy
            _OptionIcon(
              icons: const Icon(Icons.copy_all_rounded,color: Colors.white,size: 25,), 
              name: "Copy Text", 
              onTap: ()async{
                //for copying a text from dialog box and paste on clipboard
                await Clipboard.setData(ClipboardData(text: widget.message.msg)).then((value){
                  //for clossing a dialog box
                  Navigator.pop(context);
                  DialogboX.showSnackBar(context, 'Msg Copied');
                });
              }) :
            //Save
            _OptionIcon(
              icons: const Icon(Icons.download_done_rounded,color: Colors.white,size: 25,), 
              name: "Save Image", 
              onTap: (){}),
              //seperater or divider
              if(isMe)
              Divider(
                color: Colors.white,
                endIndent: mq.width * .04,
                indent: mq.width * .04,
              ),
              if(widget.message.type == Type.text && isMe)
              //Edit
              _OptionIcon(
              icons: const Icon(Icons.edit,color: Colors.white,size: 25,), 
              name: "Edit Message", 
              onTap: ()async{
              }),
              //Delete
              if(isMe)
              _OptionIcon(
              icons: const Icon(Icons.delete_forever,color: Colors.red,size: 25,), 
              name: "Delete Message", 
              onTap: (){
                FirebaseServices.deleteMessageFromChat(widget.message).then((value){
                  //close model bottom after delete msg
                  Navigator.pop(context);
                });
              }),
              //seperater or divider
              Divider(
                color: Colors.white,
                endIndent: mq.width * .04,
                indent: mq.width * .04,
              ),
              _OptionIcon(
              icons: const Icon(Icons.remove_red_eye,color: Colors.white,size: 25,), 
              name: "Sent At  ${MyTimeFormat.getLastMsgTimeSentRead(
                context: context, time: widget.message.sent)}", 
              onTap: (){}),
              //Read
              _OptionIcon(
              icons: const Icon(Icons.remove_red_eye,color: Colors.red,size: 25,), 
              name: 
                widget.message.read.isEmpty ?
                'not seen yet'
                :"Read At   ${MyTimeFormat.getLastMsgTimeSentRead(
                context: context, time: widget.message.read)}", 
              onTap: (){})
          ],);
      },);
  }
}

//private class for not calling in another class
class _OptionIcon extends StatelessWidget {
  const _OptionIcon({required this.icons, required this.name, required this.onTap});

  final Icon icons;
  final String name;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(),
      child: Padding(
        padding:  EdgeInsets.only(
          left: mq.width*.05,
          top: mq.height * .015,
          bottom: mq.height *.025
          ),
        child: Row(
          children: [
            icons,
            Flexible(child: Text('    $name',style: const TextStyle(fontSize: 20,color: Colors.white),))
          ]),
      ),
    );
  }
}