import 'package:equatable/equatable.dart';

import '../commom/uid.dart';

class CompanyAsset extends Equatable {
  final Uid id;
  final String name;
  final Uid? locationId;
  final Uid? parentId;

  const CompanyAsset({
    required this.id,
    required this.name,
    this.locationId,
    this.parentId,
  });

  @override
  final stringify = true;

  @override
  List<Object?> get props => [id, name, locationId, parentId];
}
