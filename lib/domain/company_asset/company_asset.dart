import 'package:equatable/equatable.dart';

import '../commom/uid.dart';

class CompanyAsset extends Equatable {
  final Uid id;
  final String name;

  const CompanyAsset({
    required this.id,
    required this.name,
  });

  @override
  final stringify = true;

  @override
  List<Object?> get props => [id, name];
}
