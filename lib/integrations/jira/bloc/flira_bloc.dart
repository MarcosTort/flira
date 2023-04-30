import 'package:atlassian_apis/jira_platform.dart';
import 'package:flira/integrations/jira/models/models.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';



part 'flira_event.dart';
part 'flira_state.dart';

class JiraBloc extends Bloc<JiraEvent, JiraState> {
  JiraBloc({
    required JiraPlatformApi jiraPlatformApi,
  })  : _jiraPlatformApi = jiraPlatformApi,
        super(JiraState.initial()) {
    on<InitJiraRequested>(_onInitJiraRequested);

    // on<InitialButtonTappedEvent>(_onInitialButtonTappedEvent);
    // on<FliraTriggeredEvent>(_onFliraTriggeredEvent);
    // on<FliraButtonDraggedEvent>(_onFliraButtonDraggedEvent);
    //jira
    on<AddFileEvent>(_onAddFileEvent);
    // on<AddCredentialsEvent>(_onAddCredentialsEvent);
    // on<TokenTextFieldOnChangedEvent>(_onTokenTextFieldOnChangedEvent);
    // on<UserTextFieldOnChangedEvent>(_onUserTextFieldOnChangedEvent);
    // on<UrlTextFieldOnChangedEvent>(_onUrlTextFieldOnChangedEvent);
    // on<LoadCredentialsFromStorageEvent>(_onLoadCredentialsFromStorageEvent);
    on<SubmitIssueRequested>(_onSubmitIssueRequested);
    on<ChangeProjectRequested>(_onChangeProjectRequested);
    on<SummaryChanged>(_onSummaryChanged);
    on<DescriptionChanged>(_onDescriptionChanged);
    on<IssueTypeChanged>(_onIssueTypeChanged);
    on<AttachmentChanged>(_onAttachmentChanged);
  }
  final storage = const FlutterSecureStorage();
  final JiraPlatformApi _jiraPlatformApi;
  void _onIssueTypeChanged(
      IssueTypeChanged event, Emitter<JiraState> emit) async {
    emit(state.copyWith(
        issue: state.issue.copyWith(issueType: event.issueType)));
  }

  Future<void> _onAttachmentChanged(
      AttachmentChanged event, Emitter<JiraState> emit) async {
    emit(state.copyWith(attachment: event.attachment));
  }

  Future<void> _onInitJiraRequested(
      InitJiraRequested event, Emitter<JiraState> emit) async {
    emit(state.copyWith(
      status: JiraStatus.loading,
    ));
    try {
      // MondayRepository mondayRepository = MondayRepository();
      // final QueryResult result = await mondayRepository.getBoards();
      // final response = await mondayRepository.createTask('4226775781', 'Prueba desde Flutter', 'descripcion de prueba', );
      // final response2 = await mondayRepository.createUpdate('4244253964', 'Prueba desde Flutter', );
      
      final projects = await _jiraPlatformApi.projects.getAllProjects();
      emit(state.copyWith(
        status: JiraStatus.initSuccess,
        jiraPlatformApi: _jiraPlatformApi,
        projects: projects,
        selectedProject: projects.first,
      ));
    } on Exception catch (e) {
      emit(state.copyWith(
        status: JiraStatus.failure,
      ));
      throw Exception('Error: $e');
    }
  }

  // Future<void> _onTokenTextFieldOnChangedEvent(
  //     TokenTextFieldOnChangedEvent event, Emitter<JiraState> emit) async {
  //   emit(state.copyWith(atlassianApiToken: event.text));
  // }

  // Future<void> _onUserTextFieldOnChangedEvent(
  //     UserTextFieldOnChangedEvent event, Emitter<JiraState> emit) async {
  //   emit(state.copyWith(atlassianUser: event.text));
  // }

  // Future<void> _onUrlTextFieldOnChangedEvent(
  //     UrlTextFieldOnChangedEvent event, Emitter<JiraState> emit) async {
  //   emit(state.copyWith(atlassianUrlPrefix: event.text));
  // }

  // Future<void> _onInitialButtonTappedEvent(
  //     InitialButtonTappedEvent event, Emitter<JiraState> emit) async {
  //   emit(state.copyWith(
  //     materialAppHeight: 1000,
  //     materialAppWidth: 1000,
  //     status: JiraStatus.loading,
  //     reportDialogOpen: true,
  //   ));
  //   await Future.delayed(const Duration(seconds: 1));
  //   emit(state.copyWith(
  //     initialButtonHeight: 0,
  //     initialButtonWidth: 0,
  //     status: JiraStatus.fliraStarted,
  //   ));
  // }

  // Future<void> _onFliraTriggeredEvent(
  //     FliraTriggeredEvent event, Emitter<JiraState> emit) async {
  //   emit(state.copyWith(
  //     initialButtonWidth: 100,
  //     initialButtonHeight: 100,
  //     materialAppHeight: 100,
  //     materialAppWidth: 100,
  //   ));
  // }

  // Future<void> _onFliraButtonDraggedEvent(
  //     FliraButtonDraggedEvent event, Emitter<JiraState> emit) async {
  //   emit(state.copyWith(
  //     initialButtonWidth: 0,
  //     initialButtonHeight: 0,
  //     materialAppHeight: 0,
  //     materialAppWidth: 0,
  //     reportDialogOpen: false,
  //   ));
  // }

  Future<void> _onAddFileEvent(
      AddFileEvent event, Emitter<JiraState> emit) async {
    emit(state.copyWith(
      filePickerResult: event.filePickerResult,
    ));
  }

  // Future<void> _onAddCredentialsEvent(
  //     AddCredentialsEvent event, Emitter<JiraState> emit) async {
  //   Future.wait([
  //     storage.write(key: 'atlassianApiToken', value: state.atlassianApiToken),
  //     storage.write(key: 'atlassianUser', value: state.atlassianUser),
  //     storage.write(key: 'atlassianUrlPrefix', value: state.atlassianUrlPrefix),
  //   ]);
  //   emit(state.copyWith(
  //     atlassianApiToken: state.atlassianApiToken,
  //     atlassianUser: state.atlassianUser,
  //     atlassianUrlPrefix: state.atlassianUrlPrefix,
  //   ));
  // }

  // Future<void> _onLoadCredentialsFromStorageEvent(
  //     LoadCredentialsFromStorageEvent event, Emitter<JiraState> emit) async {
  //   final atlassianApiToken = await storage.read(key: 'atlassianApiToken');
  //   final atlassianUser = await storage.read(key: 'atlassianUser');
  //   final atlassianUrlPrefix = await storage.read(key: 'atlassianUrlPrefix');

  //   emit(state.copyWith(
  //     atlassianApiToken: atlassianApiToken,
  //     atlassianUser: atlassianUser,
  //     atlassianUrlPrefix: atlassianUrlPrefix,
  //   ));
  // }

  void _onChangeProjectRequested(
      ChangeProjectRequested event, Emitter<JiraState> emit) {
    emit(state.copyWith(
      selectedProject: event.project,
      issue: state.issue
          .copyWith(projectKey: event.project.key, project: event.project),
    ));
  }

  Future<void> _onSubmitIssueRequested(
      SubmitIssueRequested event, Emitter<JiraState> emit) async {
    try {
      emit(state.copyWith(
        status: JiraStatus.loading,
      ));
      final issue = state.issue;
      final send = await state.jiraPlatformApi?.issues
          .createIssue(
              body: IssueUpdateDetails(
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
                    "text": 'Reported using Flira\n\n${issue.description}',
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
          .catchError((onError) {
        throw Exception('Error: $onError');
      });
      if (state.attachment != const FilePickerResult([])) {
        final multiPartFile = await MultipartFile.fromPath(
          'file',
          state.attachment.paths.first!,
          filename: state.attachment.names.first!,
        );
        await state.jiraPlatformApi!.issueAttachments
            .addAttachment(issueIdOrKey: send!.id!, file: multiPartFile);
      }
      emit(state.copyWith(
          attachment: null,
          status: JiraStatus.ticketSubmittionSuccess,
          issue: FliraIssue.initial(
            projectKey: state.selectedProject.key,
            project: state.selectedProject,
          )));
    } on Exception catch (e) {
      emit(state.copyWith(
        status: JiraStatus.ticketSubmittionError,
        errorMessage: e.toString(),
      ));
    }
  }

  void _onSummaryChanged(SummaryChanged event, Emitter<JiraState> emit) {
    emit(state.copyWith(
      issue: state.issue.copyWith(name: event.summary),
    ));
  }

  void _onDescriptionChanged(
      DescriptionChanged event, Emitter<JiraState> emit) {
    emit(state.copyWith(
      issue: state.issue.copyWith(description: event.description),
    ));
  }
}
