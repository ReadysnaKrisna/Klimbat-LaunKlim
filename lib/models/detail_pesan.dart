import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:klimbat_launklim/services/detail.dart';
import 'package:klimbat_launklim/services/location_service.dart';

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
    int total = 0;
    int ongkir = 5000;
    for (int i = 0; i < _selectedServices.length; i++) {
      if (_selectedServices[i]) {
        total += services[i].price;
      }
    }

    setState(() {
      _totalPayment = total + ongkir;
    });
  }

  void _getCurrentLocation() async {
    Position? currentPosition = await LocationService.getCurrentPosition();
    setState(() {
      _updateAddress(currentPosition);
    });
  }

  void _updateAddress(Position? position) {
    if (position != null) {
      _addressController.text =
          'Lat: ${position.latitude}, Long: ${position.longitude}';
    } else {
      _addressController.text = 'Unknown';
    }
  }

  void _submitOrder() async {
    List<Map<String, dynamic>> selectedServices = [];
    for (int i = 0; i < _selectedServices.length; i++) {
      if (_selectedServices[i]) {
        selectedServices.add({
          'name': services[i].name,
          'price': services[i].price,
          'duration': services[i].duration,
        });
      }
    }

    await FirebaseFirestore.instance.collection('orders').add({
      'location': _addressController.text,
      'services': selectedServices,
      'totalPayment': _totalPayment,
      'timestamp': FieldValue.serverTimestamp(),
    });

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Pemesanan', style: TextStyle(color: Colors.white)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              GestureDetector(
                onTap: () async {
                  _getCurrentLocation();
                },
                child: Container(
                  width: double.infinity,
                  color: Colors.lightBlueAccent,
                  padding: EdgeInsets.all(13),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _addressController,
                          decoration: InputDecoration(
                            hintText: 'Pilih Alamat',
                            hintStyle: TextStyle(color: Colors.white),
                            border: InputBorder.none,
                          ),
                          style: TextStyle(color: Colors.white),
                          enabled: false,
                        ),
                      ),
                      Icon(
                        Icons.edit,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16),
              Container(
                color: Colors.lightBlueAccent,
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Pilih Layanan',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    SizedBox(height: 8),
                    Column(
                      children: List.generate(services.length, (index) {
                        return Container(
                          color: Colors.lightBlueAccent,
                          child: CheckboxListTile(
                            title: Text(
                              services[index].name,
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                            ),
                            subtitle: Text(
                              'Rp ${services[index].price} - ${services[index].duration}',
                              style:
                                  TextStyle(fontSize: 14, color: Colors.white),
                            ),
                            value: _selectedServices[index],
                            onChanged: (bool? value) {
                              setState(() {
                                _selectedServices[index] = value ?? false;
                                _updateTotalPayment();
                              });
                            },
                            activeColor: Colors.white,
                            checkColor: Colors.lightBlueAccent,
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),
              Divider(thickness: 1, color: Colors.white),
              SizedBox(height: 8),
              Bayar(
                nama: 'Biaya Pengiriman:',
                harga: 5000,
                color: Colors.lightBlueAccent,
                textColor: Colors.white,
              ),
              Bayar(
                nama: 'Total Pembayaran:',
                harga: _totalPayment,
                color: Colors.lightBlueAccent,
                textColor: Colors.white,
              ),
              SizedBox(height: 10),
              Center(
                child: ElevatedButton(
                  onPressed: _submitOrder,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 22, vertical: 16),
                    backgroundColor: Colors.lightBlueAccent,
                    textStyle: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                  child: Text('PESAN SEKARANG',
                      style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Bayar extends StatelessWidget {
  final String nama;
  final int harga;
  final Color color;
  final Color textColor;

  const Bayar({
    required this.nama,
    required this.harga,
    required this.color,
    required this.textColor,
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
          Text(nama, style: TextStyle(fontSize: 16, color: textColor)),
          Text('Rp $harga', style: TextStyle(fontSize: 16, color: textColor)),
        ],
      ),
    );
  }
}
