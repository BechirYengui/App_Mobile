import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:nom_du_projet/home_page.dart';

class PostAJobPage extends StatelessWidget {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController jobTypeController = TextEditingController();
  final TextEditingController fieldController = TextEditingController();
  final TextEditingController profileRequestedController =
      TextEditingController();
  final TextEditingController skillsRequestedController =
      TextEditingController();

  Future<void> postJob(BuildContext context) async {
    final url = Uri.parse('http://127.0.0.1:5000/post-job');

    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'title': titleController.text,
        'description': descriptionController.text,
        'job_type': jobTypeController.text,
        'field': fieldController.text,
        'profile_requested': profileRequestedController.text,
        'skills_requested': skillsRequestedController.text,
      }),
    );

    if (response.statusCode == 200) {
      // Job post successful, navigate to the home page
      print('Job post successful');
      Navigator.pop(context); // Close the PostAJobPage
    } else {
      // Handle errors, such as failed job post or server errors
      print('Failed to post job');
      print('Response: ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          },
          child: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
              size: 20,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        title: Text('New Post'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFieldWithLabel('Title', titleController),
            TextFieldWithLabel('Description', descriptionController),
            TextFieldWithLabel('Job Type', jobTypeController),
            TextFieldWithLabel('Field', fieldController),
            TextFieldWithLabel('Profile Requested', profileRequestedController),
            TextFieldWithLabel('Skills Requested', skillsRequestedController),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                postJob(context);
              },
              child: Text('Share your post'),
            ),
          ],
        ),
      ),
    );
  }
}

class TextFieldWithLabel extends StatelessWidget {
  final String label;
  final TextEditingController controller;

  const TextFieldWithLabel(this.label, this.controller);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
        ),
        keyboardType: TextInputType.text,
      ),
    );
  }
}
