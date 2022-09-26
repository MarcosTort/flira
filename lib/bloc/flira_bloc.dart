import 'package:bloc/bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

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
  }
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
    emit(state.copyWith(
      atlassianApiToken: event.atlassianApiToken,
      atlassianUser: event.atlassianUser,
      atlassianUrlPrefix: event.atlassianUrlPrefix,
    ));
  }
}
