import 'package:flutter/material.dart';
//date package
import 'package:intl/intl.dart';
import 'quote.dart';

class QuoteCard extends StatelessWidget {
  final Quote quote;
  final VoidCallback onLike;
  final VoidCallback onDelete;

  QuoteCard({required this.quote, required this.onLike, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    String dateStr = DateFormat('MMM d, yyyy').format(quote.createdAt);

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
            const SizedBox(height: 6.0),

            // Category Chip
            Align(
              alignment: Alignment.centerLeft,
              child: Chip(
                label: Text(quote.category),
                backgroundColor: Colors.blue[100],
              ),
            ),

            // Show createdAt
            Text(
              "Added: $dateStr",
              style: TextStyle(color: Colors.grey[700], fontSize: 12.0),
            ),

            // Likes + Delete row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text('${quote.likes}'),
                    IconButton(
                      icon: const Icon(Icons.thumb_up, color: Colors.blue),
                      onPressed: onLike,
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text("Delete Quote"),
                        content: const Text("Are you sure you want to delete this quote?"),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx), // cancel
                            child: const Text("Cancel"),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(ctx); // close dialog
                              onDelete();          // call delete
                            },
                            child: const Text("Delete", style: TextStyle(color: Colors.red)),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}