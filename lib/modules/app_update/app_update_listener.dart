import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:green_cycle/models/response_models/app_settings_response_model.dart';
import 'package:green_cycle/modules/app_update/app_update_controller.dart';
import 'package:green_cycle/modules/app_update/force_update_screen.dart';
import 'package:green_cycle/modules/app_update/optional_update_dialog.dart';

/// Top-level shell that wraps the app's navigator (from the app `builder`) and
/// reacts as soon as the background version check answers:
///   * `forced`   -> covers the whole app with [ForceUpdateScreen]
///   * `optional` -> shows [OptionalUpdateDialog]
///   * otherwise  -> does nothing
///
/// Both live above the navigator on purpose. The launch flow redirects twice
/// in its first second and an expired session calls `offAllNamed`, any of
/// which would cover or remove an update screen pushed as a route.
class AppUpdateListener extends StatefulWidget {
  const AppUpdateListener({super.key, required this.child});

  final Widget child;

  @override
  State<AppUpdateListener> createState() => _AppUpdateListenerState();
}

class _AppUpdateListenerState extends State<AppUpdateListener> {
  final AppUpdateController _controller = Get.find<AppUpdateController>();
  late final Worker _statusWorker;
  bool _optionalShown = false;

  @override
  void initState() {
    super.initState();
    _statusWorker = ever(_controller.status, _onStatusChanged);
    // Covers an answer that arrived before this widget was mounted.
    WidgetsBinding.instance.addPostFrameCallback(
        (_) => _onStatusChanged(_controller.status.value));
  }

  @override
  void dispose() {
    _statusWorker.dispose();
    super.dispose();
  }

  void _onStatusChanged(AppUpdateStatus status) {
    if (status != AppUpdateStatus.optional) return;
    if (_optionalShown || _controller.optionalDismissed) return;
    _optionalShown = true;
    OptionalUpdateDialog.show(controller: _controller);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isForced = _controller.status.value == AppUpdateStatus.forced;
      return Stack(
        fit: StackFit.expand,
        children: [
          widget.child,
          if (isForced) const ForceUpdateScreen(),
        ],
      );
    });
  }
}
