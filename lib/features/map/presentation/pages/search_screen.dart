import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_devops/features/map/presentation/controller/search_screen_controller.dart';

class SearchScreen extends GetView<SearchScreenController> {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leadingWidth: 50,
          title: Obx(
            () => TextFormField(
              controller: controller.searchTextEditingController.value,
              decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                hintText: 'Search here...',
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
        body: Obx(
          () => _mainData(),
        ),
      ),
    );
  }

  Widget _mainData() {
    return Center(
      child: controller.isLoading.value
          ? const CircularProgressIndicator()
          : ListView.builder(
              itemCount: controller.searchedLocationList.length,
              itemBuilder: (context, index) {
                var searchedData = controller.searchedLocationList[index];
                return ListTile(
                  title: Text(
                    searchedData.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(searchedData.address),
                  leading: const Icon(Icons.location_pin),
                );
              }),
    );
  }
}
