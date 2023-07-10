library flira;

import 'package:flira/bloc/flira_bloc.dart';
import 'package:flutter/material.dart';
import 'package:atlassian_apis/jira_platform.dart' as j;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'flira_wrapper/flira_wrapper.dart';
import 'report_dialog/report_dialog.dart';

/// This is the main class
class Flira {
  Flira();

  /// initializing triggering methods

  /// This method returns the atlassian api client
  Future<j.ApiClient> _getApiClient(
      String url, String user, String token) async {
    try {
      final uri = '$url.atlassian.net';
      final j.ApiClient result = j.ApiClient.basicAuthentication(
        Uri.https(uri, ''),
        user: user,
        apiToken: token,
      );
      return result;
    } on Exception catch (e) {
      throw Exception('Error: $e');
    }
  }

  /// This method returns the Jira client in which we can get all the information of the atlassianUrl projects
  Future<j.JiraPlatformApi> _getJiraPlatformApi(j.ApiClient client) async {
    try {
      return j.JiraPlatformApi(client);
    } on Exception catch (e) {
      throw Exception('Error: $e');
    }
  }

  /// This void function will show the report dialog in which we can report our issues

  Future<void> displayReportDialog(BuildContext context) async {
    try {
      final state = context.read<FliraBloc>().state;
      final url = state.atlassianUrlPrefix;
      final apiToken = state.atlassianApiToken;
      final user = state.atlassianUser;
      final apiClient = await _getApiClient(
        (url ?? '').trim(),
        (user ?? '').trim(),
        (apiToken ?? '').trim(),
      );
      final jiraPlatformApi = await _getJiraPlatformApi(apiClient);

      /// Here we get the projects of the current atlassianUrl
      final projects = await jiraPlatformApi.projects.getAllProjects();
      if (projects.isEmpty) {
        Future.delayed(
            const Duration(milliseconds: 500), () => settingsDialog(context));
      } else {
        Future.delayed(
          const Duration(milliseconds: 500),
          () => showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) => Stack(
              children: [
                ReportBugDialog(
                    projects: projects, jiraPlatformApi: jiraPlatformApi),
                Material(
                  color: Colors.transparent,
                  child: IconButton(
                      onPressed: () {
                        settingsDialog(
                          context,
                          fromSettings: true,
                          message: 'Settings\n \nTo get a new token go to: \n',
                        );
                      },
                      icon: const Icon(
                        Icons.settings,
                        color: Colors.white,
                        size: 40,
                      )),
                )
              ],
            ),
          ).whenComplete(() async => Future.delayed(
                const Duration(microseconds: 100),
                () => context.read<FliraBloc>().add(
                      FliraButtonDraggedEvent(),
                    ),
              )),
        );
      }
    } on Exception {
      Future.delayed(
          const Duration(milliseconds: 500), () => settingsDialog(context));
    }
  }
}

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
          create: (ctx) => FliraBloc()
            ..add(
              LoadCredentialsFromStorageEvent(),
            ),
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
  byTouch,
}

const curve = Curves.linearToEaseOut;
