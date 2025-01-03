import 'dart:isolate';

import '../../../../core/domain/company_asset/company_asset.dart';
import '../../../../core/domain/company_location/company_location.dart';
import '../../../../core/domain/uid.dart';
import 'assets_tree_filters.dart';
import 'assets_tree_state.dart';

final class AssetsTreeIsolateMessage {
  const AssetsTreeIsolateMessage._({
    required this.sendPort,
    required this.payload,
  });

  final SendPort sendPort;
  final Map<String, dynamic> payload;

  AssetsTreeIsolateMessage.create({
    required SendPort sendPort,
    required List<CompanyAsset> assets,
    required List<CompanyLocation> locations,
  }) : this._(
          sendPort: sendPort,
          payload: {
            'type': 'create',
            'assets': assets,
            'locations': locations,
          },
        );

  AssetsTreeIsolateMessage.expand({
    required SendPort sendPort,
    required AssetsTreeState state,
    Uid? nodeId,
  }) : this._(
          sendPort: sendPort,
          payload: {
            'type': 'expand',
            'state': state,
            'nodeId': nodeId,
          },
        );

  AssetsTreeIsolateMessage.collapse({
    required SendPort sendPort,
    required AssetsTreeState state,
    Uid? nodeId,
  }) : this._(
          sendPort: sendPort,
          payload: {
            'type': 'collapsed',
            'state': state,
            'nodeId': nodeId,
          },
        );

  AssetsTreeIsolateMessage.refresh({
    required SendPort sendPort,
    required AssetsTreeState state,
    required AssetsTreeFilters filters,
  }) : this._(
          sendPort: sendPort,
          payload: {
            'type': 'refresh',
            'state': state,
            'filters': filters,
          },
        );
}

abstract class AssetsTreeIsolate {
  static void entryPoint(SendPort sendPort) {
    final receivePort = ReceivePort();
    sendPort.send(receivePort.sendPort);
    receivePort.listen((message) async {
      final AssetsTreeIsolateMessage(:sendPort, :payload) = message;
      switch (payload['type'] as String) {
        case 'create':
          final state = AssetsTreeState(
            assets: payload['assets'],
            locations: payload['locations'],
          );
          sendPort.send(state);
          break;
        case 'expand':
          final state = payload['state'] as AssetsTreeState;
          final nodeId = payload['nodeId'] as Uid?;
          final expandedNodes = state.expandedNodes;
          if (nodeId != null) {
            expandedNodes.add(nodeId);
          } else {
            expandedNodes.clear();
            expandedNodes.addAll(state.nodeIds);
          }
          final newState = state.copyWith(
            expandedNodes: expandedNodes,
          );
          sendPort.send(newState);
          break;
        case 'collapsed':
          final state = payload['state'] as AssetsTreeState;
          final nodeId = payload['nodeId'] as Uid?;
          final expandedNodes = state.expandedNodes;
          if (nodeId != null) {
            expandedNodes.remove(nodeId);
          } else {
            expandedNodes.clear();
          }
          final newState = state.copyWith(
            expandedNodes: expandedNodes,
          );
          sendPort.send(newState);
          break;
        case 'refresh':
          final state = payload['state'] as AssetsTreeState;
          final filters = payload['filters'] as AssetsTreeFilters;
          final newState = state.copyWith(filters: filters);
          sendPort.send(newState);
          break;
      }
    });
  }
}
