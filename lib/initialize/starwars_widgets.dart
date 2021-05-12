import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:starwars_live/main.dart';

const SW_BORDER_SIDE = BorderSide(
  color: MAIN_COLOR,
  style: BorderStyle.solid,
  width: 3.0,
);

class StarWarsBorder extends BeveledRectangleBorder {
  StarWarsBorder({required double corner})
      : super(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(corner),
            bottomRight: Radius.circular(corner),
          ),
        );
}

class StarWarsButton extends OutlineButton {
  StarWarsButton({
    Key? key,
    VoidCallback? onPressed,
    VoidCallback? onLongPress,
    MouseCursor? mouseCursor,
    ButtonTextTheme? textTheme,
    Color? textColor,
    Color? disabledTextColor,
    Color? color,
    Color? focusColor,
    Color? hoverColor,
    Color? highlightColor,
    Color? splashColor,
    double? highlightElevation,
    BorderSide? borderSide,
    Color? disabledBorderColor,
    Color? highlightedBorderColor,
    EdgeInsetsGeometry? padding,
    VisualDensity? visualDensity,
    ShapeBorder? shape,
    Clip clipBehavior = Clip.none,
    FocusNode? focusNode,
    bool autofocus = false,
    MaterialTapTargetSize? materialTapTargetSize,
    double? borderWidth,
    double corner = 10.0,
    required Widget child,
  }) : super(
            key: key,
            onPressed: onPressed,
            onLongPress: onLongPress,
            mouseCursor: mouseCursor,
            textTheme: textTheme,
            textColor: textColor ?? MAIN_COLOR,
            disabledTextColor: disabledTextColor ?? MAIN_COLOR_INACTIVE,
            color: color,
            focusColor: focusColor,
            hoverColor: hoverColor,
            highlightColor: highlightColor,
            splashColor: splashColor,
            highlightElevation: highlightElevation,
            borderSide: borderSide ??
                SW_BORDER_SIDE.copyWith(
                  width: borderWidth ?? 3.0,
                ),
            disabledBorderColor: disabledBorderColor ?? MAIN_COLOR_INACTIVE,
            highlightedBorderColor: highlightedBorderColor,
            padding: padding,
            visualDensity: visualDensity,
            shape: shape ?? StarWarsBorder(corner: corner),
            clipBehavior: clipBehavior,
            focusNode: focusNode,
            autofocus: autofocus,
            materialTapTargetSize: materialTapTargetSize,
            child: child);
}

class StarWarsMenuButton extends StarWarsButton {
  StarWarsMenuButton({
    VoidCallback? onPressed,
    Color? disabledBorderColor,
    EdgeInsetsGeometry? padding,
    required Widget child,
  }) : super(
          onPressed: onPressed,
          disabledBorderColor: disabledBorderColor,
          padding: padding,
          corner: 20.0,
          child: child,
        );
}

class StarWarsTextButton extends StarWarsMenuButton {
  StarWarsTextButton({required String text, VoidCallback? onPressed})
      : super(
          padding: EdgeInsets.all(16),
          child: FittedBox(child: Text(text)),
          onPressed: onPressed,
        );
}

class StarWarsMenuFrame extends Padding {
  StarWarsMenuFrame({required Widget child})
      : super(
          padding: EdgeInsets.all(8),
          child: StarWarsMenuButton(
            onPressed: null,
            disabledBorderColor: MAIN_COLOR,
            child: child,
          ),
        );
}

class StarWarsSwipeToDismissScreen extends StatelessWidget {
  final Widget child;

  StarWarsSwipeToDismissScreen({required this.child});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: StarWarsScreen(child: child),
      onHorizontalDragEnd: (details) => Navigator.of(context).pop(),
    );
  }
}

class StarWarsScreen extends StatelessWidget {
  final Widget child;

  StarWarsScreen({required this.child});

  @override
  Widget build(BuildContext context) {
    return StarWarsMenuFrame(
      child: Container(
        constraints: BoxConstraints.expand(),
        child: child,
      ),
    );
  }
}

class DoubleTextSizeTheme extends FontScaleTheme {
  const DoubleTextSizeTheme({Key? key, required Widget child}) : super(key: key, child: child, factor: 2.0);
}

class FontScaleTheme extends StatelessWidget {
  final double factor;
  final Widget child;

  const FontScaleTheme({Key? key, required this.child, required this.factor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(textTheme: Theme.of(context).textTheme.apply(fontSizeFactor: factor)),
      child: child,
    );
  }
}

class StarWarsMasterDetailScreen extends StatelessWidget {
  final Widget masterChild;
  final List<Widget> detailChildren;
  final double masterTextFactor;
  final double detailTextFactor;

  const StarWarsMasterDetailScreen({
    Key? key,
    required this.masterChild,
    required this.detailChildren,
    this.masterTextFactor = 1.0,
    this.detailTextFactor = 1.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          FontScaleTheme(
            factor: masterTextFactor,
            child: Expanded(
              flex: 4,
              child: StarWarsMenuFrame(child: masterChild),
            ),
          ),
          FontScaleTheme(
            factor: detailTextFactor,
            child: Expanded(
              flex: 1,
              child: StarWarsScreen(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: detailChildren.map((child) => Padding(padding: EdgeInsets.all(8), child: child)).toList(growable: false),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
