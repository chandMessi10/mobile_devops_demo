import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:lottie/lottie.dart' as lt;
import 'package:mobile_devops/features/map/presentation/controller/map_screen_controller.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final controller = MapScreenController.to;

  @override
  void initState() {
    controller.platformState();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: Visibility(
            visible: controller.searchLocationFocus.value.hasFocus,
            child: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                controller.searchLocationFocus.value.unfocus();
              },
            ),
          ),
          leadingWidth: controller.searchLocationFocus.value.hasFocus ? 50 : 0,
          title: Obx(
            () => TextFormField(
              focusNode: controller.searchLocationFocus.value,
              /*onTap: () {
                controller.searchFormFocusNode.requestFocus();
              },*/
              controller: controller.searchTextEditingController.value,
              decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                hintText: 'Search locations here...',
                suffixIcon: Visibility(
                  visible: controller
                      .searchTextEditingController.value.text.isNotEmpty,
                  child: IconButton(
                    onPressed: () {
                      controller.clearSearchField();
                    },
                    icon: const Icon(Icons.close),
                  ),
                ),
              ),
              onChanged: (value) {
                controller.searchBaatoPlaces(value);
              },
            ),
          ),
        ),
        body: Obx(() {
          if (controller.isWaitingForPermission.value) {
            return Center(
              child: lt.Lottie.asset(
                'assets/map_loading_animation.json',
                height: 150,
                width: 150,
              ),
            );
          } else if (!controller.permissionGranted.value) {
            return const Center(
              child: Text('Permission not granted'),
            );
          } else {
            return Stack(
              alignment: Alignment.center,
              children: [
                FlutterMap(
                  mapController: controller.mapController,
                  options: MapOptions(
                    center: LatLng(
                      controller.latitude.value,
                      controller.longitude.value,
                    ),
                    maxZoom: 17,
                    zoom: 15,
                    minZoom: 8,
                    onTap: (tapPosition, latLng) {
                      controller.requestLocationDetails(context, latLng);
                    },
                  ),
                  // nonRotatedChildren: [
                  //   AttributionWidget.defaultWidget(
                  //     source: 'OpenStreetMap contributors',
                  //     onSourceTapped: null,
                  //   ),
                  // ],
                  children: [
                    TileLayer(
                      // urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      urlTemplate:
                          'https://api.mapbox.com/styles/v1/jhilkeybro/clg3f72'
                          '5t004v01t3ammuo9vh/tiles/256/{z}/{x}/{y}@2x?access_token=p'
                          'k.eyJ1IjoiamhpbGtleWJybyIsImEiOiJja3duZXZwb3owMXQ2MnVyND'
                          'JoMjR4bmpwIn0.MqmiglhUhJD1Tczd_-1qDw',
                      // userAgentPackageName: 'com.example.app',
                    ),
                    Obx(
                      () => Visibility(
                        visible: controller.showHideOffers.value,
                        child: MarkerLayer(
                          markers: [
                            for (int i = 0;
                                i < controller.mapMarkers.length;
                                i++)
                              Marker(
                                height: 40,
                                width: 40,
                                point: controller.mapMarkers[i].location ??
                                    LatLng(
                                      controller.latitude.value,
                                      controller.longitude.value,
                                    ),
                                builder: (_) {
                                  return GestureDetector(
                                    onTap: () {
                                      controller.pageController.animateToPage(
                                        i,
                                        duration:
                                            const Duration(milliseconds: 500),
                                        curve: Curves.easeInOut,
                                      );
                                    },
                                    child: AnimatedScale(
                                      scale: controller.selectedIndex.value == i
                                          ? 1
                                          : 0.7,
                                      duration:
                                          const Duration(milliseconds: 500),
                                      child: AnimatedOpacity(
                                        duration:
                                            const Duration(milliseconds: 500),
                                        opacity:
                                            controller.selectedIndex.value == i
                                                ? 1
                                                : 0.5,
                                        child:
                                            Image.asset('assets/ic_marker.png'),
                                      ),
                                    ),
                                  );
                                },
                              ),
                          ],
                        ),
                      ),
                    ),
                    Obx(
                      () {
                        return Visibility(
                          visible: controller.showSelectedLocation.value,
                          child: MarkerLayer(
                            markers: [
                              Marker(
                                height: 50,
                                width: 50,
                                point: LatLng(
                                  controller.latitude.value,
                                  controller.longitude.value,
                                ),
                                builder: (_) {
                                  return Image.asset(
                                    'assets/selected_location.png',
                                  );
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    MarkerLayer(
                      markers: [
                        Marker(
                          height: 25,
                          width: 25,
                          point: LatLng(
                            controller.myLatitude.value,
                            controller.myLongitude.value,
                          ),
                          builder: (_) {
                            return Image.asset('assets/user.png');
                          },
                        ),
                      ],
                    )
                  ],
                ),
                Positioned(
                  left: 16,
                  right: 16,
                  bottom: MediaQuery.of(context).size.height * 0.1,
                  child: Obx(
                    () => Visibility(
                      visible: controller.showSelectedLocation.value,
                      child: Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Image.asset('assets/selected_location.png'),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  controller.selectedLocationNameAddress.value,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 8),
                              IconButton(
                                onPressed: () {
                                  controller.animateMapCamera(
                                    latLng: LatLng(
                                      controller.latitude.value,
                                      controller.longitude.value,
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.arrow_forward),
                                padding: const EdgeInsets.all(4),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Obx(
                  () => Visibility(
                    visible: controller.showHideOffers.value,
                    child: Positioned(
                      left: 0,
                      right: 0,
                      top: 2,
                      height: MediaQuery.of(context).size.height * 0.28,
                      child: PageView.builder(
                        controller: controller.pageController,
                        onPageChanged: (value) {
                          controller.selectedIndex.value = value;
                          LatLng currentLocation =
                              controller.mapMarkers[value].location ??
                                  LatLng(
                                    controller.latitude.value,
                                    controller.longitude.value,
                                  );
                          controller.animateMapCamera(latLng: currentLocation);
                        },
                        physics: const BouncingScrollPhysics(),
                        itemCount: controller.mapMarkers.length,
                        itemBuilder: (_, index) {
                          final item = controller.mapMarkers[index];
                          return Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Card(
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              color: const Color.fromARGB(255, 30, 29, 29),
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                alignment: Alignment.centerLeft,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 25,
                                      child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: item.rating,
                                        itemBuilder: (context, index) {
                                          return const Icon(
                                            Icons.star,
                                            size: 14,
                                            color: Colors.amberAccent,
                                          );
                                        },
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                item.title.toString(),
                                                style: const TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                item.address.toString(),
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Container(
                                          height: 100,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          alignment: Alignment.center,
                                          child: Image.asset(
                                            item.image.toString(),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: 16,
                  bottom: 16,
                  height: 50,
                  child: FloatingActionButton(
                    onPressed: () {
                      controller.getMyCurrentLocation();
                    },
                    child: const Icon(Icons.my_location),
                  ),
                ),
                Positioned(
                  left: 16,
                  bottom: 16,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      controller.showHideOffers.value =
                          !controller.showHideOffers.value;
                    },
                    child: Text(controller.showHideOffers.value
                        ? 'Hide offers'
                        : 'Show offers'),
                  ),
                ),
                Positioned(
                  child: Obx(
                    () => _mainData(),
                  ),
                ),
              ],
            );
          }
        }),
      ),
    );
  }

  Widget _mainData() {
    return Visibility(
      visible: controller.searchTextEditingController.value.text.isNotEmpty ||
          controller.searchLocationFocus.value.hasFocus,
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        alignment: Alignment.topCenter,
        child: controller.isLoading.value
            ? const CircularProgressIndicator()
            : ListView.builder(
                itemCount: controller.searchedLocationList.length,
                itemBuilder: (context, index) {
                  var searchedData = controller.searchedLocationList[index];
                  return ListTile(
                    onTap: () {
                      controller.searchedResultBaatoPlaces(
                        placeId: searchedData.placeId,
                      );
                    },
                    title: Text(
                      searchedData.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(searchedData.address),
                    leading: const Icon(Icons.location_pin),
                  );
                }),
      ),
    );
  }
}
