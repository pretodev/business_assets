import 'package:equatable/equatable.dart';

import '../../../../../core/domain/uid.dart';
import '../../models/tree_node_model.dart';

typedef AssetTreeFilter = bool Function(TreeNodeModel asset);

class AssetTreeState extends Equatable {
  final Set<Uid> expandedNodes;
  final Map<Uid, List<TreeNodeModel>> treeNodes;
  final List<AssetTreeFilter> filters;

  const AssetTreeState({
    this.expandedNodes = const {},
    this.treeNodes = const {},
    this.filters = const [],
  });

  @override
  List<Object?> get props => [expandedNodes, treeNodes, filters];

  AssetTreeState copyWith({
    Set<Uid>? expandedNodes,
    Map<Uid, List<TreeNodeModel>>? treeNodes,
    List<AssetTreeFilter>? filters,
  }) {
    return AssetTreeState(
      expandedNodes: expandedNodes ?? this.expandedNodes,
      treeNodes: treeNodes ?? this.treeNodes,
      filters: filters ?? this.filters,
    );
  }
}
