import 'package:athingani/src/models/graph_node_link.dart';
import 'package:flutter/material.dart';

///
///
///
class NodeStepLinkCircleWidget extends StatelessWidget {
  const NodeStepLinkCircleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      height: GraphNodeLinkCircleAlignment.circleRadius,
      width: GraphNodeLinkCircleAlignment.circleRadius,
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: BorderRadius.circular(GraphNodeLinkCircleAlignment.circleRadius),
        border: Border.all(
          color: colors.primary,
          width: 1,
        ),
      ),
    );
  }
}
