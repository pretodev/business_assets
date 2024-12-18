import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../config/application.dart';
import '../../domain/company/company.dart';
import '../../domain/company/company_repository.dart';
import '../styles/styles.dart';
import '../widgets/app_icon.dart';
import 'assets_screen.dart';

class CompaniesScreen extends StatefulWidget {
  const CompaniesScreen({super.key});

  @override
  State<CompaniesScreen> createState() => _CompaniesScreenState();
}

class _CompaniesScreenState extends State<CompaniesScreen>
    with ServiceLocatorMixin {
  late final companyRepository = instance<CompanyRepository>();

  List<Company> _companies = [];
  bool _loading = false;

  void _load() async {
    setState(() => _loading = true);
    final companies = await companyRepository.all;
    setState(() {
      _companies = companies;
      _loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SvgPicture.asset('assets/images/logo.svg'),
        centerTitle: true,
      ),
      body: Visibility(
        visible: !_loading,
        replacement: Center(
          child: CircularProgressIndicator(),
        ),
        child: ListView.builder(
          padding: EdgeInsets.symmetric(
            horizontal: 22.0,
            vertical: 30.0,
          ),
          itemCount: _companies.length,
          itemBuilder: (context, index) {
            final company = _companies[index];
            return CompanyTile(
              company: _companies[index],
              onClicked: () => AssetsScreen.push(context, company: company),
            );
          },
        ),
      ),
    );
  }
}

class CompanyTile extends StatelessWidget {
  const CompanyTile({
    super.key,
    required this.company,
    required this.onClicked,
  });

  final Company company;
  final VoidCallback onClicked;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: 40.0,
      ),
      child: InkWell(
        onTap: onClicked,
        child: Container(
          decoration: BoxDecoration(
            color: context.appColors.primary,
            borderRadius: BorderRadius.circular(5.0),
          ),
          padding: EdgeInsets.all(32.0),
          alignment: Alignment.centerLeft,
          child: Row(
            children: [
              AppIcon(name: 'gold_bars'),
              SizedBox(width: 16.0),
              Text(
                company.name,
                style: context.appTextStyles.titleSmall.copyWith(
                  color: context.appColors.textOnPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
