part of 'node_renderer_widget.dart';

const double _minScale = 0.8;
const double _maxScale = 2;
Key _interactiveViewerKey = const Key("_interactiveViewer");
Key _mouseListenerKey = const Key("_mouseListener");

///
/// The main body widget
///
Widget _bodyWidget({required BuildContext context}) {
  return _mouseListener(
    context,
    _layoutWidget(context),
  );
}

Widget _layoutWidget(BuildContext context) {
  var viewState = context.read<AthinganiRendererBloc>().viewState;
  return InteractiveViewer.builder(
    key: _interactiveViewerKey,
    transformationController: viewState.transform,
    panEnabled: viewState.canvasMoveEnabled,
    scaleEnabled: viewState.canvasMoveEnabled,
    onInteractionStart: (details) {
      viewState.mousePosition = details.focalPoint;
      viewState.mouseDragStart = viewState.mousePosition;
    },
    onInteractionUpdate: (details) {
      viewState.scale = details.scale;
      context.read<AthinganiRendererBloc>().add(
            AthinganiRendererBlocEventMoveSelection(position: details.focalPoint),
          );
      viewState.mousePosition = details.focalPoint;
    },
    onInteractionEnd: (_) => viewState.mouseDragStart = null,
    minScale: _minScale,
    maxScale: _maxScale,
    boundaryMargin: const EdgeInsets.all(double.infinity),
    builder: (context, quad) {
      return SizedBox.fromSize(
        size: _getMaxSize(context).size,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            _backgroundWidget(quad),
            _nodesWidget(context),
            _linksWidgets(context),
          ],
        ),
      );
    },
  );
}

Widget _mouseListener(BuildContext context, Widget child) {
  var viewState = context.read<AthinganiRendererBloc>().viewState;
  return Listener(
      key: _mouseListenerKey,
      onPointerDown: (details) {
        print("click down");
        viewState.mouseDown = true;
        context.read<AthinganiRendererBloc>().add(
              AthinganiRendererBlocEventCheckSelection(localPosition: details.localPosition),
            );
      },
      onPointerUp: (details) {
        print("click release");
        viewState.mouseDown = false;
        context.read<AthinganiRendererBloc>().add(
              AthinganiRendererBlocEventCheckNewLink(localPosition: details.localPosition),
            );
      },
      onPointerCancel: (details) {
        viewState.mouseDown = false;
      },
      onPointerHover: (details) {
        viewState.mousePosition = details.localPosition;
      },
      onPointerMove: (details) {
        if (viewState.linkStart != null) {
          viewState.linkEnd = details.localPosition;
        }
      },
      child: child);
}

Widget _nodesWidget(BuildContext context) => Positioned.fill(
      child: CustomMultiChildLayout(
        delegate: NodeRendererDelegate(context.read<AthinganiRendererBloc>().viewState.nodes),
        children: context
            .read<AthinganiRendererBloc>()
            .viewState
            .nodes
            .map((e) => LayoutId(
                  key: e.key,
                  id: e,
                  child: NodeStepContainer(
                    node: e,
                    viewState: context.read<AthinganiRendererBloc>().viewState,
                  ),
                ))
            .toList(),
      ),
    );

/// The background widget
Widget _backgroundWidget(Quad quad) => Positioned.fill(
      child: NodeRendererBackgroundWidget(
        viewport: _axisAlignedBoundingBox(quad),
      ),
    );

/// The links widget
Widget _linksWidgets(BuildContext context) => Positioned.fill(
      child: NodeLinkRenderer(
        viewState: context.read<AthinganiRendererBloc>().viewState,
      ),
    );

Rect _getMaxSize(BuildContext context) {
  Rect rect = Rect.zero;
  for (final child in context.read<AthinganiRendererBloc>().viewState.nodes) {
    rect = Rect.fromLTRB(
      min(rect.left, child.rect.left),
      min(rect.top, child.rect.top),
      max(rect.right, child.rect.right),
      max(rect.bottom, child.rect.bottom),
    );
  }
  return rect;
}

Rect _axisAlignedBoundingBox(Quad quad) {
  double xMin = quad.point0.x;
  double xMax = quad.point0.x;
  double yMin = quad.point0.y;
  double yMax = quad.point0.y;

  for (final Vector3 point in <Vector3>[
    quad.point1,
    quad.point2,
    quad.point3,
  ]) {
    if (point.x < xMin) {
      xMin = point.x;
    } else if (point.x > xMax) {
      xMax = point.x;
    }

    if (point.y < yMin) {
      yMin = point.y;
    } else if (point.y > yMax) {
      yMax = point.y;
    }
  }

  return Rect.fromLTRB(xMin, yMin, xMax, yMax);
}
