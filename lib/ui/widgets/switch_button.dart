import 'package:flutter/material.dart';

class SwitchButton extends StatefulWidget {
  const SwitchButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onChanged,
  });

  final String label;
  final Widget icon;
  final ValueChanged<bool> onChanged;

  @override
  State<SwitchButton> createState() => _SwitchButtonState();
}

class _SwitchButtonState extends State<SwitchButton> {
  bool _actived = false;

  @override
  Widget build(BuildContext context) {
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
          color: _actived ? Theme.of(context).primaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: _actived ? Theme.of(context).primaryColor : Colors.black12,
          ),
        ),
        child: Row(
          children: [
            widget.icon,
            const SizedBox(width: 8),
            Text(
              widget.label,
              style: const TextStyle(color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}
