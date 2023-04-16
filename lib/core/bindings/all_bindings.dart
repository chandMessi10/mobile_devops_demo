import 'package:get/get.dart';
import 'package:mobile_devops/features/map/presentation/controller/map_screen_controller.dart';
import 'package:mobile_devops/features/map/presentation/controller/search_screen_controller.dart';

class AllBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MapScreenController>(() => MapScreenController(), fenix: true);
    Get.lazyPut<SearchScreenController>(
      () => SearchScreenController(),
      fenix: true,
    );
  }
}
