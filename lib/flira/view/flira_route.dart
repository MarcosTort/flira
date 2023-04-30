import 'package:flutter/material.dart';
import 'package:flira/flira/flira.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FliraRoute extends StatelessWidget {
  const FliraRoute({Key? key}) : super(key: key);

  static Route<void> route() {
    return MaterialPageRoute(
      builder: (ctx) {
        return BlocProvider(
          create: (_) => FliraBloc(),
          child: const FliraView(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return const FliraView();
  }
}