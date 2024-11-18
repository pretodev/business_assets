import 'package:flutter/material.dart';

import '../../config/application.dart';
import '../../domain/commom/uid.dart';
import '../../domain/company_asset/company_asset_repository.dart';
import '../../domain/company_asset/sensor_types.dart';
import '../../domain/company_asset/statuses.dart';
import '../../domain/company_location/company_location_repository.dart';
import '../widgets/asset_tree.dart';
import '../widgets/switch_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with ServiceLocatorMixin {
  late final assetRepository = instance<CompanyAssetRepository>();
  late final locationRepository = instance<CompanyLocationRepository>();

  final AssetTreeController _controller = AssetTreeController();
  final TextEditingController _searchController = TextEditingController();

  bool _filterByName(TreeNodeModel node) {
    final name = switch (node) {
      LocationNodeModel(location: final data) => data.name.toLowerCase(),
      AssetNodeModel(asset: final data) => data.name.toLowerCase(),
    };
    return !name.contains(_searchController.text.toLowerCase());
  }

  bool _filterOnlyAlertStatus(TreeNodeModel node) {
    return switch (node) {
      AssetNodeModel(asset: final data) when data.isComponent =>
        data.status != Statuses.alert,
      AssetNodeModel() => true,
      LocationNodeModel() => true,
    };
  }

  bool _filterOnlyEnergySensor(TreeNodeModel node) {
    return switch (node) {
      AssetNodeModel(asset: final data) when data.isComponent =>
        data.sensorType != SensorTypes.energy,
      AssetNodeModel() => true,
      LocationNodeModel() => true,
    };
  }

  void _toggleEnergySensorFilter(bool value) {
    if (value) {
      _controller.addFilter(_filterOnlyEnergySensor);
    } else {
      _controller.removeFilter(_filterOnlyEnergySensor);
    }
  }

  void _toggleAlertStatusFilter(bool value) {
    if (value) {
      _controller.addFilter(_filterOnlyAlertStatus);
    } else {
      _controller.removeFilter(_filterOnlyAlertStatus);
    }
  }

  void _toogleExpandAll(bool value) {
    if (value) {
      _controller.expandAll();
    } else {
      _controller.collapseAll();
    }
  }

  void _toggleNameFilter() {
    if (_searchController.text.isNotEmpty) {
      _controller.addFilter(_filterByName);
    } else {
      _controller.removeFilter(_filterByName);
    }
  }

  void _loadAssets() async {
    final companyId = Uid.fromString('662fd0fab3fd5656edb39af5');
    final assets = await assetRepository.fromCompany(companyId);
    final locations = await locationRepository.fromCompany(companyId);
    _controller.load(
      assets: assets,
      locations: locations,
    );
  }

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_toggleNameFilter);
    _loadAssets();
  }

  @override
  void dispose() {
    _controller.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverAppBar(
            title: Text('Assets'),
            centerTitle: true,
            pinned: true,
          ),
          SliverPersistentHeader(
            floating: false,
            pinned: false,
            delegate: _FilterHeaderDelegate(
              searchController: _searchController,
              toggleEnergySensorFilter: _toggleEnergySensorFilter,
              toggleAlertStatusFilter: _toggleAlertStatusFilter,
              toggleExpandAll: _toogleExpandAll,
            ),
          ),
          AssetTree(
            controller: _controller,
          ),
        ],
      ),
    );
  }
}

class _FilterHeaderDelegate extends SliverPersistentHeaderDelegate {
  final TextEditingController searchController;
  final ValueChanged<bool> toggleEnergySensorFilter;
  final ValueChanged<bool> toggleAlertStatusFilter;
  final ValueChanged<bool> toggleExpandAll;

  _FilterHeaderDelegate({
    required this.searchController,
    required this.toggleEnergySensorFilter,
    required this.toggleAlertStatusFilter,
    required this.toggleExpandAll,
  });

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      height: maxExtent,
      padding: const EdgeInsets.all(16.0),
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Column(
        children: [
          TextField(
            controller: searchController,
            decoration: InputDecoration(
              hintText: 'Search',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              SwitchButton(
                label: 'Sensor de Energia',
                icon: const Icon(Icons.bolt_outlined),
                onChanged: toggleEnergySensorFilter,
              ),
              const SizedBox(width: 8),
              SwitchButton(
                label: 'Crítico',
                icon: const Icon(Icons.error_outline_sharp),
                onChanged: toggleAlertStatusFilter,
              ),
              const Spacer(),
              SwitchButton(
                icon: const Icon(Icons.expand_sharp),
                onChanged: toggleExpandAll,
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  double get maxExtent => 140.0;

  @override
  double get minExtent => 140.0;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      false;
}
