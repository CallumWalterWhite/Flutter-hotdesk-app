import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ioc/ioc.dart';
import '../../constants/location_duration_codes.dart';
import '../../entities/booking.dart';
import '../../services/booking_service.dart';
import '../../util/translation.dart';
import '../../widgets/widget.dart';

class DeskDetail extends StatefulWidget {
  const DeskDetail({Key? key, required this.id, required this.floorId, required this.effectiveDate}) : super(key: key);

  final int id;
  final int floorId;
  final DateTime effectiveDate;

  @override
  State<DeskDetail> createState() => _DeskDetailState(effectiveDate, id, floorId);
}

class _DeskDetailState extends State<DeskDetail> {
  final BookingService _bookingService = Ioc().use('bookingService');
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final int id;
  final int floorId;
  final DateTime effectiveDate;
  late final Translation _translation = Translation();
  static const String defaultDropDownValue = 'Select Value';

  String dropdownValue = defaultDropDownValue;
  String validation = '';

  _DeskDetailState(this.effectiveDate, this.id, this.floorId);

  Future<void> _processBooking() async {
    Booking booking = await _bookingService.createDeskBooking(effectiveDate, floorId, id, _translation.getTranslationKey(dropdownValue)!);
    await ShowDialog(context, "Booked", "Hot desk has been booked.", () {
      Navigator.pop(context, booking);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Book a hot desk")),
      body:Form(
        key: _formKey,
        child:
        Column(
          children: <Widget>[
            DropdownButtonFormField<String>(
              value: dropdownValue,
              items: [defaultDropDownValue,
                _translation.getTranslation(LocationDurationCodes.FULL),
                _translation.getTranslation(LocationDurationCodes.HALF)]
                  .map((label) => DropdownMenuItem(
                child: Text(label!),
                value: label,
              )).toList(),
              icon: const Icon(Icons.arrow_downward),
              elevation: 16,
              style: const TextStyle(color: Colors.deepPurple),
              validator: (value) {
                if (value == "Select Value") {
                  return 'Please select a value from the list';
                }
                return null;
              },
              onChanged: (String? newValue) {
                setState(() {
                  if (_formKey.currentState!.validate()) {
                    dropdownValue = newValue!;
                  }
                });
              },
            ),
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
                    child: const Text('Submit'),
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