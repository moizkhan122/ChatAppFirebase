
import 'package:flutter_application_1/Widgets/TextStylee.dart';
import 'package:flutter_application_1/Widgets/loadingIndicator.dart';
import '../../FirebaseService/FirebaseService.dart';
import '../../Model/ChatUserModel/ChatUserModel.dart';
import '../../Widgets/chatUserCard.dart';
import '../../const/const.dart';
import '../Userprofile/Userprofile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

   List<ChatuserModel> items = [];
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
                Navigator.push(context, MaterialPageRoute(builder: (context) =>  UserProfile(userdata: items[0]),));
            }, 
            icon: const Icon(Icons.more_vert,color: white,size: 25,))
        ]),
        body: StreamBuilder(
          stream: FirebaseServices.firestore.collection('user').snapshots(),
          builder: (context, snapshot) {
           switch (snapshot.connectionState) {
            //if data is loading or comming
             // ignore: constant_pattern_never_matches_value_type
             case ConnectionState.waiting :
             // ignore: constant_pattern_never_matches_value_type
             case ConnectionState.none :
             return Center(child: loadingIndicator(),);

             //if data is come
             // ignore: constant_pattern_never_matches_value_type
             case ConnectionState.active :
             // ignore: constant_pattern_never_matches_value_type
             case ConnectionState.done :
              final data = snapshot.data?.docs;
              items = data?.map((e) => ChatuserModel.fromJson(e.data())).toList() ?? [];
            if(items.isNotEmpty){
              return ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: items.length,
          itemBuilder: (context, index){
            //return Text('${items[index]}',style: TextStyle(color: white,fontSize: 30),);
            return ChatUserCard(user: items[index],);
            });
            }else{
              return Center(child: boldText(title: "No user found",color: white,size: 40.0),);
            }
           }
          },),
    );
  }
}