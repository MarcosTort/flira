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
    return Directionality(
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
    );
  }
}

enum TriggeringMethod {
  screenshot,
  shaking,
  none,
}

const curve = Curves.linearToEaseOut;
Future<dynamic> settingsDialog(BuildContext context,
    {bool fromSettings = false,
    String message =
        'No projects found. Please check your api token and url. To get a new token, go to:\n'}) {
  return showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) => AlertDialog(
      title: Column(
        children: [
          Text(
            message,
          ),
          const SelectableText(
            'https://id.atlassian.com/manage-profile/security/api-tokens',
            style: TextStyle(color: Colors.blue),
          ),
        ],
      ),
      actions: [
        TextFormField(
          initialValue:
              context.select((FliraBloc bloc) => bloc.state.atlassianUrlPrefix),
          onChanged: (value) => context.read<FliraBloc>().add(
                UrlTextFieldOnChangedEvent(value),
              ),
          decoration: const InputDecoration(
            hintText: 'Enter your jira server name',
          ),
        ),
        TextFormField(
          initialValue:
              context.select((FliraBloc bloc) => bloc.state.atlassianUser),
          onChanged: (value) => context.read<FliraBloc>().add(
                UserTextFieldOnChangedEvent(value),
              ),
          decoration: const InputDecoration(
            hintText: 'Enter your jira user email',
          ),
        ),
        TextFormField(
          obscureText: true,
          initialValue:
              context.select((FliraBloc bloc) => bloc.state.atlassianApiToken),
          onChanged: (value) => context.read<FliraBloc>().add(
                TokenTextFieldOnChangedEvent(value),
              ),
          decoration: const InputDecoration(
            hintText: 'Enter your api token',
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton(
              onPressed: () {
                if (!fromSettings) {
                  context.read<FliraBloc>().add(FliraButtonDraggedEvent());
                }
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                context.read<FliraBloc>().add(
                      const AddCredentialsEvent(),
                    );
                await Future.delayed(const Duration(milliseconds: 200))
                    .whenComplete(() {
                  Navigator.pop(context);
                  if (!fromSettings) {
                    context.read<FliraBloc>().add(FliraButtonDraggedEvent());
                  }
                });
              },
              child: const Text('Ok'),
            ),
          ],
        )
      ],
    ),
  );
}
