import 'package:ar_project/apps/ARProject/ARTicTacToe.dart';
import 'package:ar_project/apps/ARTest.dart';
import 'package:ar_project/apps/HelloWorld.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'RowView.dart';


class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Flutter Projects"),
      ),
      body: SingleChildScrollView(
          child:
          Column(
            children: [
              SizedBox(height: 2,),
              RowView(appInstance: HelloWorld()),

              SizedBox(height: 2,),
              RowView(appInstance: ARTest()),

              SizedBox(height: 2,),
              RowView(appInstance: ARTicTacToe()),
            ],
          )
      ),
    );
  }
}