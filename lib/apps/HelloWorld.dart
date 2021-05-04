import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HelloWorld extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    int x = 2~/3;
    int y = 2 % 3;
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("HelloWorldTitle"),
        ),
        body: new SingleChildScrollView(
            child: Column(
          children: [
            SizedBox(height: 2,),
            Text("$x$y")
          ],
        )),
      ),
    );
  }
}
