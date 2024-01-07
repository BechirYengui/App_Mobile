import 'package:flutter/material.dart';

import 'Search.dart';
import 'home_page.dart';
import 'notification.dart';
import 'post_a_job.dart';

class message extends StatefulWidget {
  @override
  _MsgState createState() => _MsgState();
}

class _MsgState extends State<message> {
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: const Color(0xffadd4f3),
        appBar: AppBar(
          title: const Text(
            'Messages', // Modification ici
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Color(0xff003f5f),
            ),
          ),
          backgroundColor: const Color(0xffadd4f3),
          actions: const <Widget>[
            Padding(
              padding: EdgeInsets.all(6),
              child: Text(
                'Freelansi',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff003f5f),
                ),
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            Container(
              height: 1,
              color: const Color(0xfff8f8f8),
            ),
            // Le reste du corps ici
          ],
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
            BottomNavigationBarItem(
                icon: Icon(Icons.message), label: 'Messages'),
            BottomNavigationBarItem(
                icon: Icon(Icons.notifications), label: 'Notifications'),
          ],
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
            // Ajouter la logique de navigation en fonction de l'index si nécessaire
            if (index == 0) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
              );
              // Navigation vers la page d'accueil
            } else if (index == 1) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PostAJobPage()),
              );
              // Navigation vers la nouvelle publication
            } else if (index == 2) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Search()),
              );
              // Navigation vers la recherche
            } else if (index == 3) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => message()),
              );
              // Navigation vers les messages
            } else if (index == 4) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Notifications()),
              );
              // Navigation vers les notifications
            }
          },
        ),
      ),
    );
  }
}
