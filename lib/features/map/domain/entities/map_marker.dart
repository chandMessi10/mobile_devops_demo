import 'package:latlong2/latlong.dart';

class MapMarker {
  final String? image;
  final String? title;
  final String? address;
  final LatLng? location;
  final int? rating;

  MapMarker({
    this.image,
    this.title,
    this.address,
    this.location,
    this.rating,
  });
}
