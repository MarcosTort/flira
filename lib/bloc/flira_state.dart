part of 'flira_bloc.dart';

enum FliraStatus {
  initial,
  loading,
  success,
  failure, initSuccess, fliraStarted, ticketSubmittionError, ticketSubmittionSuccess,
}

class FliraState extends Equatable {
  const FliraState({
    this.materialAppHeight,
    this.materialAppWidth,
    this.initialButtonHeight,
    this.initialButtonWidth,
    this.alignment,
    this.status,
    this.filePickerResult,
    this.atlassianApiToken,
    this.atlassianUser,
    this.atlassianUrlPrefix,
    required this.triggeringMethod,
    this.reportDialogOpen = false,
    this.jiraPlatformApi,
    required this.projects,
    required this.issue,
    required this.attachment,
    required this.selectedProject,
    required this.errorMessage,
  });
  FliraState.initial()
      : this(
            materialAppHeight: 0,
            materialAppWidth: 0,
            initialButtonHeight: 0,
            initialButtonWidth: 0,
            alignment: Alignment.bottomRight,
            status: FliraStatus.initial,
            projects: [],
            attachment: const FilePickerResult([]),
            issue: const FliraIssue(
               issueType: 'Bug',
               description: '',
               name: '',
               
            ),
            selectedProject: Project(),
            errorMessage: '',
            triggeringMethod: TriggeringMethod.none);


  final double? materialAppWidth;
  final double? materialAppHeight;
  final double? initialButtonWidth;
  final double? initialButtonHeight;
  final AlignmentGeometry? alignment;
  final FliraStatus? status;
  final FilePickerResult? filePickerResult;
  final TriggeringMethod triggeringMethod;
  final String? atlassianApiToken;
  final String? atlassianUser;
  final String? atlassianUrlPrefix;
  final bool reportDialogOpen;
  final JiraPlatformApi? jiraPlatformApi;
  final List<Project> projects;
  final FliraIssue issue;
  final FilePickerResult attachment;
  final Project selectedProject;
  final String errorMessage;

  

  FliraState copyWith({
    double? materialAppWidth,
    double? materialAppHeight,
    double? initialButtonWidth,
    double? initialButtonHeight,
    AlignmentGeometry? alignment,
    FliraStatus? status,
    FilePickerResult? filePickerResult,
    TriggeringMethod? triggeringMethod,
    String? atlassianApiToken,
    String? atlassianUser,
    String? atlassianUrlPrefix,
    bool? reportDialogOpen,
    JiraPlatformApi? jiraPlatformApi,
    List<Project>? projects,
    FliraIssue? issue,
    FilePickerResult? attachment,
    Project? selectedProject,
    String? errorMessage,
    
  }) {
    return FliraState(
      materialAppWidth: materialAppWidth ?? this.materialAppWidth,
      materialAppHeight: materialAppHeight ?? this.materialAppHeight,
      initialButtonWidth: initialButtonWidth ?? this.initialButtonWidth,
      initialButtonHeight: initialButtonHeight ?? this.initialButtonHeight,
      filePickerResult: filePickerResult ?? this.filePickerResult,
      alignment: alignment ?? this.alignment,
      status: status ?? this.status,
      triggeringMethod: triggeringMethod ?? this.triggeringMethod,
      atlassianApiToken: atlassianApiToken ?? this.atlassianApiToken,
      atlassianUser: atlassianUser ?? this.atlassianUser,
      atlassianUrlPrefix: atlassianUrlPrefix ?? this.atlassianUrlPrefix,
      reportDialogOpen: reportDialogOpen ?? this.reportDialogOpen,
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
        materialAppWidth,
        materialAppHeight,
        initialButtonWidth,
        initialButtonHeight,
        alignment,
        status,
        filePickerResult,
        triggeringMethod,
        atlassianApiToken,
        atlassianUser,
        atlassianUrlPrefix,
        reportDialogOpen,
        jiraPlatformApi,
        projects,
        issue,
        attachment,
        selectedProject,
        errorMessage,
      ];
}
