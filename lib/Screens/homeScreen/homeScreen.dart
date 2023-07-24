
import 'package:flutter_application_1/Widgets/TextStylee.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../FirebaseService/FirebaseService.dart';
import '../../const/const.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
            onPressed: (){}, 
            icon: const Icon(Icons.home,color: white,size: 25,)),
        title: normalText(color: white,size: 22.0,title: "Moiz Chat"),
        actions: [
          IconButton(
            onPressed: (){}, 
            icon: const Icon(Icons.search,color: white,size: 25,)),
            
          IconButton(
            onPressed: (){

            }, 
            icon: const Icon(Icons.more_vert,color: white,size: 25,))
        ]),
        floatingActionButton: FloatingActionButton(
          backgroundColor: white,
          onPressed: () async {
            await FirebaseServices.auth.signOut();
            await GoogleSignIn().signOut();
          },child: const Icon(Icons.logout,color: green,size: 25,),),
    );
  }
}