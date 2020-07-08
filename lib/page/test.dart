import 'package:florescer/data/data.dart';
import 'package:florescer/widget/wheel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TestPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final data = context.watch<AppData>();
    return Scaffold(
      body: data.categories != null && data.categories.length > 0
          ? WheelOfLife(
              Map.fromEntries(
                context.watch<AppData>().categories.asMap().entries.map(
                      (category) => MapEntry(category.value.shortTitle, category.key + 7.0),
                    ),
              ),
            )
          : CircularProgressIndicator(),
    );
  }
}
