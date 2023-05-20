import 'package:flutter/material.dart';

import 'drawer.dart';

class Termspage extends StatelessWidget {
  const Termspage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        title: const Text(
          "MOVEASY",
          style: TextStyle(
              color: Colors.white, fontSize: 27, fontWeight: FontWeight.bold),
        ),
      ),
      drawer: MyDrawer(),
      body: Container(
        child: Center(child: Text('TNC')),
      ),
    );
  }
}
