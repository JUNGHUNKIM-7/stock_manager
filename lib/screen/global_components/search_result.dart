import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SearchResultPage extends StatelessWidget {
  const SearchResultPage({Key? key, required this.text}) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          children: [
            Text(text),
            ElevatedButton(
                onPressed: () {
                  context.goNamed('home');
                },
                child: const Text('home'))
          ],
        ),
      ),
    );
  }
}
