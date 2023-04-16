import 'package:baato_api/baato_api.dart';
import 'package:baato_api/models/search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchScreenController extends GetxController {
  static SearchScreenController get to => Get.find();
  Rx<TextEditingController> searchTextEditingController =
      TextEditingController().obs;
  RxBool isLoading = false.obs;
  RxList<Search> searchedLocationList = <Search>[].obs;

  static const String baatoAccessToken =
      "bpk.C9lk--UtnhtCmXp-vbJvuwtK0-o1uQ81eQxsAzxwQ2q5";

  void clearSearchField() {
    searchTextEditingController.value.clear();
  }

  searchBaatoPlaces(String query) async {
    isLoading.value = true;

    BaatoSearch baatoSearch = BaatoSearch.initialize(
      query: query,
      accessToken: baatoAccessToken,
      // type: 'school', //optional parameter
      limit: 5, //optional parameter
    );

    //perform Search
    SearchResponse response = await baatoSearch.searchQuery();
    if (response != null && response.status == 200) {
      searchedLocationList.value = response.data ?? [];
    } else {
      searchedLocationList.value = [];
    }
    isLoading.value = false;
  }
}
