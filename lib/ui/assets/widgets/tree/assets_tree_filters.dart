import '../../../../core/domain/company_asset/company_asset.dart';
import '../../../../core/domain/company_asset/sensor_types.dart';
import '../../../../core/domain/company_asset/statuses.dart';
import 'assets_tree_node_model.dart';

typedef AssetsTreeFilterFunc = bool Function(AssetsTreeNodeModel asset);

class AssetsTreeFilters {
  static AssetsTreeFilters empty = AssetsTreeFilters();

  AssetsTreeFilters({
    String? name,
    SensorTypes? sensorType,
    Statuses? status,
  }) : filters = [] {
    if (name != null && name.isNotEmpty) {
      filters.add(_filterName(name));
    }
    if (sensorType != null) {
      filters.add(_filterSensor(sensorType));
    }
    if (status != null) {
      filters.add(_filterStatus(status));
    }
  }

  final List<AssetsTreeFilterFunc> filters;

  bool matches(AssetsTreeNodeModel node) {
    for (final filter in filters) {
      if (filter(node)) return true;
    }
    return false;
  }

  AssetsTreeFilterFunc _filterName(String name) {
    return (AssetsTreeNodeModel node) {
      return !node.resource.name.toLowerCase().contains(name.toLowerCase());
    };
  }

  AssetsTreeFilterFunc _filterStatus(Statuses status) {
    return (AssetsTreeNodeModel node) {
      if (node.resource is! CompanyAsset) return true;
      final asset = node.resource as CompanyAsset;
      return asset.status != status;
    };
  }

  AssetsTreeFilterFunc _filterSensor(SensorTypes sensorType) {
    return (AssetsTreeNodeModel node) {
      if (node.resource is! CompanyAsset) return true;
      final asset = node.resource as CompanyAsset;
      return asset.sensorType != sensorType;
    };
  }
}
