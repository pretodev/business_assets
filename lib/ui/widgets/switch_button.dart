import 'package:flutter/material.dart';

import '../features/app/styles/styles.dart';

class SwitchButton extends StatefulWidget {
  const SwitchButton({
    super.key,
    this.label = '',
    required this.icon,
    required this.onChanged,
  });

  final String label;
  final IconData icon;
  final ValueChanged<bool> onChanged;

  @override
  State<SwitchButton> createState() => _SwitchButtonState();
}

class _SwitchButtonState extends State<SwitchButton> {
  bool _actived = false;

  @override
  Widget build(BuildContext context) {
    final Styles(:colors, :text) = context.styles;
    return GestureDetector(
      onTap: () {
        setState(() {
          _actived = !_actived;
          widget.onChanged(_actived);
        });
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: _actived ? colors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: _actived ? Colors.transparent : colors.border,
          ),
        ),
        child: widget.label != ''
            ? Row(
                children: [
                  Icon(
                    widget.icon,
                    color:
                        _actived ? colors.textOnPrimary : colors.textSecondary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    widget.label,
                    style: text.bodyMedium.copyWith(
                      color: _actived
                          ? colors.textOnPrimary
                          : colors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              )
            : Icon(
                widget.icon,
                color: _actived ? colors.textOnPrimary : colors.textSecondary,
              ),
      ),
    );
  }
}
