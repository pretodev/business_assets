import 'package:equatable/equatable.dart';

import '../commom/uid.dart';

class CompanyLocation extends Equatable {
  final Uid id;
  final String name;

  const CompanyLocation({
    required this.id,
    required this.name,
  });

  @override
  final stringify = true;

  @override
  List<Object?> get props => [id, name];
}
