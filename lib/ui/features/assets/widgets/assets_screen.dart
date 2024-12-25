import 'package:flutter/material.dart';

import '../../../../config/service_locator/service_locator_provider.dart';
import '../../../../core/domain/company/company.dart';
import '../../../../core/domain/company_asset/sensor_types.dart';
import '../../../../core/domain/company_asset/statuses.dart';
import '../assets_view_model.dart';
import 'assets_filter_header_delegate.dart';
import 'tree/assets_tree_view.dart';

class AssetsScreen extends StatefulWidget {
  static Future<void> push(
    BuildContext context, {
    required Company company,
    bool replace = false,
  }) {
    final route = MaterialPageRoute<void>(
      builder: (context) {
        final viewModel = AssetsViewModel(
          companyAssetRepository: context.get(),
          companyLocationRepository: context.get(),
        );
        viewModel.loadActivities.execute(company.id);
        return AssetsScreen(viewModel: viewModel);
      },
    );
    return replace
        ? Navigator.pushReplacement(context, route)
        : Navigator.push(context, route);
  }

  const AssetsScreen({
    super.key,
    required this.viewModel,
  });

  final AssetsViewModel viewModel;

  @override
  State<AssetsScreen> createState() => _AssetsScreenState();
}

class _AssetsScreenState extends State<AssetsScreen> {
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
  }

  @override
  void dispose() {
    _searchController.dispose();
    // _controller.dispose();
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
            listenable: widget.viewModel.loadActivities,
            builder: (context, child) {
              if (widget.viewModel.loadActivities.running) {
                return const SliverFillRemaining(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              return child!;
            },
            child: ListenableBuilder(
              listenable: widget.viewModel,
              builder: (context, child) {
                return AssetsTreeView(
                  key: _assetsKey,
                  assets: widget.viewModel.assets,
                  locations: widget.viewModel.locations,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
