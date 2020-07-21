import 'package:flutter/material.dart';

Future<T> showLoadingModal<T>(BuildContext context, Future<T> task()) async {
  BuildContext modalContext;
  Navigator.push(
    context,
    PageRouteBuilder(
      barrierDismissible: false,
      opaque: false,
      pageBuilder: (context, animation, _) {
        modalContext = context;
        return FadeTransition(
          opacity: animation,
          child: WillPopScope(
            onWillPop: () async => false  ,
            child: DecoratedBox(
              decoration: BoxDecoration(color: Colors.black54),
              child: Center(child: CircularProgressIndicator()),
            ),
          ),
        );
      },
    ),
  );

  final result = await Future.wait([task(), Future.delayed(Duration(seconds: 1))]);
  Navigator.pop(modalContext);
  return result.first;
}
