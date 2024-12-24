import 'package:equatable/equatable.dart';

import '../commom/company_resource.dart';
import '../uid.dart';
import 'sensor_types.dart';
import 'statuses.dart';

class CompanyAsset extends Equatable implements CompanyResource {
  @override
  final Uid id;
  @override
  final String name;
  @override
  final Uid? parentId;

  final Uid? locationId;
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
