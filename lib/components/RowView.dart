import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RowView extends StatefulWidget {

  RowView({this.appInstance});
  final Widget appInstance;

  @override
  State<RowView> createState() => _RowViewState();
}

class _RowViewState extends State<RowView> {

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      color: Colors.grey.shade400,
      child: Row(
        children: [
          Icon(Icons.account_tree_outlined, size: 14),
          SizedBox(width: 10),
          Text(widget.appInstance.toStringShort(), style: TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Container()),
          TextButton(onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => widget.appInstance),
            );
          } ,
              child: Icon(Icons.arrow_forward_ios_outlined, size: 14)),
        ],
      ),
    );
  }
}