import 'package:flutter/material.dart';

class Detail {
  final String name;
  final int price;
  final String duration;

  Detail({required this.name, required this.price, required this.duration});
}

class DetailPesan extends StatefulWidget {
  @override
  _DetailPesanState createState() => _DetailPesanState();
}

class _DetailPesanState extends State<DetailPesan> {
  final TextEditingController _addressController = TextEditingController();

  List<bool> _selectedServices = [false, false, false, false, false];
  int _totalPayment = 0;

  final List<Detail> services = [
    Detail(name: 'Reguler', price: 7000, duration: '3 Hari'),
    Detail(name: 'Cuci Cepat', price: 12000, duration: '1 Hari'),
    Detail(name: 'Setrika Reguler', price: 4500, duration: '3 Hari'),
    Detail(name: 'Setrika Cepat', price: 7000, duration: '1 Hari'),
    Detail(name: 'Cuci Kering', price: 4000, duration: '3 Jam'),
  ];

  void _updateTotalPayment() {
    int ongkir = 0;
    for (int i = 0; i < _selectedServices.length; i++) {
      if (_selectedServices[i]) {
        ongkir += services[i].price;
      }
    }

    setState(() {
      _totalPayment = ongkir;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Pemesanan', style: TextStyle(color: Colors.black)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              color: Colors.lightBlueAccent,
              padding: EdgeInsets.all(16),
              child: TextField(
                controller: _addressController,
                decoration: InputDecoration(
                  hintText: 'Pilih Alamat',
                  hintStyle: TextStyle(color: Colors.white),
                  border: InputBorder.none,
                ),
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(height: 16),
            Container(
              color: Colors.grey[200] ?? Color(0xFFEEEEEE),
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Pilih Layanan',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  SizedBox(height: 8),
                  Column(
                    children: List.generate(services.length, (index) {
                      return CheckboxListTile(
                        title: Text(
                          services[index].name,
                          style: TextStyle(fontSize: 16),
                        ),
                        subtitle: Text(
                          'Rp ${services[index].price} - ${services[index].duration}',
                          style: TextStyle(fontSize: 14),
                        ),
                        value: _selectedServices[index],
                        onChanged: (bool? value) {
                          setState(() {
                            _selectedServices[index] = value ?? false;
                            _updateTotalPayment();
                          });
                        },
                      );
                    }),
                  ),
                ],
              ),
            ),
            Divider(thickness: 1, color: Colors.black),
            SizedBox(height: 8),
            Bayar(
              nama: 'Biaya Pengiriman:',
              harga: 5000,
              color: Colors.grey[200] ?? Color(0xFFEEEEEE),
            ),
            Spacer(),
            Bayar(
              nama: 'Total Pembayaran:',
              harga: _totalPayment,
              color: Colors.grey[200] ?? Color(0xFFEEEEEE),
            ),
            SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Handle order submission logic here
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 16),
                  backgroundColor:
                      Colors.lightBlueAccent, // Match the button color
                  textStyle: TextStyle(fontSize: 18, color: Colors.black),
                ),
                child: Text('PESAN', style: TextStyle(color: Colors.black)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Bayar extends StatelessWidget {
  final String nama;
  final int harga;
  final Color color;

  const Bayar({
    required this.nama,
    required this.harga,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(nama, style: TextStyle(fontSize: 16)),
          Text('Rp $harga', style: TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}
