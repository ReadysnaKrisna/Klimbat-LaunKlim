import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:klimbat_launklim/services/edit_profile.dart';
import 'package:klimbat_launklim/screens/sign_in_screen.dart';
import 'package:klimbat_launklim/screens/favorite_screen.dart';
import '../services/detail.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late User? user;
  late Future<Map<String, dynamic>> _userDataFuture;
  File? _image;
  final ImagePicker _picker = ImagePicker();
  List<Detail> favorites = [];

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    _userDataFuture = _getUserData();
    _loadFavorites();
  }

  Future<Map<String, dynamic>> _getUserData() async {
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get();
    return userDoc.data() as Map<String, dynamic>;
  }

  Future<void> _loadFavorites() async {
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

  Future<void> _pickImage(ImageSource source) async {
    final XFile? selectedImage = await _picker.pickImage(source: source);

    if (selectedImage != null) {
      setState(() {
        _image = File(selectedImage.path);
      });
      await _uploadImage();
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
                    leading: Icon(Icons.photo_library),
                    title: Text('Gallery'),
                    onTap: () {
                      _pickImage(ImageSource.gallery);
                      Navigator.of(context).pop();
                    }),
                ListTile(
                  leading: Icon(Icons.photo_camera),
                  title: Text('Camera'),
                  onTap: () {
                    _pickImage(ImageSource.camera);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        });
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
                  GestureDetector(
                    onTap: () {
                      _showPicker(context);
                    },
                    child: FutureBuilder<Map<String, dynamic>>(
                      future: _userDataFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircleAvatar(
                            radius: 60,
                            backgroundColor: Colors.grey[200],
                            child: Icon(
                              Icons.person,
                              size: 80,
                            ),
                          );
                        } else if (snapshot.hasError) {
                          return CircleAvatar(
                            radius: 60,
                            backgroundColor: Colors.grey[200],
                            child: Icon(
                              Icons.error,
                              size: 80,
                            ),
                          );
                        } else {
                          final userData = snapshot.data!;
                          return CircleAvatar(
                            radius: 60,
                            backgroundImage: userData['profileImageUrl'] != null
                                ? NetworkImage(userData['profileImageUrl'])
                                : null,
                            child: userData['profileImageUrl'] == null
                                ? Icon(
                                    Icons.person,
                                    size: 80,
                                  )
                                : null,
                          );
                        }
                      },
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
      ),
    );
  }
}
