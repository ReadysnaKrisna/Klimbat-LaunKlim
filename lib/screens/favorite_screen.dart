import 'package:flutter/material.dart';
import '../services/detail.dart';

class FavoriteScreen extends StatelessWidget {
  final List<Detail> favorites;

  const FavoriteScreen({
    Key? key,
    required this.favorites,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorites'),
      ),
      body: Container(
        color: Colors.lightBlue[50],
        child: ListView.builder(
          padding: EdgeInsets.all(8.0),
          itemCount: favorites.length,
          itemBuilder: (context, index) {
            final detail = favorites[index];
            return Card(
              color: Colors.lightBlue,
              margin: EdgeInsets.symmetric(vertical: 8.0),
              child: ListTile(
                leading: Icon(Icons.local_laundry_service, color: Colors.white),
                title: Text(
                  detail.name,
                  style: TextStyle(color: Colors.white),
                ),
                subtitle: Text(
                  'Rp ${detail.price}\n${detail.duration}',
                  style: TextStyle(color: Colors.white),
                ),
                isThreeLine: true,
              ),
            );
          },
        ),
      ),
    );
  }
}
