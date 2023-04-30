part of 'flira_bloc.dart';

@immutable
abstract class JiraEvent {
  const JiraEvent();
  List<Object?> get props => [];
}
class InitJiraRequested extends JiraEvent {
  const InitJiraRequested();

  @override
  List<Object?> get props => [];
}


class AddFileEvent extends JiraEvent {
  const AddFileEvent(this.filePickerResult);
  final FilePickerResult? filePickerResult;

  @override
  List<Object?> get props => [filePickerResult];
}



class SubmitIssueRequested extends JiraEvent {
  const SubmitIssueRequested();

  @override
  List<Object?> get props => [];
}

class ChangeProjectRequested extends JiraEvent {
  const ChangeProjectRequested(this.project);

  final Project project;

  @override
  List<Object?> get props => [project];
}

class SummaryChanged extends JiraEvent {
  const SummaryChanged(this.summary);

  final String summary;

  @override
  List<Object?> get props => [summary];
}

class DescriptionChanged extends JiraEvent {
  const DescriptionChanged(this.description);

  final String description;

  @override
  List<Object?> get props => [description];
}

class IssueTypeChanged extends JiraEvent {
  const IssueTypeChanged(this.issueType);

  final String issueType;

  @override
  List<Object?> get props => [issueType];
}

class AttachmentChanged extends JiraEvent {
  const AttachmentChanged(this.attachment);

  final FilePickerResult attachment;

  @override
  List<Object?> get props => [attachment];
}
