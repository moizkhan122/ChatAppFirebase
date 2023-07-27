
import 'package:flutter_application_1/Widgets/TextStylee.dart';
import 'package:flutter_application_1/const/styles.dart';
import 'package:flutter_application_1/main.dart';

import '../const/const.dart';

Widget customTextField({titleHint,controller,initailvalue}){
  return 
      Padding(
        padding: EdgeInsets.symmetric(horizontal: mq.width*.04,vertical: mq.width*.015),
        child: TextFormField(
          style: TextStyle(color: Colors.white),
          controller: controller,
          initialValue: initailvalue,
            decoration:  InputDecoration(
              label : normalText(title: titleHint,color: green,size: 15.0),
            isDense: true,//for short textfield,
            hintStyle: const TextStyle(
              fontFamily: semibold,
              color: textfieldGrey
            ),
            enabledBorder: OutlineInputBorder(
            borderSide:
              const BorderSide(width: 2, color: Colors.green), //<-- SEE HERE
            borderRadius: BorderRadius.circular(50.0),
        ),
            focusedBorder:  OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              // ignore: prefer_const_constructors
              borderSide: BorderSide(color: green)
            )
          ),
        ),
      );
}