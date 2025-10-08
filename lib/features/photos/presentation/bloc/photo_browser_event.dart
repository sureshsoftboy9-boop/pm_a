import 'package:equatable/equatable.dart';

abstract class PhotoBrowserEvent extends Equatable {
  const PhotoBrowserEvent();

  @override
  List<Object> get props => [];
}

class LoadDirectory extends PhotoBrowserEvent {
  final String path;
  final bool recursive;

  const LoadDirectory({
    required this.path,
    this.recursive = false,
  });

  @override
  List<Object> get props => [path, recursive];
}

class NavigateBack extends PhotoBrowserEvent {}

class ToggleViewMode extends PhotoBrowserEvent {}

class SelectPhoto extends PhotoBrowserEvent {
  final String path;
  final bool selected;

  const SelectPhoto({
    required this.path,
    required this.selected,
  });

  @override
  List<Object> get props => [path, selected];
}

class ClearSelection extends PhotoBrowserEvent {}

class RefreshCurrentDirectory extends PhotoBrowserEvent {}
