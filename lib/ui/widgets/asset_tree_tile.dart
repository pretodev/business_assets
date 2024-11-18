import 'package:flutter/material.dart';

import '../../domain/commom/uid.dart';
import '../models/asset_tree_node.dart';

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
          const SizedBox(width: 4),
          switch (node) {
            AssetNodeModel(asset: final asset) => Text(asset.name),
            LocationNodeModel(location: final location) => Text(location.name),
          },
        ],
      ),
    );
  }
}
