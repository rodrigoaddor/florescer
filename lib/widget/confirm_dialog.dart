import 'package:flutter/material.dart';

class ConfirmDialog extends StatelessWidget {
  final String title;
  final String body;
  final String cancelText;
  final String confirmText;

  ConfirmDialog({
    @required this.title,
    this.body,
    this.cancelText = 'Cancelar',
    this.confirmText = 'Confirmar',
  });

  @override
  Widget build(BuildContext context) => AlertDialog(
        title: Text(this.title),
        content: this.body != null ? Text(this.body) : null,
        contentPadding: EdgeInsets.fromLTRB(24, 20, 24, 12),
        actions: [
          FlatButton(
            child: Text(this.cancelText),
            onPressed: () => Navigator.pop(context, false),
          ),
          FlatButton(
            child: Text(this.confirmText),
            onPressed: () => Navigator.pop(context, true),
          ),
        ],
      );

  static Future<bool> show({
    @required BuildContext context,
    @required String title,
    String body,
    String cancelText = 'Cancelar',
    String confirmText = 'Confirmar',
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => ConfirmDialog(
        title: title,
        body: body,
        cancelText: cancelText,
        confirmText: confirmText,
      ),
    );
    return result ?? false; // If null, return false
  }
}
