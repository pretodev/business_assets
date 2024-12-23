import 'package:equatable/equatable.dart';

import '../commom/uid.dart';
import 'sensor_types.dart';
import 'statuses.dart';

class CompanyAsset extends Equatable {
  final Uid id;
  final String name;
  final Uid? locationId;
  final Uid? parentId;
  final SensorTypes? sensorType;
  final Statuses? status;

  const CompanyAsset({
    required this.id,
    required this.name,
    this.locationId,
    this.parentId,
    this.sensorType,
    this.status,
  });

  bool get isComponent {
    return sensorType != null || status != null;
  }

  @override
  final stringify = true;

  @override
  List<Object?> get props => [
        id,
        name,
        locationId,
        parentId,
        sensorType,
        status,
      ];
}
