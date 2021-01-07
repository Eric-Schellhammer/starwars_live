import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:starwars_live/main.dart';

const SW_BORDER_SIDE = BorderSide(
  color: MAIN_COLOR,
  style: BorderStyle.solid,
  width: 3.0,
);

class StarWarsBorder extends BeveledRectangleBorder {
  StarWarsBorder({@required double corner})
      : super(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(corner),
            bottomRight: Radius.circular(corner),
          ),
        );
}

class StarWarsButton extends OutlineButton {
  StarWarsButton({
    Key key,
    @required VoidCallback onPressed,
    VoidCallback onLongPress,
    MouseCursor mouseCursor,
    ButtonTextTheme textTheme,
    Color textColor,
    Color disabledTextColor,
    Color color,
    Color focusColor,
    Color hoverColor,
    Color highlightColor,
    Color splashColor,
    double highlightElevation,
    BorderSide borderSide,
    Color disabledBorderColor,
    Color highlightedBorderColor,
    EdgeInsetsGeometry padding,
    VisualDensity visualDensity,
    ShapeBorder shape,
    Clip clipBehavior = Clip.none,
    FocusNode focusNode,
    bool autofocus = false,
    MaterialTapTargetSize materialTapTargetSize,
    double borderWidth,
    double corner = 10.0,
    Widget child,
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
    @required VoidCallback onPressed,
    Color disabledBorderColor,
    EdgeInsetsGeometry padding,
    Widget child,
  }) : super(
          onPressed: onPressed,
          disabledBorderColor: disabledBorderColor,
          padding: padding,
          corner: 20.0,
          child: child,
        );
}

class StarWarsMenuFrame extends Padding {
  StarWarsMenuFrame({Widget child})
      : super(
          padding: EdgeInsets.all(8),
          child: StarWarsMenuButton(
            onPressed: null,
            disabledBorderColor: MAIN_COLOR,
            child: child,
          ),
        );
}
