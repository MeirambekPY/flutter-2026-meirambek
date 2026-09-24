import 'package:flutter/material.dart';

import 'info_row.dart';
import 'data.dart';

class ProfileHeader extends StatelessWidget {
  final String name;
  final String university;

  const ProfileHeader({
    required this.name,
    required this.university,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const CircleAvatar(
          radius: 40,
          backgroundImage: AssetImage('assets/images/myPhoto.jpg'),
        ),
        const SizedBox(height: 8),
        Text(
          name,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          university,
          style: const TextStyle(fontSize: 16, color: Colors.grey),
        ),
        for (final fact in facts) InfoRow(label: fact.label, value: fact.value),
      ],
    );
  }
}