import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'asd_state.dart';

class AsdCubit extends Cubit<AsdState> {
  AsdCubit() : super(AsdInitial());
}
