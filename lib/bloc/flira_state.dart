part of 'flira_bloc.dart';

enum FliraStatus {
  initial,
  loading,
  success,
  failure,
}
enum ButtonStatus {
  expanded,
  collapsed,
  window
}

class FliraState extends Equatable {
  const FliraState({
    this.materialAppHeight,
    this.materialAppWidth,
    this.initialButtonHeight,
    this.initialButtonWidth,
    this.alignment,
    this.status,
    this.filePickerResult,
    this.atlassianApiToken,
    this.atlassianUser,
    this.atlassianUrlPrefix,
    required this.triggeringMethod,
    this.reportDialogOpen = false,
    required this.buttonStatus,
  });
  const FliraState.initial()
      : this(
          materialAppHeight: 100,
          materialAppWidth: 10,
          initialButtonHeight: 100,
          initialButtonWidth: 10,
          alignment: Alignment.centerLeft,
          status: FliraStatus.initial,
          triggeringMethod: TriggeringMethod.none,
          buttonStatus: ButtonStatus.collapsed,
        );
  final double? materialAppWidth;
  final double? materialAppHeight;
  final double? initialButtonWidth;
  final double? initialButtonHeight;
  final AlignmentGeometry? alignment;
  final FliraStatus? status;
  final FilePickerResult? filePickerResult;
  final TriggeringMethod triggeringMethod;
  final String? atlassianApiToken;
  final String? atlassianUser;
  final String? atlassianUrlPrefix;
  final bool reportDialogOpen;
  final ButtonStatus buttonStatus;

  FliraState copyWith({
    double? materialAppWidth,
    double? materialAppHeight,
    double? initialButtonWidth,
    double? initialButtonHeight,
    AlignmentGeometry? alignment,
    FliraStatus? status,
    FilePickerResult? filePickerResult,
    TriggeringMethod? triggeringMethod,
    String? atlassianApiToken,
    String? atlassianUser,
    String? atlassianUrlPrefix,
    bool? reportDialogOpen,
    ButtonStatus? buttonStatus,
  }) {
    return FliraState(
      materialAppWidth: materialAppWidth ?? this.materialAppWidth,
      materialAppHeight: materialAppHeight ?? this.materialAppHeight,
      initialButtonWidth: initialButtonWidth ?? this.initialButtonWidth,
      initialButtonHeight: initialButtonHeight ?? this.initialButtonHeight,
      filePickerResult: filePickerResult ?? this.filePickerResult,
      alignment: alignment ?? this.alignment,
      status: status ?? this.status,
      triggeringMethod: triggeringMethod ?? this.triggeringMethod,
      atlassianApiToken: atlassianApiToken ?? this.atlassianApiToken,
      atlassianUser: atlassianUser ?? this.atlassianUser,
      atlassianUrlPrefix: atlassianUrlPrefix ?? this.atlassianUrlPrefix,
      reportDialogOpen: reportDialogOpen ?? this.reportDialogOpen,
      buttonStatus: buttonStatus ?? this.buttonStatus,
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
        filePickerResult,
        triggeringMethod,
        atlassianApiToken,
        atlassianUser,
        atlassianUrlPrefix,
        reportDialogOpen,
        buttonStatus,
      ];
}
