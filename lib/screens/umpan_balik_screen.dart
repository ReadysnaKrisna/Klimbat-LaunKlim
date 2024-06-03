import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FeedbackScreen extends StatefulWidget {
  @override
  _FeedbackScreenState createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final _commentController = TextEditingController();

  Future<void> _submitFeedback() async {
    try {
      await FirebaseFirestore.instance.collection('feedbacks').add({
        'comment': _commentController.text,
        'timestamp': FieldValue.serverTimestamp(),
      });

      setState(() {
        _commentController.clear();
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Feedback submitted!')));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Umpan Balik'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _commentController,
              decoration: InputDecoration(labelText: 'Komentar'),
              maxLines: 3,
            ),
            Spacer(),
            ElevatedButton(
              onPressed: _submitFeedback,
              child: Text('Submit Feedback'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightBlueAccent,
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
