import 'package:flutter/material.dart';
import 'quote.dart';
import 'quote_card.dart';

void main() => runApp(MaterialApp(
  home: QuoteList(),
));

class QuoteList extends StatefulWidget {
  const QuoteList({super.key});

  @override
  State<QuoteList> createState() => _QuoteListState();
}

class _QuoteListState extends State<QuoteList> {
  List<Quote> quotes = [
    Quote(author: 'Oscar Wilde', text: 'Be yourself; everyone else is already taken', category: 'Inspiration'),
    Quote(author: 'Oscar Wilde', text: 'I have nothing to declare except my genius', category: 'Humor'),
    Quote(author: 'Oscar Wilde', text: 'The truth is rarely pure and never simple', category: 'Philosophy')
  ];
  void incrementLikes(Quote quote){
    setState((){
      quote.likes++;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text('Awesome Quotes'),
        centerTitle: true,
        backgroundColor: Colors.redAccent,
      ),
      body: Column(
        children: quotes.map((quote) => QuoteCard(quote: quote, onLike: () => incrementLikes(quote),)).toList(),
      )
    );
  }
}

