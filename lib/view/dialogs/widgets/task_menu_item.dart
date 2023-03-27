import 'package:flutter/material.dart';

class TaskMenuItem extends StatelessWidget {
  const TaskMenuItem({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary,
            borderRadius: BorderRadius.circular(2),
          ),
          child:  Icon(
            Icons.check,
            color: theme.colorScheme.secondary,
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
