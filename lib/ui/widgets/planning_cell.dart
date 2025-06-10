import 'package:flutter/material.dart';

class PlanningCell extends StatelessWidget {
  final String title;
  final String? meal;
  final VoidCallback? onTap;

  const PlanningCell({super.key, required this.title, this.meal, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
          color: onTap != null ? Colors.grey.shade100 : Colors.white,
        ),
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            if (meal != null)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  meal!,
                  style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 14),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
