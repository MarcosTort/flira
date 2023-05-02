part of 'jira_bloc.dart';

enum JiraStatus {
  initial,
  loading,
  success,
  failure,
  initSuccess,
  fliraStarted,
  ticketSubmittionError,
  ticketSubmittionSuccess,
}

class JiraState extends Equatable {
  const JiraState({
    this.status,
    this.filePickerResult,
    required this.triggeringMethod,
    this.jiraPlatformApi,
    required this.projects,
    required this.issue,
    required this.attachment,
    required this.selectedProject,
    required this.errorMessage,
  });
  JiraState.initial()
      : this(
          status: JiraStatus.initial,
          projects: [],
          attachment: const FilePickerResult([]),
          issue: const FliraIssue(
            issueType: 'Bug',
            description: '',
            name: '',
          ),
          selectedProject: Project(),
          errorMessage: '',
          triggeringMethod: TriggeringMethod.none,
        );

  final JiraStatus? status;
  final FilePickerResult? filePickerResult;
  final TriggeringMethod triggeringMethod;

  final JiraPlatformApi? jiraPlatformApi;
  final List<Project> projects;
  final FliraIssue issue;
  final FilePickerResult attachment;
  final Project selectedProject;
  final String errorMessage;

  JiraState copyWith({
    JiraStatus? status,
    FilePickerResult? filePickerResult,
    TriggeringMethod? triggeringMethod,
    JiraPlatformApi? jiraPlatformApi,
    List<Project>? projects,
    FliraIssue? issue,
    FilePickerResult? attachment,
    Project? selectedProject,
    String? errorMessage,
  }) {
    return JiraState(
      filePickerResult: filePickerResult ?? this.filePickerResult,
      status: status ?? this.status,
      triggeringMethod: triggeringMethod ?? this.triggeringMethod,
      jiraPlatformApi: jiraPlatformApi ?? this.jiraPlatformApi,
      projects: projects ?? this.projects,
      issue: issue ?? this.issue,
      attachment: attachment ?? this.attachment,
      selectedProject: selectedProject ?? this.selectedProject,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        filePickerResult,
        triggeringMethod,
        jiraPlatformApi,
        projects,
        issue,
        attachment,
        selectedProject,
        errorMessage,
      ];
}
