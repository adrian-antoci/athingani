import 'package:flutter/material.dart';

///
class NodeRendererBackgroundWidget extends StatelessWidget {
  const NodeRendererBackgroundWidget({
    super.key,
    required this.viewport,
  });
  final double _cellSize = 40;
  final Rect viewport;

  @override
  Widget build(BuildContext context) {
    final int firstRow = (viewport.top / _cellSize).floor();
    final int lastRow = (viewport.bottom / _cellSize).ceil();
    final int firstCol = (viewport.left / _cellSize).floor();
    final int lastCol = (viewport.right / _cellSize).ceil();

    final colors = Theme.of(context).colorScheme;
    return Material(
      color: colors.background,
      child: Stack(
        clipBehavior: Clip.none,
        children: <Widget>[
          for (int row = firstRow; row < lastRow; row++)
            for (int col = firstCol; col < lastCol; col++)
              Positioned(
                left: col * _cellSize,
                top: row * _cellSize,
                child: Container(
                  height: 2,
                  width: 2,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    color: colors.primary.withOpacity(0.5),
                  ),
                ),
              ),
        ],
      ),
    );
  }
}
