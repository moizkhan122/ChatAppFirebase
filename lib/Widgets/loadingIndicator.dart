

import '../const/const.dart';

Widget loadingIndicator(){
  return const CircularProgressIndicator(
    color: green,
    strokeWidth: 5,
    valueColor: AlwaysStoppedAnimation(green),
  );
}