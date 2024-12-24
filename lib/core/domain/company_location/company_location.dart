import 'package:equatable/equatable.dart';

import '../commom/company_resource.dart';
import '../uid.dart';

class CompanyLocation extends Equatable implements CompanyResource {
  @override
  final Uid id;
  @override
  final String name;
  @override
  final Uid? parentId;

  const CompanyLocation({
    required this.id,
    required this.name,
    this.parentId,
  });

  @override
  final stringify = true;

  @override
  List<Object?> get props => [id, name, parentId];
}
