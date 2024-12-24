import 'dart:isolate';

import 'package:flutter/material.dart';

import '../../../../../core/domain/company_asset/company_asset.dart';
import '../../../../../core/domain/company_location/company_location.dart';
import 'assets_tree_isolate.dart';
import 'assets_tree_node_model.dart';
import 'assets_tree_state.dart';
import 'node/asset_node_view.dart';

class AssetsTreeView extends StatefulWidget {
  const AssetsTreeView({
    super.key,
    required this.locations,
    required this.assets,
  });

  final List<CompanyLocation> locations;
  final List<CompanyAsset> assets;

  @override
  State<AssetsTreeView> createState() => _AssetsTreeViewState();
}

class _AssetsTreeViewState extends State<AssetsTreeView> {
  Isolate? _isolate;
  SendPort? _sendPort;
  final _listenner = ReceivePort();

  bool _ready = false;
  AssetsTreeState _tree = AssetsTreeState(assets: [], locations: []);

  void _buildTree() async {
    final receivePort = ReceivePort();
    _isolate = await Isolate.spawn(
      AssetsTreeIsolate.entryPoint,
      receivePort.sendPort,
    );
    _sendPort = await receivePort.first;
    _listenner.listen((tree) {
      setState(() {
        _tree = tree as AssetsTreeState;
        _ready = true;
      });
    });
    _sendPort?.send(
      AssetsTreeIsolateMessage.create(
        sendPort: _listenner.sendPort,
        assets: widget.assets,
        locations: widget.locations,
      ),
    );
  }

  void _toggleExpansion(AssetsTreeNodeModel node) {
    if (node.expanded) {
      _sendPort?.send(
        AssetsTreeIsolateMessage.collapsed(
          sendPort: _listenner.sendPort,
          state: _tree,
          nodeId: node.resource.id,
        ),
      );
    } else {
      _sendPort?.send(
        AssetsTreeIsolateMessage.expand(
          sendPort: _listenner.sendPort,
          state: _tree,
          nodeId: node.resource.id,
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _buildTree();
  }

  @override
  void dispose() {
    _isolate?.kill();
    _isolate = null;
    _sendPort = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_ready) {
      return const SliverFillRemaining(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return SliverList.builder(
      itemBuilder: (context, index) {
        final node = _tree.visibleNodes[index];
        return AssetNodeView(
          node: node,
          toggleExpansion: () => _toggleExpansion(node),
        );
      },
      itemCount: _tree.visibleNodes.length,
    );
  }
}
