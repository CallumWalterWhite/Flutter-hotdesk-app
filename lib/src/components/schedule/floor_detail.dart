import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:ioc/ioc.dart';
import '../../entities/booking.dart';
import '../../entities/floor.dart';
import '../../entities/location.dart';
import '../../persistence/storage_repository.dart';
import '../../services/booking_service.dart';
import '../../services/location_service.dart';
import '../../util/colour_palette.dart';
import 'location_detail.dart';

class FloorDetail extends StatefulWidget {
  const FloorDetail({Key? key, required this.floor, required this.effectiveDate, }) : super(key: key);

  final Floor floor;
  final DateTime effectiveDate;

  @override
  _FloorDetailState createState() => _FloorDetailState(effectiveDate, floor);
}

class _FloorDetailState extends State<FloorDetail> {
  late Image image;
  late Location location;

  final Floor floor;
  final DateTime effectiveDate;

  final BookingService _bookingService = Ioc().use('bookingService');
  final LocationService _locationService = Ioc().use('locationService');
  final StorageRepository _storageRepository = Ioc().use('storageRepository');

  late List<Booking> _bookings;
  bool imageLoaded = false;
  bool bookingLoaded = false;

  _FloorDetailState(this.effectiveDate, this.floor);

  void initState() {
    super.initState();
    init();
  }

  Future <Null> init() async {
    await loadFloor(floor);
    await loadLocationPoints(floor);
  }

  Future<void> loadFloor(Floor floor) async {
    image = Image.network(await _storageRepository.downloadURL(floor.overlay));
    setState(() {
      imageLoaded = true;
    });
  }

  Future<void> loadLocationPoints(Floor floor) async {
    location = await _locationService.get(floor.id);
    _bookings = await _bookingService.getAll(effectiveDate, floor.id);
    setState(() {
      bookingLoaded = true;
    });
  }

  List<Widget> buildOverlay() {
    if (bookingLoaded){
      List<Widget> widgets = [];
      widgets.add(image);
      for (var point in location.positions)
      {
        widgets.add(LocationDetail(
          id: point.id,
          floorId: location.floorId,
          pos: Offset(point.posX, point.posY),
          type: point.type,
          bookings: _bookings.where((element) => element.locationId == point.id).toList(),
          effectiveDate: effectiveDate,),);
      }
      return widgets;
    }
    else {
      return [];
    }
  }

  Widget _buildImage() {
    if (imageLoaded && bookingLoaded) {
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
          iconTheme: IconThemeData(color: mainColour),
          title: Text(floor.title, style: const TextStyle(color: mainColour)),
          backgroundColor: Colors.white,
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