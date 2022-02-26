import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../entities/booking.dart';
import '../../persistence/booking_repository.dart';
import '../../constants/location_duration_codes.dart';

class MeetingDetail extends StatelessWidget {
  final int id;
  final int floorId;
  late BookingRepository _bookingRepository;
  MeetingDetail({Key? key, required this.id, required this.floorId}) : super(key: key){
    _bookingRepository = BookingRepository();
  }

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
              onPressed: () async {
                Booking booking = Booking(DateTime.now(), floorId, id, LocationDurationCodes.FULL);
                await _bookingRepository.Add(booking);
                Navigator.pop(context, booking);
              },
            ),
            ElevatedButton(
              child: Text('Return No'),
              onPressed: () {
                Navigator.pop(context, null);
              },
            ),
          ],
        ),
      ),
    );
  }
}