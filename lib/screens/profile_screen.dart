import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:klimbat_launklim/services/edit_profile.dart';
import 'package:klimbat_launklim/screens/sign_in_screen.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late User? user;
  late Future<Map<String, dynamic>> _userDataFuture;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    _userDataFuture = _getUserData();
  }

  Future<Map<String, dynamic>> _getUserData() async {
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get();
    return userDoc.data() as Map<String, dynamic>;
  }

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
            FutureBuilder<Map<String, dynamic>>(
              future: _userDataFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  final userData = snapshot.data!;
                  return Column(
                    children: [
                      ProfileItem(
                        icon: Icons.person,
                        text: userData['nama'] ?? 'Tidak ada Nama',
                      ),
                      ProfileItem(
                        icon: Icons.phone,
                        text: userData['phone'] ?? 'Tidak ada nomor hp',
                      ),
                      ProfileItem(
                        icon: Icons.email,
                        text: userData['email'] ?? 'Tidak ada email',
                      ),
                      ProfileItem(
                        icon: Icons.favorite,
                        text: 'Favorite',
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () async {
                          await FirebaseAuth.instance.signOut();
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => SignInScreen()));
                        },
                        child: Text('Logout'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          padding: EdgeInsets.symmetric(
                              horizontal: 100, vertical: 15),
                        ),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () async {
                          final Map<String, dynamic>? updatedData =
                              await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditProfileScreen(
                                name: userData['nama'] ?? '',
                                phone: userData['phone'] ?? '',
                                email: userData['email'] ?? '',
                              ),
                            ),
                          );

                          if (updatedData != null) {
                            setState(() {
                              _userDataFuture = Future.value(updatedData);
                            });
                          }
                        },
                        child: Text('Edit Profile'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.lightBlueAccent,
                          padding: EdgeInsets.symmetric(
                              horizontal: 100, vertical: 15),
                        ),
                      ),
                    ],
                  );
                }
              },
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
