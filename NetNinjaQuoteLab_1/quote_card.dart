import 'package:flutter/material.dart';
import 'quote.dart';

class QuoteCard extends StatelessWidget {

  final Quote quote;
  final VoidCallback onLike;
  QuoteCard({required this.quote, required this.onLike});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              quote.text,
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 6.0),
            Text(
              quote.author,
              style: TextStyle(
                fontSize: 14.0,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 8.0),

            // Category Chip
            Align(
              alignment: Alignment.centerLeft,
              child: Chip(
                label: Text(quote.category),
                backgroundColor: Colors.blue[100],
              ),
            ),

            // Likes row
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text('${quote.likes}'),
                IconButton(
                  icon: const Icon(Icons.thumb_up, color: Colors.blue),
                  onPressed: onLike,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}