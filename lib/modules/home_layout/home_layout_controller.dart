import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:green_cycle/main.dart';
import 'package:green_cycle/models/response_models/user_response_model.dart';
import 'package:green_cycle/modules/home_layout/home_lauout_repo.dart';
import 'package:green_cycle/modules/tabs/complaints/complaints_tab.dart';
import 'package:green_cycle/modules/tabs/events/events_tab.dart';
import 'package:green_cycle/modules/tabs/home/home_tab.dart';
import 'package:green_cycle/modules/tabs/locations/locations_tab.dart';
import 'package:green_cycle/modules/tabs/streak_board/streak_board_tab.dart';
import 'package:green_cycle/utilities/base/base_controller.dart';
import 'package:green_cycle/utilities/global/app_constants.dart';
import 'package:green_cycle/utilities/navigation/app_routes.dart';
import 'package:green_cycle/utilities/network/dio_client.dart';

class HomeLayoutController extends BaseController {
  final RxInt _navBarIndex = 0.obs;
  final _repo = HomeLayoutRepo();
  late final UserData user;

  @override
  void onInit() {
    getUser();
    super.onInit();
  }

  int get getNavBarIndex => _navBarIndex.value;
  final List<Widget> tabs = [
    const HomeTab(),
    const LocationsTab(),
    const EventsTab(),
    const ComplaintsTab(),
    const StreakBoardTab(),
  ];
  final List<String> titles = [
    'الصفحة الرئيسية',
    'مواقع  الصناديق',
    'الفعاليات',
    'الشكاوي والمقترحات',
    'لوحة المتصدرين',
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

  Future<void> getUser() async {
    try {
      setLoading = true;
      final userResponseModel = await _repo.getUser();
      user = userResponseModel.data;
      _addDummyActivities();
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

  void _addDummyActivities() {
    final dummyActivities = [
      Activity(
        id: 'dummy_1',
        type: 'recycle',
        details: 'لقد حصلت على 120 نقطة بسبب تسليم 5 كجم من البلاستيك في صندوق إعادة التدوير بكلية الصيدلة، جامعة الإسكندرية.',
        summary: 'تسليم بلاستيك',
        points: 120,
        createdAt: DateTime(2026, 3, 10),
      ),
      Activity(
        id: 'dummy_2',
        type: 'recycle',
        details: 'لقد حصلت على 80 نقطة بسبب تسليم 3 كجم من الورق والكرتون في صندوق إعادة التدوير بكلية الصيدلة، جامعة الإسكندرية.',
        summary: 'تسليم ورق وكرتون',
        points: 80,
        createdAt: DateTime(2026, 3, 5),
      ),
      Activity(
        id: 'dummy_3',
        type: 'event',
        details: 'لقد حصلت على 100 نقطة بسبب المشاركة في فعالية تنظيف حرم كلية الصيدلة، جامعة الإسكندرية مع فريق جرين سايكل.',
        summary: 'فعالية تنظيف الكلية',
        points: 100,
        createdAt: DateTime(2026, 2, 20),
      ),
      Activity(
        id: 'dummy_4',
        type: 'recycle',
        details: 'لقد حصلت على 50 نقطة بسبب تسليم 2 كجم من الزجاج في صندوق إعادة التدوير بكلية الصيدلة، جامعة الإسكندرية.',
        summary: 'تسليم زجاج',
        points: 50,
        createdAt: DateTime(2026, 2, 12),
      ),
      Activity(
        id: 'dummy_5',
        type: 'survey',
        details: 'لقد حصلت على 50 نقطة بسبب إكمال استبيان عن عادات إعادة التدوير في كلية الصيدلة، جامعة الإسكندرية.',
        summary: 'إكمال استبيان',
        points: 50,
        createdAt: DateTime(2026, 1, 28),
      ),
    ];
    user.activities?.addAll(dummyActivities);
  }
}
