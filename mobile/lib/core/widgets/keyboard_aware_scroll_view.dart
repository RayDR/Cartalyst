import 'package:flutter/material.dart';

class KeyboardAwareScrollView extends StatelessWidget {
  const KeyboardAwareScrollView({
    required this.child,
    super.key,
    this.padding = EdgeInsets.zero,
    this.fillViewport = false,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final bool fillViewport;

  @override
  Widget build(BuildContext context) {
    final EdgeInsets resolvedPadding =
        padding.resolve(Directionality.of(context));
    final EdgeInsets viewInsets = MediaQuery.viewInsetsOf(context);

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final bool canFillViewport =
            fillViewport && constraints.hasBoundedHeight;
        final Widget content = canFillViewport
            ? ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: child,
              )
            : child;

        return SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: resolvedPadding.add(
            EdgeInsets.only(bottom: viewInsets.bottom),
          ),
          child: content,
        );
      },
    );
  }
}
