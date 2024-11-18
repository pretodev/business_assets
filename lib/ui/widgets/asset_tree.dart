import 'package:equatable/equatable.dart';
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

class AssetTreeValue extends Equatable {
  final Set<Uid> expandedNodes;
  final Map<Uid, List<TreeNodeModel>> treeNodes;

  const AssetTreeValue({
    this.expandedNodes = const {},
    this.treeNodes = const {},
  });

  @override
  List<Object?> get props => [expandedNodes, treeNodes];

  AssetTreeValue copyWith({
    Set<Uid>? expandedNodes,
    Map<Uid, List<TreeNodeModel>>? treeNodes,
  }) {
    return AssetTreeValue(
      expandedNodes: expandedNodes ?? this.expandedNodes,
      treeNodes: treeNodes ?? this.treeNodes,
    );
  }
}

class AssetTreeController extends ValueNotifier<AssetTreeValue> {
  AssetTreeController() : super(const AssetTreeValue());

  final rootId = Uid.fromString('root');

  Set<Uid> get expandedNodes => value.expandedNodes;

  Map<Uid, List<TreeNodeModel>> get treeNodes => value.treeNodes;

  List<TreeNodeModel> childrenIn(Uid parentId) {
    return value.treeNodes[parentId] ?? [];
  }

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
  late AssetTreeController _controller;

  List<Widget> _buildTree(Uid parentId, int level) {
    final List<Widget> widgets = [];
    for (final node in _controller.childrenIn(parentId)) {
      final isExpanded = _controller.isExpanded(node.id);
      widgets.add(
        AssetTreeTile(
          key: ValueKey(node.id.value),
          node: node,
          toggleExpansion: _controller.toggleExpansion,
          level: level,
          hasChildren: _controller.hasChildren(node.id),
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
    _controller = widget.controller ?? AssetTreeController();
    _controller.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final rootId = _controller.rootId;
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
