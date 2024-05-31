import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:klimbat_launklim/models/detail_kiloan.dart';
import 'package:klimbat_launklim/models/detail_satuan.dart';
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
            Expanded(
              child: Column(
                children: [
                  SearchableServiceSection(),
                  ActiveOrdersSection(),
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
  final TextEditingController _addressController = TextEditingController();
  String _address = '';

  @override
  void initState() {
    super.initState();
    _loadAddress();
  }

  Future<void> _loadAddress() async {
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    setState(() {
      _address = userDoc['address'] ?? '';
      _addressController.text = _address;
    });
  }

  Future<void> _updateAddress() async {
    String newAddress = _addressController.text;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({'address': newAddress});
    setState(() {
      _address = newAddress;
    });
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    String newAddress =
        'Lat: ${position.latitude}, Long: ${position.longitude}';
    _addressController.text = newAddress;
    _updateAddress();
  }

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
                ),
                onChanged: (value) {
                  context
                      .findAncestorStateOfType<_SearchableServiceSectionState>()
                      ?.updateSearchQuery(value);
                },
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: _addressController,
                decoration: InputDecoration(
                  hintText: 'Alamat',
                  prefixIcon: Icon(Icons.location_on),
                  border: OutlineInputBorder(),
                ),
                onSubmitted: (value) => _updateAddress(),
              ),
            ),
            IconButton(
              icon: Icon(Icons.my_location),
              onPressed: _getCurrentLocation,
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
  final List<ServiceTile> _allServices = [
    ServiceTile(icon: Icons.local_laundry_service, label: 'Kiloan'),
    ServiceTile(icon: Icons.shopping_bag, label: 'Satuan'),
    ServiceTile(icon: Icons.dry_cleaning, label: 'VIP'),
    ServiceTile(icon: Icons.iron, label: 'Setrika Saja'),
    ServiceTile(icon: Icons.flash_on, label: 'Ekspress'),
  ];

  String _searchQuery = '';

  void updateSearchQuery(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<ServiceTile> filteredServices = _allServices
        .where((service) =>
            service.label.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();

    return Expanded(
      child: GridView.count(
        crossAxisCount: 3,
        children: filteredServices.map((service) {
          return GestureDetector(
            onTap: () {
              if (service.label == 'Kiloan') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailKiloan(),
                  ),
                );
              }
              if (service.label == 'Satuan') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailSatuan(),
                  ),
                );
              }
            },
            child: service,
          );
        }).toList(),
      ),
    );
  }
}

class ServiceTile extends StatelessWidget {
  final IconData icon;
  final String label;

  const ServiceTile({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 50),
        Text(label),
      ],
    );
  }
}

class ActiveOrdersSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Pesanan Aktif',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ActiveOrderTile(orderNumber: '0002142', status: 'Sudah selesai'),
        ActiveOrderTile(orderNumber: '0002143', status: 'Masih dicuci'),
      ],
    );
  }
}

class ActiveOrderTile extends StatelessWidget {
  final String orderNumber;
  final String status;

  const ActiveOrderTile({required this.orderNumber, required this.status});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(Icons.local_laundry_service),
        title: Text('Pesanan No.$orderNumber'),
        subtitle: Text(status),
      ),
    );
  }
}
