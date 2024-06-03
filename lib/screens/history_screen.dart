import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HistoryScreen extends StatelessWidget {
  Future<void> _deleteOrder(String orderId) async {
    await FirebaseFirestore.instance.collection('orders').doc(orderId).delete();
  }

  Future<void> _confirmDelete(BuildContext context) async {
    var orders = await FirebaseFirestore.instance.collection('orders').get();
    var ordersToDelete = orders.docs.where((doc) {
      var orderData = doc.data();
      return orderData['status'] == 'Selesai';
    }).toList();

    if (ordersToDelete.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text("Tidak ada riwayat pemesanan yang bisa dihapus.")),
      );
      return;
    }

    bool? shouldDelete = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Konfirmasi Hapus'),
          content: Text(
              'Apakah Anda yakin ingin menghapus riwayat pemesanan yang selesai?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text('Tidak'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text('Ya'),
            ),
          ],
        );
      },
    );

    if (shouldDelete == true) {
      for (var order in ordersToDelete) {
        await _deleteOrder(order.id);
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text("Riwayat pemesanan yang selesai telah dihapus.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(16.0),
            color: Colors.lightBlueAccent,
            child: Center(
              child: Text(
                'History',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('orders')
                    .orderBy('timestamp', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }
                  var orders = snapshot.data!.docs;
                  if (orders.isEmpty) {
                    return Center(child: Text("Tidak ada riwayat pemesanan"));
                  }
                  return ListView.builder(
                    itemCount: orders.length,
                    itemBuilder: (context, index) {
                      var order = orders[index];
                      var orderData = order.data() as Map<String, dynamic>;
                      var services = orderData['services'] as List<dynamic>;
                      var status = orderData.containsKey('status')
                          ? orderData['status']
                          : 'Dalam Proses';
                      return Card(
                        child: Container(
                          color: Colors.lightBlueAccent,
                          padding: EdgeInsets.all(8.0),
                          child: ListTile(
                            title: Text('Order at ${orderData['location']}'),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    'Total Pembayaran: Rp ${orderData['totalPayment']}'),
                                SizedBox(height: 4),
                                Text('Layanan:'),
                                ...services.map((service) {
                                  return Text(
                                      '${service['name']} - Rp ${service['price']} - ${service['duration']}');
                                }).toList(),
                                SizedBox(height: 8),
                                Text('Status: $status'),
                                if (status == 'Dalam Proses')
                                  ElevatedButton(
                                    onPressed: () {
                                      FirebaseFirestore.instance
                                          .collection('orders')
                                          .doc(order.id)
                                          .update({'status': 'Selesai'});
                                    },
                                    child: Text('Selesaikan'),
                                  ),
                              ],
                            ),
                            isThreeLine: true,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Center(
              child: ElevatedButton(
                onPressed: () => _confirmDelete(context),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 22, vertical: 16),
                  backgroundColor: Colors.lightBlueAccent,
                  textStyle: TextStyle(fontSize: 18, color: Colors.white),
                ),
                child: Text('Hapus Riwayat',
                    style: TextStyle(color: Colors.white)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
