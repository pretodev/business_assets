import 'package:flutter/material.dart';

import '../../config/application.dart';
import '../../domain/commom/uid.dart';
import '../../domain/company_asset/company_asset_repository.dart';
import '../../domain/company_location/company_location_repository.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with ServiceLocatorMixin {
  late final assetRepository = instance<CompanyAssetRepository>();
  late final locationRepository = instance<CompanyLocationRepository>();

  void _loadAssets() async {
    final companyId = Uid.fromString('662fd0ee639069143a8fc387');
    final assets = await assetRepository.fromCompany(companyId);
    final locations = await locationRepository.fromCompany(companyId);
    print(assets);
    print(locations);
  }

  @override
  void initState() {
    super.initState();
    _loadAssets();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tractian: Business Assets'),
      ),
      body: Container(),
    );
  }
}
