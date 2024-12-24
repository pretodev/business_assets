import 'package:flutter/widgets.dart';

import '../../../widgets/app_icon.dart';
import '../models/tree_node_model.dart';

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
