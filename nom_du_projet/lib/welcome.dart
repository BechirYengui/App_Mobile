import 'dart:async';

import 'package:flutter/material.dart';

import 'home_page.dart';
//import 'signup.dart';

class Welcome extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<Welcome> {
  @override
  void initState() {
    super.initState();

    // Delay for 5 seconds and then navigate to the next page
    Timer(Duration(seconds: 4), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 90, 10, 0),
                child: Text(
                  'Welcome to our mobile application',
                  style: TextStyle(
                    fontSize: 26,
                    fontFamily: 'Hedvig',
                    color: Colors.blue.shade900,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(30, 70, 0, 0),
                width: 400,
                height: 85,
                child: Image.asset(
                  '../android/asset/img/fleche_gauche.png',
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(40, 90, 40, 0),
                child: Text(
                  'Empower your freelance journey with our app - where'
                  ' passion meets opportunity, and skills transform into'
                  ' success, all at your fingertips.',
                  style: TextStyle(
                      fontSize: 24,
                      fontFamily: 'Hedvig',
                      color: Colors.blue.shade900),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(50, 120, 0, 0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 60,
                      height: 10,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Color(0xffadd4f3),
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Container(
                      width: 20,
                      height: 10,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Color(0x668f908d),
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Container(
                      width: 20,
                      height: 10,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Color(0x668f908d),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
