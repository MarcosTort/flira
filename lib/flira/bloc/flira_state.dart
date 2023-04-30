part of 'flira_bloc.dart';

enum FliraStatus {
  initial,
  loading,
  loaded,
  error,
  fliraStarted,
  failure, initSuccess,
}

class FliraState extends Equatable {
  const FliraState({
    required this.status,
    this.materialAppHeight,
    this.materialAppWidth,
    this.initialButtonHeight,
    this.initialButtonWidth,
    this.reportDialogOpen = false,
    this.atlassianApiToken,
    this.atlassianUser,
    this.atlassianUrlPrefix,
    this.alignment,
    this.jiraPlatformApi,
  });

  const FliraState.initial()
      : this(
          status: FliraStatus.initial,
          materialAppHeight: 0,
          materialAppWidth: 0,
          initialButtonHeight: 0,
          initialButtonWidth: 0,
          reportDialogOpen: false,
          alignment: Alignment.bottomRight,
        );

  final FliraStatus status;
  final double? materialAppWidth;
  final double? materialAppHeight;
  final double? initialButtonWidth;
  final double? initialButtonHeight;
  final bool reportDialogOpen;
  final String? atlassianApiToken;
  final String? atlassianUser;
  final String? atlassianUrlPrefix;
  final AlignmentGeometry? alignment;
  final JiraPlatformApi? jiraPlatformApi;

  FliraState copyWith({
    FliraStatus? status,
    double? materialAppWidth,
    double? materialAppHeight,
    double? initialButtonWidth,
    double? initialButtonHeight,
    bool? reportDialogOpen,
    String? atlassianApiToken,
    String? atlassianUser,
    String? atlassianUrlPrefix,
    AlignmentGeometry? alignment,
    JiraPlatformApi? jiraPlatformApi,
  }) {
    return FliraState(
      status: status ?? this.status,
      materialAppWidth: materialAppWidth ?? this.materialAppWidth,
      materialAppHeight: materialAppHeight ?? this.materialAppHeight,
      initialButtonWidth: initialButtonWidth ?? this.initialButtonWidth,
      initialButtonHeight: initialButtonHeight ?? this.initialButtonHeight,
      reportDialogOpen: reportDialogOpen ?? this.reportDialogOpen,
      atlassianApiToken: atlassianApiToken ?? this.atlassianApiToken,
      atlassianUser: atlassianUser ?? this.atlassianUser,
      atlassianUrlPrefix: atlassianUrlPrefix ?? this.atlassianUrlPrefix,
      alignment: alignment ?? this.alignment,
    );
  }

  @override
  List<Object?> get props => [
        status,
        materialAppWidth,
        materialAppHeight,
        initialButtonWidth,
        initialButtonHeight,
        reportDialogOpen,
        atlassianApiToken,
        atlassianUser,
        atlassianUrlPrefix,
        alignment,
      ];
}
