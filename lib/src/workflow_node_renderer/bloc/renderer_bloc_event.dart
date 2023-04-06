part of 'renderer_bloc.dart';

class AthinganiRendererBlocEvent {}

class AthinganiRendererBlocEventNodesAvailable extends AthinganiRendererBlocEvent {}

class AthinganiRendererBlocEventCheckSelection extends AthinganiRendererBlocEvent {
  final Offset localPosition;

  AthinganiRendererBlocEventCheckSelection({required this.localPosition});
}

class AthinganiRendererBlocEventCheckNewLink extends AthinganiRendererBlocEvent {
  final Offset localPosition;

  AthinganiRendererBlocEventCheckNewLink({required this.localPosition});
}

class AthinganiRendererBlocEventMoveSelection extends AthinganiRendererBlocEvent {
  final Offset position;
  AthinganiRendererBlocEventMoveSelection({required this.position});
}
