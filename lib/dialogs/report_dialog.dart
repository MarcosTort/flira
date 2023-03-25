import 'package:flira/bloc/flira_bloc.dart';
import 'package:flira/dialogs/dialogs.dart';
import 'package:flira/flira.dart';
import 'package:flutter/material.dart';
import 'package:atlassian_apis/jira_platform.dart' hide Icon;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'widgets/widgets.dart';
import 'package:file_picker/file_picker.dart';

class ReportBugDialog extends StatelessWidget {
  const ReportBugDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<FliraBloc>();
    final projects = bloc.state.projects;

    final attachment =
        context.select((FliraBloc value) => value.state.attachment);
    final issue = context.select((FliraBloc value) => value.state.issue);
    final project =
        context.select((FliraBloc value) => value.state.selectedProject);

    final ticketFieldNames = [
      'Summary',
      'Description',
    ];
    return Dialog(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Create Issue',
                      style: Theme.of(context).textTheme.titleLarge),
                ],
              ),
              const SizedBox(
                height: 36,
              ),
              Text('Project', style: Theme.of(context).textTheme.titleMedium),
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
                  child: DropdownButton<Project>(
                    iconEnabledColor: Colors.black,
                    borderRadius: BorderRadius.circular(10),
                    autofocus: true,
                    isExpanded: true,
                    value: project,
                    items: projects
                        .map(
                          (Project e) => DropdownMenuItem<Project>(
                            value: e,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(e.name ?? '',
                                  style: Theme.of(context).textTheme.bodyLarge),
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      context
                          .read<FliraBloc>()
                          .add(ChangeProjectRequested(value!));
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
                              style: Theme.of(context).textTheme.titleMedium),
                          const SizedBox(
                            height: 5,
                          ),
                          TextField(
                            onChanged: (value) {
                              if (e == 'Summary') {
                                context
                                    .read<FliraBloc>()
                                    .add(SummaryChanged(value));
                              } else if (e == 'Description') {
                                context
                                    .read<FliraBloc>()
                                    .add(DescriptionChanged(value));
                              }
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
              Row(
                children: [
                  DropdownButton(
                      borderRadius: BorderRadius.circular(10),
                      hint: issue.issueType == 'Bug'
                          ? const BugMenuItem()
                          : issue.issueType == 'Task'
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
                        context
                            .read<FliraBloc>()
                            .add(IssueTypeChanged(value as String));
                      }),
                  Stack(
                    children: [
                      IconButton(
                        onPressed: () async {
                          final result = await FilePicker.platform.pickFiles(
                            type: FileType.media,
                          );
                          if (result != null) {
                            bloc.add(AttachmentChanged(result));
                          }
                        },
                        icon: const Icon(Icons.attach_file_outlined),
                      ),
                      if ((attachment).files.isNotEmpty)
                        Container(
                          height: 20,
                          width: 20,
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              (attachment).files.length.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        )
                    ],
                  )
                ],
              ),
              const SizedBox(
                height: 24,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MaterialButton(
                      onPressed: () async {
                        Navigator.pop(context);
                      },
                      child: const Text('Cancel')),
                  SubmitButton(
                    onPressed: issue.name.toString().isEmpty ||
                            issue.description.toString().isEmpty
                        ? null
                        : () {
                            context
                                .read<FliraBloc>()
                                .add(const SubmitIssueRequested());
                          },
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> open(List<Project> projects, BuildContext context) async {
    try {
      if (projects.isEmpty) {
        throw Exception;
      } else {
        Future.delayed(
          const Duration(milliseconds: 500),
          () => showDialog(
              barrierDismissible: false,
              context: context,
              builder: (_) {
                return Stack(
                  children: [
                    this,
                    Material(
                      color: Colors.transparent,
                      child: IconButton(
                          onPressed: () {
                            const SettingsDialog(
                                fromSettings: true,
                                message:
                                    'Settings\n \nTo get a new token go to: \n').open(context);
                          },
                          icon: const Icon(
                            Icons.settings,
                            color: Colors.white,
                            size: 40,
                          )),
                    )
                  ],
                );
              }).whenComplete(() async => Future.delayed(
                const Duration(microseconds: 100),
                () => context.read<FliraBloc>().add(
                      FliraButtonDraggedEvent(),
                    ),
              )),
        );
      }
    } catch (e) {
      const SettingsDialog(

      ).open(context);
    }
  }
}

class FliraIssue {
  const FliraIssue(
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
  final Project? project;

  FliraIssue copyWith({
    String? projectKey,
    String? name,
    String? description,
    String? issueType,
    String? status,
    Project? project,
  }) {
    return FliraIssue(
      projectKey: projectKey ?? this.projectKey,
      name: name ?? this.name,
      description: description ?? this.description,
      issueType: issueType ?? this.issueType,
      status: status ?? this.status,
      project: project ?? this.project,
    );
  }
}

class SubmitButton extends StatelessWidget {
  const SubmitButton({super.key, required this.onPressed});
  final VoidCallback? onPressed;
  @override
  Widget build(BuildContext context) {
    final isLoading = context.select((FliraBloc bloc) => bloc.state.status ==
        FliraStatus.loading);
    return isLoading?  CircularProgressIndicator(color:  const Color.fromARGB(255, 8, 0, 255).withOpacity(0.7),): MaterialButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
      ),
      disabledColor: Colors.grey,
      onPressed: onPressed,
      color: const Color.fromARGB(255, 8, 0, 255).withOpacity(0.7),
      child: const Text('Send ticket',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
    );
  }
}
