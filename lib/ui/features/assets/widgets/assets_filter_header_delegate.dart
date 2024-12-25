import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../app/widgets/switch_button.dart';

class AssetsFilterHeaderDelegate extends SliverPersistentHeaderDelegate {
  final TextEditingController searchController;
  final ValueChanged<bool> toggleEnergySensorFilter;
  final ValueChanged<bool> toggleAlertStatusFilter;
  final ValueChanged<bool> toggleExpandAll;

  AssetsFilterHeaderDelegate({
    required this.searchController,
    required this.toggleEnergySensorFilter,
    required this.toggleAlertStatusFilter,
    required this.toggleExpandAll,
  });

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final loc = AppLocalizations.of(context)!;
    return Container(
      height: maxExtent,
      padding: const EdgeInsets.all(16.0),
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Column(
        children: [
          TextField(
            controller: searchController,
            decoration: InputDecoration(
              hintText: loc.searchHint,
              prefixIcon: const Icon(Icons.search),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              SwitchButton(
                label: loc.energySensor,
                icon: Icons.bolt_outlined,
                onChanged: toggleEnergySensorFilter,
              ),
              const SizedBox(width: 8),
              SwitchButton(
                label: loc.critical,
                icon: Icons.error_outline_sharp,
                onChanged: toggleAlertStatusFilter,
              ),
              const Spacer(),
              SwitchButton(
                icon: Icons.expand_sharp,
                onChanged: toggleExpandAll,
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  double get maxExtent => 140.0;

  @override
  double get minExtent => 140.0;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      false;
}
