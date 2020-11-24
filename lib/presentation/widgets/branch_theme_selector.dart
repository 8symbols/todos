import 'package:flutter/material.dart';
import 'package:todos/domain/models/branch_theme.dart';

typedef OnThemeSelectedCallback = void Function(BranchTheme selectedTheme);

/// Виджет для выбора темы из [themes].
class BranchThemeSelector extends StatelessWidget {
  /// Текущая выбранная тема.
  ///
  /// Предполагается, что она находится в [themes].
  final BranchTheme currentTheme;

  /// Темы, из которых можно выбрать.
  final List<BranchTheme> themes;

  /// Callback, который будет вызван при выборе.
  final OnThemeSelectedCallback onSelect;

  const BranchThemeSelector(
    this.themes,
    this.currentTheme, {
    @required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    const size = 32.0;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final theme in themes)
            Container(
              margin: const EdgeInsets.only(right: 4.0),
              height: size,
              width: size,
              decoration: BoxDecoration(
                color: theme.primaryColor,
                shape: BoxShape.circle,
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: () => onSelect(theme),
                child: theme == currentTheme
                    ? Icon(
                        Icons.circle,
                        color: Colors.white70,
                        size: size / 2,
                      )
                    : null,
              ),
            ),
        ],
      ),
    );
  }
}
