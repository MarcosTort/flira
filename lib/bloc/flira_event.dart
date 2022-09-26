part of 'flira_bloc.dart';

@immutable
abstract  class FliraEvent {
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
  const AddCredentialsEvent(this.atlassianApiToken, this.atlassianUser, this.atlassianUrlPrefix);
  final String? atlassianApiToken;
  final String? atlassianUser;
  final String? atlassianUrlPrefix;

  @override
  List<Object?> get props => [atlassianApiToken, atlassianUser, atlassianUrlPrefix];
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