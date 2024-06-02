import 'package:flutter/material.dart';
import '../services/detail.dart';

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

  void toggleFavorite(Detail detail) {
    setState(() {
      if (favorites.contains(detail)) {
        favorites.remove(detail);
      } else {
        favorites.add(detail);
      }
    });
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
                    color: Colors.white),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.all(8.0),
                itemCount: services.length,
                itemBuilder: (context, index) {
                  final detail = services[index];
                  final isFavorite = favorites.contains(detail);
                  return Card(
                    color: Colors.lightBlue,
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: ListTile(
                            leading: Icon(Icons.local_laundry_service,
                                color: Colors.white),
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
                          onPressed: () => toggleFavorite(detail),
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
