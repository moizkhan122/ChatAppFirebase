// ignore: file_names
import 'package:flutter_application_1/Widgets/TextStylee.dart';
import 'package:flutter_application_1/Widgets/loadingIndicator.dart';
import 'package:flutter_application_1/const/const.dart';

class DialogboX {
  
  //snack bar
  static void showSnackBar(BuildContext context,String msg){
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: normalText(title: msg,color: green,size: 20.0),
        behavior: SnackBarBehavior.floating,
        ));
  }

  //circuler progress bar
  static void showProgressBar(BuildContext context,){
    showDialog(context: context, builder: (context) =>  Center(child: loadingIndicator()),);
  }

}