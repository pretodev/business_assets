import 'package:flutter/material.dart';

import '../../../config/service_locator/service_locator_provider.dart';
import '../../../core/domain/company_asset/sensor_types.dart';
import '../../../core/domain/company_asset/statuses.dart';
import '../../../core/domain/uid.dart';
import '../assets_view_model.dart';
import 'assets_filter_header_delegate.dart';
import 'tree/assets_tree_view.dart';

class AssetsScreen extends StatefulWidget {
  const AssetsScreen({
    super.key,
    required this.companyId,
  });

  final Uid companyId;

  @override
  State<AssetsScreen> createState() => _AssetsScreenState();
}

class _AssetsScreenState extends State<AssetsScreen> {
  late final _viewModel = AssetsViewModel(
    companyAssetRepository: context.get(),
    companyLocationRepository: context.get(),
  );

  final _searchController = TextEditingController();

  final _assetsKey = GlobalKey<AssetsTreeViewState>();

  bool _energySensorFilter = false;
  bool _alertStatusFilter = false;

  void _toggleEnergySensorFilter(bool value) {
    _energySensorFilter = value;
    _applyFilters();
  }

  void _toggleAlertStatusFilter(bool value) {
    _alertStatusFilter = value;
    _applyFilters();
  }

  void _applyFilters() {
    _assetsKey.currentState?.filterBy(
      name: _searchController.text,
      status: _alertStatusFilter ? Statuses.alert : null,
      sensorType: _energySensorFilter ? SensorTypes.energy : null,
    );
  }

  void _toogleExpandAll(bool value) {
    if (value) {
      _assetsKey.currentState?.expandAll();
    } else {
      _assetsKey.currentState?.collapseAll();
    }
  }

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_applyFilters);
    Future(() => _viewModel.loadActivities.execute(widget.companyId));
  }

  @override
  void dispose() {
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
            delegate: AssetsFilterHeaderDelegate(
              searchController: _searchController,
              toggleEnergySensorFilter: _toggleEnergySensorFilter,
              toggleAlertStatusFilter: _toggleAlertStatusFilter,
              toggleExpandAll: _toogleExpandAll,
            ),
          ),
          ListenableBuilder(
            listenable: _viewModel.loadActivities,
            builder: (context, child) {
              if (_viewModel.loadActivities.running) {
                return const SliverFillRemaining(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              return child!;
            },
            child: ListenableBuilder(
              listenable: _viewModel,
              builder: (context, child) {
                return AssetsTreeView(
                  key: _assetsKey,
                  assets: _viewModel.assets,
                  locations: _viewModel.locations,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
