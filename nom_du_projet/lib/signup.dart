import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'home_page.dart';
import 'Profile.dart'; // Import your ProfilePage

class SignupPage extends StatelessWidget {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController localisationController = TextEditingController();
  final TextEditingController occupationController = TextEditingController();
  final TextEditingController fieldOfWorkController = TextEditingController();
  final TextEditingController skillsController = TextEditingController();
  final TextEditingController birthDateController = TextEditingController();
  final TextEditingController educationController = TextEditingController();
  final TextEditingController diplomaController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  Future<void> signUpUser(BuildContext context) async {
    final url = Uri.parse('http://127.0.0.1:5000/signup');

    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'first_name': firstNameController.text,
        'last_name': lastNameController.text,
        'localisation': localisationController.text,
        'occupation': occupationController.text,
        'field_of_work': fieldOfWorkController.text,
        'skills': skillsController.text,
        'birth_date': birthDateController.text,
        'education': educationController.text,
        'diploma': diplomaController.text,
        'email': emailController.text,
        'password': passwordController.text,
        'confirm_password': confirmPasswordController.text,
      }),
    );

    if (response.statusCode == 200) {
      // Successful signup, navigate to the profile page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ProfilePage(email: emailController.text),
        ),
      );
    } else {
      // Handle errors, such as duplicate email or server errors
      print('User registration failed');
      print('Response: ${response.body}');
      // You may want to display an error message to the user
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            width: double.infinity,
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(40, 40, 0, 0),
                  width: 400,
                  height: 85,
                  child: Image.asset(
                    '../android/asset/img/freelance.png',
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 50, 10, 0),
                  child: Text(
                    'Sign up',
                    style: TextStyle(
                      fontSize: 30,
                      fontFamily: 'acme',
                      color: Colors.blue.shade900,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(40, 70, 0, 16),
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFieldWithLabel('First Name', firstNameController),
                      TextFieldWithLabel('Last Name', lastNameController),
                      TextFieldWithLabel(
                          'Localisation', localisationController),
                      TextFieldWithLabel('Occupation', occupationController),
                      TextFieldWithLabel(
                          'Field of Work', fieldOfWorkController),
                      TextFieldWithLabel('Skills', skillsController),
                      TextFieldWithLabel('Birth Date', birthDateController),
                      TextFieldWithLabel('Education', educationController),
                      TextFieldWithLabel('Diploma', diplomaController),
                      TextFieldWithLabel('Email', emailController),
                      TextFieldWithLabel(
                        'Password',
                        passwordController,
                        obscureText: true,
                      ),
                      TextFieldWithLabel(
                        'Confirm Password',
                        confirmPasswordController,
                        obscureText: true,
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(90, 30, 0, 50),
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
                                // Call the signUpUser function and pass the context
                                signUpUser(context);
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
                        left: 60,
                        top: 16,
                        child: Align(
                          child: SizedBox(
                            width: 80,
                            height: 27,
                            child: Text(
                              'Sign Up',
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
      ),
    );
  }
}

class TextFieldWithLabel extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool obscureText;

  const TextFieldWithLabel(this.label, this.controller,
      {this.obscureText = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 10, 20, 17),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          labelText: label,
        ),
        keyboardType: TextInputType.emailAddress,
      ),
    );
  }
}
