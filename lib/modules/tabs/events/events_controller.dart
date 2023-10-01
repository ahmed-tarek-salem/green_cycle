import 'dart:developer';

import 'package:get/get.dart';
import 'package:green_cycle/models/response_models/event_response_model.dart';
import 'package:green_cycle/modules/tabs/events/events_repo.dart';
import 'package:green_cycle/utilities/base/base_controller.dart';
import 'package:green_cycle/utilities/global/app_constants.dart';
import 'package:green_cycle/utilities/network/dio_client.dart';

class EventsController extends BaseController {
  final _repo = EventsRepo();
  final RxList<EventResponseModel> events = RxList();

  @override
  void onInit() {
    if (isInit) {
      getEvents();
      isInit = false;
    }
    super.onInit();
  }

  Future<void> getEvents() async {
    try {
      setLoading = true;
      final events = await _repo.getEvents();
      this.events.addAll(events);
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
