part of 'flira_bloc.dart';

@immutable
abstract class FliraEvent {
  const FliraEvent();
  List<Object?> get props => [];
}

class InitialButtonTappedEvent extends FliraEvent {
  @override
  List<Object?> get props => [];
}

class FliraTriggeredEvent extends FliraEvent {
  @override
  List<Object?> get props => [];
}

class FliraButtonDraggedEvent extends FliraEvent {
  @override
  List<Object?> get props => [];
}

class AddFileEvent extends FliraEvent {
  const AddFileEvent(this.filePickerResult);
  final FilePickerResult? filePickerResult;

  @override
  List<Object?> get props => [filePickerResult];
}

class AddCredentialsEvent extends FliraEvent {
  const AddCredentialsEvent();

  @override
  List<Object?> get props => [];
}

class TokenTextFieldOnChangedEvent extends FliraEvent {
  const TokenTextFieldOnChangedEvent(this.text);
  final String? text;

  @override
  List<Object?> get props => [text];
}

class UserTextFieldOnChangedEvent extends FliraEvent {
  const UserTextFieldOnChangedEvent(this.text);
  final String? text;

  @override
  List<Object?> get props => [text];
}

class UrlTextFieldOnChangedEvent extends FliraEvent {
  const UrlTextFieldOnChangedEvent(this.text);
  final String? text;

  @override
  List<Object?> get props => [text];
}

class LoadCredentialsFromStorageEvent extends FliraEvent {
  @override
  List<Object?> get props => [];
}

class InitJiraRequested extends FliraEvent {
  const InitJiraRequested(this.url, this.user, this.token);
  final String? url;
  final String? user;
  final String? token;

  @override
  List<Object?> get props => [url, user, token];
}
class SubmitIssueRequested extends FliraEvent {
  const SubmitIssueRequested();

  @override
  List<Object?> get props => [];
}
class ChangeProjectRequested extends FliraEvent {
  const ChangeProjectRequested(this.project);

  final Project project;

  @override
  List<Object?> get props => [project];
}
class SummaryChanged extends FliraEvent {
  const SummaryChanged(this.summary);

  final String summary;

  @override
  List<Object?> get props => [summary];
}
class DescriptionChanged extends FliraEvent {
  const DescriptionChanged(this.description);

  final String description;

  @override
  List<Object?> get props => [description];
}
class IssueTypeChanged extends FliraEvent {
  const IssueTypeChanged(this.issueType);

  final String issueType;

  @override
  List<Object?> get props => [issueType];
}
class AttachmentChanged extends FliraEvent {
  const AttachmentChanged(this.attachment);

  final FilePickerResult attachment;

  @override
  List<Object?> get props => [attachment];
}