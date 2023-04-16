import 'package:baato_api/baato_api.dart';
import 'package:baato_api/models/place.dart';
import 'package:baato_api/models/search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:mobile_devops/features/map/domain/entities/map_marker.dart';

class MapScreenController extends GetxController {
  static MapScreenController get to => Get.find();

  final mapController = MapController();

  static const String baatoAccessToken =
      "bpk.C9lk--UtnhtCmXp-vbJvuwtK0-o1uQ81eQxsAzxwQ2q5";
  static const String mapBoxAccessToken =
      'pk.eyJ1IjoiamhpbGtleWJybyIsImEiOiJja3duZXZwb3owMXQ2MnVyNDJoMjR4'
      'bmpwIn0.MqmiglhUhJD1Tczd_-1qDw';

  RxDouble latitude = 0.0.obs, longitude = 0.0.obs;
  RxDouble myLatitude = 0.0.obs, myLongitude = 0.0.obs;
  Rx<PlaceResponse> placeResponse = PlaceResponse('', 0, '').obs;
  RxBool showSelectedLocation = false.obs;
  RxBool showHideOffers = false.obs;
  RxString selectedLocationNameAddress = ''.obs;

  RxBool isWaitingForPermission = false.obs;
  RxBool permissionGranted = false.obs;
  RxBool unableToFetchLocation = false.obs;

  Location location = Location();
  late PermissionStatus permission;
  late LocationData currentLocation;

  platformState() async {
    isWaitingForPermission.value = true;
    currentLocation = await location.getLocation();
    permission = await location.hasPermission();
    try {
      if (permission == PermissionStatus.granted) {
        if (currentLocation.latitude != null &&
            currentLocation.longitude != null) {
          latitude.value = currentLocation.latitude!;
          longitude.value = currentLocation.longitude!;
          myLatitude.value = currentLocation.latitude!;
          myLongitude.value = currentLocation.longitude!;
        } else {
          unableToFetchLocation.value = false;
        }
        permissionGranted.value = true;
        isWaitingForPermission.value = false;
      } else {
        unableToFetchLocation.value = true;
        permissionGranted.value = false;
        isWaitingForPermission.value = false;
      }
    } on Exception {
      unableToFetchLocation.value = true;
      permissionGranted.value = false;
      isWaitingForPermission.value = false;
    }
  }

  animateMapCamera({required LatLng latLng}) {
    mapController.move(
      latLng,
      15.0,
    );
  }

  void getMyCurrentLocation() async {
    currentLocation = await location.getLocation();
    if (currentLocation.latitude != null && currentLocation.longitude != null) {
      myLatitude.value = currentLocation.latitude!;
      myLongitude.value = currentLocation.longitude!;
      animateMapCamera(latLng: LatLng(myLatitude.value, myLongitude.value));
    } else {
      unableToFetchLocation.value = false;
    }
  }

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
    MapMarker(
      image: 'assets/location_2.jpg',
      title: 'Mega Bank',
      address: 'Tindhara Sadak, Kamalpokhari',
      location: LatLng(27.713687605681073, 85.32230008278538),
      rating: 5,
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
  }

  showMarkerOnTappedLocation(LatLng latLng, PlaceResponse response) {
    print("address info");
    latitude.value = latLng.latitude;
    longitude.value = latLng.longitude;
    animateMapCamera(latLng: LatLng(latLng.latitude, latLng.longitude));
    debugPrint('(${latitude.value}, ${latitude.value})');
    if (response.data == null || response.data!.isEmpty) {
      print("No result found");
      showSelectedLocation.value = false;
    } else {
      print("Result fetched");
      showSelectedLocation.value = true;
      print("${showSelectedLocation.value}");
      selectedLocationNameAddress.value =
          "${response.data![0].name}\n${response.data![0].address}";
    }
  }

  /// for searching
  Rx<TextEditingController> searchTextEditingController =
      TextEditingController().obs;
  RxBool isLoading = false.obs;
  RxList<Search> searchedLocationList = <Search>[].obs;
  Rx<FocusNode> searchLocationFocus = FocusNode().obs;

  void clearSearchField() {
    searchTextEditingController.value.clear();
    searchedLocationList.value = [];
  }

  searchBaatoPlaces(String query) async {
    isLoading.value = true;

    BaatoSearch baatoSearch = BaatoSearch.initialize(
      query: query,
      accessToken: baatoAccessToken,
      // type: 'school', //optional parameter
      limit: 5, //optional parameter
    );

    //Perform Search
    SearchResponse response = await baatoSearch.searchQuery();
    if (response != null && response.status == 200) {
      searchedLocationList.value = response.data ?? [];
    } else {
      searchedLocationList.value = [];
    }
    isLoading.value = false;
  }

  searchedResultBaatoPlaces({
    required int placeId,
  }) async {
    BaatoPlace baatoPlace = BaatoPlace.initialize(
      placeId: placeId, //placeId is required parameter
      accessToken: baatoAccessToken, //accessToken is required parameter
    );
    PlaceResponse placeResponse = await baatoPlace.getPlaceDetails();
    debugPrint('BAATO_PLACE_RESPONSE: ${placeResponse.data}');
    Place tappedLocationData = placeResponse.data![0];
    debugPrint(
        'BAATO_PLACE_LAT_LONG: (${tappedLocationData.centroid.lat},${tappedLocationData.centroid.lon})');
    clearSearchField();
    searchLocationFocus.value.unfocus();
    showMarkerOnTappedLocation(
      LatLng(
        tappedLocationData.centroid.lat,
        tappedLocationData.centroid.lon,
      ),
      placeResponse,
    );
  }

  /// for animating selected offer location
  RxInt selectedIndex = 0.obs;
  PageController pageController = PageController();
}
