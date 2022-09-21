
import 'package:flutter/material.dart';
import 'package:atlassian_apis/jira_platform.dart' as j;

import 'widgets/widgets.dart';

class ReportBugDialog extends StatefulWidget {
  const ReportBugDialog(
      {Key? key, required this.projects, required this.jiraPlatformApi})
      : super(key: key);
  final List<j.Project> projects;
  final j.JiraPlatformApi jiraPlatformApi;
  @override
  // ignore: no_logic_in_create_state
  State<ReportBugDialog> createState() =>
      // ignore: no_logic_in_create_state
      _ReportBugDialogState(projects, jiraPlatformApi);
}

class _ReportBugDialogState extends State<ReportBugDialog> {
  _ReportBugDialogState(this.projects, this.jiraPlatformApi);

  /// Initial Project object to be used in the dropdown. This will be updated when the user selects a different project
  late j.Project _project;

  /// Initial IssueType object to be used in the dropdown. This will be updated when the user selects a different issue type
  late _Issue _issue;

  @override
  void initState() {
    /// Set the initial project and issue

    _project = projects.first;
    _issue = _Issue(
      name: '',
      project: _project,
      projectKey: _project.key,
      issueType: 'Bug',
      description: '',
    );
    super.initState();
  }

  final j.JiraPlatformApi jiraPlatformApi;
  final List<j.Project> projects;
  @override
  Widget build(BuildContext context) {
    final ticketFieldNames = [
      'Summary',
      'Description',
    ];
    return Dialog(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 16,
                ),
                Text('Create Issue',
                    style: Theme.of(context).textTheme.headline6),
                const SizedBox(
                  height: 36,
                ),
                Text('Project', style: Theme.of(context).textTheme.subtitle1),
                const SizedBox(
                  height: 5,
                ),
                DropdownButtonHideUnderline(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    width: MediaQuery.of(context).size.width,
                    child: DropdownButton<j.Project>(
                      iconEnabledColor: Colors.black,
                      borderRadius: BorderRadius.circular(10),
                      autofocus: true,
                      isExpanded: true,
                      value: _project,
                      items: projects
                          .map(
                            (j.Project e) => DropdownMenuItem<j.Project>(
                              value: e,
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(e.name ?? '',
                                    style:
                                        Theme.of(context).textTheme.bodyText1),
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _project = value!;
                          _issue = _issue.copyWith(
                            project: _project,
                            projectKey: _project.key,
                          );
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                ...ticketFieldNames
                    .map((e) => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(e,
                                style: Theme.of(context).textTheme.subtitle1),
                            const SizedBox(
                              height: 5,
                            ),
                            TextField(
                              onChanged: (value) {
                                setState(() {
                                  if (e == 'Summary') {
                                    _issue = _issue.copyWith(name: value);
                                  } else if (e == 'Description') {
                                    _issue =
                                        _issue.copyWith(description: value);
                                  }
                                });
                              },
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(6)),
                              ),
                            ),
                            const SizedBox(
                              height: 25,
                            ),
                          ],
                        ))
                    .toList(),
                DropdownButton(
                    borderRadius: BorderRadius.circular(10),
                    hint: _issue.issueType == 'Bug'
                        ? const BugMenuItem()
                        : _issue.issueType == 'Task'
                            ? const TaskMenuItem()
                            : const StoryMenuItem(),
                    items: const [
                      DropdownMenuItem(
                        value: 'Bug',
                        child: BugMenuItem(),
                      ),
                      DropdownMenuItem(
                        value: 'Task',
                        child: TaskMenuItem(),
                      ),
                      DropdownMenuItem(
                        value: 'Story',
                        child: StoryMenuItem(),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _issue = _issue.copyWith(issueType: value.toString());
                      });
                    }),
                const SizedBox(
                  height: 24,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MaterialButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Cancel')),
                    _SubmitTicketButton(
                      jiraPlatformApi: jiraPlatformApi,
                      issue: _issue,
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Issue {
  const _Issue(
      {this.projectKey,
      this.name,
      this.description,
      this.issueType,
      this.status,
      this.project});
  final String? projectKey;
  final String? name;
  final String? description;
  final String? issueType;
  final String? status;
  final j.Project? project;

  _Issue copyWith({
    String? projectKey,
    String? name,
    String? description,
    String? issueType,
    String? status,
    j.Project? project,
  }) {
    return _Issue(
      projectKey: projectKey ?? this.projectKey,
      name: name ?? this.name,
      description: description ?? this.description,
      issueType: issueType ?? this.issueType,
      status: status ?? this.status,
      project: project ?? this.project,
    );
  }
}

class _SubmitTicketButton extends StatelessWidget {
  const _SubmitTicketButton({
    Key? key,
    required this.jiraPlatformApi,
    required this.issue,
  }) : super(key: key);

  final j.JiraPlatformApi jiraPlatformApi;
  final _Issue issue;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
      ),
      disabledColor: Colors.grey,
      onPressed: issue.name.toString().isEmpty ||
              issue.description.toString().isEmpty
          ? null
          : () async {
              /// Create a new issue
              final send = await jiraPlatformApi.issues
                  .createIssue(
                      body: j.IssueUpdateDetails(
                fields: {
                  'project': {
                    'key': issue.projectKey,
                  },
                  'summary': issue.name,
                  "description": {
                    "type": "doc",
                    "version": 1,
                    "content": [
                      {
                        "type": "paragraph",
                        "content": [
                          {
                            "type": "text",
                            "text": '${issue.description}',
                          }
                        ]
                      }
                    ]
                  },
                  'issuetype': {
                    'name': issue.issueType,
                  },
                },
              ))
                  .

                  /// Catching the error if the ticket is not created
                  catchError((onError) {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Error'),
                        content: Text(onError.toString()),
                        actions: [
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('Ok'))
                        ],
                      );
                    });
              })

                  /// If the ticket is created successfully
                  .whenComplete(() {
                   
                showDialog(
                  context: context,
                  builder: (context) {
                    
                    return AlertDialog(
                      title: const Text('Success'),
                      content:
                          const Text('Do you want to create another ticket?'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Yes'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.pop(context);
                          },
                          child: const Text(
                            'No',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    );
                  },
                );
              });
                await Future.delayed(const Duration(seconds: 10));
                var file = j.MultipartFile.fromString(
                  'test.txt',
                  'Test attachment',
                );
                
                await jiraPlatformApi.issueAttachments
                    .addAttachment(issueIdOrKey: send.id??'', file: file );
            },
      color: const Color.fromARGB(255, 8, 0, 255).withOpacity(0.7),
      child: const Text('Send ticket',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
    );
  }
}

// void createIssueWithAttachment () async {
//     var issue = IssueUpdateDetails(
//       fields: {
//         'project': {
//           'key': 'TEST',
//         },
//         'summary': 'Test issue',
//         'attachment': [],
//         "description": {
//           "type": "doc",
//           "version": 1,
//           "content": [
//             {
//               "type": "paragraph",
//               "content": [
//                 {
//                   "type": "text",
//                   "text": 'Test issue description',
//                 }
//               ]
//             }
//           ]
//         },
//         'issuetype': {
//           'name': 'Bug',
//         },
//       },
//     );

//     var issueCreated = await jiraPlatformApi.issues.createIssue(body: issue);

//     var attachment = Attachment(
//       filename: 'test.txt',
//       mimeType: 'text/plain',
//       content: base64Encode(utf8.encode('Test attachment')),
//     );

//     await jiraPlatformApi.issues.addAttachment(
//       issueIdOrKey: issueCreated.key,
//       body: attachment,
//     );
//   }