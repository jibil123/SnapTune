
import 'package:flutter/material.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 50,
              color: Colors.grey,
              child: TextField(
                decoration: InputDecoration(
                   hintText: 'What do you want to litsen',
                   border: OutlineInputBorder()
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Text('All Songs',style: TextStyle(fontSize: 28,fontStyle: FontStyle.italic,fontWeight: FontWeight.bold),),
            ),

          ],
        ),
      ),
    );
  }
}