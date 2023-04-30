library flira;

import 'package:flira/integrations/jira/bloc/flira_bloc.dart';
import 'package:flira/integrations/jira/jira_repository/jira_repository.dart';
import 'package:flira/integrations/jira/models/models.dart';
import 'package:flira/integrations/jira/view/view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// A widget that wraps a [MaterialApp] with custom theme, [JiraBloc], and [FliraOverlay].
///
/// This widget is designed to be used as the top-level widget for a Flutter application.
/// It accepts a [MaterialApp] as its child and wraps it with a [Theme], a [BlocProvider],
/// and a [FliraOverlay] widget. The [JiraBloc] is created and provided to the app
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
            create: (ctx) => JiraBloc(
              jiraPlatformApi: const JiraRepository(),
            )..add(
                LoadCredentialsFromStorageEvent(),
              )..add(
                FliraTriggeredEvent(),
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
