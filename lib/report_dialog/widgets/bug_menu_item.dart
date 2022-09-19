import 'package:flutter/material.dart';

class BugMenuItem extends StatelessWidget {
  const BugMenuItem({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(2),
          ),
          child: const Icon(
            Icons.circle,
            color: Colors.white,
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