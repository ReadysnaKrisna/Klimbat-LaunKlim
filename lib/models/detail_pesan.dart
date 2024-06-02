import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:klimbat_launklim/services/location_service.dart';

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
  TextEditingController _addressController = TextEditingController();
  List<bool> _selectedServices = [false, false, false, false, false];
  int _totalPayment = 0;
  final int _ongkir = 5000;

  final List<Detail> services = [
    Detail(name: 'Reguler', price: 7000, duration: '3 Hari'),
    Detail(name: 'Cuci Cepat', price: 12000, duration: '1 Hari'),
    Detail(name: 'Setrika Reguler', price: 4500, duration: '3 Hari'),
    Detail(name: 'Setrika Cepat', price: 7000, duration: '1 Hari'),
    Detail(name: 'Cuci Kering', price: 4000, duration: '3 Jam'),
  ];

  late GoogleMapController _mapController;
  Position? _currentPosition;

  @override
  void initState() {
    super.initState();
    _initializeFirebase();
  }

  Future<void> _initializeFirebase() async {
    await Firebase.initializeApp();
  }

  void _updateTotalPayment() {
    int total = 0;
    for (int i = 0; i < _selectedServices.length; i++) {
      if (_selectedServices[i]) {
        total += services[i].price;
      }
    }

    setState(() {
      _totalPayment = total + _ongkir;
    });
  }

  Future<void> _pickLocation() async {
    Position? position = await LocationService.getCurrentPosition();
    if (position != null) {
      setState(() {
        _currentPosition = position;
        _addressController.text =
            'Lat: ${position.latitude}, Long: ${position.longitude}';
        _mapController.animateCamera(
          CameraUpdate.newLatLng(
            LatLng(position.latitude, position.longitude),
          ),
        );
      });
    } else {
      // Handle location permission denied
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Location permission denied')),
      );
    }
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
                  suffixIcon: IconButton(
                    icon: Icon(Icons.location_on, color: Colors.white),
                    onPressed: _pickLocation,
                  ),
                ),
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(height: 16),
            _currentPosition == null
                ? Container(
                    color: Colors.grey[200] ?? Color(0xFFEEEEEE),
                    height: 200,
                    child: Center(child: Text('Loading map...')),
                  )
                : Container(
                    color: Colors.grey[200] ?? Color(0xFFEEEEEE),
                    height: 200,
                    child: GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: LatLng(
                          _currentPosition!.latitude,
                          _currentPosition!.longitude,
                        ),
                        zoom: 15,
                      ),
                      onMapCreated: (controller) {
                        _mapController = controller;
                      },
                      myLocationEnabled: true,
                      myLocationButtonEnabled: true,
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
              harga: _ongkir,
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
                  backgroundColor: Colors.lightBlueAccent,
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
