import 'package:flutter/material.dart';

import '../../../../core/domain/uid.dart';
import '../../../styles/styles.dart';
import '../../../widgets/app_icon.dart';
import '../models/tree_node_model.dart';
import 'asset_status_icon.dart';
import 'asset_tree_vertical_line.dart';

class AssetNodeView extends StatelessWidget {
  const AssetNodeView({
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
    final Styles(:colors, :text) = context.styles;
    return Row(
      children: [
        Row(
          children:
              List.generate(level + 1, (index) => VerticalLine(level: index)),
        ),
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
        Flexible(
          child: Text(
            node.label,
            style: text.bodyMedium.copyWith(
              color: colors.textPrimary,
            ),
          ),
        ),
        const SizedBox(width: 4),
        switch (node) {
          AssetNodeModel(asset: final asset) =>
            StatusIcon(status: asset.status),
          LocationNodeModel() => const SizedBox(width: 0),
        },
      ],
    );
  }
}
