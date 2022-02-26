import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as developer;

import '../../persistence/booking_repository.dart';

class DeskDetail extends StatelessWidget {
  final int id;
  late BookingRepository _bookingRepository;
  DeskDetail({Key? key, required this.id}) : super(key: key) {
    _bookingRepository = BookingRepository();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Desk Location'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Desk Location',
            ),
            ElevatedButton(
              child: Text('Return Yes'),
              onPressed: () async {
                await _bookingRepository.Add(1, id, DateTime.now(), 'FULL');
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