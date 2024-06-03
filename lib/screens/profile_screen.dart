import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:klimbat_launklim/screens/review_screen,dart';
import 'package:klimbat_launklim/screens/umpan_balik_screen.dart';
import 'package:klimbat_launklim/services/edit_profile.dart';
import 'package:klimbat_launklim/screens/sign_in_screen.dart';
import 'package:klimbat_launklim/screens/favorite_screen.dart';
import '../services/detail.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User? user;
  late Future<Map<String, dynamic>> _userDataFuture;
  File? _image;
  final ImagePicker _picker = ImagePicker();
  List<Detail> favorites = [];

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _userDataFuture = _getUserData();
      _loadFavorites();
    }
  }

  Future<Map<String, dynamic>> _getUserData() async {
    if (user == null) {
      throw Exception("User not logged in");
    }
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get();
    return userDoc.data() as Map<String, dynamic>;
  }

  Future<void> _loadFavorites() async {
    if (user == null) return;
    final userFavorites = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('favorites')
        .get();

    setState(() {
      favorites = userFavorites.docs
          .map((doc) => Detail(
                name: doc['name'],
                price: doc['price'],
                duration: doc['duration'],
              ))
          .toList();
    });
  }

  Future _pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.camera);
      if (image == null) return;

      final imageTemporary = File(image.path);
      setState(() => this._image = imageTemporary);
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  Future<void> _uploadImage() async {
    if (_image == null) return;
    try {
      final ref = FirebaseStorage.instance
          .ref()
          .child('user_images')
          .child('${user!.uid}.jpg');

      await ref.putFile(_image!);

      final url = await ref.getDownloadURL();

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .update({'profileImageUrl': url});

      setState(() {
        _userDataFuture = _getUserData();
      });
    } catch (e) {
      print('Error uploading image: $e');
    }
  }

  void _showPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.photo_library, color: Colors.black),
                title: Text('Gallery', style: TextStyle(color: Colors.black)),
                onTap: () {
                  _pickImage();
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
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
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () {
                        _showPicker(context);
                      },
                      child: FutureBuilder<Map<String, dynamic>>(
                        future: _userDataFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Stack(
                              children: [
                                CircleAvatar(
                                  radius: 60,
                                  backgroundColor: Colors.grey[200],
                                  child: Icon(
                                    Icons.person,
                                    size: 80,
                                    color: Colors.white,
                                  ),
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Container(
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.green,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.camera_alt,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          } else if (snapshot.hasError) {
                            return Stack(
                              children: [
                                CircleAvatar(
                                  radius: 60,
                                  backgroundColor: Colors.grey[200],
                                  child: Icon(
                                    Icons.error,
                                    size: 80,
                                    color: Colors.white,
                                  ),
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Container(
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.green,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.camera_alt,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          } else {
                            final userData = snapshot.data!;
                            return Stack(
                              children: [
                                CircleAvatar(
                                  radius: 60,
                                  backgroundImage:
                                      userData['profileImageUrl'] != null
                                          ? NetworkImage(
                                              userData['profileImageUrl'])
                                          : null,
                                  child: userData['profileImageUrl'] == null
                                      ? Icon(
                                          Icons.person,
                                          size: 80,
                                          color: Colors.white,
                                        )
                                      : null,
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Container(
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.green,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.camera_alt,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            FutureBuilder<Map<String, dynamic>>(
              future: _userDataFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}',
                      style: TextStyle(color: Colors.black));
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
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FavoriteScreen(
                                favorites: favorites,
                              ),
                            ),
                          );
                        },
                      ),
                      ProfileItem(
                        icon: Icons.feedback,
                        text: 'Umpan Balik',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => FeedbackScreen()),
                          );
                        },
                      ),
                      ProfileItem(
                        icon: Icons.reviews,
                        text: 'Review',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ReviewScreen()),
                          );
                        },
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () async {
                          await FirebaseAuth.instance.signOut();
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => SignInScreen()));
                        },
                        child: Text('Logout',
                            style: TextStyle(color: Colors.white)),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.lightBlueAccent,
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
                        child: Text('Edit Profile',
                            style: TextStyle(color: Colors.white)),
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
  final VoidCallback? onTap;

  ProfileItem({
    required this.icon,
    required this.text,
    this.isPrivate = false,
    this.isCommunity = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        padding: EdgeInsets.all(10),
        color: Colors.lightBlueAccent,
        child: Row(
          children: <Widget>[
            Icon(icon, size: 30, color: Colors.white),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ),
            if (isPrivate) Icon(Icons.lock, size: 20, color: Colors.white),
            if (isCommunity) Icon(Icons.group, size: 20, color: Colors.white),
          ],
        ),
      ),
    );
  }
}
