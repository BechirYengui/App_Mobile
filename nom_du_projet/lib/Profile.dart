import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProfilePage extends StatefulWidget {
  final String email;

  ProfilePage({required this.email});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String _firstName = '';
  String _lastName = '';
  String _job = '';
  String _birthday = '';
  String _skills = '';

  @override
  void initState() {
    super.initState();
    fetchUserProfile();
  }

  Future<void> fetchUserProfile() async {
    try {
      final response = await http.post(
        Uri.parse('http://127.0.0.1:5000/get-user-profile'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'Email': widget.email}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _firstName = data['first_name'];
          _lastName = data['last_name'];
          _job = data['job'];
          _birthday = data['birthday'];
          _skills = data['skills'];
        });
      } else {
        print('Failed to fetch user profile data');
      }
    } catch (e) {
      print('Exception: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildText('First Name:', _firstName),
            buildText('Last Name:', _lastName),
            buildText('Job:', _job),
            buildText('Birthday:', _birthday),
            buildText('Skills:', _skills),
          ],
        ),
      ),
    );
  }

  Widget buildText(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text(
          '$value',
          style: TextStyle(fontSize: 16),
        ),
        SizedBox(height: 16),
      ],
    );
  }
}
