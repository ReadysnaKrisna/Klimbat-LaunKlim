import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              color: Colors.lightBlueAccent,
              width: double.infinity,
              padding: EdgeInsets.all(20),
              child: Column(
                children: <Widget>[
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey[200],
                    child: Icon(
                      Icons.person,
                      size: 50,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
            ProfileItem(
              icon: Icons.person,
              text: 'Readysna Krisna Pambudi',
            ),
            ProfileItem(
              icon: Icons.phone,
              text: '082377832998',
            ),
            ProfileItem(
              icon: Icons.email,
              text: 'koalawaruk123@gmail.com',
            ),
            ProfileItem(
              icon: Icons.favorite,
              text: 'Favorite',
              isPrivate: true,
            ),
            ProfileItem(
              icon: Icons.feedback,
              text: 'Umpan Balik',
              isCommunity: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {},
              child: Text('Logout'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightBlueAccent,
                padding: EdgeInsets.symmetric(horizontal: 100, vertical: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool isPrivate;
  final bool isCommunity;

  ProfileItem({
    required this.icon,
    required this.text,
    this.isPrivate = false,
    this.isCommunity = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.all(10),
      color: Colors.lightBlueAccent,
      child: Row(
        children: <Widget>[
          Icon(icon, size: 30),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ),
          if (isPrivate) Icon(Icons.lock, size: 20, color: Colors.black),
          if (isCommunity) Icon(Icons.group, size: 20, color: Colors.black),
        ],
      ),
    );
  }
}
