import 'package:flutter/material.dart';
import 'package:athingani/src/workflow_node_renderer/node_renderer_widget.dart';
import 'glass_card.dart';

part 'container_widget_parts.dart';

class ContainerWidget extends StatelessWidget {
  const ContainerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GlassCardWidget(child: AthinganiNodeRendererV2.instance()),
    );
  }
}
