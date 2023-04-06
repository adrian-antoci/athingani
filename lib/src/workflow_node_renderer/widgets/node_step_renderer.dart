import 'package:athingani/src/workflow_node_renderer/bloc/renderer_bloc_view_state.dart';
import 'package:flutter/material.dart';
import 'package:athingani/src/models/models.dart';

import 'node_step_link_circle.dart';

///
///
///
class NodeStepContainer extends StatelessWidget {
  const NodeStepContainer({
    super.key,
    required this.node,
    required this.viewState,
  });

  final GraphNode node;
  final RendererBlocViewState viewState;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return _layoutWidget(colors);
  }

  Widget _layoutWidget(ColorScheme colors) => SizedBox.fromSize(
        size: node.size,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            _nodeChildWidget(),
            if (viewState.isSelected(node.key))
              _borderWidget(
                colors: colors,
              ),
            node.type == GraphNodeType.step
                ? _linkCircleWidget(GraphNodeLinkCircleAlignment.rightAlignment)
                : const SizedBox.shrink(),
            _linkCircleWidget(GraphNodeLinkCircleAlignment.leftAlignment),
            _titleWidget(colors),
          ],
        ),
      );
  Widget _titleWidget(ColorScheme colors) => Positioned.fill(
        child: Align(
          alignment: Alignment.center,
          child: Text(
            node.title,
            style: TextStyle(
              fontSize: 16,
              color: colors.onSurface,
              shadows: [
                Shadow(
                  offset: const Offset(0.8, 0.8),
                  blurRadius: 3,
                  color: colors.surface,
                ),
              ],
            ),
          ),
        ),
      );

  Widget _borderWidget({required ColorScheme colors}) => Positioned(
        top: 0,
        left: 0,
        right: 0,
        bottom: 0,
        child: IgnorePointer(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: viewState.isSelected(node.key) ? colors.primary : colors.tertiary,
                width: viewState.isSelected(node.key) ? 3 : 2,
              ),
            ),
          ),
        ),
      );

  Widget _linkCircleWidget(AlignmentGeometry align) => Positioned.fill(
        child: Align(
          alignment: align,
          child: const AbsorbPointer(
            child: NodeStepLinkCircleWidget(),
          ),
        ),
      );

  Widget _nodeChildWidget() => Positioned.fill(
        key: key,
        child: node.childWidget,
      );
}
