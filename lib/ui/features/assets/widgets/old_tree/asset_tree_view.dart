import 'package:flutter/material.dart';

import '../../../../../core/domain/company_asset/company_asset.dart';
import '../../../../../core/domain/company_location/company_location.dart';
import '../../../../../core/domain/uid.dart';
import '../asset_node_view.dart';
import 'asset_tree_state.dart';
import 'tree_node_model.dart';

class AssetTreeController extends ValueNotifier<AssetsTreeState> {
  AssetTreeController() : super(const AssetsTreeState());

  final rootId = Uid.fromString('root');

  bool _matchesFilter(TreeNodeModel node) {
    for (final filter in value.filters) {
      if (filter(node)) return true;
    }
    return false;
  }

  Set<Uid> get expandedNodes => value.expandedNodes;

  Map<Uid, List<TreeNodeModel>> get treeNodes => value.treeNodes;

  bool isExpanded(Uid nodeId) {
    return value.expandedNodes.contains(nodeId);
  }

  void load({
    List<CompanyLocation> locations = const [],
    List<CompanyAsset> assets = const [],
  }) {
    final treeNodes = <Uid, List<TreeNodeModel>>{};
    final nodes = [
      ...locations.map(TreeNodeModel.fromCompanyLocation),
      ...assets.map(TreeNodeModel.fromCompanyAsset),
    ];
    value = value.copyWith(
      treeNodes: {},
      expandedNodes: {},
    );
    for (final node in nodes) {
      final parentId = node.parentId ?? rootId;
      if (!treeNodes.containsKey(parentId)) {
        treeNodes[parentId] = [];
      }
      treeNodes[parentId]?.add(node);
    }
    value = value.copyWith(
      treeNodes: treeNodes,
      expandedNodes: {},
    );
  }

  bool hasChildren(Uid id) {
    return value.treeNodes.containsKey(id) &&
        (value.treeNodes[id]?.isNotEmpty ?? false);
  }

  void toggleExpansion(Uid nodeId) {
    if (value.expandedNodes.contains(nodeId)) {
      value.expandedNodes.remove(nodeId);
    } else {
      value.expandedNodes.add(nodeId);
    }
    notifyListeners();
  }

  void addFilter(AssetTreeFilter filter) {
    value = value.copyWith(filters: [...value.filters, filter]);
  }

  void removeFilter(AssetTreeFilter filter) {
    value = value.copyWith(
      filters: value.filters.where((f) => f != filter).toList(),
    );
  }

  void expandAll() {
    final allNodeIds = <Uid>{};
    void collectNodeIds(Uid parentId) {
      for (final child in childrenOf(parentId)) {
        allNodeIds.add(child.id);
        if (hasChildren(child.id)) {
          collectNodeIds(child.id);
        }
      }
    }

    collectNodeIds(rootId);
    value = value.copyWith(expandedNodes: allNodeIds);
  }

  void collapseAll() {
    value = value.copyWith(expandedNodes: {});
  }

  List<TreeNodeModel> childrenOf(Uid parentId) {
    final children = value.treeNodes[parentId] ?? [];
    final filteredChildren = <TreeNodeModel>[];
    for (final child in children) {
      if (!_matchesFilter(child)) {
        filteredChildren.add(child);
      } else if (hasChildren(child.id)) {
        final grandChildren = childrenOf(child.id);
        if (grandChildren.isNotEmpty) {
          filteredChildren.add(child);
        }
      }
    }
    return filteredChildren;
  }
}

class AssetTreeView extends StatefulWidget {
  const AssetTreeView({
    super.key,
    this.controller,
  });

  final AssetTreeController? controller;

  @override
  State<AssetTreeView> createState() => _AssetTreeViewState();
}

class _AssetTreeViewState extends State<AssetTreeView> {
  AssetTreeController? _controller;

  AssetTreeController get _effectiveController =>
      widget.controller ?? _controller!;

  List<Widget> _buildTree(Uid parentId, int level) {
    final List<Widget> widgets = [];
    for (final node in _effectiveController.childrenOf(parentId)) {
      final isExpanded = _effectiveController.isExpanded(node.id);
      widgets.add(
        AssetNodeView(
          key: ValueKey(node.id.value),
          node: node,
          toggleExpansion: _effectiveController.toggleExpansion,
          level: level,
          hasChildren: _effectiveController.hasChildren(node.id),
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
    if (widget.controller == null) {
      _controller = AssetTreeController();
    }
    _effectiveController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final rootId = _effectiveController.rootId;
    return SliverList.builder(
      itemBuilder: (context, index) {
        final nodes = _buildTree(rootId, 0);
        return nodes[index];
      },
      itemCount: _effectiveController.childrenOf(rootId).length,
    );
  }
}
