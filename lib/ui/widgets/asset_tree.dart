import 'package:flutter/material.dart';

import '../../domain/commom/uid.dart';
import '../../domain/company_asset/company_asset.dart';
import '../../domain/company_asset/statuses.dart';
import '../../domain/company_location/company_location.dart';
import 'app_icon.dart';

sealed class TreeNodeModel {
  factory TreeNodeModel.fromCompanyAsset(CompanyAsset asset) = AssetNodeModel;

  factory TreeNodeModel.fromCompanyLocation(CompanyLocation location) =
      LocationNodeModel;

  TreeNodeModel({
    required this.id,
    this.parentId,
    this.label = '',
  });

  final Uid id;
  final Uid? parentId;
  final String label;

  @override
  String toString() => 'AssetTreeNodeModel(id: $id)';
}

class AssetNodeModel extends TreeNodeModel {
  final CompanyAsset asset;

  AssetNodeModel(this.asset)
      : super(
          id: asset.id,
          parentId: asset.parentId ?? asset.locationId,
          label: asset.name,
        );
}

class LocationNodeModel extends TreeNodeModel {
  final CompanyLocation location;

  LocationNodeModel(this.location)
      : super(
          id: location.id,
          parentId: location.parentId,
          label: location.name,
        );
}

class AssetTree extends StatefulWidget {
  const AssetTree({
    super.key,
    required this.nodes,
  });

  final List<TreeNodeModel> nodes;

  @override
  State<AssetTree> createState() => _AssetTreeState();
}

class _AssetTreeState extends State<AssetTree> {
  final Set<Uid> _expandedNodes = {};
  final rootId = Uid.fromString('root');
  final Map<Uid, List<TreeNodeModel>> _treeNodes = {};

  bool _hasChildren(Uid id) {
    return _treeNodes.containsKey(id) && (_treeNodes[id]?.isNotEmpty ?? false);
  }

  void _toggleExpansion(Uid nodeId) {
    if (_expandedNodes.contains(nodeId)) {
      _expandedNodes.remove(nodeId);
    } else {
      _expandedNodes.add(nodeId);
    }
    setState(() {});
  }

  List<Widget> _buildTree(Uid parentId, int level) {
    final List<Widget> widgets = [];
    final children = _treeNodes[parentId] ?? [];
    for (final node in children) {
      final isExpanded = _expandedNodes.contains(node.id);
      widgets.add(
        AssetTreeTile(
          node: node,
          toggleExpansion: _toggleExpansion,
          level: level,
          hasChildren: _hasChildren(node.id),
          isExpanded: isExpanded,
        ),
      );
      if (isExpanded) {
        widgets.addAll(_buildTree(node.id, level + 1));
      }
    }

    return widgets;
  }

  @override
  void initState() {
    super.initState();
    for (final node in widget.nodes) {
      final parentId = node.parentId ?? rootId;
      if (!_treeNodes.containsKey(parentId)) {
        _treeNodes[parentId] = [];
      }
      _treeNodes[parentId]?.add(node);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: _buildTree(rootId, 0),
    );
  }
}

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
        Text(node.label),
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

class VerticalLine extends StatelessWidget {
  const VerticalLine({super.key, required this.level});

  final int level;

  @override
  Widget build(BuildContext context) {
    if (level == 0) return const SizedBox(width: 0);
    return SizedBox(
      width: 24.0,
      height: 24.0,
      child: Center(
        child: Container(
          width: 1,
          height: 24,
          alignment: Alignment.center,
          color: Colors.grey[300],
        ),
      ),
    );
  }
}
