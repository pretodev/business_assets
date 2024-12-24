import 'dart:isolate';

import '../../../../core/domain/company_asset/company_asset.dart';
import '../../../../core/domain/company_location/company_location.dart';
import '../../../../core/domain/uid.dart';
import '../../assets/models/tree_node_model.dart';
import '../../assets/widgets/tree/asset_tree_state.dart';

class AssetsTreeIsolates {
  static void _logic(SendPort sendPort) {
    final receivePort = ReceivePort();
    sendPort.send(receivePort.sendPort);
    receivePort.listen((message) async {
      if (message is BuildAssetsTreeMessage) {
        _buildTree(message, sendPort);
      }
    });
  }

  static Future<void> _buildTree(
    BuildAssetsTreeMessage message,
    SendPort sendPort,
  ) async {
    final rootId = Uid.fromString('root');
    final treeNodes = <Uid, List<TreeNodeModel>>{};
    final nodes = [
      ...message.locations.map(TreeNodeModel.fromCompanyLocation),
      ...message.assets.map(TreeNodeModel.fromCompanyAsset),
    ];

    for (final node in nodes) {
      final parentId = node.parentId ?? rootId;
      if (!treeNodes.containsKey(parentId)) {
        treeNodes[parentId] = [];
      }
      treeNodes[parentId]?.add(node);
    }

    sendPort.send(
      AssetTreeState(
        treeNodes: treeNodes,
        expandedNodes: {},
        filters: [],
      ),
    );
  }

  AssetsTreeIsolates() {
    _initialize();
  }

  late Isolate _isolate;

  late SendPort _send;
  late ReceivePort _receive;

  void buildTree({
    List<CompanyLocation> locations = const [],
    List<CompanyAsset> assets = const [],
  }) {
    _execute(BuildAssetsTreeMessage(locations: locations, assets: assets));
  }

  void dispose() {
    _isolate.kill();
    _receive.close();
  }

  void _initialize() async {
    _receive = ReceivePort();
    _isolate = await Isolate.spawn(_logic, _receive.sendPort);
    _send = await _receive.first;
  }

  Future<void> _execute(AssetsTreeMessage message) async {
    final responsePort = ReceivePort();
    _send.send([message, responsePort.sendPort]);
    return responsePort.first;
  }
}

sealed class AssetsTreeMessage {
  const AssetsTreeMessage();
}

class BuildAssetsTreeMessage extends AssetsTreeMessage {
  const BuildAssetsTreeMessage({
    required this.assets,
    required this.locations,
  });

  final List<CompanyLocation> locations;
  final List<CompanyAsset> assets;
}
