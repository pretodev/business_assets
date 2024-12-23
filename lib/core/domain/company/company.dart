import 'package:equatable/equatable.dart';

import '../uid.dart';

class Company extends Equatable {
  final Uid id;
  final String name;

  const Company({required this.id, required this.name});

  @override
  final stringify = true;

  @override
  List<Object?> get props => [id, name];
}
