import 'package:flutter/material.dart';

class SliderChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final double value;
  final double min;
  final double max;
  final ValueChanged<double> onChanged;

  const SliderChip({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),

      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 18),
          const SizedBox(width: 6),
          Expanded(
            child: SliderTheme(
              data: SliderThemeData(
                activeTrackColor: Colors.pinkAccent,
                inactiveTrackColor: Colors.white24,
                thumbColor: Colors.pinkAccent,
                overlayColor: Colors.pinkAccent.withOpacity(0.2),
              ),
              child: Slider(
                value: value,
                min: min,
                max: max,
                divisions: 6,
                onChanged: onChanged,
              ),
            ),
          ),
        ],
      ),
    );
  }
}