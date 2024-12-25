import 'package:flutter/material.dart';

import '../../../../../core/domain/company_asset/company_asset.dart';
import '../../../../app/styles/styles.dart';
import '../assets_tree_node_model.dart';
import 'asset_node_icon.dart';
import 'asset_status_icon.dart';
import 'asset_tree_vertical_line.dart';

class AssetNodeView extends StatelessWidget {
  const AssetNodeView({
    super.key,
    required this.node,
    required this.toggleExpansion,
  });

  final AssetsTreeNodeModel node;

  final VoidCallback toggleExpansion;

  @override
  Widget build(BuildContext context) {
    final Styles(:colors, :text) = context.styles;
    return Row(
      children: [
        Row(
          children: List.generate(
            node.level + 1,
            (index) => VerticalLine(level: index),
          ),
        ),
        Visibility(
          visible: node.hasChildren,
          replacement: const SizedBox(width: 24),
          child: GestureDetector(
            onTap: toggleExpansion,
            child: Icon(
              node.expanded ? Icons.expand_more : Icons.chevron_right,
            ),
          ),
        ),
        AssetNodeIcon(node: node),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            node.resource.name,
            style: text.bodyMedium.copyWith(
              color: colors.textPrimary,
            ),
          ),
        ),
        const SizedBox(width: 4),
        if (node.resource is CompanyAsset)
          AssetStatusIcon(status: (node.resource as CompanyAsset).status),
      ],
    );
  }
}
