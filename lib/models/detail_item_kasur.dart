import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/detail.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DetailItemKasur extends StatefulWidget {
  @override
  _DetailItemKasurState createState() => _DetailItemKasurState();
}

class _DetailItemKasurState extends State<DetailItemKasur> {
  final List<Detail> services = [
    Detail(name: 'Bedcover No.1', price: 25000, duration: '3 Hari'),
    Detail(name: 'Bedcover No.2', price: 20000, duration: '3 Hari'),
    Detail(name: 'Bedcover No.3', price: 15000, duration: '3 Hari'),
    Detail(name: 'Seprei No.1', price: 15000, duration: '3 Hari'),
    Detail(name: 'Seprei No.2', price: 10000, duration: '3 Hari'),
    Detail(name: 'Seprei No.3', price: 8000, duration: '3 Hari'),
    Detail(name: 'Seprei Sedang/Double', price: 15000, duration: '3 Hari'),
    Detail(name: 'Selimut Tebal', price: 15000, duration: '3 Hari'),
    Detail(name: 'Selimut Tipis', price: 10000, duration: '3 Hari'),
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
                'Item Kasur',
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
