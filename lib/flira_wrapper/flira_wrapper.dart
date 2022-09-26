
import 'package:flira/bloc/flira_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:screenshot_callback/screenshot_callback.dart';
import 'package:shake/shake.dart';
import '../flira.dart';

class FliraOverlay extends StatelessWidget {
  const FliraOverlay({
    required this.triggeringMethod,
    // required this.atlassianApiToken,
    // required this.atlassianUser,
    // required this.atlassianUrlPrefix,
    Key? key,
  }) : super(key: key);
  final TriggeringMethod triggeringMethod;
  // final String atlassianApiToken;
  // final String atlassianUser;
  // final String atlassianUrlPrefix;
  @override
  Widget build(BuildContext context) {
    final state = context.read<FliraBloc>().state;
    Flira fliraClient = Flira(
      atlassianApiToken: state.atlassianApiToken??'',
      atlassianUser: state.atlassianUser??'',
      atlassianUrl: state.atlassianUrlPrefix??'',
    );
    if (triggeringMethod == TriggeringMethod.screenshot) {
      final screenshotCallback = ScreenshotCallback(requestPermissions: true);
      screenshotCallback.initialize();
      screenshotCallback.checkPermission();

      screenshotCallback.addListener(
        () {
          context.read<FliraBloc>().add(FliraTriggeredEvent());
        },
      );
    } else if (triggeringMethod == TriggeringMethod.shaking) {
      ShakeDetector shakeDetector = ShakeDetector.autoStart(
        onPhoneShake: () {
          context.read<FliraBloc>().add(FliraTriggeredEvent());
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
              onDoubleTap: () {
                context.read<FliraBloc>().add(FliraButtonDraggedEvent());
              },
              onTap: () async {
                ctx.read<FliraBloc>().add(InitialButtonTappedEvent());
                await fliraClient
                    .displayReportDialog(ctx)
                    .whenComplete(() => null);
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