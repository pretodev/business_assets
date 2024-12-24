import 'package:equatable/equatable.dart';

import '../../../../../core/domain/uid.dart';
import 'tree_node_model.dart';

typedef AssetTreeFilter = bool Function(TreeNodeModel asset);

class AssetsTreeState extends Equatable {
  final Set<Uid> expandedNodes;
  final Map<Uid, List<TreeNodeModel>> treeNodes;
  final List<AssetTreeFilter> filters;

  const AssetsTreeState({
    this.expandedNodes = const {},
    this.treeNodes = const {},
    this.filters = const [],
  });

  @override
  List<Object?> get props => [expandedNodes, treeNodes, filters];

  AssetsTreeState copyWith({
    Set<Uid>? expandedNodes,
    Map<Uid, List<TreeNodeModel>>? treeNodes,
    List<AssetTreeFilter>? filters,
  }) {
    return AssetsTreeState(
      expandedNodes: expandedNodes ?? this.expandedNodes,
      treeNodes: treeNodes ?? this.treeNodes,
      filters: filters ?? this.filters,
    );
  }
}
