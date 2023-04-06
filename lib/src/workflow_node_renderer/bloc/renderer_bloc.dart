import 'dart:convert';

import 'package:athingani/src/workflow_node_renderer/bloc/renderer_bloc_view_state.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:athingani/src/models/models.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'renderer_bloc_event.dart';
part 'renderer_bloc_state.dart';
part 'parts/on_start.dart';

class AthinganiRendererBloc extends Bloc<AthinganiRendererBlocEvent, AthinganiRendererBlocState> {
  AthinganiRendererBloc() : super(AthinganiRendererBlocStateDefault()) {
    on<AthinganiRendererBlocEventNodesAvailable>(
      (event, emit) => emit(AthinganiRendererBlocStateDefault()),
    );

    on<AthinganiRendererBlocEventCheckSelection>(
      (event, emit) {
        viewState.checkSelection(event.localPosition);
        viewState.checkNewLinkStart(event.localPosition);
        emit(AthinganiRendererBlocStateDefault());
      },
    );

    on<AthinganiRendererBlocEventMoveSelection>(
      (event, emit) {
        viewState.moveSelection(event.position);
        emit(AthinganiRendererBlocStateDefault());
        var json = viewState.asJSON();
        _saveGraph(json);
      },
    );

    on<AthinganiRendererBlocEventCheckNewLink>(
      (event, emit) {
        viewState.checkNewLinkEnd(event.localPosition);
        emit(AthinganiRendererBlocStateDefault());
      },
    );
    //
    _onStart(
      viewState: viewState,
      bloc: this,
    );
  }

  final RendererBlocViewState viewState = RendererBlocViewState();

  /// FIXME only on release click
  void _saveGraph(dynamic data) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("graph", jsonEncode(data));
  }
}
