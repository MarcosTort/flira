library flira;

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:atlassian_apis/jira_platform.dart';

/// A Calculator.
class Flira {
  const Flira({
    required this.atlassianUser,
    required this.atlassianApiToken,
    required this.atlassianUrl,
  });

  Future<ApiClient> getApiClient() async {
    final uri = '$atlassianUrl.atlassian.net';
    final ApiClient result = ApiClient.basicAuthentication(
      Uri.https(uri, ''),
      user: atlassianUser,
      apiToken: atlassianApiToken,
    );
    return result;
  }

  Future<JiraPlatformApi> getJiraPlatformApi(ApiClient client) async {
    return JiraPlatformApi(client);
  }

  void showReportDialog(BuildContext context) async {
    final apiClient = await getApiClient();
    final jiraPlatformApi = await getJiraPlatformApi(apiClient);
    final projects = await jiraPlatformApi.projects.getAllProjects();

    showDialog(
      context: context,
      builder: (BuildContext _) {
        // return object of type Dialog
        return AlertDialog(
          title: const Text("Report"),
          content: Row(
            children: projects
                .map((e) => MaterialButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return ReportBugDialog(
                                jiraPlatformApi: jiraPlatformApi,
                                project: e,
                              );
                            });
                      },
                      color: Colors.black26,
                      child: Text(e.name.toString()),
                    ))
                .toList(),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            MaterialButton(
              child: const Text("Close"),
              onPressed: () {},
            ),
          ],
        );
      },
    );
  }

  final String atlassianUser;
  final String atlassianApiToken;
  final String atlassianUrl;
}

class ReportBugDialog extends StatefulWidget {
  const ReportBugDialog(
      {Key? key, required this.project, required this.jiraPlatformApi})
      : super(key: key);
  final Project project;
  final JiraPlatformApi jiraPlatformApi;
  @override
  // ignore: no_logic_in_create_state
  State<ReportBugDialog> createState() =>
      _ReportBugDialogState(project, jiraPlatformApi);
}

class _ReportBugDialogState extends State<ReportBugDialog> {
  _ReportBugDialogState(this.project, this.jiraPlatformApi);
  String _title = '';
  String _description = '';
  @override
  void initState() {
    _title = '';
    _description = '';
    super.initState();
  }

  final JiraPlatformApi jiraPlatformApi;
  final Project project;
  @override
  Widget build(BuildContext context) {
    final ticketFieldNames = [
      'Title',
      'Description',
      'Steps to Reproduce',
      'Expected Result',
      'Actual Result',
      'Attachments',
    ];

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.min,
      children: [
        Dialog(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: ticketFieldNames
                    .map((e) => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            onChanged: (value) {
                              setState(() {
                                if (e == 'Title') {
                                  _title = value;
                                } else if (e == 'Description') {
                                  _description = value;
                                }
                              });
                            },
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              labelText: e,
                            ),
                          ),
                        ))
                    .toList(),
              ),
            ),
          ),
        ),
        MaterialButton(
          onPressed: () {
            jiraPlatformApi.issues.createIssue(
                body: IssueUpdateDetails(fields: {
              'project': {
                'key': 'TES',
              },
              'summary': _title,
              "description": {
                "type": "doc",
                "version": 1,
                "content": [
                  {
                    "type": "paragraph",
                    "content": [
                      {
                        "type": "text",
                        "text": _description,
                      }
                    ]
                  }
                ]
              },
              'issuetype': {'name': 'Bug'},
            }));
            // getProject(projectIdOrKey: 'testproject')
          },
          child: Text('Send ticket'),
          color: Colors.blue,
        )
      ],
    );
  }
}
