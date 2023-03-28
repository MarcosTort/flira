import 'package:flira/bloc/flira_bloc.dart';
import 'package:flira/view/dialogs/dialogs.dart';
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

    final project =
        context.select((FliraBloc value) => value.state.selectedProject);
    final isLoading = context
        .select((FliraBloc value) => value.state.status == FliraStatus.loading);
    return Dialog(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              isLoading
                  ? const Center(
                      child: SizedBox(
                          height: 450,
                          width: 224,
                          child: CircularProgressIndicator.adaptive()),
                    )
                  : Column(
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
                        Text('Project',
                            style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(
                          height: 5,
                        ),
                        _ProjectSelector(project: project, projects: projects),
                        const SizedBox(
                          height: 25,
                        ),
                        const _Form(),
                        Row(
                          children: const [
                            _IssueTypeSelector(),
                            _AttachmentButton()
                          ],
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                      ],
                    ),
              const _ActionButtons()
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
                final theme = Theme.of(context);
                return Stack(
                  children: [
                    this,
                    Material(
                      color: theme.colorScheme.onSurface,
                      child: IconButton(
                          onPressed: () {
                            const SettingsDialog(
                                    fromSettings: true,
                                    message:
                                        'Settings\n \nTo get a new token go to: \n')
                                .open(context);
                          },
                          icon: Icon(
                            Icons.settings,
                            color: theme.colorScheme.secondary,
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
      const SettingsDialog().open(context);
    }
  }
}

class _Form extends StatelessWidget {
  const _Form();

  @override
  Widget build(BuildContext context) {
    final ticketFieldNames = [
      'Summary',
      'Description',
    ];
    return ListView.builder(
      itemCount: ticketFieldNames.length,
      shrinkWrap: true,
      itemBuilder: (context, index) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(ticketFieldNames[index],
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(
            height: 5,
          ),
          TextField(
            onChanged: (value) {
              if (ticketFieldNames[index] == 'Summary') {
                context.read<FliraBloc>().add(SummaryChanged(value));
              } else if (ticketFieldNames[index] == 'Description') {
                context.read<FliraBloc>().add(DescriptionChanged(value));
              }
            },
            decoration: InputDecoration(
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
            ),
          ),
          const SizedBox(
            height: 25,
          ),
        ],
      ),
    );
  }
}

class _ActionButtons extends StatelessWidget {
  const _ActionButtons();

  @override
  Widget build(BuildContext context) {
    final issue = context.select((FliraBloc value) => value.state.issue);
    final isLoading = context
        .select((FliraBloc value) => value.state.status == FliraStatus.loading);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        MaterialButton(
            onPressed: () async {
              Navigator.pop(context);
            },
            child: const Text('Cancel')),
        SubmitButton(
          onPressed: (issue.name.toString().isEmpty ||
                      issue.description.toString().isEmpty) &&
                  !isLoading
              ? null
              : () {
                  context.read<FliraBloc>().add(const SubmitIssueRequested());
                },
        ),
      ],
    );
  }
}

class _AttachmentButton extends StatelessWidget {
  const _AttachmentButton();

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<FliraBloc>();
    final attachment =
        context.select((FliraBloc value) => value.state.attachment);
    final theme = Theme.of(context);
    return Stack(
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
            decoration: BoxDecoration(
              color: theme.colorScheme.onError,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                (attachment).files.length.toString(),
                style: TextStyle(
                  color: theme.colorScheme.secondary,
                  fontSize: 12,
                ),
              ),
            ),
          )
      ],
    );
  }
}

class _IssueTypeSelector extends StatelessWidget {
  const _IssueTypeSelector();

  @override
  Widget build(BuildContext context) {
    final issue = context.select((FliraBloc value) => value.state.issue);

    return DropdownButton(
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
          context.read<FliraBloc>().add(IssueTypeChanged(value as String));
        });
  }
}

class _ProjectSelector extends StatelessWidget {
  const _ProjectSelector({
    required this.project,
    required this.projects,
  });

  final Project project;
  final List<Project> projects;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return DropdownButtonHideUnderline(
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.onBackground.withOpacity(0.2),
          borderRadius: BorderRadius.circular(6),
        ),
        width: MediaQuery.of(context).size.width,
        child: DropdownButton<Project>(
          iconEnabledColor: theme.colorScheme.onSecondary,
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
            context.read<FliraBloc>().add(ChangeProjectRequested(value!));
          },
        ),
      ),
    );
  }
}

class SubmitButton extends StatelessWidget {
  const SubmitButton({super.key, required this.onPressed});
  final VoidCallback? onPressed;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLoading = context
        .select((FliraBloc bloc) => bloc.state.status == FliraStatus.loading);
    return MaterialButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
      ),
      disabledColor: theme.colorScheme.onBackground,
      onPressed: !isLoading ? onPressed : null,
      color: theme.colorScheme.primary.withOpacity(0.7),
      child: Text('Send ticket',
          style: TextStyle(
              color: theme.colorScheme.secondary, fontWeight: FontWeight.w700)),
    );
  }
}
