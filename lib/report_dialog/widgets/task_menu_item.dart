import 'package:flutter/material.dart';

class TaskMenuItem extends StatelessWidget {
  const TaskMenuItem({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(2),
          ),
          child: const Icon(
            Icons.check,
            color: Colors.white,
            size: 15,
          ),
        ),
        const SizedBox(
          width: 16,
        ),
        const Text('Task'),
      ],
    );
  }
}
