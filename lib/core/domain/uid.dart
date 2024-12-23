import 'package:equatable/equatable.dart';

class Uid extends Equatable {
  final String value;

  const Uid._(this.value);

  factory Uid.fromString(String uid) {
    if (uid.isEmpty) {
      throw ArgumentError('UID cannot be empty');
    }
    return Uid._(uid);
  }

  @override
  String toString() {
    return value;
  }

  @override
  List<Object?> get props => [value];
}
