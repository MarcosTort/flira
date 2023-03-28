import 'package:flira/bloc/flira_bloc.dart';
import 'package:flira/consts.dart';
import 'package:flira/models/models.dart';
import 'package:flira/view/dialogs/dialogs.dart';
import 'package:flira/view/view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:screenshot_callback/screenshot_callback.dart';
import 'package:shake/shake.dart';
import 'package:permission_handler/permission_handler.dart';

class FliraOverlay extends StatelessWidget {
  const FliraOverlay({
    required this.triggeringMethod,
    Key? key,
  }) : super(key: key);
  final TriggeringMethod triggeringMethod;

  @override
  Widget build(BuildContext context) {
    final reportDialogOpen =
        context.select((FliraBloc value) => value.state.reportDialogOpen);
    final canTriggerDialog = !reportDialogOpen;
    ReportBugDialog fliraClient = const ReportBugDialog();
    if (triggeringMethod == TriggeringMethod.screenshot) {
      final screenshotCallback = ScreenshotCallback();

      screenshotCallback.initialize().whenComplete(() => _checkPermissions());
      screenshotCallback.addListener(
        () {
          if (canTriggerDialog) {
            context.read<FliraBloc>().add(FliraTriggeredEvent());
          }
        },
      );
    } else if (triggeringMethod == TriggeringMethod.shaking) {
      ShakeDetector.autoStart(
        onPhoneShake: () {
          if (canTriggerDialog) {
            context.read<FliraBloc>().add(FliraTriggeredEvent());
          }
        },
      );
    }

    return BlocBuilder<FliraBloc, FliraState>(
      builder: (context, state) {
        final theme = Theme.of(context);
        final width = state.materialAppWidth;
        final height = state.materialAppHeight;
        return Align(
          alignment: state.alignment!,
          child: AnimatedContainer(
            curve: kcurve,
            duration: const Duration(milliseconds: 400),
            decoration: BoxDecoration(
              color: theme.colorScheme.onSurface,
            ),
            width: width,
            height: height,
            child: Localizations(
              delegates: const [
                DefaultMaterialLocalizations.delegate,
                DefaultWidgetsLocalizations.delegate,
                DefaultCupertinoLocalizations.delegate
              ],
              locale: const Locale('en', 'US'),
              child: MediaQuery(
                data: MediaQueryData.fromWindow(WidgetsBinding.instance.window),
                child: Material(
                  color: theme.colorScheme.onSurface,
                  child: Navigator(
                    onGenerateRoute: (settings) => MaterialPageRoute(
                      builder: (context) => FloatingButton(
                        fliraClient: fliraClient,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}



Future<void> _checkPermissions() async {
  final status = await Permission.storage.status;
  if (status.isDenied) {
    Permission.storage.request();
  }
}
