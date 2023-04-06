import 'package:flutter/material.dart';
import 'package:athingani/src/models/models.dart';

///
///
///
class NodeRendererDelegate extends MultiChildLayoutDelegate {
  NodeRendererDelegate(this.nodes);
  final List<GraphNode> nodes;

  @override
  void performLayout(Size size) {
    for (final widget in nodes) {
      layoutChild(widget, BoxConstraints.tight(widget.size));
      positionChild(widget, widget.offset);
    }
  }

  @override
  bool shouldRelayout(NodeRendererDelegate oldDelegate) => true;
}
