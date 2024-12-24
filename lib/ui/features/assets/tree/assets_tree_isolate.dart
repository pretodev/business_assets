import 'dart:isolate';

import '../../../../core/domain/company_asset/company_asset.dart';
import '../../../../core/domain/company_location/company_location.dart';
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
      }
    });
  }
}
