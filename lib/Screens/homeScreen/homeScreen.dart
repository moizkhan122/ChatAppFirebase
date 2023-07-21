

import 'package:flutter_application_1/Widgets/TextStylee.dart';

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
            onPressed: (){}, 
            icon: const Icon(Icons.more_vert,color: white,size: 25,))
        ]),
        
    );
  }
}