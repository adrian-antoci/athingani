import 'package:flutter/material.dart';

class GraphNodeLinkCircleAlignment {
  static int endSide = 1;
  static int startSide = 2;
  static const double circleOffset = 0.075;
  static const double circleRadius = 14;

  static List<int> get values => [GraphNodeLinkCircleAlignment.endSide, GraphNodeLinkCircleAlignment.startSide];

  static AlignmentGeometry get leftAlignment => Alignment.centerRight.add(const Alignment(circleOffset, 0));
  static AlignmentGeometry get rightAlignment => Alignment.centerLeft.add(const Alignment(-circleOffset, 0));
}

class GraphNodeLink {
  const GraphNodeLink({
    required this.fromNode,
    required this.toNode,
    required this.fromNodeAlignment,
    required this.toNodeAlignment,
  });
  final int fromNode;
  final int toNode;
  final int fromNodeAlignment;
  final int toNodeAlignment;

  Key get fromKey => Key(fromNode.toString());
  Key get toKey => Key(toNode.toString());

  dynamic asJSON() => {
        "fromNode": fromNode,
        "toNode": toNode,
        "fromNodeAlignment": fromNodeAlignment,
        "toNodeAlignment": toNodeAlignment,
      };

  factory GraphNodeLink.fromJSON(dynamic json) {
    return GraphNodeLink(
        fromNodeAlignment: GraphNodeLinkCircleAlignment.values.firstWhere((element) => element == json["fromNodeAlignment"]),
        toNodeAlignment: GraphNodeLinkCircleAlignment.values.firstWhere((element) => element == json["toNodeAlignment"]),
        fromNode: json["fromNode"],
        toNode: json["toNode"]);
  }
}
