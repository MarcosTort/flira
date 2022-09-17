import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
part 'flira_event.dart';
part 'flira_state.dart';

class FliraBloc extends Bloc<FliraEvent, FliraState> {
  FliraBloc() : super(const FliraState.initial()) {
    on<InitialButtonTappedEvent>(_onInitialButtonTappedEvent);
    on<FliraTriggeredEvent>(_onFliraTriggeredEvent);
    on<FliraButtonDraggedEvent>(_onFliraButtonDraggedEvent);
  }
  Future<void> _onInitialButtonTappedEvent(
      InitialButtonTappedEvent event, Emitter<FliraState> emit) async {
    emit(state.copyWith(
      materialAppHeight: 1000,
      materialAppWidth: 1000,
    ));
  }

  Future<void> _onFliraTriggeredEvent(
      FliraTriggeredEvent event, Emitter<FliraState> emit) async {
    emit(state.copyWith(
      initialButtonWidth: 250,
      initialButtonHeight: 100,
      materialAppHeight: 100,
      materialAppWidth: 250,
      opacity: 16,
    ));
   
  }
  Future<void> _onFliraButtonDraggedEvent(
      FliraButtonDraggedEvent event, Emitter<FliraState> emit) async {
    emit(state.copyWith(
      initialButtonWidth: 0,
      initialButtonHeight: 100,
      materialAppHeight: 0,
      materialAppWidth: 0,
      opacity: 0.1,
    ));

   
  }
}