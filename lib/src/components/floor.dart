import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:ioc/ioc.dart';
import '../entities/booking.dart';
import '../services/booking_service.dart';
import 'location.dart';

class Floor extends StatefulWidget {
  Floor({Key? key, required this.effectiveDate, required this.floorTitle}) : super(key: key);

  final String floorTitle;
  final DateTime effectiveDate;

  @override
  _FloorState createState() => _FloorState(effectiveDate, floorTitle);
}

class _FloorState extends State<Floor> {
  late ui.Image image;
  final DateTime effectiveDate;
  final String floorTitle;
  late dynamic locationPoints;
  final BookingService _bookingService = Ioc().use('bookingService');
  late List<Booking> _bookings;
  bool imageLoaded = false;
  bool bookingLoaded = false;

  _FloorState(this.effectiveDate, this.floorTitle);

  void initState() {
    super.initState();
    init();
  }

  Future <Null> init() async {
    ByteData data = await rootBundle.load('assets/office.png');
    image = await loadImage(Uint8List.view(data.buffer));
    await loadLocationPoints();
  }

  Future<void> loadLocationPoints() async {
    final String response = await rootBundle.loadString('assets/template/floor1_locations.json');
    locationPoints = await json.decode(response);
    int floorId = 1;
    _bookings = await _bookingService.getAll(effectiveDate, floorId);
    setState(() {
      bookingLoaded = true;
    });
  }

  Future<ui.Image> loadImage(List<int> img) async {
    final Completer<ui.Image> completer = Completer();
    ui.decodeImageFromList(Uint8List.fromList(img), (ui.Image img) {
      setState(() {
        imageLoaded = true;
      });
      return completer.complete(img);
    });
    return completer.future;
  }

  List<Widget> buildOverlay() {
    if (bookingLoaded){
      List<Widget> widgets = [];
      widgets.add(CustomPaint(
        painter: FloorOverlay(image: image),
      ));
      locationPoints["points"].forEach((point) => {
        widgets.add(Location(
          id: point["id"],
          floorId: locationPoints["floorId"],
          pos: Offset(double.parse(point["posX"]), double.parse(point["posY"])),
          type: point["type"],
          bookings: _bookings.where((element) => element.locationId == point["id"]).toList()))
      });
      return widgets;
    }
    else {
      return [];
    }
  }

  Widget _buildImage() {
    if (imageLoaded) {
      return Stack(
        children: buildOverlay(),
      );
    } else {
      return const Center(child: Text('loading'));
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(floorTitle),
        ),
        body: Container(
          child: _buildImage(),
        )
    );
  }
}

class FloorOverlay extends CustomPainter {
  FloorOverlay({
    required this.image,
  });

  ui.Image image;

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }

  @override
  void paint(ui.Canvas canvas, ui.Size size) {
    canvas.drawImage(image, const Offset(0.0, 0.0), Paint());
  }

}