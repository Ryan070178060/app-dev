import 'dart:async';

import 'package:appsbyreezy/AllScreens/mainscreen.dart';
import 'package:appsbyreezy/authentication/login_screen.dart';
import 'package:appsbyreezy/authentication/signup_screen.dart';
import 'package:appsbyreezy/customer_screens/customer_login_screen.dart';
import 'package:flutter/material.dart';

class MySplashScreen extends StatefulWidget {
  const MySplashScreen({super.key});

  @override
  State<MySplashScreen> createState() => _MySplashScreenState();
}

class _MySplashScreenState extends State<MySplashScreen> 
{


  //startTimer()
   //{
  //  Timer(const Duration(seconds: 13), () async
    // {
      //send user to home screen
    //  Navigator.push(context, MaterialPageRoute(builder: (c) => LoginScreen()));
   // }); //Timer
 // }

  @override
  void initState() {
    super.initState();

    //startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [const SizedBox(
                height: 100,
              ),

              Image.asset("images/splash.png"),
              const SizedBox(
                height: 30,
              ),
              const Text(
                "Reezy Taxi",
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  fontSize: 30,
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),

               const SizedBox(
                height: 30,
              ),
              
              Padding(
                padding: const EdgeInsets.all(25.0),
                child: Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (c) => LoginScreen()));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        fixedSize: const Size(200, 50)
                      ),
                      
                      child: const Text(
                        "Login as a Driver",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                     ElevatedButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (c) => CustomerLoginScreen()));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        fixedSize: const Size(200, 50)
                      ),
                      child: const Text(
                        "Login as a Customer",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      ),
    );
  }
}
