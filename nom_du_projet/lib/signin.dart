import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'home_page.dart';
import 'Profile.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> _login(BuildContext context) async {
    final String apiUrl = 'http://127.0.0.1:5000/login';

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': emailController.text,
        'password': passwordController.text,
      }),
    );

    if (response.statusCode == 200) {
      // Successful login, navigate to the home page
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(),
        ),
      );

      // Fetch and display the user profile
      await fetchAndNavigateToProfile(context, emailController.text);
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Login Failed'),
            content: Text('Invalid credentials. Please try again.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> fetchAndNavigateToProfile(
      BuildContext context, String Email) async {
    // Fetch user profile data
    final profileResponse = await http.post(
      Uri.parse('http://127.0.0.1:5000/get-user-profile'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'Email': Email}),
    );

    if (profileResponse.statusCode == 200) {
      final profileData = jsonDecode(profileResponse.body);

      // Navigate to the ProfilePage and pass the user data
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ProfilePage(
            email: profileData['Email'],
            // You can pass other data as needed
          ),
        ),
      );
    } else {
      print('Failed to fetch user profile data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: double.infinity,
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(40, 70, 0, 16),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 0, 20, 17),
                      child: TextField(
                        controller: emailController,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          hintText: 'example@gmail.com',
                        ),
                        keyboardType: TextInputType.emailAddress,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 0, 20, 17),
                      child: TextField(
                        controller: passwordController,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          hintText: 'Enter your password',
                        ),
                        obscureText: true,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(90, 30, 0, 25),
                width: double.infinity,
                height: 72,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      left: 0,
                      top: 0,
                      child: Align(
                        child: SizedBox(
                          width: 201,
                          height: 59,
                          child: GestureDetector(
                            onTap: () {
                              _login(context);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Color(0xff284e7b),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 71,
                      top: 16,
                      child: Align(
                        child: SizedBox(
                          width: 63,
                          height: 27,
                          child: Text(
                            'Sign In',
                            style: TextStyle(
                              fontFamily: 'ABeeZee',
                              fontSize: 22,
                              fontWeight: FontWeight.w400,
                              height: 1.1825,
                              fontStyle: FontStyle.italic,
                              color: Color(0xffffffff),
                            ),
                          ),
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
    );
  }
}
