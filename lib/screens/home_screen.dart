import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:klimbat_launklim/models/detail_kiloan.dart';
import 'package:klimbat_launklim/models/detail_item_kasur.dart';
import 'package:klimbat_launklim/models/detail_pesan.dart';
import 'package:klimbat_launklim/models/detail_vip.dart';
import 'package:klimbat_launklim/screens/history_screen.dart';
import 'package:klimbat_launklim/screens/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final User? user = FirebaseAuth.instance.currentUser;
  int _selectedIndex = 0;
  final PageController _pageController = PageController();

  Future<String> _getUserName() async {
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get();
    return userDoc['nama'];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: [
          HomeContent(getUserName: _getUserName),
          HistoryScreen(
            orders: [],
          ),
          ProfileScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Account',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  final Future<String> Function() getUserName;

  HomeContent({required this.getUserName});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          FutureBuilder<String>(
            future: getUserName(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return WelcomeSection(userName: snapshot.data ?? 'User');
              }
            },
          ),
          SizedBox(height: 30),
          Expanded(
            child: Column(
              children: [
                ServiceSection(),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => DetailPesan()));
                  },
                  child: Text('Pesan'),
                )
                // PesananAktif(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class WelcomeSection extends StatelessWidget {
  final String userName;

  WelcomeSection({required this.userName});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Selamat Datang, $userName', style: TextStyle(fontSize: 20)),
      ],
    );
  }
}

class ServiceSection extends StatelessWidget {
  final List<Layanan> _allServices = [
    Layanan(icon: Icons.local_laundry_service, label: 'Kiloan'),
    Layanan(icon: Icons.shopping_bag, label: 'Item Kasur'),
    Layanan(icon: Icons.dry_cleaning, label: 'VIP'),
  ];

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GridView.builder(
        padding: EdgeInsets.all(4),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: _allServices.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              if (_allServices[index].label == 'Kiloan') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailKiloan(),
                  ),
                );
              }
              if (_allServices[index].label == 'Item Kasur') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailItemKasur(),
                  ),
                );
              }
              if (_allServices[index].label == 'VIP') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailVIP(),
                  ),
                );
              }
            },
            child: _allServices[index],
          );
        },
      ),
    );
  }
}

class Layanan extends StatelessWidget {
  final IconData icon;
  final String label;

  const Layanan({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.lightBlueAccent,
        border: Border.all(color: Colors.lightBlueAccent),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 50, color: Colors.black),
          Text(label, style: TextStyle(color: Colors.black)),
        ],
      ),
    );
  }
}
