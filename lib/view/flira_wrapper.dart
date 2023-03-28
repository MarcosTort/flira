library flira;

import 'package:flira/bloc/flira_bloc.dart';
import 'package:flira/jira_repository/jira_repository.dart';
import 'package:flira/models/models.dart';
import 'package:flira/view/view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// A widget that wraps a [MaterialApp] with custom theme, [FliraBloc], and [FliraOverlay].
///
/// This widget is designed to be used as the top-level widget for a Flutter application.
/// It accepts a [MaterialApp] as its child and wraps it with a [Theme], a [BlocProvider],
/// and a [FliraOverlay] widget. The [FliraBloc] is created and provided to the app
/// via the [BlocProvider]. The [FliraOverlay] is used to display a widget on top of the app
/// when a certain triggering method is invoked.
class FliraWrapper extends StatelessWidget {
  /// Creates a [FliraWrapper] widget.
  ///
  /// The [app] parameter is required and should be a [MaterialApp]. The [context]
  /// parameter is required and should be the `BuildContext` of the parent widget.
  /// The [triggeringMethod] parameter is optional and defaults to [TriggeringMethod.none].
  const FliraWrapper({
    Key? key,
    required this.app,
    required this.context,
    this.triggeringMethod = TriggeringMethod.none,
  }) : super(key: key);

  /// The [MaterialApp] child widget to be wrapped.
  final MaterialApp app;

  /// The [BuildContext] of the parent widget.
  final BuildContext context;

  /// The [TriggeringMethod] to be used for the [FliraOverlay] widget.
  final TriggeringMethod triggeringMethod;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          colorScheme: jiraColorScheme),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Stack(children: [
          app,
          BlocProvider(
            create: (ctx) => FliraBloc(
              jiraRepository: const JiraRepository(),
            )..add(
                LoadCredentialsFromStorageEvent(),
              ),
            child: FliraOverlay(
              triggeringMethod: triggeringMethod,
            ),
          )
        ]),
      ),
    );
  }
}
