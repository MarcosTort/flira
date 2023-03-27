library flira;

import 'package:flira/bloc/flira_bloc.dart';
import 'package:flira/models/models.dart';
import 'package:flira/view/flira_overlay.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jira_repository/jira_repository.dart';

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
        colorScheme: jiraColorScheme
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

const jiraColorScheme = ColorScheme(
  primary: Color(0xFF0052CC), // Azul claro (#2684FF) como variante del color primario
  secondary: Color(0xFFF4F5F7), // Verde claro (#71A800) como variante del color secundario
  surface: Color(0xFFFFFFFF), // Blanco (#FFFFFF) como color de superficie
  background: Color(0xFFFFFFFF), // Blanco (#FFFFFF) como color de fondo
  error: Color(0xFFCF1322), // Rojo (#CF1322) como color de error
  outline: Colors.green,
  onPrimary: Color(0xFFFFFFFF), // Blanco (#FFFFFF) como color en el texto del color primario
  onSecondary: Color(0xFF000000), // Negro (#000000) como color en el texto del color secundario
  onSurface: Colors.transparent, // Negro (#000000) como color en el texto en la superficie
  onBackground: Colors.grey, // Negro (#000000) como color en el texto en el fondo
  onError: Color(0xFFFFFFFF), // Blanco (#FFFFFF) como color en el texto en el color de error
  brightness: Brightness.light, // Establecer el brillo a light
);
