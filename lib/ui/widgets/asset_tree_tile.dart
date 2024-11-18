import 'package:flutter/material.dart';

import '../../domain/commom/uid.dart';
import '../../domain/company_asset/statuses.dart';
import '../models/asset_tree_node.dart';
import 'app_icon.dart';

class AssetTreeTile extends StatelessWidget {
  const AssetTreeTile({
    super.key,
    required this.node,
    required this.toggleExpansion,
    this.level = 0,
    this.hasChildren = false,
    this.isExpanded = false,
  });

  final TreeNodeModel node;
  final int level;
  final bool hasChildren;
  final bool isExpanded;
  final void Function(Uid) toggleExpansion;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          SizedBox(width: level * 16),
          Visibility(
            visible: hasChildren,
            replacement: const SizedBox(width: 24),
            child: GestureDetector(
              child: Icon(
                isExpanded ? Icons.expand_less : Icons.expand_more,
              ),
              onTap: () => toggleExpansion(node.id),
            ),
          ),
          switch (node) {
            AssetNodeModel(asset: final asset) =>
              AppIcon(name: asset.isComponent ? 'codepen' : 'cube', size: 22),
            LocationNodeModel() => const AppIcon(name: 'location', size: 22),
          },
          const SizedBox(width: 4),
          Text(node.label),
          const SizedBox(width: 4),
          switch (node) {
            AssetNodeModel(asset: final asset) =>
              StatusIcon(status: asset.status),
            LocationNodeModel() => const SizedBox(width: 0),
          },
        ],
      ),
    );
  }
}

class NodeIcon extends StatelessWidget {
  const NodeIcon({super.key, required this.node});

  final TreeNodeModel node;

  @override
  Widget build(BuildContext context) {
    return switch (node) {
      AssetNodeModel(asset: final asset) when asset.isComponent =>
        const AppIcon(
          name: 'codepen',
          size: 22,
        ),
      AssetNodeModel() => const AppIcon(
          name: 'cube',
          size: 22,
        ),
      LocationNodeModel() => const AppIcon(
          name: 'location',
          size: 22,
        ),
    };
  }
}

class StatusIcon extends StatelessWidget {
  const StatusIcon({super.key, required this.status});

  final Statuses? status;
  @override
  Widget build(BuildContext context) {
    if (status == null) return const SizedBox(width: 0);

    return switch (status!) {
      Statuses.alert => const AppIcon(name: 'bolt', size: 16),
      Statuses.operating => Container(
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
