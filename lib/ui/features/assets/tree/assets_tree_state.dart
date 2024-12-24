import 'package:equatable/equatable.dart';

import '../../../../../core/domain/uid.dart';
import '../../../../core/domain/company_asset/company_asset.dart';
import '../../../../core/domain/company_location/company_location.dart';
import 'models/assets_tree_node_model.dart';

typedef AssetTreeFilter = bool Function(AssetsTreeNodeModel asset);

class AssetsTreeState extends Equatable {
  static final rootId = Uid.fromString('root');

  /// Computa recursivamente todos os nós visíveis,
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

      // Adiciona o nó atual ao resultado com o nível de indentação e estado de expansão.
      result.add(node.copyWith(level: level, expanded: expanded));

      // Se o nó está expandido, acrescenta recursivamente os filhos dele.
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

  /// Retorna os filhos de [nodeId], caso não sejam filtrados ou se tiverem subfilhos.
  static List<AssetsTreeNodeModel> _computeChildren(
    Uid nodeId,
    Map<Uid, List<AssetsTreeNodeModel>> nodesMap,
    List<AssetTreeFilter> filters,
  ) {
    final children = nodesMap[nodeId] ?? [];
    final filteredChildren = <AssetsTreeNodeModel>[];

    for (final child in children) {
      // Se o nó não foi filtrado, adiciona na lista;
      // caso tenha sido filtrado, só adiciona se ele tiver filhos que passam no filtro.
      if (!_matchesAnyFilter(child, filters)) {
        filteredChildren.add(child);
      } else {
        // Se o próprio nó é filtrado, mas possui filhos que não são, exibe o nó em prol dos filhos.
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

  /// Construtor de fábrica que constrói o estado inicial a partir de listas de
  /// [assets] e [locations].
  factory AssetsTreeState({
    required List<CompanyAsset> assets,
    required List<CompanyLocation> locations,
  }) {
    // Se não há ativos nem locais, retorna um estado vazio.
    if (assets.isEmpty && locations.isEmpty) {
      return const AssetsTreeState._(
        expandedNodes: {},
        filters: [],
        nodesMap: {},
        visibleNodes: [],
      );
    }

    // Cria a lista de nós a partir de `assets` e `locations`.
    final nodes = [
      ...locations.map((loc) => AssetsTreeNodeModel(resource: loc)),
      ...assets.map((asset) => AssetsTreeNodeModel(resource: asset)),
    ];

    // Monta o mapa de nós, agrupando nós-filhos pelos IDs de seus pais.
    final nodesMap = <Uid, List<AssetsTreeNodeModel>>{};
    for (final node in nodes) {
      final parentId = node.resource.parentId ?? rootId;
      nodesMap.putIfAbsent(parentId, () => []).add(node);
    }

    // Nós expandidos por padrão (ex.: apenas a raiz).
    final expandedNodes = {rootId};

    // Nenhum filtro por padrão.
    final filters = <AssetTreeFilter>[];

    // Calcula a lista de nós visíveis (já levando em conta filtros e expansões).
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

  /// Construtor privado imutável, recebendo todos os campos já prontos.
  const AssetsTreeState._({
    required this.expandedNodes,
    required this.filters,
    required Map<Uid, List<AssetsTreeNodeModel>> nodesMap,
    required this.visibleNodes,
  }) : _nodesMap = nodesMap;

  /// Nó(s) que estão expandidos na árvore.
  final Set<Uid> expandedNodes;

  /// Lista de filtros para a árvore.
  final List<AssetTreeFilter> filters;

  /// Lista de nós visíveis, calculada de acordo com `expandedNodes`, `filters` e `_nodesMap`.
  final List<AssetsTreeNodeModel> visibleNodes;

  /// Mapa principal que agrupa cada nó pela chave de seu nó-pai.
  final Map<Uid, List<AssetsTreeNodeModel>> _nodesMap;

  /// Retorna um novo estado com possíveis modificações.
  AssetsTreeState copyWith({
    Set<Uid>? expandedNodes,
    Map<Uid, List<AssetsTreeNodeModel>>? treeNodes,
    List<AssetTreeFilter>? filters,
  }) {
    final newExpandedNodes = expandedNodes ?? this.expandedNodes;
    final newNodesMap = treeNodes ?? _nodesMap;
    final newFilters = filters ?? this.filters;

    // Sempre recalcula `visibleNodes` para manter a coerência do estado.
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
