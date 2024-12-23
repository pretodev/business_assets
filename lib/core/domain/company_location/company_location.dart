import 'package:equatable/equatable.dart';

import '../uid.dart';

class CompanyLocation extends Equatable {
  final Uid id;
  final String name;
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
