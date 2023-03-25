import 'package:flira/bloc/flira_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SuccessDialog extends StatelessWidget {
  const SuccessDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
                title: const Text('Success'),
                content: const Text('Do you want to create another ticket?'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Yes'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                      context.read<FliraBloc>().add(FliraButtonDraggedEvent());
                    },
                    child: const Text(
                      'No',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              );
  }
  void open(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => this,
    ).then((value) => context.read<FliraBloc>().add(FliraButtonDraggedEvent()));
  }
}