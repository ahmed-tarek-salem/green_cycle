import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:green_cycle/main.dart';
import 'package:green_cycle/modules/home_layout/home_lauout_repo.dart';
import 'package:green_cycle/modules/tabs/complaints/complaints_tab.dart';
import 'package:green_cycle/modules/tabs/events/events_tab.dart';
import 'package:green_cycle/modules/tabs/home/home_tab.dart';
import 'package:green_cycle/modules/tabs/locations/locations_tab.dart';
import 'package:green_cycle/utilities/base/base_controller.dart';
import 'package:green_cycle/utilities/global/app_constants.dart';
import 'package:green_cycle/utilities/navigation/app_routes.dart';
import 'package:green_cycle/utilities/network/dio_client.dart';

class HomeLayoutController extends BaseController {
  final RxInt _navBarIndex = 0.obs;
  final _repo = HomeLayoutRepo();

  @override
  void onInit() {
    _repo.getUser();
    super.onInit();
  }

  int get getNavBarIndex => _navBarIndex.value;
  final List<Widget> tabs = [
    const HomeTab(),
    const LocationsTab(),
    const EventsTab(),
    const ComplaintsTab(),
  ];
  final List<String> titles = [
    'الصفحة الرئيسية',
    'مواقع  الصناديق',
    'الفعاليات',
    'الشكاوي والمقترحات'
  ];

  set navBarIndex(int index) {
    _navBarIndex.value = index;
    update();
  }

  logout() {
    navBarIndex = 0;
    DioClient.logout();
    localStorage.clearToken();
    Get.offAndToNamed(AppRoutes.loginScreen);
  }

  Future<void> getFaqs() async {
    try {
      setLoading = true;
      final data = await _repo.getUser();
      setError = false;
      update();
    } catch (e) {
      setError = true;
      final exceptionMessage =
          (e is MyCustomException) ? e.message : AppConstants.error;
      showErrorDialog(exceptionMessage);
    } finally {
      setLoading = false;
    }
  }
}
