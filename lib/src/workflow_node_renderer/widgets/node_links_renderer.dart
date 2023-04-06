import 'dart:math';
import 'dart:typed_data';

import 'package:athingani/src/workflow_node_renderer/bloc/renderer_bloc_view_state.dart';
import 'package:flutter/material.dart';
import 'package:athingani/src/models/models.dart';

import 'inline_painter.dart';

///
///
///
class NodeLinkRenderer extends StatelessWidget {
  const NodeLinkRenderer({super.key, required this.viewState});

  final RendererBlocViewState viewState;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return CustomPaint(
      painter: InlinePainter(
        brush: Paint()
          ..color = colors.tertiary
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2,
        builder: (brush, canvas, rect) {
          for (final link in viewState.links) {
            final from = viewState.nodes.firstWhere((node) => node.key == link.fromKey);
            final to = viewState.nodes.firstWhere((node) => node.key == link.toKey);
            _drawLink(
                context,
                canvas,
                link.fromNodeAlignment == GraphNodeLinkCircleAlignment.endSide
                    ? from.linkCircleRightPosition()
                    : from.linkCircleLeftPosition(),
                link.toNodeAlignment == GraphNodeLinkCircleAlignment.startSide
                    ? to.linkCircleLeftPosition()
                    : to.linkCircleRightPosition(),
                brush,
                MediaQuery.of(context).size);
          }
        },
      ),
      foregroundPainter: InlinePainter(
        brush: Paint()
          ..color = colors.primary
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2,
        builder: (brush, canvas, child) {
          if (viewState.linkStart != null && viewState.linkEnd != null) {
            _drawLink(
                context, canvas, viewState.linkStart!, viewState.toLocal(viewState.linkEnd!), brush, MediaQuery.of(context).size);
          }
        },
      ),
    );
  }

  ///
  /// Will draw a line between [fromOffset] and [toOffset]
  ///
  void _drawLink(BuildContext context, Canvas canvas, Offset fromOffset, Offset toOffset, Paint brush, Size screenSize) {
    final linkPath = Path();
    linkPath.moveTo(fromOffset.dx, fromOffset.dy);
    linkPath.cubicTo(
      fromOffset.dx,
      fromOffset.dy,
      fromOffset.dx,
      toOffset.dy,
      toOffset.dx,
      toOffset.dy,
    );

    canvas.drawPath(linkPath, brush);

    final pathMetrics = linkPath.computeMetrics();
    final pathMetric = pathMetrics.first;
    final pathLength = pathMetric.length;
    final middle = pathMetric.getTangentForOffset(pathLength / 2);

    if (middle == null) return;

    var centerAngle = _getAngleBetweenPoints(toOffset, fromOffset);
    canvas.drawPath(_arrowPath(middle.position, centerAngle), brush..style = PaintingStyle.fill);
    canvas.drawCircle(fromOffset, 4, brush..style = PaintingStyle.fill);
    canvas.drawCircle(toOffset, 4, brush..style = PaintingStyle.fill);

    // set it back to what it was
    brush.style = PaintingStyle.stroke;
  }

  double _getAngleBetweenPoints(Offset toOffset, Offset fromOffset) {
    return _invertAngle(atan2(toOffset.dy - fromOffset.dy, toOffset.dx - fromOffset.dx));
  }

  double _invertAngle(angle) {
    return (angle + pi) % (2 * pi);
  }

  Path _arrowPath(Offset offset, double alpha) {
    var size = 10.0;
    Path a = Path();
    a.moveTo(size, -size);
    a.lineTo(0, 0);
    a.lineTo(size, size);
    final translateM = Float64List.fromList([1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, offset.dx, offset.dy, 0, 1]);
    final rotateM = Float64List.fromList([cos(alpha), sin(alpha), 0, 0, -sin(alpha), cos(alpha), 0, 0, 0, 0, 1, 0, 0, 0, 0, 1]);
    final b = a.transform(rotateM);
    return b.transform(translateM);
  }
}
