import 'package:flira/consts.dart';
import 'package:flira/flira/bloc/flira_bloc.dart';
import 'package:flira/integrations/jira/bloc/jira_bloc.dart';
import 'package:flira/integrations/jira/view/dialogs/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FloatingButton extends StatelessWidget {
  const FloatingButton({
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocListener<FliraBloc, FliraState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status == FliraStatus.fliraStarted) {
          final projects = context.read<JiraBloc>().state.projects;
          final jiraPlatformApi = context.read<JiraBloc>().state.jiraPlatformApi;
          const JiraReportBugDialog().open(projects, context, jiraPlatformApi );
        }
        if (state.status == JiraStatus.ticketSubmittionError) {
          const ErrorDialog(
            message: ' ',
          ).open(context);
        }
        if (state.status == JiraStatus.ticketSubmittionSuccess) {
          const SuccessDialog().open(context);
        }
        if (state.status == FliraStatus.initSuccess ||
            state.status == FliraStatus.failure) {
          context.read<FliraBloc>().add(InitialButtonTappedEvent());
        }
      },
      child: BlocBuilder<FliraBloc, FliraState>(
        builder: (context, state) {
          final theme = Theme.of(context);
          final width = state.initialButtonWidth;
          final height = state.initialButtonHeight;
          return Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: AnimatedAlign(
              duration: const Duration(milliseconds: 450),
              alignment: Alignment.center,
              child: GestureDetector(
                onVerticalDragStart: (details) {
                  context.read<FliraBloc>().add(FliraButtonDraggedEvent());
                },
                onTap: () async {
                  context
                      .read<FliraBloc>()
                      .add(const CreateJiraPlatformApiRequested());
                },
                child: Material(
                  shape: const CircleBorder(),
                  child: AnimatedContainer(
                    curve: kcurve,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    duration: const Duration(milliseconds: 400),
                    width: width,
                    height: height,
                    child: Center(
                      child: state.status == FliraStatus.initial
                          ? FittedBox(
                              child: Text(
                                'Flira',
                                style: TextStyle(
                                  color: theme.colorScheme.secondary,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            )
                          : CircularProgressIndicator(
                              color: theme.colorScheme.secondary,
                            ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
