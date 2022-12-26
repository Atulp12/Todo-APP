import 'package:flutter/material.dart';

class Description extends StatelessWidget {
 
 final String title;
 final String description;

 Description(this.title,this.description);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Description'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.all(20),
            child: Text(title,style: TextStyle(fontFamily: 'OpenSans',fontSize: 30,fontWeight: FontWeight.bold),)
            ),
            Container(
            margin: EdgeInsets.all(20),
            child: Text(description,style: TextStyle(fontFamily: 'OpenSans',fontSize: 20),)
            ),
        ],
      ),
    );
  }
}