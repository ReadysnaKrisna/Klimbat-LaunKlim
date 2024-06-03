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
        child: favorites.isEmpty
            ? Center(
                child: Text(
                  'No favorites added.',
                  style: TextStyle(fontSize: 18),
                ),
              )
            : ListView.builder(
                itemCount: favorites.length,
                itemBuilder: (context, index) {
                  final favorite = favorites[index];
                  return Card(
                    margin: EdgeInsets.all(10),
                    child: ListTile(
                      title: Text(favorite.name),
                      subtitle:
                          Text('${favorite.price} - ${favorite.duration}'),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
