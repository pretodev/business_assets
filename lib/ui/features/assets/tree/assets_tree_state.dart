import 'package:equatable/equatable.dart';

import '../../../../../core/domain/uid.dart';
import '../../../../core/domain/company_asset/company_asset.dart';
import '../../../../core/domain/company_location/company_location.dart';
import 'models/assets_tree_node_model.dart';

typedef AssetTreeFilter = bool Function(AssetsTreeNodeModel asset);

class AssetsTreeState extends Equatable {
  static final rootId = Uid.fromString('root');

  /// Recursively computes all visible nodes,
  /// respeitando a estrutura da árvore, filtros e nós expandidos.
  static List<AssetsTreeNodeModel> _computeVisibleNodes(
    Uid nodeId,
    int level,
    Set<Uid> expandedNodes,
    Map<Uid, List<AssetsTreeNodeModel>> nodesMap,
    List<AssetTreeFilter> filters,
  ) {
    final result = <AssetsTreeNodeModel>[];

    for (final node in _computeChildren(nodeId, nodesMap, filters)) {
      final expanded = expandedNodes.contains(node.resource.id);

      // Adds the current node to the result with the indentation level and expansion state.
      result.add(node.copyWith(level: level, expanded: expanded));

      // If the node is expanded, recursively add its children.
      if (expanded) {
        result.addAll(
          _computeVisibleNodes(
            node.resource.id,
            level + 1,
            expandedNodes,
            nodesMap,
            filters,
          ),
        );
      }
    }

    return result;
  }

  /// Returns the children of [nodeId], if they are not filtered or if they have subchildren.
  static List<AssetsTreeNodeModel> _computeChildren(
    Uid nodeId,
    Map<Uid, List<AssetsTreeNodeModel>> nodesMap,
    List<AssetTreeFilter> filters,
  ) {
    final children = nodesMap[nodeId] ?? [];
    final filteredChildren = <AssetsTreeNodeModel>[];

    for (final child in children) {
      // If the node was not filtered, add it to the list;
      // caso tenha sido filtrado, só adiciona se ele tiver filhos que passam no filtro.
      if (!_matchesAnyFilter(child, filters)) {
        filteredChildren.add(child);
      } else {
        // If the node itself is filtered, but has children that are not, display the node for the sake of the children.
        if (_hasChildren(child.resource.id, nodesMap) &&
            _computeChildren(child.resource.id, nodesMap, filters).isNotEmpty) {
          filteredChildren.add(child);
        }
      }
    }

    return filteredChildren;
  }

  /// Verifica se [node] corresponde a algum filtro.
  static bool _matchesAnyFilter(
    AssetsTreeNodeModel node,
    List<AssetTreeFilter> filters,
  ) {
    for (final filter in filters) {
      if (filter(node)) return true;
    }
    return false;
  }

  /// Verifica se [nodeId] tem filhos no mapa.
  static bool _hasChildren(
    Uid nodeId,
    Map<Uid, List<AssetsTreeNodeModel>> nodesMap,
  ) {
    return nodesMap.containsKey(nodeId) &&
        (nodesMap[nodeId]?.isNotEmpty ?? false);
  }

  /// Factory constructor that builds the initial state from lists of
  /// [assets] e [locations].
  factory AssetsTreeState({
    required List<CompanyAsset> assets,
    required List<CompanyLocation> locations,
  }) {
    // If there are no assets or locations, return an empty state.
    if (assets.isEmpty && locations.isEmpty) {
      return const AssetsTreeState._(
        expandedNodes: {},
        filters: [],
        nodesMap: {},
        visibleNodes: [],
      );
    }

    // Creates the list of nodes from `assets` and `locations`.
    final nodes = [
      ...locations.map((loc) => AssetsTreeNodeModel(resource: loc)),
      ...assets.map((asset) => AssetsTreeNodeModel(resource: asset)),
    ];

    // Builds the node map, grouping child nodes by their parent IDs.
    final nodesMap = <Uid, List<AssetsTreeNodeModel>>{};
    for (final node in nodes) {
      final parentId = node.resource.parentId ?? rootId;
      nodesMap.putIfAbsent(parentId, () => []).add(node);
    }

    // Nodes expanded by default (e.g., only the root).
    final expandedNodes = {rootId};

    // No filters by default.
    final filters = <AssetTreeFilter>[];

    // Calculates the list of visible nodes (already taking filters and expansions into account).
    final visibleNodes = _computeVisibleNodes(
      rootId,
      0,
      expandedNodes,
      nodesMap,
      filters,
    );

    return AssetsTreeState._(
      expandedNodes: expandedNodes,
      filters: filters,
      nodesMap: nodesMap,
      visibleNodes: visibleNodes,
    );
  }

  /// Private immutable constructor, receiving all fields already prepared.
  const AssetsTreeState._({
    required this.expandedNodes,
    required this.filters,
    required Map<Uid, List<AssetsTreeNodeModel>> nodesMap,
    required this.visibleNodes,
  }) : _nodesMap = nodesMap;

  /// Node(s) that are expanded in the tree.
  final Set<Uid> expandedNodes;

  /// List of filters for the tree.
  final List<AssetTreeFilter> filters;

  /// List of visible nodes, calculated according to `expandedNodes`, `filters`, and `_nodesMap`.
  final List<AssetsTreeNodeModel> visibleNodes;

  /// Main map that groups each node by the key of its parent node.
  final Map<Uid, List<AssetsTreeNodeModel>> _nodesMap;

  /// Returns a new state with possible modifications.
  AssetsTreeState copyWith({
    Set<Uid>? expandedNodes,
    Map<Uid, List<AssetsTreeNodeModel>>? treeNodes,
    List<AssetTreeFilter>? filters,
  }) {
    final newExpandedNodes = expandedNodes ?? this.expandedNodes;
    final newNodesMap = treeNodes ?? _nodesMap;
    final newFilters = filters ?? this.filters;

    // Always recalculates `visibleNodes` to maintain state consistency.
    final newVisibleNodes = _computeVisibleNodes(
      rootId,
      0,
      newExpandedNodes,
      newNodesMap,
      newFilters,
    );

    return AssetsTreeState._(
      expandedNodes: newExpandedNodes,
      filters: newFilters,
      nodesMap: newNodesMap,
      visibleNodes: newVisibleNodes,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [
        expandedNodes,
        filters,
        visibleNodes,
        _nodesMap,
      ];
}
