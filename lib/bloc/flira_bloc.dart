import 'package:bloc/bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../flira.dart';
part 'flira_event.dart';
part 'flira_state.dart';

class FliraBloc extends Bloc<FliraEvent, FliraState> {
  FliraBloc() : super(const FliraState.initial()) {
    on<InitialButtonTappedEvent>(_onInitialButtonTappedEvent);
    on<FliraTriggeredEvent>(_onFliraTriggeredEvent);
    on<FliraButtonDraggedEvent>(_onFliraButtonDraggedEvent);
    on<AddFileEvent>(_onAddFileEvent);
    on<AddCredentialsEvent>(_onAddCredentialsEvent);
    on<TokenTextFieldOnChangedEvent>(_onTokenTextFieldOnChangedEvent);
    on<UserTextFieldOnChangedEvent>(_onUserTextFieldOnChangedEvent);
    on<UrlTextFieldOnChangedEvent>(_onUrlTextFieldOnChangedEvent);
    on<LoadCredentialsFromStorageEvent>(_onLoadCredentialsFromStorageEvent);
  }
  final storage = const FlutterSecureStorage();

  Future<void> _onTokenTextFieldOnChangedEvent(
      TokenTextFieldOnChangedEvent event, Emitter<FliraState> emit) async {
    emit(state.copyWith(atlassianApiToken: event.text));
  }

  Future<void> _onUserTextFieldOnChangedEvent(
      UserTextFieldOnChangedEvent event, Emitter<FliraState> emit) async {
    emit(state.copyWith(atlassianUser: event.text));
  }

  Future<void> _onUrlTextFieldOnChangedEvent(
      UrlTextFieldOnChangedEvent event, Emitter<FliraState> emit) async {
    emit(state.copyWith(atlassianUrlPrefix: event.text));
  }

  Future<void> _onInitialButtonTappedEvent(
      InitialButtonTappedEvent event, Emitter<FliraState> emit) async {
    emit(state.copyWith(
      materialAppHeight: 1000,
      materialAppWidth: 1000,
      status: FliraStatus.loading,
      reportDialogOpen: true,
    ));
    await Future.delayed(const Duration(seconds: 1));
    emit(state.copyWith(
      initialButtonHeight: 0,
      initialButtonWidth: 0,
      status: FliraStatus.initial,
    ));
  }

  Future<void> _onFliraTriggeredEvent(
      FliraTriggeredEvent event, Emitter<FliraState> emit) async {
    emit(state.copyWith(
      initialButtonWidth: 100,
      initialButtonHeight: 100,
      materialAppHeight: 100,
      materialAppWidth: 100,
    ));
  }

  Future<void> _onFliraButtonDraggedEvent(
      FliraButtonDraggedEvent event, Emitter<FliraState> emit) async {
    emit(state.copyWith(
      initialButtonWidth: 0,
      initialButtonHeight: 0,
      materialAppHeight: 0,
      materialAppWidth: 0,
      reportDialogOpen: false,
    ));
  }

  Future<void> _onAddFileEvent(
      AddFileEvent event, Emitter<FliraState> emit) async {
    emit(state.copyWith(
      filePickerResult: event.filePickerResult,
    ));
  }

  Future<void> _onAddCredentialsEvent(
      AddCredentialsEvent event, Emitter<FliraState> emit) async {
    Future.wait([
      storage.write(key: 'atlassianApiToken', value: state.atlassianApiToken),
      storage.write(key: 'atlassianUser', value: state.atlassianUser),
      storage.write(key: 'atlassianUrlPrefix', value: state.atlassianUrlPrefix),
    ]);
    emit(state.copyWith(
      atlassianApiToken: state.atlassianApiToken,
      atlassianUser: state.atlassianUser,
      atlassianUrlPrefix: state.atlassianUrlPrefix,
    ));
  }

  Future<void> _onLoadCredentialsFromStorageEvent(
      LoadCredentialsFromStorageEvent event, Emitter<FliraState> emit) async {
    final atlassianApiToken = await storage.read(key: 'atlassianApiToken');
    final atlassianUser = await storage.read(key: 'atlassianUser');
    final atlassianUrlPrefix = await storage.read(key: 'atlassianUrlPrefix');

    emit(state.copyWith(
      atlassianApiToken: atlassianApiToken,
      atlassianUser: atlassianUser,
      atlassianUrlPrefix: atlassianUrlPrefix,
    ));
  }
}
