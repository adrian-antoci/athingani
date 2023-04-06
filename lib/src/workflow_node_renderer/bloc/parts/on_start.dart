part of '../renderer_bloc.dart';

void _onStart({
  required RendererBlocViewState viewState,
  required AthinganiRendererBloc bloc,
}) async {
  final prefs = await SharedPreferences.getInstance();
  var graph = prefs.get("graphs");
  if (graph != null) {
    var json = jsonDecode(graph.toString());
    viewState.links = (json["links"] as List<dynamic>).map((e) => GraphNodeLink.fromJSON(e)).toList();
    viewState.nodes = (json["nodes"] as List<dynamic>).map((e) => GraphNode.fromJSON(e)).toList();
  } else {
    viewState.links = _edges();
    viewState.nodes = _nodes();
  }

  bloc.add(AthinganiRendererBlocEventNodesAvailable());
}

List<GraphNodeLink> _edges() {
  return [
    // GraphNodeLink(
    //   fromNode: 1,
    //   toNode: 2,
    //   fromNodeAlignment: GraphNodeLinkCircleAlignment.endSide,
    //   toNodeAlignment: GraphNodeLinkCircleAlignment.startSide,
    // ),
    // GraphNodeLink(
    //   fromNode: 2,
    //   toNode: 3,
    //   fromNodeAlignment: GraphNodeLinkCircleAlignment.endSide,
    //   toNodeAlignment: GraphNodeLinkCircleAlignment.startSide,
    // ),
    // const GraphNodeLink(
    //   fromNode: 22,
    //   toNode: 2,
    //   direction: GraphNodeLinkDirection.right,
    // ),
    // const GraphNodeLink(
    //   fromNode: 2,
    //   toNode: 3,
    //   direction: GraphNodeLinkDirection.right,
    // ),
    // const GraphNodeLink(
    //   fromNode: 3,
    //   toNode: 4,
    //   direction: GraphNodeLinkDirection.right,
    // ),
    // const GraphNodeLink(
    //   fromNode: 4,
    //   toNode: 5,
    //   direction: GraphNodeLinkDirection.right,
    // ),
  ];
}

List<GraphNode> _nodes() {
  var card1 = GraphNode(
    id: 1,
    title: 'Start',
    x: 500,
    y: 500,
    type: GraphNodeType.start,
  );
  //
  // var card2 = GraphNode(
  //   id: 2,
  //   title: 'Onboarding Step 1',
  //   x: 800,
  //   y: 500,
  // );
  // var card2B = GraphNode(
  //   id: 22,
  //   title: 'Log analytics event',
  //   x: 800,
  //   y: 300,
  // );
  // var card3 = GraphNode(
  //   id: 3,
  //   title: 'Onboarding Step 2',
  //   x: 1100,
  //   y: 500,
  // );
  //
  // var card4 = GraphNode(
  //   id: 4,
  //   title: 'Onboarding Step 3',
  //   x: 1400,
  //   y: 500,
  // );
  //
  // var card5 = GraphNode(
  //   id: 5,
  //   title: 'Display Home Page',
  //   x: 1700,
  //   y: 500,
  // );
  // var card6 = GraphNode(
  //   id: 6,
  //   title: 'Testing',
  //   x: -500,
  //   y: 0,
  // );
  return [
    card1,
    // card2,
    // card2B,
    // card3,
    // card4,
    // card5,
    // card6,
  ];
}
