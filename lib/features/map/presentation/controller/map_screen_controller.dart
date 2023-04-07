import 'package:baato_api/baato_api.dart';
import 'package:baato_api/models/place.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:mobile_devops/features/map/domain/entities/map_marker.dart';

class MapScreenController extends GetxController {
  static MapScreenController get to => Get.find();

  static const String baatoAccessToken =
      "bpk.C9lk--UtnhtCmXp-vbJvuwtK0-o1uQ81eQxsAzxwQ2q5";
  static const String mapBoxAccessToken =
      'pk.eyJ1IjoiamhpbGtleWJybyIsImEiOiJja3duZXZwb3owMXQ2MnVyNDJoMjR4'
      'bmpwIn0.MqmiglhUhJD1Tczd_-1qDw';

  late MapController mapController;
  RxDouble latitude = 0.0.obs, longitude = 0.0.obs;
  Rx<PlaceResponse> placeResponse = PlaceResponse('', 0, '').obs;
  RxBool showSelectedLocation = false.obs;
  RxString selectedLocationNameAddress = ''.obs;

  final mapMarkers = [
    MapMarker(
      image: 'assets/location_1.jpg',
      title: 'Offer One',
      address: 'Pulchowk 1',
      location: LatLng(27.678568213364073, 85.31655577036742),
      rating: 3,
    ),
    MapMarker(
      image: 'assets/location_2.jpg',
      title: 'Offer Two',
      address: 'Pulchowk 2',
      location: LatLng(27.678257612468332, 85.31613454953589),
      rating: 4,
    ),
  ];

  Future<void> requestLocationDetails(
    BuildContext context,
    LatLng latLng,
  ) async {
    BaatoReverse baatoReverse = BaatoReverse.initialize(
      latLon: GeoCoord(latLng.latitude, latLng.longitude),
      accessToken: baatoAccessToken,
    );

    //perform reverse Search
    PlaceResponse response = await baatoReverse.reverseGeocode();

    showMarkerOnTappedLocation(latLng, response);
    latitude.value = latLng.latitude;
    longitude.value = latLng.longitude;
  }

  showMarkerOnTappedLocation(LatLng latLng, PlaceResponse response) {
    print("address info");
    if (response.data == null || response.data!.isEmpty) {
      print("No result found");
      showSelectedLocation.value = false;
    } else {
      print("Result fetched");
      showSelectedLocation.value = true;
      print("${showSelectedLocation.value}");
      selectedLocationNameAddress.value =
          "${response.data![0].name}\n${response.data![0].address}";
      /*CustomSnackBar.buildErrorSnackBar(
        context,
        response.data![0].name! + "\n" + response.data![0].address!,
      );*/
    }
  }
}
