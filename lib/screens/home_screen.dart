import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:klimbat_launklim/models/detail_pesan.dart';
import 'package:klimbat_launklim/models/detail_kiloan.dart';
import 'package:klimbat_launklim/models/detail_item_kasur.dart';
import 'package:klimbat_launklim/models/detail_vip.dart';
import 'package:klimbat_launklim/screens/history_screen.dart';
import 'package:klimbat_launklim/screens/profile_screen.dart';

class HomeScreen extends StatelessWidget {
  final User? user = FirebaseAuth.instance.currentUser;

  Future<String> _getUserName() async {
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get();
    return userDoc['nama'];
  }

  void _onItemTapped(BuildContext context, int index) {
    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HistoryScreen()),
      );
    }
    if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ProfileScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            FutureBuilder<String>(
              future: _getUserName(),
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
            SizedBox(
                height:
                    40), // Menambahkan jarak antara WelcomeSection dan Search
            Expanded(
              child: Column(
                children: [
                  SearchableServiceSection(),
                  SizedBox(height: 2),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailPesan(),
                        ),
                      );
                    },
                    child: Text('Pesan'),
                  ),
                  PesananAktif(),
                ],
              ),
            )
          ],
        ),
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
        onTap: (index) => _onItemTapped(context, index),
      ),
    );
  }
}

class WelcomeSection extends StatefulWidget {
  final String userName;

  WelcomeSection({required this.userName});

  @override
  _WelcomeSectionState createState() => _WelcomeSectionState();
}

class _WelcomeSectionState extends State<WelcomeSection> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Selamat Datang, ${widget.userName}',
            style: TextStyle(fontSize: 20)),
        SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                    hintText: 'Search Layanan',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                    fillColor: Colors.lightBlueAccent),
                onChanged: (value) {
                  context
                      .findAncestorStateOfType<_SearchableServiceSectionState>()
                      ?.updateSearchQuery(value);
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class SearchableServiceSection extends StatefulWidget {
  @override
  _SearchableServiceSectionState createState() =>
      _SearchableServiceSectionState();
}

class _SearchableServiceSectionState extends State<SearchableServiceSection> {
  final List<Layanan> _allServices = [
    Layanan(icon: Icons.local_laundry_service, label: 'Kiloan'),
    Layanan(icon: Icons.shopping_bag, label: 'Item Kasur'),
    Layanan(icon: Icons.dry_cleaning, label: 'VIP'),
  ];

  String _searchQuery = '';

  void updateSearchQuery(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Layanan> filteredServices = _allServices
        .where((service) =>
            service.label.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();

    return Expanded(
      child: GridView.builder(
        padding: EdgeInsets.all(8), // Menambahkan padding pada GridView
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 8, // Jarak horizontal antar item
          mainAxisSpacing: 8, // Jarak vertikal antar item
        ),
        itemCount: filteredServices.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              if (filteredServices[index].label == 'Kiloan') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailKiloan(),
                  ),
                );
              }
              if (filteredServices[index].label == 'Item Kasur') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailItemKasur(),
                  ),
                );
              }
              if (filteredServices[index].label == 'VIP') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailVIP(),
                  ),
                );
              }
            },
            child: filteredServices[index],
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
        color: Colors.blue,
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

class PesananAktif extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Pesanan Aktif',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
