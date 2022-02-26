import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MeetingDetail extends StatelessWidget {
  final int id;
  const MeetingDetail({Key? key, required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meeting Location'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Meeting Location',
            ),
            ElevatedButton(
              child: Text('Return Yes'),
              onPressed: () {
                Navigator.pop(context, "Yes");
              },
            ),
            ElevatedButton(
              child: Text('Return No'),
              onPressed: () {
                Navigator.pop(context, "No");
              },
            ),
          ],
        ),
      ),
    );
  }
}