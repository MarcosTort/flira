import 'package:flira/bloc/flira_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shake/shake.dart';

import '../flira.dart';

class FliraOverlay extends StatelessWidget {
  const FliraOverlay({
    required this.triggeringMethod,
    Key? key,
  }) : super(key: key);
  final TriggeringMethod triggeringMethod;
//asd
  @override
  Widget build(BuildContext context) {
    Flira fliraClient = Flira();
    final canTriggerDialog = !context.read<FliraBloc>().state.reportDialogOpen;
    if (triggeringMethod == TriggeringMethod.shaking) {
      ShakeDetector.autoStart(
        shakeSlopTimeMS: 100,
        minimumShakeCount: 1,
        shakeThresholdGravity: 2.5,
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
            duration: const Duration(milliseconds: 500),
            decoration: const BoxDecoration(
              color: Colors.transparent,
            ),
            width: width! + 10,
            height: height! + 10,
            child: Localizations(
              delegates: const [
                DefaultMaterialLocalizations.delegate,
                DefaultWidgetsLocalizations.delegate,
                DefaultCupertinoLocalizations.delegate,
              ],
              locale: const Locale('en', 'US'),
              child: MediaQuery(
                data: MediaQueryData.fromView(WidgetsBinding.instance.window),
                child: Material(
                  color: Colors.transparent,
                  child: Navigator(
                    onGenerateRoute: (settings) => MaterialPageRoute(
                      builder: (context) => Align(
                        alignment: Alignment.centerLeft,
                        child: _SideButton(
                          fliraClient: fliraClient,
                        ),
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

// class _FloatingButton extends StatelessWidget {
//   const _FloatingButton({
//     Key? key,
//     required this.fliraClient,
//   }) : super(key: key);
//   final Flira fliraClient;
//   @override
//   Widget build(BuildContext ctx) {
//     return BlocBuilder<FliraBloc, FliraState>(
//       builder: (context, state) {
//         final width = state.initialButtonWidth;
//         final height = state.initialButtonHeight;
//         return Padding(
//           padding: const EdgeInsets.only(bottom: 20),
//           child: AnimatedAlign(
//             duration: const Duration(milliseconds: 450),
//             alignment: Alignment.center,
//             child: GestureDetector(
//               onVerticalDragStart: (details) {
//                 context.read<FliraBloc>().add(FliraButtonDraggedEvent());
//               },
//               onTap: () async {
//                 ctx.read<FliraBloc>().add(InitialButtonTappedEvent());
//                 fliraClient.displayReportDialog(ctx);
//               },
//               child: Material(
//                 shape: const CircleBorder(),
//                 child: AnimatedContainer(
//                   curve: curve,
//                   decoration: const BoxDecoration(
//                     shape: BoxShape.circle,
//                     color: Color.fromARGB(
//                       255,
//                       7,
//                       85,
//                       210,
//                     ),
//                   ),
//                   duration: const Duration(milliseconds: 400),
//                   width: width,
//                   height: height,
//                   child: Center(
//                     child: state.status == FliraStatus.initial
//                         ? const FittedBox(
//                             child: Text(
//                               'Flira',
//                               style: TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 20,
//                                 fontWeight: FontWeight.w700,
//                               ),
//                             ),
//                           )
//                         : const CircularProgressIndicator(
//                             color: Colors.white,
//                           ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

class _SideButton extends StatelessWidget {
  const _SideButton({
    Key? key,
    required this.fliraClient,
  }) : super(key: key);
  final Flira fliraClient;
  @override
  Widget build(BuildContext ctx) {
    final buttonStatus =
        ctx.select((FliraBloc value) => value.state.buttonStatus);
    return BlocBuilder<FliraBloc, FliraState>(
      builder: (context, state) {
        final width = state.initialButtonWidth;
        final height = state.initialButtonHeight;
        return Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: AnimatedAlign(
            duration: const Duration(milliseconds: 450),
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              onHorizontalDragStart: (details) {
                context.read<FliraBloc>().add(CollapseInitialButtonEvent());
              },
              onTap: () async {
                if (buttonStatus == ButtonStatus.expanded) {
                  ctx.read<FliraBloc>().add(InitialButtonTappedEvent());
                  fliraClient.displayReportDialog(ctx);
                }
              },
              child: Material(
                color: Colors.transparent,
                child: AnimatedContainer(
                  curve: curve,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                    boxShadow: state.buttonStatus != ButtonStatus.window
                        ? [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              spreadRadius: 1,
                              blurRadius: 5,
                              offset: const Offset(0, 5),
                            ),
                          ]
                        : null,
                    shape: BoxShape.rectangle,
                    color: state.buttonStatus == ButtonStatus.window
                        ? Colors.transparent
                        : const Color.fromARGB(255, 242, 247, 255),
                  ),
                  duration: const Duration(milliseconds: 400),
                  width: width,
                  height: height,
                  child: buttonStatus == ButtonStatus.collapsed
                      ? const SizedBox()
                      : Center(
                          child: state.status == FliraStatus.initial
                              ? state.buttonStatus == ButtonStatus.expanded
                                  ? const FittedBox(
                                      child: AnimatedLogo(),
                                    )
                                  : const SizedBox()
                              : const CircularProgressIndicator(
                                  color: Color.fromARGB(
                                    255,
                                    7,
                                    85,
                                    210,
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

class AnimatedLogo extends StatefulWidget {
  const AnimatedLogo({
    super.key,
  });

  @override
  State<AnimatedLogo> createState() => _AnimatedLogoState();
}

class _AnimatedLogoState extends State<AnimatedLogo>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: CurvedAnimation(
        parent: AnimationController(
          duration: const Duration(milliseconds: 2000),
          vsync: this,
        )..repeat(),
        curve: Curves.elasticInOut,
      ),
      child: Image.network(
        height: 50,
        width: 50,
        'https://cdn.icon-icons.com/icons2/2699/PNG/512/atlassian_jira_logo_icon_170511.png',
      ),
    );
  }
}

Future<void> checkPermissions() async {
  final status = await Permission.storage.status;
  if (status.isDenied) {
    Permission.storage.request();
  }
}
