
import 'package:flutter_application_1/Screens/homeScreen/homeScreen.dart';
import 'package:flutter_application_1/main.dart';

import '../../../Widgets/TextStylee.dart';
import '../../../const/const.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  bool _isanimate = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(const Duration(milliseconds: 500),
    (){
        setState(() {
          _isanimate = true;
        });
    });
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        elevation: 0,
        centerTitle: true,
        title: normalText(color: white,size: 20.0,title: "Wellcome To Moiz Chat"),
        ),
        body: Stack(
          children: [
            AnimatedPositioned(
              top: mq.height*0.15,
              right:_isanimate ? mq.width*0.21 : -mq.width*.5,
              width: mq.width*0.6,
              duration: Duration(seconds: 1),
              child: Image.asset("assets/message.png")),

              Positioned(
              bottom: mq.height*.15,
              left: mq.width*.05,
              width: mq.width*.9,
              height: mq.height*.06,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.greenAccent,
                  shape: const StadiumBorder(),
                  elevation: 1
                ),
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const HomeScreen(),));
                }, 
                icon: Image.asset("assets/google.png",height: mq.height*.03,), 
                label: RichText(
                  text: const TextSpan(
                    style: TextStyle(color: Colors.black,fontSize: 20),
                    children: [
                      TextSpan(text: "Login With "),
                      TextSpan(text: "Google",
                      style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ])))
              ),
          ]),
        
    );
  }
}