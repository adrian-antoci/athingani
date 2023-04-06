import 'dart:math';

import 'package:athingani/src/workflow_node_renderer/bloc/renderer_bloc.dart';
import 'package:athingani/src/workflow_node_renderer/widgets/background.dart';
import 'package:athingani/src/workflow_node_renderer/widgets/delegate.dart';
import 'package:athingani/src/workflow_node_renderer/widgets/node_links_renderer.dart';
import 'package:athingani/src/workflow_node_renderer/widgets/node_step_renderer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vector_math/vector_math_64.dart' hide Colors;

part 'node_renderer_widget_parts.dart';

class AthinganiNodeRendererV2 extends StatelessWidget {
  const AthinganiNodeRendererV2({super.key});

  static Widget instance() {
    return BlocProvider(
      lazy: false,
      create: (context) {
        return AthinganiRendererBloc();
      },
      child: const AthinganiNodeRendererV2(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AthinganiRendererBloc, AthinganiRendererBlocState>(
      buildWhen: (previous, current) => current is AthinganiRendererBlocStateDefault,
      builder: (context, state) {
        if (state is AthinganiRendererBlocStateDefault) {
          return _bodyWidget(context: context);
        }
        return const SizedBox();
      },
    );
  }
}
