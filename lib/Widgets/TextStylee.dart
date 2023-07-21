

import '../const/const.dart';

Widget normalText({title,color=Colors.white,size=14.0}){
  return "$title".text.color(color).size(size).make();
}

Widget boldText({title,color=Colors.white,size=14.0}){
  return "$title".text.semiBold.color(color).size(size).make();
}