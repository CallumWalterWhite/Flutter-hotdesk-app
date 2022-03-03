import 'package:flutter/material.dart';
import 'package:ioc/ioc.dart';

import '../../entities/booking.dart';
import '../../constants/location_duration_codes.dart';
import '../../services/booking_service.dart';
import '../../widgets/widget.dart';

class MeetingDetail extends StatefulWidget {
  const MeetingDetail({Key? key, required this.id, required this.floorId, required this.effectiveDate}) : super(key: key);

  final int id;
  final int floorId;
  final DateTime effectiveDate;

  @override
  State<MeetingDetail> createState() => _MeetingDetailState(id: id, floorId: floorId, effectiveDate: effectiveDate);
}

class _MeetingDetailState extends State<MeetingDetail> {
  final int id;
  final int floorId;
  final DateTime effectiveDate;
  TimeOfDay _startTime = const TimeOfDay(hour: 9, minute: 00);
  TimeOfDay _endTime = const TimeOfDay(hour: 10, minute: 00);
  final BookingService _bookingService = Ioc().use('bookingService');
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  _MeetingDetailState({Key? key, required this.id, required this.floorId, required this.effectiveDate});
  String validation = '';

  Future<void> _processBooking() async {
    Booking booking = await _bookingService.createMeetingBooking(effectiveDate, _startTime, _endTime, floorId, id, LocationDurationCodes.TIME);
    await ShowDialog(context, "Booked", "Meeting has been booked.", () {
      Navigator.pop(context, booking);
    });
  }

  void _selectStartTime() async {
    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: _startTime,
    );
    if (newTime != null) {
      setState(() {
        _startTime = newTime;
      });
    }
  }

  void _selectEndTime() async {
    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: _endTime,
    );
    if (newTime != null) {
      setState(() {
        _endTime = newTime;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Meeting room booking"),
      ),
      body:
      Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.access_time),
              title: Text('Start time: ${_startTime.format(context)}'),
              onTap: _selectStartTime,
            ),
            const Divider(
              height: 2.0,
            ),
            ListTile(
              leading: const Icon(Icons.access_time),
              title: Text('End time: ${_endTime.format(context)}'),
              onTap: _selectEndTime,
            ),
            const Divider(
              height: 2.0,
            ),
            const Text("Equipment -"),
            BulletList(const [
              '2x Monitors',
              '1x Microsoft keyboard',
              '1x Microsoft mouse',
              '1x Docking station',
            ]),
            const Divider(
              height: 1.0,
            ),
            Text(validation),
            Wrap(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        await _processBooking();
                      }
                    },
                    child: const Text('Book'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: ElevatedButton(
                    onPressed: () {Navigator.pop(context, null);
                    },
                    child: const Text('Cancel'),
                  ),
                ),
              ],
            )
          ],
        ),
      )
    );
  }
}