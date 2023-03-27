import 'package:flutter/material.dart';

class BugMenuItem extends StatelessWidget {
  const BugMenuItem({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: theme.colorScheme.error,
            borderRadius: BorderRadius.circular(2),
          ),
          child:  Icon(
            Icons.circle,
            color: theme.colorScheme.secondary,
            size: 10,
          ),
        ),
        const SizedBox(
          width: 16,
        ),
        const Text('Bug'),
      ],
    );
  }
}
