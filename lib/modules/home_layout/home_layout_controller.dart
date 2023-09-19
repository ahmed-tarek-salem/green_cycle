import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:green_cycle/modules/tabs/complaints/complaints_tab.dart';
import 'package:green_cycle/modules/tabs/events/events_tab.dart';
import 'package:green_cycle/modules/tabs/home/home_tab.dart';
import 'package:green_cycle/modules/tabs/locations/locations_tab.dart';

class HomeLayoutController extends GetxController {
  final RxInt _navBarIndex = 0.obs;

  int get getNavBarIndex => _navBarIndex.value;
  final List<Widget> tabs = [
    const HomeTab(),
    const LocationsTab(),
    const EventsTab(),
    const ComplaintsTab(),
  ];

  set navBarIndex(int index) {
    print(index);
    _navBarIndex.value = index;
    update();
  }
}
