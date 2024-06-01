import 'package:flutter/material.dart';

class Detail {
  final String name;
  final int price;
  final String duration;

  Detail({required this.name, required this.price, required this.duration});
}

class DetailVIP extends StatelessWidget {
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
                'VIP',
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
