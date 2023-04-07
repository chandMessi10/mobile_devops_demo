import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:mobile_devops/features/map/presentation/controller/map_screen_controller.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final controller = MapScreenController.to;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        FlutterMap(
          options: MapOptions(
            center: LatLng(27.67936787178884, 85.31626411485279),
            maxZoom: 17,
            zoom: 15,
            minZoom: 8,
            onTap: (tapPosition, latLng) {
              debugPrint('TAP_POSITION: ${tapPosition.global}');
              debugPrint('LATITUDE_LONGITUDE: $latLng');
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
              urlTemplate: 'https://api.mapbox.com/styles/v1/jhilkeybro/clg3f72'
                  '5t004v01t3ammuo9vh/tiles/256/{z}/{x}/{y}@2x?access_token=p'
                  'k.eyJ1IjoiamhpbGtleWJybyIsImEiOiJja3duZXZwb3owMXQ2MnVyND'
                  'JoMjR4bmpwIn0.MqmiglhUhJD1Tczd_-1qDw',
              // userAgentPackageName: 'com.example.app',
            ),
            MarkerLayer(
              markers: [
                for (int i = 0; i < controller.mapMarkers.length; i++)
                  Marker(
                    height: 40,
                    width: 40,
                    point: controller.mapMarkers[i].location ??
                        LatLng(27.67936787178884, 85.31626411485279),
                    builder: (_) {
                      return GestureDetector(
                        onTap: () {},
                        child: Image.asset('assets/ic_marker.png'),
                      );
                    },
                  ),
              ],
            ),
            Obx(() {
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
                        return Image.asset('assets/selected_location.png');
                      },
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
        Positioned(
          left: 16,
          right: 16,
          top: MediaQuery.of(context).size.height * 0.07,
          // height: MediaQuery.of(context).size.height * 0.08,
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
                        onPressed: () {},
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
        Positioned(
          left: 0,
          right: 0,
          bottom: 2,
          height: MediaQuery.of(context).size.height * 0.28,
          child: PageView.builder(
            onPageChanged: (value) {},
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
                            physics: const NeverScrollableScrollPhysics(),
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
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                            const SizedBox(width: 8),
                            Container(
                              height: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
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
      ],
    );
  }
}
