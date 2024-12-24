import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../styles/styles.dart';
import '../../assets/widgets/assets_screen.dart';
import '../companies_view_model.dart';
import 'company_tile.dart';

class CompaniesScreen extends StatefulWidget {
  const CompaniesScreen({
    super.key,
    required this.viewModel,
  });

  final CompaniesViewModel viewModel;

  @override
  State<CompaniesScreen> createState() => _CompaniesScreenState();
}

class _CompaniesScreenState extends State<CompaniesScreen> {
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
        listenable: widget.viewModel.loadCompanies,
        builder: (context, child) {
          if (widget.viewModel.loadCompanies.completed) {
            return child!;
          }
          if (widget.viewModel.loadCompanies.running) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return SizedBox();
        },
        child: ListenableBuilder(
          listenable: widget.viewModel,
          builder: (context, child) {
            return ListView.builder(
              padding: EdgeInsets.symmetric(
                horizontal: 22.0,
                vertical: 30.0,
              ),
              itemCount: widget.viewModel.companies.length,
              itemBuilder: (context, index) {
                final company = widget.viewModel.companies[index];
                return CompanyTile(
                  company: company,
                  onClicked: () {
                    AssetsScreen.push(context, company: company);
                  },
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
