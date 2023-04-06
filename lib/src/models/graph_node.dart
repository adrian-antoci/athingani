import 'package:athingani/src/models/graph_node_link.dart';
import 'package:flutter/material.dart';

import 'graph_node_type.dart';

class GraphNode {
  GraphNode({
    required this.id,
    required this.title,
    this.type = GraphNodeType.step,
    required this.x,
    required this.y,
  });

  int id;
  final GraphNodeType type;

  late String title;
  Rect get rect => offset & const Size(200, 100);
  Size get size => const Size(200, 100);
  Key get key => Key(id.toString());
  Offset get offset => Offset(x, y);

  late double x;
  late double y;

  /// FIXME based on type
  Widget get childWidget => type == GraphNodeType.step
      ? Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.deepPurpleAccent.withOpacity(0.6), width: 2),
          ),
        )
      : Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.deepPurpleAccent, width: 2),
          ),
        );

  dynamic asJSON() {
    return {
      "id": id,
      "title": title,
      "type": type.name,
      "x": x,
      "y": y,
    };
  }

  factory GraphNode.fromJSON(dynamic json) {
    return GraphNode(
      id: json["id"],
      title: json["title"],
      type: GraphNodeType.values.firstWhere(
        (element) => element.name == json["type"],
      ),
      x: json["x"],
      y: json["y"],
    );
  }

  void move({
    Size? size,
    Offset? offset,
    String? title,
  }) {
    if (offset != null) {
      x = offset.dx;
      y = offset.dy;
    }
    if (title != null) this.title = title;
  }

  Offset linkCircleRightPosition() {
    return Offset(rect.centerRight.dx + GraphNodeLinkCircleAlignment.circleOffset, rect.centerRight.dy);
  }

  Offset linkCircleLeftPosition() {
    return Offset(rect.centerLeft.dx - GraphNodeLinkCircleAlignment.circleOffset, rect.centerRight.dy);
  }

  Key get rightLinkCircleKey => Key("${id}_rcircle");
  Key get leftLinkCircleKey => Key("${id}_lcircle");
}
