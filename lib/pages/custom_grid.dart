import 'package:flutter/material.dart';

class CustomGrid extends StatelessWidget {
  final List<Widget> children;
  final int columns;
  final double height;
  final double width;
  final double spacing;

  const CustomGrid({
    super.key,
    required this.children,
    required this.columns,
    required this.height,
    required this.width,
    this.spacing = 5,
  });

  @override
  Widget build(BuildContext context) {
    // número de filas necesarias
    final int rows = (children.length / columns).ceil();

    return SizedBox(
      height: height,
      child: Padding(
        padding: EdgeInsets.all(spacing),
        child: Column(
          spacing: spacing,
          children: List.generate(rows, (rowIndex) {
            return Expanded(
              child: Row(
                spacing: spacing,
                children: List.generate(columns, (colIndex) {
                  final childIndex = rowIndex * columns + colIndex;

                  if (childIndex >= children.length) {
                    return Expanded(child: SizedBox());
                  }

                  return Expanded(child: SizedBox(child: children[childIndex]));
                }),
              ),
            );
          }),
        ),
      ),
    );
  }
}
