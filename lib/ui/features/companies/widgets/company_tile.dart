import 'package:flutter/material.dart';

import '../../../../core/domain/company/company.dart';
import '../../../widgets/app_icon.dart';
import '../../app/styles/styles.dart';

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
    final Styles(:colors, :text) = context.styles;
    return Padding(
      padding: EdgeInsets.only(
        bottom: 40.0,
      ),
      child: InkWell(
        onTap: onClicked,
        child: Container(
          decoration: BoxDecoration(
            color: colors.primary,
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
                style: text.titleSmall.copyWith(
                  color: colors.textOnPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
