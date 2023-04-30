import 'package:flira/integrations/jira/bloc/flira_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ErrorDialog extends StatelessWidget {
  const ErrorDialog({
    super.key,
    required this.message,
  });
  final String message;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Error'),
      content: Text(message),
      actions: [
        TextButton(
            onPressed: () {
              context.read<JiraBloc>().add(FliraButtonDraggedEvent());
              Navigator.pop(context);
            },
            child: const Text('Ok'))
      ],
    );
  }

  void open(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => this,
    ).then((value) => context.read<JiraBloc>().add(FliraButtonDraggedEvent()));
  }
}
