import 'package:flira/bloc/flira_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:screenshot_callback/screenshot_callback.dart';
import 'package:shake/shake.dart';
import '../flira.dart';
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
    Flira fliraClient = Flira();
    if (triggeringMethod == TriggeringMethod.screenshot) {
      final screenshotCallback = ScreenshotCallback();

      screenshotCallback.initialize().whenComplete(() => checkPermissions());
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
        final width = state.materialAppWidth;
        final height = state.materialAppHeight;
        return Align(
          alignment: state.alignment!,
          child: AnimatedContainer(
            curve: curve,
            duration: const Duration(milliseconds: 400),
            decoration: const BoxDecoration(
              color: Colors.transparent,
            ),
            width: width,
            height: height,
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              color: Colors.black,
              builder: (ctx, child) => Navigator(
                onGenerateRoute: (settings) => MaterialPageRoute(
                  builder: (context) => _FloatingButton(
                    fliraClient: fliraClient,
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

class _FloatingButton extends StatelessWidget {
  const _FloatingButton({
    Key? key,
    required this.fliraClient,
  }) : super(key: key);
  final Flira fliraClient;
  @override
  Widget build(BuildContext ctx) {
    return BlocBuilder<FliraBloc, FliraState>(
      builder: (context, state) {
        final width = state.initialButtonWidth;
        final height = state.initialButtonHeight;
        return Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: AnimatedAlign(
            duration: const Duration(milliseconds: 450),
            alignment: Alignment.center,
            child: GestureDetector(
              onVerticalDragStart: (details) {
                context.read<FliraBloc>().add(FliraButtonDraggedEvent());
              },
              onTap: () async {
                ctx.read<FliraBloc>().add(InitialButtonTappedEvent());
                fliraClient.displayReportDialog(ctx);
              },
              child: Material(
                shape: const CircleBorder(),
                child: AnimatedContainer(
                  curve: curve,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color.fromARGB(
                      255,
                      7,
                      85,
                      210,
                    ),
                  ),
                  duration: const Duration(milliseconds: 400),
                  width: width,
                  height: height,
                  child: Center(
                    child: state.status == FliraStatus.initial
                        ? const FittedBox(
                            child: Text(
                              'Flira',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          )
                        : const CircularProgressIndicator(
                            color: Colors.white,
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

Future<void> checkPermissions() async {
  final status = await Permission.storage.status;
  if (status.isDenied) {
    Permission.storage.request();
  }
}
