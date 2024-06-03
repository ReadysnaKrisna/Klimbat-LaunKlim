import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:klimbat_launklim/models/detail_kiloan.dart';
import 'package:klimbat_launklim/models/detail_item_kasur.dart';
import 'package:klimbat_launklim/models/detail_pesan.dart';
import 'package:klimbat_launklim/models/detail_vip.dart';
import 'package:klimbat_launklim/screens/history_screen.dart';
import 'package:klimbat_launklim/screens/profile_screen.dart';
import 'package:klimbat_launklim/services/data.dart';
import 'package:klimbat_launklim/services/detail.dart';

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
          HistoryScreen(),
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

class HomeContent extends StatefulWidget {
  final Future<String> Function() getUserName;

  HomeContent({required this.getUserName});

  @override
  _HomeContentState createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  final TextEditingController _searchController = TextEditingController();
  List<Detail> _searchResults = [];

  void _searchItems(String query) {
    final List<Detail> results = [];
    if (query.isNotEmpty) {
      results.addAll(vipServices.where((service) =>
          service.name.toLowerCase().contains(query.toLowerCase())));
      results.addAll(kasurServices.where((service) =>
          service.name.toLowerCase().contains(query.toLowerCase())));
    }
    setState(() {
      _searchResults = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          FutureBuilder<String>(
            future: widget.getUserName(),
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
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search...',
                hintStyle: TextStyle(color: Colors.white),
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.white,
                ),
                filled: true,
                fillColor: Colors.lightBlueAccent,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onChanged: _searchItems,
            ),
          ),
          SizedBox(height: 30),
          _searchResults.isNotEmpty
              ? Expanded(
                  child: ListView.builder(
                    itemCount: _searchResults.length,
                    itemBuilder: (context, index) {
                      final detail = _searchResults[index];
                      return ListTile(
                        title: Text(detail.name),
                        subtitle:
                            Text('Rp ${detail.price}\n${detail.duration}'),
                        onTap: () {
                          if (vipServices.contains(detail)) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailVIP(),
                              ),
                            );
                          } else if (kasurServices.contains(detail)) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailItemKasur(),
                              ),
                            );
                          }
                        },
                      );
                    },
                  ),
                )
              : Flexible(
                  child: Column(
                    children: [
                      ServiceSection(),
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DetailPesan()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.lightBlueAccent,
                            padding: EdgeInsets.symmetric(
                                horizontal: 22, vertical: 16),
                          ),
                          child: Text('Pesan'),
                        ),
                      ),
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
    return Container(
      padding: EdgeInsets.all(16.0),
      color: Colors.lightBlueAccent,
      child: Center(
        child: Text(
          'Selamat Datang, $userName',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
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
    return Flexible(
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
          Icon(icon, size: 50, color: Colors.white),
          SizedBox(height: 8),
          Text(label, style: TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}
