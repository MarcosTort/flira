library flira;

import 'package:flira/bloc/flira_bloc.dart';
import 'package:flutter/material.dart';
import 'package:atlassian_apis/jira_platform.dart' as j;
import 'package:screenshot_callback/screenshot_callback.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shake/shake.dart';

enum TriggeringMethod {
  screenshot,
  shaking,
  none,
}

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
      key: _project.key,
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
                            key: _project.key,
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
                        ? const _BugMenuItem()
                        : _issue.issueType == 'Task'
                            ? const _TaskMenuItem()
                            : const _StoryMenuItem(),
                    items: const [
                      DropdownMenuItem(
                        value: 'Bug',
                        child: _BugMenuItem(),
                      ),
                      DropdownMenuItem(
                        value: 'Task',
                        child: _TaskMenuItem(),
                      ),
                      DropdownMenuItem(
                        value: 'Story',
                        child: _StoryMenuItem(),
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

/// Dropdown menu item for Story issue type
class _StoryMenuItem extends StatelessWidget {
  const _StoryMenuItem({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.circular(2),
          ),
          child: const Icon(
            Icons.bookmark,
            color: Colors.white,
            size: 15,
          ),
        ),
        const SizedBox(
          width: 16,
        ),
        const Text('Story'),
      ],
    );
  }
}

/// Dropdown menu item for Task issue type
class _TaskMenuItem extends StatelessWidget {
  const _TaskMenuItem({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(2),
          ),
          child: const Icon(
            Icons.check,
            color: Colors.white,
            size: 15,
          ),
        ),
        const SizedBox(
          width: 16,
        ),
        const Text('Task'),
      ],
    );
  }
}

/// Dropdown menu item for Bug issue type
class _BugMenuItem extends StatelessWidget {
  const _BugMenuItem({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(2),
          ),
          child: const Icon(
            Icons.circle,
            color: Colors.white,
            size: 10,
          ),
        ),
        const SizedBox(
          width: 16,
        ),
        const Text('Bug'),
      ],
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
          : () {
              /// Create a new issue
              jiraPlatformApi.issues.createIssue(
                body: j.IssueUpdateDetails(
                  fields: {
                    'project': {
                      'key': issue.key,
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
                ),
              )

                /// Catching the error if the ticket is not created
                ..catchError((onError) {
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
                ..whenComplete(
                  () => showDialog(
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
                  ),
                );
            },
      color: const Color.fromARGB(255, 8, 0, 255).withOpacity(0.7),
      child: const Text('Send ticket',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
    );
  }
}

class _Issue {
  const _Issue(
      {this.key,
      this.name,
      this.description,
      this.issueType,
      this.status,
      this.project});
  final String? key;
  final String? name;
  final String? description;
  final String? issueType;
  final String? status;
  final j.Project? project;

  _Issue copyWith({
    String? key,
    String? name,
    String? description,
    String? issueType,
    String? status,
    j.Project? project,
  }) {
    return _Issue(
      key: key ?? this.key,
      name: name ?? this.name,
      description: description ?? this.description,
      issueType: issueType ?? this.issueType,
      status: status ?? this.status,
      project: project ?? this.project,
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
  final TriggeringMethod triggeringMethod;
  final String atlassianApiToken;
  final String atlassianUser;
  final String atlassianUrlPrefix;
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Stack(children: [
        app,
        BlocProvider(
          create: (ctx) => FliraBloc(),
          child: _FliraOverlay(
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

const curve = Curves.linearToEaseOut;

class _FliraOverlay extends StatelessWidget {
  const _FliraOverlay({
    required this.triggeringMethod,
    required this.atlassianApiToken,
    required this.atlassianUser,
    required this.atlassianUrlPrefix,
    Key? key,
  }) : super(key: key);
  final TriggeringMethod triggeringMethod;
  final String atlassianApiToken;
  final String atlassianUser;
  final String atlassianUrlPrefix;
  @override
  Widget build(BuildContext context) {
    Flira fliraClient = Flira(
      atlassianApiToken: atlassianApiToken,
      atlassianUser: atlassianUser,
      atlassianUrl: atlassianUrlPrefix,
    );
    if (triggeringMethod == TriggeringMethod.screenshot) {
      final screenshotCallback = ScreenshotCallback(requestPermissions: true);
      screenshotCallback.initialize();
      screenshotCallback.checkPermission();

      screenshotCallback.addListener(
        () {
          context.read<FliraBloc>().add(FliraTriggeredEvent());
        },
      );
    } else if (triggeringMethod == TriggeringMethod.shaking) {
      ShakeDetector shakeDetector = ShakeDetector.autoStart(
        onPhoneShake: () {
          context.read<FliraBloc>().add(FliraTriggeredEvent());
        },
      );
    }

    return BlocBuilder<FliraBloc, FliraState>(
      builder: (context, state) {
        final width = state.materialAppWidth;
        final height = state.materialAppHeight;
        return Align(
          alignment: state.alignment!,
          child: AnimatedContainer(
            curve: curve,
            duration: const Duration(milliseconds: 400),
            decoration: const BoxDecoration(
              color: Colors.transparent,
            ),
            width: width,
            height: height,
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              color: Colors.black,
              builder: (ctx, child) => Navigator(
                onGenerateRoute: (settings) => MaterialPageRoute(
                  builder: (context) => _Button(
                    fliraClient: fliraClient,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _Button extends StatelessWidget {
  const _Button({
    Key? key,
    required this.fliraClient,
  }) : super(key: key);
  final Flira fliraClient;
  @override
  Widget build(BuildContext ctx) {
    return BlocBuilder<FliraBloc, FliraState>(
      builder: (context, state) {
        final width = state.initialButtonWidth;
        final height = state.initialButtonHeight;
        return Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: AnimatedAlign(
            duration: const Duration(milliseconds: 450),
            alignment: Alignment.center,
            child: GestureDetector(
              onDoubleTap: () {
                context.read<FliraBloc>().add(FliraButtonDraggedEvent());
              },
              onTap: () async {
                ctx.read<FliraBloc>().add(InitialButtonTappedEvent());
                await fliraClient
                    .displayReportDialog(ctx)
                    .whenComplete(() => null);
              },
              child: Material(
                shape: const CircleBorder(),
                child: AnimatedContainer(
                  curve: curve,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color.fromARGB(
                      255,
                      7,
                      85,
                      210,
                    ),
                  ),
                  duration: const Duration(milliseconds: 400),
                  width: width,
                  height: height,
                  child: Center(
                    child: state.status == FliraStatus.initial
                        ? const FittedBox(
                            child: Text(
                              'Flira',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          )
                        : const CircularProgressIndicator(
                            color: Colors.white,
                          ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
