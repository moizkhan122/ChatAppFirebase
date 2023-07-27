

import '../const/const.dart';
import '../main.dart';
import 'TextStylee.dart';

Widget ourButton({title,bgColor,onpress}){
  return ElevatedButton(
          // ignore: sort_child_properties_last
          child: SizedBox(
            height: mq.height*.06,
            width: mq.width*.27,
            child: Row(
              children: [
                Icon(Icons.logout,color: white,size: 20,),
                SizedBox(width: mq.width*.04,),
                normalText(title: title,color: white,size: 18.0)
              ]),
          ),
          style: ElevatedButton.styleFrom(
            primary: bgColor,
            textStyle: const TextStyle(
                color: Colors.white, fontSize: 25, fontStyle: FontStyle.normal),
            shape: const BeveledRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(18))),
          ),
          onPressed: onpress,
        );
}