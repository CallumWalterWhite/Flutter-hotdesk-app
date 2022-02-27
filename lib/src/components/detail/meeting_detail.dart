import 'package:flutter/material.dart';
import 'package:ioc/ioc.dart';

import '../../entities/booking.dart';
import '../../persistence/booking_repository.dart';
import '../../constants/location_duration_codes.dart';
import '../../services/booking_service.dart';

class MeetingDetail extends StatefulWidget {
  const MeetingDetail({Key? key, required this.id, required this.floorId}) : super(key: key);

  final int id;
  final int floorId;

  @override
  State<MeetingDetail> createState() => _MeetingDetailState(id: id, floorId: floorId);
}

class _MeetingDetailState extends State<MeetingDetail> {
  final int id;
  final int floorId;
  TimeOfDay _startTime = const TimeOfDay(hour: 9, minute: 00);
  TimeOfDay _endTime = const TimeOfDay(hour: 10, minute: 00);
  final BookingService _bookingService = Ioc().use('bookingService');
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  _MeetingDetailState({Key? key, required this.id, required this.floorId});
  String validation = '';

  Future<void> _processBooking() async {
    Booking booking = await _bookingService.createBooking(DateTime.now(), floorId, id, LocationDurationCodes.TIME);
    Navigator.pop(context, booking);
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

  void _endStartTime() async {
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
        appBar: AppBar(title: const Text("Book a meeting room")),
        body:Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ElevatedButton(
                onPressed: _selectStartTime,
                child: const Text('Select Start time'),
              ),
              const SizedBox(height: 8),
              Text(
                'Selected time: ${_startTime.format(context)}',
              ),
              const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0)
              ),
              ElevatedButton(
                onPressed: _endStartTime,
                child: const Text('Select End time'),
              ),
              const SizedBox(height: 8),
              Text(
                'Selected time: ${_endTime.format(context)}',
              ),
              const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0)
              ),
              Text(validation),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      await _processBooking();
                    }
                  },
                  child: const Text('Submit'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: () {Navigator.pop(context, null);
                  },
                  child: const Text('Cancel'),
                ),
              ),
            ],
          ),
        )
    );
  }
}