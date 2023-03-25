library flira;

import 'package:flira/bloc/flira_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jira_repository/jira_repository.dart';
import 'flira_wrapper/flira_wrapper.dart';

class FliraWrapper extends StatelessWidget {
  const FliraWrapper({
    super.key,
    required this.app,
    required this.context,
    this.triggeringMethod = TriggeringMethod.none,
  });
  final MaterialApp app;
  final BuildContext context;

  /// Triggering method for the client
  final TriggeringMethod triggeringMethod;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Stack(children: [
          app,
          BlocProvider(
            create: (ctx) => FliraBloc(
              jiraRepository: const JiraRepository(),
            )
              ..add(
                LoadCredentialsFromStorageEvent(),
              )
              ..add(FliraTriggeredEvent()),
            child: FliraOverlay(
              triggeringMethod: triggeringMethod,
            ),
          )
        ]),
      ),
    );
  }
}

enum TriggeringMethod {
  screenshot,
  shaking,
  none,
}

const curve = Curves.linearToEaseOut;

