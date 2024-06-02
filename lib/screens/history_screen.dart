import 'package:flutter/material.dart';
import 'package:klimbat_launklim/services/detail.dart';

class HistoryScreen extends StatelessWidget {
  final List<Detail> orders;

  HistoryScreen({required this.orders});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'History',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  final order = orders[index];
                  return ListTile(
                    title: Text(order.name),
                    subtitle: Text('Rp ${order.price} - ${order.duration}'),
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
