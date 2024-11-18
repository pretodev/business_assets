import 'package:flutter/material.dart';

import '../../domain/commom/uid.dart';
import '../models/asset_tree_node.dart';
import 'asset_tree_tile.dart';

class AssetTree extends StatefulWidget {
  const AssetTree({
    super.key,
    required this.nodes,
  });

  final List<AssetTreeNodeModel> nodes;

  @override
  State<AssetTree> createState() => _AssetTreeState();
}

class _AssetTreeState extends State<AssetTree> {
  final Set<Uid> _expandedNodes = {};
  final rootId = Uid.fromString('root');
  final Map<Uid, List<AssetTreeNodeModel>> _treeNodes = {};

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
