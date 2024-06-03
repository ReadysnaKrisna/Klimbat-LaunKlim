import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/detail.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DetailVIP extends StatefulWidget {
  @override
  _DetailVIPState createState() => _DetailVIPState();
}

class _DetailVIPState extends State<DetailVIP> {
  final List<Detail> services = [
    Detail(name: 'Gorden', price: 12000, duration: '3 Hari'),
    Detail(name: 'Vitrose', price: 7000, duration: '3 Hari'),
    Detail(name: 'Boneka Kecil', price: 7000, duration: '3 Hari'),
    Detail(name: 'Boneka Sedang', price: 15000, duration: '3 Hari'),
    Detail(name: 'Boneka Besar', price: 25000, duration: '3 Hari'),
    Detail(name: 'Stroller', price: 100000, duration: '3 Hari'),
    Detail(name: 'Kemeja/Batik', price: 12000, duration: '3 Hari'),
    Detail(name: 'Jas', price: 17000, duration: '3 Hari'),
    Detail(name: 'Setelan Jas', price: 30000, duration: '3 Hari'),
    Detail(name: 'Jaket', price: 20000, duration: '3 Hari'),
    Detail(name: 'Gamis', price: 17000, duration: '3 Hari'),
    Detail(name: 'Setelan Wanita', price: 17000, duration: '3 Hari'),
  ];

  List<Detail> favorites = [];
  User? user;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    _loadFavorites();
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

  Future<void> _toggleFavorite(Detail detail) async {
    final userDoc = FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('favorites')
        .doc(detail.name);

    if (favorites.contains(detail)) {
      await userDoc.delete();
      setState(() {
        favorites.remove(detail);
      });
    } else {
      await userDoc.set({
        'name': detail.name,
        'price': detail.price,
        'duration': detail.duration,
      });
      setState(() {
        favorites.add(detail);
      });
    }
  }

  bool _isFavorite(Detail detail) {
    return favorites.any((favorite) => favorite.name == detail.name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Laundry - LaunKlim'),
      ),
      body: Container(
        color: Colors.lightBlue[50],
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(16.0),
              alignment: Alignment.center,
              color: Colors.lightBlue,
              child: Text(
                'VIP',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.all(8.0),
                itemCount: services.length,
                itemBuilder: (context, index) {
                  final detail = services[index];
                  final isFavorite = _isFavorite(detail);
                  return Card(
                    color: Colors.lightBlue,
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: ListTile(
                            leading: Icon(
                              Icons.local_laundry_service,
                              color: Colors.white,
                            ),
                            title: Text(
                              detail.name,
                              style: TextStyle(color: Colors.white),
                            ),
                            subtitle: Text(
                              'Rp ${detail.price}\n${detail.duration}',
                              style: TextStyle(color: Colors.white),
                            ),
                            isThreeLine: true,
                          ),
                        ),
                        IconButton(
                          onPressed: () => _toggleFavorite(detail),
                          icon: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
