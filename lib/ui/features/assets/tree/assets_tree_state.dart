import 'package:equatable/equatable.dart';

import '../../../../../core/domain/uid.dart';
import '../../../../core/domain/company_asset/company_asset.dart';
import '../../../../core/domain/company_location/company_location.dart';
import 'models/assets_tree_node_model.dart';

typedef AssetTreeFilter = bool Function(AssetsTreeNodeModel asset);

class AssetsTreeState extends Equatable {
  static final rootId = Uid.fromString('root');

  factory AssetsTreeState({
    required List<CompanyAsset> assets,
    required List<CompanyLocation> locations,
  }) {
    if (assets.isEmpty && locations.isEmpty) {
      return AssetsTreeState._();
    }

    final nodes = [
      ...locations.map(
        (location) => AssetsTreeNodeModel(resource: location),
      ),
      ...assets.map(
        (asset) => AssetsTreeNodeModel(resource: asset),
      ),
    ];

    final nodesMap = <Uid, List<AssetsTreeNodeModel>>{};
    for (final node in nodes) {
      final parentId = node.resource.parentId ?? rootId;
      if (!nodesMap.containsKey(parentId)) {
        nodesMap[parentId] = [];
      }
      nodesMap[parentId]?.add(node);
    }

    return AssetsTreeState._(
      nodesMap: nodesMap,
      expandedNodes: {rootId},
    );
  }

  AssetsTreeState._({
    this.filters = const [],
    this.expandedNodes = const {},
    Map<Uid, List<AssetsTreeNodeModel>> nodesMap = const {},
  })  : _nodesMap = nodesMap,
        _visibleNodes = [] {
    setVisibleNodes();
  }

  final Set<Uid> expandedNodes;
  final List<AssetTreeFilter> filters;
  List<AssetsTreeNodeModel> _visibleNodes;
  final Map<Uid, List<AssetsTreeNodeModel>> _nodesMap;

  List<AssetsTreeNodeModel> get visibleNodes => _visibleNodes;

  bool nodeHasChildren(Uid nodeId) {
    return _nodesMap.containsKey(nodeId) &&
        (_nodesMap[nodeId]?.isNotEmpty ?? false);
  }

  bool matchesFilter(AssetsTreeNodeModel node) {
    for (final filter in filters) {
      if (filter(node)) return true;
    }
    return false;
  }

  void setVisibleNodes([Uid? nodeId, int level = 0]) {
    for (final node in nodeChildren(nodeId ?? rootId)) {
      final expanded = expandedNodes.contains(node.resource.id);
      _visibleNodes.add(
        node.copyWith(level: level, expanded: expanded),
      );
      if (expanded) {
        setVisibleNodes(node.resource.id, level + 1);
      }
    }
  }

  List<AssetsTreeNodeModel> nodeChildren(Uid nodeId) {
    final children = _nodesMap[nodeId] ?? [];
    final filteredChildren = <AssetsTreeNodeModel>[];
    for (final child in children) {
      if (!matchesFilter(child)) {
        filteredChildren.add(child);
      } else if (nodeHasChildren(child.resource.id)) {
        final grandChildren = nodeChildren(child.resource.id);
        if (grandChildren.isNotEmpty) {
          filteredChildren.add(child);
        }
      }
    }
    return filteredChildren;
  }

  AssetsTreeState copyWith({
    Set<Uid>? expandedNodes,
    Map<Uid, List<AssetsTreeNodeModel>>? treeNodes,
    List<AssetTreeFilter>? filters,
    List<AssetsTreeNodeModel>? visibleNodes,
  }) {
    return AssetsTreeState._(
      expandedNodes: expandedNodes ?? this.expandedNodes,
      nodesMap: treeNodes ?? _nodesMap,
      filters: filters ?? this.filters,
    );
  }

  @override
  final stringify = true;

  @override
  List<Object?> get props => [expandedNodes, _nodesMap, filters];
}
