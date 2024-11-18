import 'package:flutter/material.dart';

import '../../config/application.dart';
import '../../domain/commom/uid.dart';
import '../../domain/company_asset/company_asset_repository.dart';
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

  List<TreeNodeModel> _nodes = [];

  void _loadAssets() async {
    final companyId = Uid.fromString('662fd0fab3fd5656edb39af5');
    final assets = await assetRepository.fromCompany(companyId);
    final locations = await locationRepository.fromCompany(companyId);
    final assetNodes = assets.map(TreeNodeModel.fromCompanyAsset);
    final locationNodes = locations.map(TreeNodeModel.fromCompanyLocation);
    setState(() {
      _nodes = [...assetNodes, ...locationNodes];
    });
  }

  @override
  void initState() {
    super.initState();
    _loadAssets();
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
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
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
                        onChanged: (value) {},
                      ),
                      const SizedBox(width: 8),
                      SwitchButton(
                        label: 'Crítico',
                        icon: const Icon(Icons.error_outline_sharp),
                        onChanged: (value) {},
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          AssetTree(nodes: _nodes),
        ],
      ),
    );
  }
}
