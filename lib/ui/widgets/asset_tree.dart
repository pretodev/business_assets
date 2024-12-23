import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../core/domain/company_asset/company_asset.dart';
import '../../core/domain/company_asset/statuses.dart';
import '../../core/domain/company_location/company_location.dart';
import '../../core/domain/uid.dart';
import '../styles/styles.dart';
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

typedef AssetTreeFilter = bool Function(TreeNodeModel asset);

class AssetTreeValue extends Equatable {
  final Set<Uid> expandedNodes;
  final Map<Uid, List<TreeNodeModel>> treeNodes;
  final List<AssetTreeFilter> filters;

  const AssetTreeValue({
    this.expandedNodes = const {},
    this.treeNodes = const {},
    this.filters = const [],
  });

  @override
  List<Object?> get props => [expandedNodes, treeNodes, filters];

  AssetTreeValue copyWith({
    Set<Uid>? expandedNodes,
    Map<Uid, List<TreeNodeModel>>? treeNodes,
    List<AssetTreeFilter>? filters,
  }) {
    return AssetTreeValue(
      expandedNodes: expandedNodes ?? this.expandedNodes,
      treeNodes: treeNodes ?? this.treeNodes,
      filters: filters ?? this.filters,
    );
  }
}

class AssetTreeController extends ValueNotifier<AssetTreeValue> {
  AssetTreeController() : super(const AssetTreeValue());

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

class AssetTree extends StatefulWidget {
  const AssetTree({
    super.key,
    this.controller,
  });

  final AssetTreeController? controller;

  @override
  State<AssetTree> createState() => _AssetTreeState();
}

class _AssetTreeState extends State<AssetTree> {
  AssetTreeController? _controller;

  AssetTreeController get _effectiveController =>
      widget.controller ?? _controller!;

  List<Widget> _buildTree(Uid parentId, int level) {
    final List<Widget> widgets = [];
    for (final node in _effectiveController.childrenOf(parentId)) {
      final isExpanded = _effectiveController.isExpanded(node.id);
      widgets.add(
        AssetTreeTile(
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
    return SliverList(
      delegate: SliverChildListDelegate(
        _buildTree(rootId, 0),
      ),
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
        Flexible(
          child: Text(
            node.label,
            style: context.appTextStyles.bodyMedium.copyWith(
              color: context.appColors.textPrimary,
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
      Statuses.operating => const AppIcon(name: 'bolt', size: 16),
      Statuses.alert => Container(
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
