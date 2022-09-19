library flira;

import 'package:flira/bloc/flira_bloc.dart';
import 'package:flutter/material.dart';
import 'package:atlassian_apis/jira_platform.dart' as j;
import 'package:flutter_bloc/flutter_bloc.dart';

import 'flira_wrapper/flira_wrapper.dart';
import 'report_dialog/report_dialog.dart';


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
  Future<j.ApiClient> _getApiClient() async {
    try {
      final uri = '$atlassianUrl.atlassian.net';
      final j.ApiClient result = j.ApiClient.basicAuthentication(
        Uri.https(uri, ''),
        //TODO: Handle a wrong atlassianUser
        user: atlassianUser,
        apiToken: atlassianApiToken,
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
      final apiClient = await _getApiClient();

      final jiraPlatformApi = await _getJiraPlatformApi(apiClient);

      /// Here we get the projects of the current atlassianUrl
      final projects = await jiraPlatformApi.projects.getAllProjects();
      if (projects.isEmpty) {
        showDialog(
            context: context,
            builder: (context) => const AlertDialog(
                  title: Text(
                      'No projects found. Please check your api token and url'),
                ));
      } else {
        
        showDialog(

            barrierDismissible: false,
            context: context,
            builder: (context) => ReportBugDialog(
                projects: projects, jiraPlatformApi: jiraPlatformApi));
      }
    } on Exception catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: Text('Something went wrong. \n\nError: ${e.toString()}'),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Ok'))
          ],
        ),
      );
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
          create: (ctx) => FliraBloc(),
          child: FliraOverlay(
            triggeringMethod: triggeringMethod,
            atlassianApiToken: atlassianApiToken,
            atlassianUser: atlassianUser,
            atlassianUrlPrefix: atlassianUrlPrefix,
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
