import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../../../../injector.dart';
import '../../controllers/connection_state_controller.dart';
import '../../controllers/navigation_controller.dart';
import '../../dialogs/no_connection_dialog.dart';

class ConnectionAppBar extends StatelessWidget implements PreferredSizeWidget {
  final NavigationController _navigationController = inject();
  final ConnectionStateController _connectionStateController = inject();
  final Icon? icon;
  final String? title;
  final List<Widget>? actions;

  ConnectionAppBar({this.icon, this.title, this.actions, Key? key})
      : preferredSize = const Size.fromHeight(kToolbarHeight),
        super(key: key);

  @override
  final Size preferredSize;

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        final isConnected = _connectionStateController.isConnected;

        return AppBar(
          leading: (ModalRoute.of(context)?.impliesAppBarDismissal ?? false)
              ? BackButton(
                  onPressed: _navigationController.navigateBack,
                )
              : null,
          backgroundColor: _getBackgroundColor(isConnected),
          title: _buildTitle(),
          actions: _buildActions(context, isConnected),
        );
      },
    );
  }

  Color? _getBackgroundColor(bool isConnected) {
    return !isConnected ? Colors.redAccent : null;
  }

  Widget? _buildTitle() {
    if (icon == null && title == null) return null;

    return Row(
      children: [
        if (icon != null) icon!,
        const SizedBox(width: 12),
        if (title != null) Text(title!),
      ],
    );
  }

  List<Widget> _buildActions(BuildContext context, bool isConnected) {
    final List<Widget> widgets = [];

    if (!isConnected) {
      widgets.addAll([
        IconButton(
          onPressed: () => showNoConnectionDialog(context),
          icon: const Icon(Icons.wifi_off_rounded),
        ),
      ]);
    }
    if (actions != null) {
      widgets.addAll(actions!);
    }

    return widgets;
  }
}
