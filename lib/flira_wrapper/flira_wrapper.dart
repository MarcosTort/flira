import 'package:flira/bloc/flira_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    Flira fliraClient = Flira();
  

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
            child: Localizations(
              delegates:  const [
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
                      builder: (context) =>
                          _SideButton(fliraClient: fliraClient),
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
            alignment: Alignment.center,
            child: GestureDetector(
              onHorizontalDragStart: (details) {
                context.read<FliraBloc>().add(CollapseInitialButtonEvent());
              },
              onTap: () async {
                if (buttonStatus == ButtonStatus.collapsed) {
                  ctx.read<FliraBloc>().add(const InitialButtonExpandedEvent());
                } else {
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
                    shape: BoxShape.rectangle,
                    color: state.buttonStatus == ButtonStatus.window
                        ? Colors.transparent
                        : const Color.fromARGB(
                            255,
                            7,
                            85,
                            210,
                          ),
                  ),
                  duration: const Duration(milliseconds: 400),
                  width: width,
                  height: height,
                  child: buttonStatus == ButtonStatus.collapsed
                      ? const SizedBox()
                      : Center(
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
