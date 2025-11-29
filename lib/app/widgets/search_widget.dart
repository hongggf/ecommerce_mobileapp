import 'package:ecommerce_urban/app/constants/app_spacing.dart';
import 'package:flutter/material.dart';

class SearchTextFieldWithFilter extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onFilterTap;
  final String hint;

  const SearchTextFieldWithFilter({
    super.key,
    required this.controller,
    this.onChanged,
    this.onFilterTap,
    this.hint = "Search...",
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: controller,
              onChanged: onChanged,
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: TextStyle(color: Colors.grey.shade500),
                border: InputBorder.none,
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
              ),
            ),
          ),
          const SizedBox(width: 8),

          // Filter Button
          GestureDetector(
            onTap: onFilterTap,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.filter_alt_rounded, color: Colors.white),
            ),
          )
        ],
      ),
    );
  }
}

class SearchCardNavigation extends StatelessWidget {
  final String hint;
  final VoidCallback? onTap;

  const SearchCardNavigation({
    super.key,
    this.hint = "Search products...",
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              const Icon(Icons.search, color: Colors.grey),
              SizedBox(width: AppSpacing.paddingS),
              Expanded(
                child: Text(
                  hint,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: Colors.grey.shade600,
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
