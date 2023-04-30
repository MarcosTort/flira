import 'package:flira/consts.dart';
import 'package:flira/integrations/jira/bloc/flira_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsDialog extends StatelessWidget {
  const SettingsDialog({
    super.key,
    this.fromSettings = false,
    this.message =
        'No projects found. Please check your api token and url. To get a new token, go to:\n',
  });
  final bool fromSettings;
  final String message;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AlertDialog(
      title: Column(
        children: [
          Text(
            message,
          ),
          SelectableText(
            katlassianUrl,
            style: TextStyle(color: theme.colorScheme.primary),
          ),
        ],
      ),
      actions: [
        const _ServerNameField(),
        const _EmailField(),
        const _ApiTokenField(),
        _ActionsButtons(fromSettings: fromSettings)
      ],
    );
  }

  void open(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => this,
    );
  }
}

class _ActionsButtons extends StatelessWidget {
  const _ActionsButtons({
    required this.fromSettings,
  });

  final bool fromSettings;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        TextButton(
          onPressed: () {
            if (!fromSettings) {
              context.read<JiraBloc>().add(FliraButtonDraggedEvent());
            }
            Navigator.pop(context);
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            context.read<JiraBloc>().add(
                  const AddCredentialsEvent(),
                );
            await Future.delayed(const Duration(milliseconds: 200))
                .whenComplete(() {
              Navigator.pop(context);
              if (!fromSettings) {
                context.read<JiraBloc>().add(FliraButtonDraggedEvent());
              }
            });
          },
          child: const Text('Ok'),
        ),
      ],
    );
  }
}

class _ApiTokenField extends StatelessWidget {
  const _ApiTokenField();

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: true,
      initialValue:
          context.select((JiraBloc bloc) => bloc.state.atlassianApiToken),
      onChanged: (value) => context.read<JiraBloc>().add(
            TokenTextFieldOnChangedEvent(value),
          ),
      decoration: const InputDecoration(
        hintText: 'Enter your api token',
      ),
    );
  }
}

class _EmailField extends StatelessWidget {
  const _EmailField();

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue:
          context.select((JiraBloc bloc) => bloc.state.atlassianUser),
      onChanged: (value) => context.read<JiraBloc>().add(
            UserTextFieldOnChangedEvent(value),
          ),
      decoration: const InputDecoration(
        hintText: 'Enter your jira user email',
      ),
    );
  }
}

class _ServerNameField extends StatelessWidget {
  const _ServerNameField();

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue:
          context.select((JiraBloc bloc) => bloc.state.atlassianUrlPrefix),
      onChanged: (value) => context.read<JiraBloc>().add(
            UrlTextFieldOnChangedEvent(value),
          ),
      decoration: const InputDecoration(
        hintText: 'Enter your jira server name',
      ),
    );
  }
}
