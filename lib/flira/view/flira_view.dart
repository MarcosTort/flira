import 'package:flutter/material.dart';
import 'package:flira/flira/flira.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FliraView extends StatelessWidget {
  const FliraView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FliraBloc, FliraState>(
      listenWhen: (previous, current) => current.status == FliraStatus.error,
      listener: (BuildContext context, FliraState state) {
        if (state.status == FliraStatus.error) {
          //handel error
        }
      },
      buildWhen: (previous, current) => current.status != previous.status,
      builder: (BuildContext context, FliraState state) {
        if(state.status == FliraStatus.initial){
          return Container();
        }
        return Container();
      },
    );
  }
}