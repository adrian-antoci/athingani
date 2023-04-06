import 'dart:math';
import 'dart:ui';

import 'package:athingani/src/models/selected_node_link.dart';
import 'package:flutter/material.dart';
import 'package:athingani/src/models/models.dart';

typedef NodeFormatter = void Function(GraphNode);

class RendererBlocViewState {
  List<GraphNode> nodes = const [];
  List<GraphNodeLink> links = const [];

  double minScale = 0.4;
  double maxScale = 4;
  final focusNode = FocusNode();
  Size? viewport;

  final Set<Key> _selectedNodesKeys = {};

  // https://stackoverflow.com/questions/481144/equation-for-testing-if-a-point-is-inside-a-circle
  bool _isPointInside(double center_x, double center_y, double radius, double x, double y) {
    return pow(x - center_x, 2) + pow(y - center_y, 2) <= pow(radius, 2);
  }

  void checkSelection(Offset localPosition) {
    final offset = toLocal(localPosition);
    final keys = <Key>[];

    for (final child in nodes) {
      var rightCircle = child.linkCircleRightPosition();
      var leftCircle = child.linkCircleLeftPosition();

      if (_isPointInside(rightCircle.dx, rightCircle.dy, GraphNodeLinkCircleAlignment.circleRadius, offset.dx, offset.dy)) {
        keys.add(child.rightLinkCircleKey);
      } else if (_isPointInside(leftCircle.dx, leftCircle.dy, GraphNodeLinkCircleAlignment.circleRadius, offset.dx, offset.dy)) {
        keys.add(child.leftLinkCircleKey);
      } else {
        final rect = child.rect;
        if (rect.contains(offset)) {
          keys.add(child.key);
        }
      }
    }
    if (keys.isNotEmpty) {
      setSelection({keys.last});
    } else {
      deselectAll();
    }

    // // checking for links
    // for (final link in links) {
    //   final fromNode = nodes.firstWhere((element) => element.id == link.fromNode);
    //   final toNode = nodes.firstWhere((element) => element.id == link.toNode);
    //
    //   var lineStart = NodeLinkRenderer.nodeLinkDirection(link, fromNode);
    //   var lineEnd = NodeLinkRenderer.nodeLinkDirectionTo(link, toNode);
    //
    //   var p = Path();
    //   p.moveTo(lineStart.dx, lineStart.dy);
    //   p.lineTo(lineEnd.dx, lineEnd.dy);
    //
    //   if (p.contains(offset)) {
    //     print("link " + fromNode.id.toString() + " SELECTED");
    //     return;
    //   }
    // }
  }

  void _cacheSelectedOrigins() {
    // cache selected node origins
    _selectedOrigins.clear();
    for (final key in _selectedNodesKeys) {
      final index = nodes.indexWhere((e) => e.key == key);
      if (index == -1) continue;
      final current = nodes[index];
      _selectedOrigins[key] = current.offset;
    }
  }

  void _cacheSelectedOrigin(Key key) {
    final index = nodes.indexWhere((e) => e.key == key);
    if (index == -1) return;
    final current = nodes[index];
    _selectedOrigins[key] = current.offset;
  }

  final Map<Key, Offset> _selectedOrigins = {};

  late final transform = TransformationController();
  Matrix4 get matrix => transform.value;
  Offset mousePosition = Offset.zero;
  Offset? mouseDragStart;
  Offset? linkStart;

  void _formatAll() {
    for (GraphNode node in nodes) {
      _formatter!(node);
    }
  }

  bool _formatterHasChanged = false;
  NodeFormatter? _formatter;
  set formatter(NodeFormatter value) {
    _formatterHasChanged = _formatter != value;

    if (_formatterHasChanged == false) return;

    _formatter = value;
    _formatAll();
  }

  Offset? _linkEnd;
  Offset? get linkEnd => _linkEnd;
  set linkEnd(Offset? value) {
    if (value == _linkEnd) return;
    _linkEnd = value;
  }

  bool _mouseDown = false;
  bool get mouseDown => _mouseDown;
  set mouseDown(bool value) {
    if (value == _mouseDown) return;
    _mouseDown = value;
  }

  bool _shiftPressed = false;
  bool get shiftPressed => _shiftPressed;
  set shiftPressed(bool value) {
    if (value == _shiftPressed) return;
    _shiftPressed = value;
    //
  }

  bool _spacePressed = false;
  bool get spacePressed => _spacePressed;
  set spacePressed(bool value) {
    if (value == _spacePressed) return;
    _spacePressed = value;
    //
  }

  bool _controlPressed = false;
  bool get controlPressed => _controlPressed;
  set controlPressed(bool value) {
    if (value == _controlPressed) return;
    _controlPressed = value;
    //
  }

  bool _metaPressed = false;
  bool get metaPressed => _metaPressed;
  set metaPressed(bool value) {
    if (value == _metaPressed) return;
    _metaPressed = value;
    //
  }

  double _scale = 1;
  double get scale => _scale;
  set scale(double value) {
    if (value == _scale) return;
    _scale = value;
    //
  }

  double getScale() {
    final matrix = transform.value;
    final scaleX = matrix.getMaxScaleOnAxis();
    return scaleX;
  }

  Rect getMaxSize() {
    Rect rect = Rect.zero;
    for (final child in nodes) {
      rect = Rect.fromLTRB(
        min(rect.left, child.rect.left),
        min(rect.top, child.rect.top),
        max(rect.right, child.rect.right),
        max(rect.bottom, child.rect.bottom),
      );
    }
    return rect;
  }

  bool isSelected(Key key) => _selectedNodesKeys.contains(key);

  bool get hasSelection => _selectedNodesKeys.isNotEmpty;

  bool get canvasMoveEnabled => !hasSelection;

  Offset toLocal(Offset global) {
    return transform.toScene(global);
  }

  // GraphNode? getNode(Key? key) {
  //   if (key == null) return null;
  //   return nodes.firstWhereOrNull((e) => e.key == key);
  // }

  void linkNodes(SelectedNodeLink from, SelectedNodeLink to) {
    // if same node
    if (from.node.id == to.node.id) return;

    // if node already has link
    for (var link in links) {
      if (link.toNode == to.node.id) return;
    }

    final edge = GraphNodeLink(
        fromNode: from.node.id, fromNodeAlignment: from.alignment, toNode: to.node.id, toNodeAlignment: to.alignment);
    links.add(edge);
  }

  void moveSelection(Offset position) {
    final delta = mouseDragStart != null ? toLocal(position) - toLocal(mouseDragStart!) : toLocal(position);
    for (final key in _selectedNodesKeys) {
      final index = nodes.indexWhere((e) => e.key == key);
      if (index == -1) continue;
      final current = nodes[index];
      final origin = _selectedOrigins[key];
      current.move(offset: origin! + delta);
      if (_formatter != null) {
        _formatter!(current);
      }
    }
  }

  void select(Key key) {
    _selectedNodesKeys.add(key);
    _cacheSelectedOrigin(key);
  }

  void setSelection(Set<Key> keys) {
    _selectedNodesKeys.clear();
    _selectedNodesKeys.addAll(keys);
    _cacheSelectedOrigins();
  }

  void deselect(
    Key key,
  ) {
    _selectedNodesKeys.remove(key);
    _selectedOrigins.remove(key);
  }

  void deselectAll() {
    _selectedNodesKeys.clear();
    _selectedOrigins.clear();
  }

  void add(GraphNode child) {
    if (_formatter != null) {
      _formatter!(child);
    }
    nodes.add(child);
  }

  void edit(GraphNode child) {
    if (_selectedNodesKeys.length == 1) {
      final idx = nodes.indexWhere((e) => e.key == _selectedNodesKeys.first);
      nodes[idx] = child;
    }
  }

  void remove(Key key) {
    nodes.removeWhere((e) => e.key == key);
    _selectedNodesKeys.remove(key);
    _selectedOrigins.remove(key);
  }

  void bringToFront() {
    final selection = _selectedNodesKeys.toList();
    for (final key in selection) {
      final index = nodes.indexWhere((e) => e.key == key);
      if (index == -1) continue;
      final current = nodes[index];
      nodes.removeAt(index);
      nodes.add(current);
    }
  }

  void sendBackward() {
    final selection = _selectedNodesKeys.toList();
    if (selection.length == 1) {
      final key = selection.first;
      final index = nodes.indexWhere((e) => e.key == key);
      if (index == -1) return;
      if (index == 0) return;
      final current = nodes[index];
      nodes.removeAt(index);
      nodes.insert(index - 1, current);
    }
  }

  void sendForward() {
    final selection = _selectedNodesKeys.toList();
    if (selection.length == 1) {
      final key = selection.first;
      final index = nodes.indexWhere((e) => e.key == key);
      if (index == -1) return;
      if (index == nodes.length - 1) return;
      final current = nodes[index];
      nodes.removeAt(index);
      nodes.insert(index + 1, current);
    }
  }

  void sendToBack() {
    final selection = _selectedNodesKeys.toList();
    for (final key in selection) {
      final index = nodes.indexWhere((e) => e.key == key);
      if (index == -1) continue;
      final current = nodes[index];
      nodes.removeAt(index);
      nodes.insert(0, current);
    }
  }

  void deleteSelection() {
    // final selection = _selected.toList();
    // for (final key in selection) {
    //   final index = nodes.indexWhere((e) => e.key == key);
    //   if (index == -1) continue;
    //   nodes.removeAt(index);
    //   _selectedOrigins.remove(key);
    // }
    // // Delete related connections
    // nodeLinks.removeWhere(
    //   (e) => selection.contains(e.from) || selection.contains(e.to),
    // );
  }

  void selectAll() {
    _selectedNodesKeys.clear();
    _selectedNodesKeys.addAll(nodes.map((e) => e.key).toList());
    _cacheSelectedOrigins();
  }

  void zoom(double delta) {
    final matrix = transform.value.clone();
    final local = toLocal(mousePosition);
    matrix.translate(local.dx, local.dy);
    matrix.scale(delta, delta);
    matrix.translate(-local.dx, -local.dy);
    transform.value = matrix;
  }

  void zoomIn() => zoom(1.1);
  void zoomOut() => zoom(0.9);
  void zoomReset() => transform.value = Matrix4.identity();

  void pan(Offset delta) {
    final matrix = transform.value.clone();
    matrix.translate(delta.dx, delta.dy);
    transform.value = matrix;
  }

  void panUp() => pan(const Offset(0, -10));
  void panDown() => pan(const Offset(0, 10));
  void panLeft() => pan(const Offset(-10, 0));
  void panRight() => pan(const Offset(10, 0));

  Offset getOffset() {
    final matrix = transform.value.clone();
    matrix.invert();
    final result = matrix.getTranslation();
    return Offset(result.x, result.y);
  }

  Rect getRect(BoxConstraints constraints) {
    final offset = getOffset();
    final scale = matrix.getMaxScaleOnAxis();
    final size = constraints.biggest;
    return offset & size / scale;
  }

  dynamic asJSON() {
    return {
      "nodes": nodes.map((e) => e.asJSON()).toList(),
      "links": links.map((e) => e.asJSON()).toList(),
    };
  }

  bool get isAnyLinkCircleSelected => _selectedNodesKeys.where((Key key) => key.toString().contains("circle")).isNotEmpty;

  Offset? linkCircleSelected() {
    for (var node in nodes) {
      if (_selectedNodesKeys.contains(node.leftLinkCircleKey)) {
        return node.linkCircleLeftPosition();
      } else if (_selectedNodesKeys.contains(node.rightLinkCircleKey)) {
        return node.linkCircleRightPosition();
      }
    }

    return null;
  }

  SelectedNodeLink? nodeLinkCircleSelected() {
    for (var node in nodes) {
      if (_selectedNodesKeys.contains(node.leftLinkCircleKey)) {
        return SelectedNodeLink(node, GraphNodeLinkCircleAlignment.startSide);
      } else if (_selectedNodesKeys.contains(node.rightLinkCircleKey)) {
        return SelectedNodeLink(node, GraphNodeLinkCircleAlignment.endSide);
      }
    }
    return null;
  }

  void checkNewLinkStart(Offset localPosition) {
    if (isAnyLinkCircleSelected) {
      linkStart = linkCircleSelected();
      linkEnd = null;
    }
  }

  void checkNewLinkEnd(Offset localPosition) {
    if (linkStart != null && linkEnd != null) {
      var startNode = nodeLinkCircleSelected();

      checkSelection(localPosition);

      if (isAnyLinkCircleSelected) {
        final endNodeSelected = nodeLinkCircleSelected();
        if (endNodeSelected != null) {
          linkNodes(startNode!, endNodeSelected);
        }
      } else {
        final offset = toLocal(localPosition);
        var id = DateTime.now().millisecondsSinceEpoch;
        var endNode = GraphNode(id: id, title: "Untitled step", x: offset.dx, y: offset.dy - 50);
        nodes.add(endNode);
        final edge = GraphNodeLink(
            fromNode: startNode!.node.id,
            fromNodeAlignment: GraphNodeLinkCircleAlignment.endSide,
            toNode: id,
            toNodeAlignment: GraphNodeLinkCircleAlignment.startSide);
        links.add(edge);
      }
    }
    linkStart = null;
    linkEnd = null;
  }
}
