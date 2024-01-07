import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nom_du_projet/Profile.dart';
import 'package:nom_du_projet/Search.dart';
import 'package:nom_du_projet/message.dart';
import 'package:nom_du_projet/notification.dart';
import 'package:nom_du_projet/post_a_job.dart';
import 'package:nom_du_projet/signin.dart';
import 'dart:convert';

import 'package:nom_du_projet/signup.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class ProfileDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.6,
        color: Colors.white,
        padding:
            EdgeInsets.only(top: 32.0, bottom: 32.0), // Adjust the values here
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Already have an account? Login'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.person_add),
              title: Text("Don't have an account? Sign up"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignupPage()),
                );
              },
            ),
            Spacer(),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {
                Navigator.pop(context);
                // Add logic for settings here if necessary
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    double boxWidth = MediaQuery.of(context).size.width * 0.9;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Color(0xFFADD4F3),
        leading: IconButton(
          icon: Icon(
            Icons.account_circle,
            color: Color(0xFF284E7B),
          ),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: TextButton(
              onPressed: () {
                // Add logic for the right action button here if needed
              },
              child: Text(
                'Freelansi',
                style: TextStyle(
                  color: Color(0xFF284E7B),
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
          ),
        ],
      ),
      drawer: ProfileDrawer(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Box 1
            buildRoundedBox(context, boxWidth),
            // Box 2
            buildRoundedBox(context, boxWidth),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0xFF284E7B),
        selectedItemColor: Color(0xFFADD4F3),
        unselectedItemColor: Color(0xFFADD4F3),
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
        unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: 'New Post'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.message), label: 'Messages'),
          BottomNavigationBarItem(
              icon: Icon(Icons.notifications), label: 'Notifications'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });

          if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          } else if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PostAJobPage()),
            );
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Search()),
            );
          } else if (index == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => message()),
            );
          } else if (index == 4) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Notifications()),
            );
          } else if (index == 5) {
            // Pass the user's email to the ProfilePage
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ProfilePage(email: 'user@example.com')),
            );
          }
        },
      ),
    );
  }

  Widget buildRoundedBox(BuildContext context, double boxWidth) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: fetchJobPosts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Erreur: ${snapshot.error}'));
        } else if (snapshot.data == null || snapshot.data!.isEmpty) {
          return Center(child: Text('Aucune offre d\'emploi disponible.'));
        } else {
          final List<Map<String, dynamic>> jobPosts = snapshot.data!;
          return Column(
            children: jobPosts.map((jobPost) {
              return Container(
                width: boxWidth,
                margin: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Titre: ${jobPost['title']}'),
                          Text('Description: ${jobPost['description']}'),
                          Text('Type d\'emploi: ${jobPost['JobType']}'),
                          Text('Domaine: ${jobPost['Field']}'),
                          Text(
                              'Profil demandé: ${jobPost['ProfileRequested']}'),
                          Text(
                              'Compétences demandées: ${jobPost['SkillsRequested']}'),
                        ],
                      ),
                    ),
                    // Ajouter d'autres widgets d'offres d'emploi si nécessaire
                  ],
                ),
              );
            }).toList(),
          );
        }
      },
    );
  }

  Future<List<Map<String, dynamic>>> fetchJobPosts() async {
    try {
      final response = await http.get(
        Uri.parse('http://127.0.0.1:5000/get-job-details'),
        headers: {'Content-Type': 'application/json'},
        // Vous pouvez passer les paramètres nécessaires ici
      );

      if (response.statusCode == 200) {
        final dynamic responseData = json.decode(response.body);

        if (responseData['success'] == true) {
          // Si la réponse contient 'success' à true
          return List<Map<String, dynamic>>.from(responseData['job_details']);
        } else {
          throw Exception(
              'Format de réponse invalide ou détails de l\'emploi manquants');
        }
      } else {
        throw Exception(
            'Échec du chargement des détails de l\'emploi. Code d\'état: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception: $e');
      throw Exception(
          'Échec du chargement des détails de l\'emploi. Vérifiez votre connexion réseau.');
    }
  }
}
