import 'package:flutter/material.dart';

import '../../../../core/domain/company_asset/statuses.dart';
import '../../../widgets/app_icon.dart';

class StatusIcon extends StatelessWidget {
  const StatusIcon({super.key, required this.status});

  final Statuses? status;
  @override
  Widget build(BuildContext context) {
    if (status == null) return const SizedBox(width: 0);

    return switch (status!) {
      Statuses.operating => const AppIcon(name: 'bolt', size: 16),
      Statuses.alert => Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: const Color(0xFFED3833),
            borderRadius: BorderRadius.circular(22),
          ),
        ),
    };
  }
}
