import 'dart:isolate';

import 'package:flutter/material.dart';

import '../../../../core/domain/company_asset/company_asset.dart';
import '../../../../core/domain/company_location/company_location.dart';
import '../widgets/tree/asset_tree_state.dart';
import 'assets_tree_isolate.dart';
import 'models/assets_isolate_payload.dart';

class AssetsTreeController extends ChangeNotifier {
  AssetsTreeController() {
    _initialize();
  }

  Isolate? _isolate;
  SendPort? _sendPort;
  final _listenner = ReceivePort();

  AssetsTreeState? _tree;

  bool _treeDone = false;

  bool get isTreeDone => _treeDone;

  AssetsTreeState get tree {
    if (_tree == null) {
      throw Exception('Tree not built yet');
    }
    return _tree!;
  }

  void buildTree({
    List<CompanyLocation> locations = const [],
    List<CompanyAsset> assets = const [],
  }) {
    final message = BuildTreeIsolatePayload(
      locations: locations,
      assets: assets,
    );
    _sendPort?.send([_listenner.sendPort, message]);
  }

  @override
  void dispose() {
    _isolate?.kill();
    _isolate = null;
    _sendPort = null;
    super.dispose();
  }

  void _initialize() async {
    final receivePort = ReceivePort();
    _isolate = await Isolate.spawn(
      AssetsTreeIsolate.entryPoint,
      receivePort.sendPort,
    );
    _sendPort = await receivePort.first;
    _listenner.listen((tree) {
      _tree = tree as AssetsTreeState;
      _treeDone = true;
      notifyListeners();
    });
  }
}
