library flira;

import 'package:flira/bloc/flira_bloc.dart';
import 'package:flira/jira_repository/jira_repository.dart';
import 'package:flira/models/models.dart';
import 'package:flira/view/view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FliraWrapper extends StatelessWidget {
  const FliraWrapper({
    super.key,
    required this.app,
    required this.context,
    this.triggeringMethod = TriggeringMethod.none,
  });
  final MaterialApp app;
  final BuildContext context;
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
            )
              ..add(
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

