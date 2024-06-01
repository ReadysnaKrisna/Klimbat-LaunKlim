import 'package:flutter/material.dart';

class Detail {
  final String name;
  final int price;
  final String duration;

  Detail({required this.name, required this.price, required this.duration});
}

class DetailKiloan extends StatelessWidget {
  final List<Detail> services = [
    Detail(name: 'Reguler', price: 7000, duration: '3 Hari'),
    Detail(name: 'Cuci Cepat', price: 12000, duration: '1 Hari'),
    Detail(name: 'Setrika Reguler', price: 4500, duration: '3 Hari'),
    Detail(name: 'Setrika Cepat', price: 7000, duration: '1 Hari'),
    Detail(name: 'Cuci Kering', price: 4000, duration: '3 Jam'),
  ];

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
              color: Colors.lightBlueAccent,
              child: Text(
                'Kiloan',
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
                  return Card(
                    color: Colors.lightBlueAccent,
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      leading: Icon(Icons.local_laundry_service,
                          color: Colors.white),
                      title: Text(
                        services[index].name,
                        style: TextStyle(color: Colors.white),
                      ),
                      subtitle: Text(
                        'Rp ${services[index].price}\n${services[index].duration}',
                        style: TextStyle(color: Colors.white),
                      ),
                      isThreeLine: true,
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
