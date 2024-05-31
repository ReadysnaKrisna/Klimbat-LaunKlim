import 'package:flutter/material.dart';

class Detail {
  final String name;
  final int price;
  final String duration;

  Detail({required this.name, required this.price, required this.duration});
}

class DetailSatuan extends StatelessWidget {
  final List<Detail> services = [
    Detail(name: '1 kg (Pakaian Dalam)', price: 5000, duration: '12 Jam'),
    Detail(name: '1 kg (Pakaian Dalam)', price: 10000, duration: '6 Jam'),
    Detail(name: '1 kg (Pakaian Dalam)', price: 15000, duration: '3 Jam'),
    Detail(name: '1 kg (Pakaian Biasa)', price: 15000, duration: '3 Jam'),
    Detail(name: '1 kg (Pakaian Biasa)', price: 12000, duration: '1 Jam'),
    Detail(name: '1 kg (Pakaian Biasa)', price: 18000, duration: '12 Jam'),
    Detail(name: '1 kg (Pakaian Kerja)', price: 8000, duration: '3 Jam,'),
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
              color: Colors.lightBlue,
              child: Text(
                'Satuan',
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
                    color: Colors.lightBlue,
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
