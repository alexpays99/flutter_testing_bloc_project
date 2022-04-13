import 'package:flutter/material.dart';

typedef DialogOptionBuilder<T> = Map<String, T?> Function();

Future<T?> shoGenericDialog<T>({
  required BuildContext context,
  required String title,
  required String content,
  required DialogOptionBuilder optionsBuilder,
}) {
  final options = optionsBuilder();
  return showDialog<T?>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: options.keys.map((optionTitle) {
          final value = options[optionTitle];
          return TextButton(
            onPressed: () {
              if (value != null) {
                Navigator.of(context).pop(
                  value,
                ); // if value is not null, it will be poped with this value back to the context
              } else {
                Navigator.of(context)
                    .pop(); // if value is null, it just pop to the context
              }
            },
            child: Text(optionTitle),
          );
        }).toList(),
      );
    },
  );
}
