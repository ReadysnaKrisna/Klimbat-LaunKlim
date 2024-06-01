import 'package:flutter/material.dart';

class HistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'History',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            OrderCard(orderNumber: '0002142', status: 'Sudah selesai'),
            OrderCard(orderNumber: '0002142', status: 'Sudah selesai'),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Account',
          ),
        ],
        currentIndex: 1,
        selectedItemColor: Colors.green,
        onTap: (index) {},
      ),
    );
  }
}

class OrderCard extends StatelessWidget {
  final String orderNumber;
  final String status;

  const OrderCard({required this.orderNumber, required this.status});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.local_laundry_service, color: Colors.blue),
        title: Text('Pesanan No.$orderNumber'),
        subtitle: Text(status),
      ),
    );
  }
}
