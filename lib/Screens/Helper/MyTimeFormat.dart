
import 'package:flutter_application_1/const/const.dart';

class MyTimeFormat {

    //for getting Formating time from fromMillisecondsSinceEpoch string
    static String getFormatTime({required BuildContext context,required String time}){
      final date = DateTime.fromMillisecondsSinceEpoch(int.parse(time));
      return TimeOfDay.fromDateTime(date).format(context);
    }

    //get last message time (used in chat user card )
    static String getLastMsgTime(
      {required BuildContext context, required String time})
      {
        final DateTime sent = DateTime.fromMillisecondsSinceEpoch(int.parse(time));
        final DateTime now = DateTime.now();

        if (
          now.day == sent.day &&
          now.month == sent.month &&
          now.year == now.year 
        ) {
          return TimeOfDay.fromDateTime(sent).format(context);
        }
        return '${sent.day} ${_getMonth(sent)}';
      }

      //get month name or month no or index
      static String _getMonth(DateTime date){
         switch (date.month){
          case 1 :
            return 'Jan';
          case 2 :
            return 'Fab';
          case 3 :
            return 'Mar';
          case 4 :
            return 'Apr';
          case 5 :
            return 'May';
          case 6 :
            return 'Jun';
          case 7 :
            return 'Jul';
          case 8 :
            return 'Aug';
          case 9 :
            return 'Sep';
          case 10 :
            return 'Oct';
          case 11 :
            return 'Nov';
          case 12 :
            return 'Dec';  
        }
        return 'NA';
      }
}