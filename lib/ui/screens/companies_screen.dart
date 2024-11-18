import 'package:flutter/material.dart';

import '../../config/application.dart';
import '../../domain/company/company.dart';
import '../../domain/company/company_repository.dart';
import 'assets_screen.dart';

class CompaniesScreen extends StatefulWidget {
  const CompaniesScreen({super.key});

  @override
  State<CompaniesScreen> createState() => _CompaniesScreenState();
}

class _CompaniesScreenState extends State<CompaniesScreen>
    with ServiceLocatorMixin {
  late final companyRepository = instance<CompanyRepository>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Companies'),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Company>>(
        future: companyRepository.all,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No companies found'));
          } else {
            final companies = snapshot.data!;
            return ListView.builder(
              itemCount: companies.length,
              itemBuilder: (context, index) {
                final company = companies[index];
                return ListTile(
                  title: Text(company.name),
                  onTap: () => AssetsScreen.push(context, company: company),
                );
              },
            );
          }
        },
      ),
    );
  }
}
