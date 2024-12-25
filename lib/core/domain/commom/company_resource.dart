import '../uid.dart';

abstract interface class CompanyResource {
  Uid get id;
  String get name;
  Uid? get parentId;
}
