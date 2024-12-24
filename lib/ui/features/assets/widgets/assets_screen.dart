import 'package:flutter/material.dart';

import '../../../../config/service_locator/service_locator_provider.dart';
import '../../../../core/domain/company/company.dart';
import '../../../../core/domain/company_asset/sensor_types.dart';
import '../../../../core/domain/company_asset/statuses.dart';
import '../assets_view_model.dart';
import '../models/tree_node_model.dart';
import '../tree/assets_tree_view.dart';
import 'assets_filter_header_delegate.dart';

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
  // final AssetTreeController _controller = AssetTreeController();
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
    // if (value) {
    //   _controller.addFilter(_filterOnlyEnergySensor);
    // } else {
    //   _controller.removeFilter(_filterOnlyEnergySensor);
    // }
  }

  void _toggleAlertStatusFilter(bool value) {
    // if (value) {
    //   _controller.addFilter(_filterOnlyAlertStatus);
    // } else {
    //   _controller.removeFilter(_filterOnlyAlertStatus);
    // }
  }

  void _toogleExpandAll(bool value) {
    // if (value) {
    //   _controller.expandAll();
    // } else {
    //   _controller.collapseAll();
    // }
  }

  void _toggleNameFilter() {
    // if (_searchController.text.isNotEmpty) {
    //   _controller.addFilter(_filterByName);
    // } else {
    //   _controller.removeFilter(_filterByName);
    // }
  }

  @override
  void initState() {
    super.initState();
    // _searchController.addListener(_toggleNameFilter);
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
