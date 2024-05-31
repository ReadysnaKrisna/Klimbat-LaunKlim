import 'package:flutter/material.dart';

class DetailEkspress extends StatefulWidget {
  @override
  _DetailEkspressState createState() => _DetailEkspressState();
}

class _DetailEkspressState extends State<DetailEkspress> {
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  List<bool> _selectedServices = [false, false];
  int _totalPayment = 1500;

  void _updateTotalPayment() {
    int basePayment = 1500; // Biaya Pengiriman
    if (_selectedServices[0]) basePayment += 5000; // Kiloan
    if (_selectedServices[1]) basePayment += 10000; // Karpet

    setState(() {
      _totalPayment = basePayment;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:
            Color(0xFF81C8FF), // Match the color from the screenshot
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Detail Ekspress', style: TextStyle(color: Colors.black)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              color: Color(0xFF81C8FF), // Background color for address section
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
              color: Colors.grey[200] ??
                  Color(0xFFEEEEEE), // Background color for service section
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
                  ToggleButtons(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Kiloan', style: TextStyle(fontSize: 16)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Setrika saja',
                            style: TextStyle(fontSize: 16)),
                      ),
                    ],
                    isSelected: _selectedServices,
                    onPressed: (int index) {
                      setState(() {
                        _selectedServices[index] = !_selectedServices[index];
                        _updateTotalPayment();
                      });
                    },
                    fillColor: Color(0xFF81C8FF),
                    selectedColor: Colors.white,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  if (_selectedServices[0]) ...[
                    SizedBox(height: 8),
                    Container(
                      padding: EdgeInsets.all(8),
                      color: Colors.grey[100],
                      child: Column(
                        children: [
                          Text('Detail layanan Kiloan:',
                              style: TextStyle(fontSize: 14)),
                          Text('Rp 5000 - 1 Hari',
                              style: TextStyle(fontSize: 14)),
                        ],
                      ),
                    ),
                  ],
                  if (_selectedServices[1]) ...[
                    SizedBox(height: 8),
                    Container(
                      padding: EdgeInsets.all(8),
                      color: Colors.grey[100],
                      child: Column(
                        children: [
                          Text('Detail layanan Setrika:',
                              style: TextStyle(fontSize: 14)),
                          Text('Rp 2000 - 1 Hari',
                              style: TextStyle(fontSize: 14)),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Divider(thickness: 1, color: Colors.black),
            SizedBox(height: 8),
            SummaryTile(
              label: 'Biaya Pengiriman:',
              amount: 1500,
              color: Colors.grey[200] ?? Color(0xFFEEEEEE),
            ),
            SizedBox(height: 8),
            Container(
              color: Colors.grey[200] ??
                  Color(0xFFEEEEEE), // Background color for message section
              padding: EdgeInsets.all(16),
              child: TextField(
                controller: _messageController,
                decoration: InputDecoration(
                  hintText: 'Silahkan tinggalkan pesan',
                  hintStyle: TextStyle(color: Colors.black),
                  border: InputBorder.none,
                ),
                maxLines: 3,
                style: TextStyle(color: Colors.black),
              ),
            ),
            Spacer(),
            SummaryTile(
              label: 'Total Pembayaran:',
              amount: _totalPayment,
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
                  backgroundColor: Color(0xFF81C8FF), // Match the button color
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

class SummaryTile extends StatelessWidget {
  final String label;
  final int amount;
  final Color color;

  const SummaryTile({
    required this.label,
    required this.amount,
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
          Text(label, style: TextStyle(fontSize: 16)),
          Text('Rp $amount', style: TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}
