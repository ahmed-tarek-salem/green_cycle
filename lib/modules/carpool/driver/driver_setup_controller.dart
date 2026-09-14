import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:green_cycle/models/request_models/setup_offer_request_model.dart';
import 'package:green_cycle/models/response_models/carpool_offer_response_model.dart';
import 'package:green_cycle/models/response_models/district_response_model.dart';
import 'package:green_cycle/modules/carpool/carpool_controller.dart';
import 'package:green_cycle/modules/carpool/carpool_repo.dart';
import 'package:green_cycle/modules/carpool/carpool_utils.dart';
import 'package:green_cycle/utilities/base/base_controller.dart';
import 'package:green_cycle/utilities/global/app_constants.dart';
import 'package:green_cycle/utilities/network/dio_client.dart';

class DriverSetupController extends BaseController {
  final _repo = Get.find<CarpoolRepo>();
  final _carpool = Get.find<CarpoolController>();

  final RxInt step = 0.obs;

  /// day -> "HH:MM"; presence means the day is enabled.
  final RxMap<String, String> schedule = <String, String>{}.obs;
  final RxList<District> selectedCheckpoints = <District>[].obs;
  final TextEditingController notesController = TextEditingController();

  List<District> get allDistricts => _carpool.districts;

  bool get isEditing => _carpool.hasActiveOffer;

  @override
  void onInit() {
    if (isEditing) _prefillFrom(_carpool.myOffer.value!);
    super.onInit();
  }

  void _prefillFrom(CarpoolOffer offer) {
    for (final s in offer.weeklySchedule.where((s) => s.active)) {
      schedule[s.dayOfWeek] = s.arrivalTime;
    }
    selectedCheckpoints.assignAll(offer.checkpoints.map((c) => c.district));
    notesController.text = offer.notes ?? '';
  }

  void toggleDay(String day, bool on) {
    if (on) {
      schedule[day] = schedule[day] ?? '08:00';
    } else {
      schedule.remove(day);
    }
    update();
  }

  void setDayTime(String day, TimeOfDay time) {
    schedule[day] = formatTimeOfDay(time);
    update();
  }

  void addCheckpoint(District d) {
    if (!selectedCheckpoints.any((c) => c.id == d.id)) {
      selectedCheckpoints.add(d);
      update();
    }
  }

  void removeCheckpoint(String id) {
    selectedCheckpoints.removeWhere((c) => c.id == id);
    update();
  }

  void reorderCheckpoints(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) newIndex -= 1;
    final item = selectedCheckpoints.removeAt(oldIndex);
    selectedCheckpoints.insert(newIndex, item);
    update();
  }

  void next() {
    if (step.value == 0 && schedule.isEmpty) {
      showErrorDialog('اختر يوماً واحداً على الأقل');
      return;
    }
    if (step.value == 1 && selectedCheckpoints.isEmpty) {
      showErrorDialog('أضف منطقة واحدة على الأقل لخط سيرك');
      return;
    }
    if (step.value < 2) {
      step.value++;
      update();
    }
  }

  void back() {
    if (step.value > 0) {
      step.value--;
      update();
    }
  }

  Future<void> submit() async {
    final wasEditing =
        isEditing; // capture before refreshOffer flips hasActiveOffer
    if (schedule.isEmpty) {
      showErrorDialog('اختر يوماً واحداً على الأقل');
      return;
    }
    if (selectedCheckpoints.isEmpty) {
      showErrorDialog('أضف منطقة واحدة على الأقل لخط سيرك');
      return;
    }
    if (notesController.text.length > 500) {
      showErrorDialog('الملاحظات يجب ألا تتجاوز 500 حرف');
      return;
    }

    final request = SetupOfferRequest(
      weeklySchedule: schedule.entries
          .map((e) =>
              WeeklyScheduleEntry(dayOfWeek: e.key, arrivalTime: e.value))
          .toList(),
      checkpoints: selectedCheckpoints
          .asMap()
          .entries
          .map((e) => CheckpointInput(district: e.value.id, order: e.key))
          .toList(),
      notes: notesController.text,
    );

    try {
      showLoadingOverlay();
      final offer = await _repo.upsertOffer(request);
      if (offer != null) {
        _carpool.setOffer(offer);
      } else {
        await _carpool.refreshOffer();
      }
      hideLoadingOverlay();
      showSuccessDialog(
        wasEditing ? 'تم تحديث رحلتك' : 'تم نشر رحلتك',
        wasEditing
            ? 'تم تحديث عرضك بنجاح'
            : 'أصبح عرضك مرئياً للباحثين عن مشوار',
        onTap: () {
          Get.back(); // close dialog
          Get.back(); // pop the setup screen (to home, or to my-offer when editing)
        },
      );
    } catch (e) {
      hideLoadingOverlay();
      showErrorDialog(e is MyCustomException ? e.message : AppConstants.error);
    }
  }

  @override
  void onClose() {
    notesController.dispose();
    super.onClose();
  }
}
