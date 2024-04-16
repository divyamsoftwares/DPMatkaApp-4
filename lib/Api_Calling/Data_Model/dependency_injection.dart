import 'package:get/get.dart';
import 'package:dp_matka_3/Controller/network_controller.dart';


class DependencyInjection {
  
  static void init() {
    Get.put<NetworkController>(NetworkController(),permanent:true);
  }
}