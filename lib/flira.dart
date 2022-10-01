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
      final apiClient =
          await _getApiClient(url ?? '', user ?? '', apiToken ?? '');

      final jiraPlatformApi = await _getJiraPlatformApi(apiClient);

      /// Here we get the projects of the current atlassianUrl
      final projects = await jiraPlatformApi.projects.getAllProjects();
      if (projects.isEmpty) {
        throw Exception;
      } else {
        showDialog(
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
                            settingsDialog(context,
                                message:
                                    'Settings\n \nTo get a new token go to: \n');
                          },
                          icon: const Icon(
                            Icons.settings,
                            color: Colors.white,
                            size: 40,
                          )),
                    )
                  ],
                ));
      }
    } on Exception {
      settingsDialog(context).whenComplete(
          () => context.read<FliraBloc>().add(FliraButtonDraggedEvent()));
    }
  }

  Future<dynamic> settingsDialog(BuildContext context,
      {String message =
          'No projects found. Please check your api token and url. To get a new token, go to:\n'}) {
    return showDialog(
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
            initialValue: context
                .select((FliraBloc bloc) => bloc.state.atlassianUrlPrefix),
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
            initialValue: context
                .select((FliraBloc bloc) => bloc.state.atlassianApiToken),
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
                      .whenComplete(() => Navigator.pop(context));
                },
                child: const Text('Ok'),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class FliraWrapper extends StatelessWidget {
  const FliraWrapper({
    super.key,
    required this.app,
    required this.context,
    required this.atlassianApiToken,
    required this.atlassianUser,
    required this.atlassianUrlPrefix,
    this.triggeringMethod = TriggeringMethod.none,
  });
  final MaterialApp app;
  final BuildContext context;

  /// Triggering method for the client
  final TriggeringMethod triggeringMethod;

  /// Atlassian API token
  final String atlassianApiToken;

  /// Atlassian user email
  final String atlassianUser;

  /// Atlassian url prefix of your jira cloud. Like https://yourcompany.atlassian.net (yourcompany)
  final String atlassianUrlPrefix;
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
}

const curve = Curves.linearToEaseOut;
