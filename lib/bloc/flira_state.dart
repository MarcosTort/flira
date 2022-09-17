part of 'flira_bloc.dart';

class FliraState extends Equatable {
  const FliraState({
    this.materialAppHeight,
    this.materialAppWidth,
    this.initialButtonHeight,
    this.initialButtonWidth,
    this.padding
  });
  const FliraState.initial()
      : this(
          materialAppHeight: 0,
          materialAppWidth: 0,
          initialButtonHeight: 0,
          initialButtonWidth: 0,
          padding: 100,
        );
  final double? materialAppWidth;
  final double? materialAppHeight;
  final double? initialButtonWidth;
  final double? initialButtonHeight;
  final double? padding;

  FliraState copyWith({
    double? materialAppWidth,
    double? materialAppHeight,
    double? initialButtonWidth,
    double? initialButtonHeight,
    double? opacity,
  }) {
    return FliraState(
      materialAppWidth: materialAppWidth ?? this.materialAppWidth,
      materialAppHeight: materialAppHeight ?? this.materialAppHeight,
      initialButtonWidth: initialButtonWidth ?? this.initialButtonWidth,
      initialButtonHeight: initialButtonHeight ?? this.initialButtonHeight,
      padding: opacity ?? this.padding,
    );
  }
  @override
  List<Object?> get props => [
        materialAppWidth,
        materialAppHeight,
        initialButtonWidth,
        initialButtonHeight,
        padding,
      ];
  
}
