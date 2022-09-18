part of 'flira_bloc.dart';

enum FliraStatus {
  initial,
  loading,
  success,
  failure,
}

class FliraState extends Equatable {
  const FliraState({
    this.materialAppHeight,
    this.materialAppWidth,
    this.initialButtonHeight,
    this.initialButtonWidth,
    this.alignment,
    this.status,
  });
  const FliraState.initial()
      : this(
          materialAppHeight: 0,
          materialAppWidth: 0,
          initialButtonHeight: 0,
          initialButtonWidth: 0,
          alignment: Alignment.bottomRight,
          status: FliraStatus.initial,
        );
  final double? materialAppWidth;
  final double? materialAppHeight;
  final double? initialButtonWidth;
  final double? initialButtonHeight;
  final AlignmentGeometry? alignment;
  final FliraStatus? status;

  FliraState copyWith({
    double? materialAppWidth,
    double? materialAppHeight,
    double? initialButtonWidth,
    double? initialButtonHeight,
    AlignmentGeometry? alignment,
    FliraStatus? status,
  }) {
    return FliraState(
      materialAppWidth: materialAppWidth ?? this.materialAppWidth,
      materialAppHeight: materialAppHeight ?? this.materialAppHeight,
      initialButtonWidth: initialButtonWidth ?? this.initialButtonWidth,
      initialButtonHeight: initialButtonHeight ?? this.initialButtonHeight,
      alignment: alignment ?? this.alignment,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [
        materialAppWidth,
        materialAppHeight,
        initialButtonWidth,
        initialButtonHeight,
        alignment,
        status,
      ];
}
