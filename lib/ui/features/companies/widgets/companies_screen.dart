import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/service_locator/service_locator_provider.dart';
import '../../app/routing/routes.dart';
import '../../app/styles/styles.dart';
import '../companies_view_model.dart';
import 'company_tile.dart';

class CompaniesScreen extends StatefulWidget {
  const CompaniesScreen({
    super.key,
  });

  @override
  State<CompaniesScreen> createState() => _CompaniesScreenState();
}

class _CompaniesScreenState extends State<CompaniesScreen> {
  late final _viewModel = CompaniesViewModel(
    companyRepository: context.get(),
  );

  @override
  void initState() {
    super.initState();
    Future(() => _viewModel.loadCompanies.execute());
  }

  @override
  Widget build(BuildContext context) {
    final lang = AppLocalizations.of(context);
    final languages = [
      lang?.spanish,
      lang?.english,
      lang?.portuguese,
    ];
    final Styles(:colors, :text) = context.styles;
    return Scaffold(
      appBar: AppBar(
        title: SvgPicture.asset('assets/images/logo.svg'),
        centerTitle: true,
      ),
      body: ListenableBuilder(
        listenable: _viewModel.loadCompanies,
        builder: (context, child) {
          if (_viewModel.loadCompanies.completed) {
            return child!;
          }
          if (_viewModel.loadCompanies.running) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return SizedBox();
        },
        child: ListenableBuilder(
          listenable: _viewModel,
          builder: (context, child) {
            return ListView.builder(
              padding: EdgeInsets.symmetric(
                horizontal: 22.0,
                vertical: 30.0,
              ),
              itemCount: _viewModel.companies.length,
              itemBuilder: (context, index) {
                final company = _viewModel.companies[index];
                return CompanyTile(
                  company: company,
                  onClicked: () => context.go(
                    Routes.companyAssets(company.id),
                  ),
                );
              },
            );
          },
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('${lang?.language}: '),
            DropdownButton<String>(
              items: languages
                  .map(
                    (value) => DropdownMenuItem(
                      value: value,
                      child: Text(value ?? ''),
                    ),
                  )
                  .toList(),
              value: AppLocalizations.of(context)!.portuguese,
              onChanged: (value) {},
              dropdownColor: colors.scaffoldBackground,
              elevation: 0,
              underline: SizedBox(),
              style: text.bodyMedium.copyWith(
                fontWeight: FontWeight.bold,
                color: colors.secondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
