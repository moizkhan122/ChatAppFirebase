

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_application_1/Model/ChatUserModel/ChatUserModel.dart';
import 'package:flutter_application_1/Widgets/TextStylee.dart';
import 'package:flutter_application_1/main.dart';

import '../const/const.dart';

class ChatUserCard extends StatefulWidget {
  const ChatUserCard({super.key, required this.user});

  final ChatuserModel user;
  @override
  State<ChatUserCard> createState() => _ChatUserCardState();
}

class _ChatUserCardState extends State<ChatUserCard> {
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
        onTap: (){},
        child: ListTile(
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
          subtitle:  Text("${widget.user.about}",maxLines: 1,style:  TextStyle(color: Colors.white.withOpacity(0.9),fontSize: 15,)),
          trailing: normalText(title: "10:00 Pm",color: white,size: 15.0),
        )),
    );
  }
}
/**margin: EdgeInsets.symmetric(horizontal: mq.width * .04,vertical: 10),
      color: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20),side: const BorderSide(color: white,)),
      shadowColor: white, */