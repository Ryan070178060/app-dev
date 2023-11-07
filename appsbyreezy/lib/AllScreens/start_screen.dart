import 'dart:async';

import 'package:appsbyreezy/AllScreens/mainscreen.dart';
import 'package:appsbyreezy/global/global.dart';
import 'package:appsbyreezy/splashScreen/splash_screen.dart';
import 'package:flutter/material.dart';

class MyStartScreen extends StatefulWidget {
  const MyStartScreen({super.key});

  @override
  State<MyStartScreen> createState() => _MyStartScreenState();
}

class _MyStartScreenState extends State<MyStartScreen> {
  startTimer() {
    Timer(const Duration(seconds: 9), () async {

      if(fAuth.currentUser !=null)
      {
Navigator.push(context, MaterialPageRoute(builder: (c)=>MainScreen()));
      }
      else
      {
        Navigator.push(context, MaterialPageRoute(builder: (c)=>MySplashScreen()));
      }
      
      Navigator.push(
          context, MaterialPageRoute(builder: (c) => MySplashScreen()));
    }); //Timer
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();


    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: Colors.black,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
    
    
              Image.asset("images/splash.png"),
    
              const SizedBox(height: 10,),
             const Text(
                "Reezy Taxi",
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                  fontFamily: ("family/Brand Bold"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
