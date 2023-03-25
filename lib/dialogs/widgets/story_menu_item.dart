import 'package:flutter/material.dart';

/// Dropdown menu item for Story issue type
class StoryMenuItem extends StatelessWidget {
  const StoryMenuItem({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.circular(2),
          ),
          child: const Icon(
            Icons.bookmark,
            color: Colors.white,
            size: 15,
          ),
        ),
        const SizedBox(
          width: 16,
        ),
        const Text('Story'),
      ],
    );
  }
}
