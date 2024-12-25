import 'package:flutter/widgets.dart';

import '../../../../../core/domain/company_asset/company_asset.dart';
import '../../../../../core/domain/company_location/company_location.dart';
import '../../../../app/widgets/app_icon.dart';
import '../assets_tree_node_model.dart';

class AssetNodeIcon extends StatelessWidget {
  const AssetNodeIcon({super.key, required this.node});

  final AssetsTreeNodeModel node;

  @override
  Widget build(BuildContext context) {
    if (node.resource is CompanyLocation) {
      return const AppIcon(
        name: 'location',
        size: 22,
      );
    }
    final asset = node.resource as CompanyAsset;
    return AppIcon(
      name: asset.isComponent ? 'codepen' : 'cube',
      size: 22,
    );
  }
}
