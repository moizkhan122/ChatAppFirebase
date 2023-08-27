

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_application_1/FirebaseService/FirebaseService.dart';
import 'package:flutter_application_1/Model/ChatUserModel/ChatUserModel.dart';
import 'package:flutter_application_1/Model/MessageModel/MessageModel.dart';
import 'package:flutter_application_1/Screens/Helper/MyTimeFormat.dart';
import 'package:flutter_application_1/Widgets/TextStylee.dart';
import 'package:flutter_application_1/main.dart';

import '../const/const.dart';

class ChatUserCard extends StatefulWidget {
  const ChatUserCard({super.key, required this.user, required this.onpress});

  final ChatuserModel user;
  final  onpress;
  @override
  State<ChatUserCard> createState() => _ChatUserCardState();
}

class _ChatUserCardState extends State<ChatUserCard> {
  
  //last message info (if null => no message)
  // ignore: unused_field
  MessagesModel? _message;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: mq.width * .012,vertical: 10),
      color: Colors.transparent,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20),
      ),
      shadowColor: white,
      child: InkWell(
        onTap: widget.onpress,
        child: StreamBuilder(
          stream: FirebaseServices.getOnlyLastMessage(widget.user),
          builder: (context, snapshot) {
          final data = snapshot.data?.docs;
          
          final items = data?.map((e) => MessagesModel.fromJson(e.data())).toList() ?? [];
          
          // ignore: unnecessary_null_comparison
          if (items.isNotEmpty) _message = items[0];          
           return ListTile(
          leading: ClipOval(
            clipBehavior: Clip.antiAlias,
            child: CachedNetworkImage(
                  width: mq.height * .070,
                  height:  mq.height * .070,
                  imageUrl: widget.user.image.toString(),
                  placeholder: (context, url) => const CircularProgressIndicator(color: white,),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
               ),
          ),
          title: boldText(title: "${widget.user.name}",color: white,size: 20.0),
          subtitle:  Text(
            _message != null ? 
            _message!.type == Type.image ? 'image' :
            _message!.msg : widget.user.about,maxLines: 1,style:  TextStyle(color: Colors.white.withOpacity(0.9),fontSize: 15,)),
          trailing:_message == null ? 
             null
             : _message!.read.isEmpty && _message!.fromId != FirebaseServices.user.uid
            ? Container(
              height: 25,
              width: 25,
              decoration: BoxDecoration(color: Colors.green,borderRadius: BorderRadius.circular(15)),
            ) :
             normalText(
            title:MyTimeFormat.getLastMsgTime(context: context, time: _message!.sent),color: white,size: 15.0),
        );
        },)),
    );
  }
}
/**margin: EdgeInsets.symmetric(horizontal: mq.width * .04,vertical: 10),
      color: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20),side: const BorderSide(color: white,)),
      shadowColor: white, */