library flira;

import 'package:flira/bloc/flira_bloc.dart';
import 'package:flutter/material.dart';
import 'package:atlassian_apis/jira_platform.dart' as j;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'flira_wrapper/flira_wrapper.dart';
import 'report_dialog/report_dialog.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// This is the main class
class Flira {
  Flira({
    /// The user's email
    required this.atlassianUser,

    /// The user's token generated in the atlassian account
    required this.atlassianApiToken,

    /// The jira url of the organization
    required this.atlassianUrl,
  });

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
            builder: (context) => ReportBugDialog(
                projects: projects, jiraPlatformApi: jiraPlatformApi));
      }
    } on Exception {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Column(
            children: [
              const Text(
                'No projects found. Please check your api token and url',
              ),
              TextButton(
                onPressed: () async {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const WebView(initialUrl: 'https://id.atlassian.com/manage-profile/security/api-tokens',);
                  }));
                },
                child: const Text(
                    'To get a new token, go to: https://id.atlassian.com/manage-profile/security/api-tokens'),
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
                  onPressed: () {
                    context.read<FliraBloc>().add(
                          const AddCredentialsEvent(),
                        );
                    displayReportDialog(context);
                  },
                  child: const Text('Ok'),
                ),
              ],
            )
          ],
        ),
      ).whenComplete(
          () => context.read<FliraBloc>().add(FliraButtonDraggedEvent()));
    }
  }

  final String atlassianUser;
  final String atlassianApiToken;
  final String atlassianUrl;
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
