import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import '../collection/booking.dart';
import '../persistence/booking_repository.dart';
import 'location.dart';
import 'dart:developer' as developer;

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
  late BookingRepository _bookingRepository;
  late List<Booking> _bookings;
  bool isImageloaded = false;
  bool isBookingloaded = false;

  _FloorState(this.effectiveDate, this.floorTitle){
    _bookingRepository = BookingRepository();
  }

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
    //TODO: update floor id to resolve from app state
    _bookings = await _bookingRepository.GetAll(1, effectiveDate);
    setState(() {
      isBookingloaded = true;
    });
  }

  Future<ui.Image> loadImage(List<int> img) async {
    final Completer<ui.Image> completer = Completer();
    ui.decodeImageFromList(Uint8List.fromList(img), (ui.Image img) {
      setState(() {
        isImageloaded = true;
      });
      return completer.complete(img);
    });
    return completer.future;
  }

  List<Widget> buildOverlay() {
    if (isBookingloaded){
      List<Widget> widgets = [];
      widgets.add(CustomPaint(
        painter: FloorOverlay(image: image),
      ));
      locationPoints["points"].forEach((point) => {
        widgets.add(Location(id: point["id"], pos: Offset(double.parse(point["posX"]), double.parse(point["posY"])), type: point["type"], bookings: _bookings.where((element) => element.locationId == point["id"]).toList(),))
      });
      return widgets;
    }
    else {
      return [];
    }
  }

  Widget _buildImage() {
    if (isImageloaded) {
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