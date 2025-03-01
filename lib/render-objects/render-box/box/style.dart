import 'package:flutter/material.dart' hide CrossAxisAlignment;
import './box_model.dart';


final $box = StyledBoxUtils();


class StyledBoxUtils {

  final boxSizing = BoxSizingUtils();

  final margin = EdgeInsetUtils();

  final border = BorderUtils();

  final padding = EdgeInsetUtils();

  final borderRadius = BorderRadiusUtils();

  final flexDirection = FlexDirectionUtils();

  final contentAlignment = ContentAlignmentUtils();

  final itemAlignment = ItemAlignmentUtils();

  final overflow = OverflowUtils();

  final boxShadow = BoxShadowUtils();

}


class BoxSizingUtils {

  BoxSizing get borderBox {
    return BoxSizing.BORDER_BOX;
  }

  BoxSizing get contentBox {
    return BoxSizing.CONTENT_BOX;
  }

}

class EdgeInsetUtils {

  EdgeInsetsUnit call(Unit value) {
    return EdgeInsetsUnit.all(value);
  }

  EdgeInsetsUnit horizontal(Unit value) {
    return EdgeInsetsUnit.horizontal(value);
  }

  EdgeInsetsUnit vertical(Unit value) {
    return EdgeInsetsUnit.vertical(value);
  }

  EdgeInsetsUnit symmetric({
    Unit horizontal = Unit.zero,
    Unit vertical = Unit.zero,
  }) {
    return EdgeInsetsUnit.symmetric(
      horizontal: horizontal,
      vertical: vertical,
    );
  }

  EdgeInsetsUnit only({
    Unit top = Unit.zero,
    Unit right = Unit.zero,
    Unit bottom = Unit.zero,
    Unit left = Unit.zero,
  }) {
    return EdgeInsetsUnit.only(
      top: top,
      right: right,
      bottom: bottom,
      left: left,
    );
  }

  EdgeInsetsUnit top(Unit value) {
    return EdgeInsetsUnit.only(top: value);
  }

  EdgeInsetsUnit left(Unit value) {
    return EdgeInsetsUnit.only(left: value);
  }

  EdgeInsetsUnit bottom(Unit value) {
    return EdgeInsetsUnit.only(bottom: value);
  }

  EdgeInsetsUnit right(Unit value) {
    return EdgeInsetsUnit.only(right: value);
  }

}

class BorderUtils {

  BorderEdgeInsetsUnit call({
    required Unit width,
    BorderUnitStyle style = BorderUnitStyle.SOLID,
    Color color = Colors.black,
  }) {
    return BorderEdgeInsetsUnit.all(
      this.side(
        width: width,
        style: style,
        color: color,
      )
    );
  }

  BorderSideUnit side({
    required Unit width,
    BorderUnitStyle style = BorderUnitStyle.SOLID,
    Color color = Colors.black,
  }) {
    return BorderSideUnit(
      style: style,
      width: width,
      color: color,
    );
  }

  BorderEdgeInsetsUnit only({
    BorderSideUnit? topSide,
    BorderSideUnit? rightSide,
    BorderSideUnit? bottomSide,
    BorderSideUnit? leftSide,
  }) {
    return BorderEdgeInsetsUnit.only(
      topSide: topSide ?? BorderSideUnit.none,
      rightSide: rightSide ?? BorderSideUnit.none,
      bottomSide: bottomSide ?? BorderSideUnit.none,
      leftSide: leftSide ?? BorderSideUnit.none,
    );
  }

  BorderEdgeInsetsUnit top({
    required Unit width,
    BorderUnitStyle style = BorderUnitStyle.SOLID,
    Color color = Colors.black,
  }) {
    return this.only(
      topSide: this.side(
        style: style,
        width: width,
        color: color,
      )
    );
  }

  BorderEdgeInsetsUnit left({
    required Unit width,
    BorderUnitStyle style = BorderUnitStyle.SOLID,
    Color color = Colors.black,
  }) {
    return this.only(
      leftSide: this.side(
        style: style,
        width: width,
        color: color,
      )
    );
  }

  BorderEdgeInsetsUnit bottom({
    required Unit width,
    BorderUnitStyle style = BorderUnitStyle.SOLID,
    Color color = Colors.black,
  }) {
    return this.only(
      bottomSide: this.side(
        style: style,
        width: width,
        color: color,
      )
    );
  }

  BorderEdgeInsetsUnit right({
    required Unit width,
    BorderUnitStyle style = BorderUnitStyle.SOLID,
    Color color = Colors.black,
  }) {
    return this.only(
      rightSide: this.side(
        style: style,
        width: width,
        color: color,
      )
    );
  }

}


class BorderRadiusUtils {

  BorderRadiusUnit call(Unit value) {
    return BorderRadiusUnit.all(value);
  }

  BorderRadiusUnit only({
    Unit topLeft = Unit.zero,
    Unit topRight = Unit.zero,
    Unit bottomRight = Unit.zero,
    Unit bottomLeft = Unit.zero,
  }) {
    return BorderRadiusUnit(
      topLeft: topLeft,
      topRight: topRight,
      bottomRight: bottomRight,
      bottomLeft: bottomLeft,
    );
  }

}

class FlexDirectionUtils {

  FlexDirection get vertical {
    return FlexDirection.VERTICAL;
  }

  FlexDirection get verticalReverse {
    return FlexDirection.VERTICAL_REVERSE;
  }

  FlexDirection get horizontal {
    return FlexDirection.HORIZONTAL;
  }

  FlexDirection get horizontalReverse {
    return FlexDirection.HORIZONTAL_REVERSE;
  }

}

class ContentAlignmentUtils {

  ContentAlignment get flexStart {
    return ContentAlignment.FLEX_START;
  }

  ContentAlignment get flexEnd {
    return ContentAlignment.FLEX_END;
  }

  ContentAlignment get center {
    return ContentAlignment.CENTER;
  }

  ContentAlignment get spaceBetween {
    return ContentAlignment.SPACE_BETWEEN;
  }

  ContentAlignment get spaceAround {
    return ContentAlignment.SPACE_AROUND;
  }

  ContentAlignment get spaceEvenly {
    return ContentAlignment.SPACE_EVENLY;
  }

}

class ItemAlignmentUtils {

  ItemAlignment get flexStart {
    return ItemAlignment.FLEX_START;
  }

  ItemAlignment get flexEnd {
    return ItemAlignment.FLEX_END;
  }

  ItemAlignment get center {
    return ItemAlignment.CENTER;
  }

  ItemAlignment get stretch {
    return ItemAlignment.STRETCH;
  }

}

class OverflowUtils {

  Overflow get visible {
    return Overflow.VISIBLE;
  }

  Overflow get hidden {
    return Overflow.HIDDEN;
  }

}

class BoxShadowUtils {

  call({
    Offset offset = Offset.zero,
    Color color = Colors.black,
    BlurStyle blurStyle = BlurStyle.outer,
    double blurRadius = 0.0,
    double spreadRadius = 0.0,
  }) {
    return BoxShadowStyle(
      offset: offset,
      color: color,
      blurStyle: blurStyle,
      blurRadius: blurRadius,
      spreadRadius: spreadRadius,
    );
  }

}


class Style {

  const Style({
    this.name,
    this.expandChildHorizontal = false,
    this.expandChildVertical = false,
    this.boxSizing = BoxSizing.BORDER_BOX,
    this.margin,
    this.border,
    this.borderRadius = BorderRadiusUnit.zero,
    this.padding,
    this.outline,
    this.aspectRatio,
    this.width = Unit.auto,
    this.minWidth,
    this.maxWidth,
    this.height = Unit.auto,
    this.minHeight,
    this.maxHeight,
    this.backgroundColor,
    this.color,
    this.overflow = Overflow.VISIBLE,
    this.opacity = 1,
    this.boxShadow,

    this.alignSelf,
    this.flexGrow = 0,
    this.flexShrink = 0,
    this.flexDirection = FlexDirection.VERTICAL,
    this.justifyContent = ContentAlignment.FLEX_START,
    this.alignContent = ContentAlignment.FLEX_START,
    this.alignItems = ItemAlignment.FLEX_START,
    this.flexWrap = FlexWrap.NOWRAP,
    this.verticalGap = Unit.zero,
    this.horizontalGap = Unit.zero,
  });

  final String? name;

  final bool expandChildHorizontal;

  final bool expandChildVertical;

  final BoxSizing boxSizing;

  final EdgeInsetsUnit? margin;

  final BorderEdgeInsetsUnit? border;

  final BorderRadiusUnit borderRadius;

  final EdgeInsetsUnit? padding;

  final BorderEdgeInsetsUnit? outline;

  final double? aspectRatio;

  final Unit width;

  final Unit? minWidth;

  final Unit? maxWidth;

  final Unit height;

  final Unit? minHeight;

  final Unit? maxHeight;

  final Color? backgroundColor;

  final Color? color;

  final Overflow overflow;

  final double opacity;

  final BoxShadowStyle? boxShadow;

  // FlexBox

  final double flexGrow;

  final double flexShrink;

  final FlexDirection flexDirection;

  final ContentAlignment justifyContent;

  final ContentAlignment alignContent;

  final ItemAlignment alignItems;

  final ItemAlignment? alignSelf;

  final FlexWrap flexWrap;

  final Unit verticalGap;

  final Unit horizontalGap;

  Style copyWith({
    String? name,
    bool? expandChildHorizontal,
    bool? expandChildVertical,
    BoxSizing? boxSizing,
    EdgeInsetsUnit? margin,
    BorderEdgeInsetsUnit? border,
    BorderRadiusUnit? borderRadius,
    EdgeInsetsUnit? padding,
    Unit? width,
    Unit? minWidth,
    Unit? maxWidth,
    Unit? height,
    Unit? minHeight,
    Unit? maxHeight,
    Color? backgroundColor,
    Color? color,
    Overflow? overflow,
    double? opacity,
    double? flexGrow,
    double? flexShrink,
    FlexDirection? flexDirection,
    ContentAlignment? justifyContent,
    ContentAlignment? alignContent,
    ItemAlignment? alignItems,
    ItemAlignment? alignSelf,
    FlexWrap? flexWrap,
    Unit? verticalGap,
    Unit? horizontalGap,
  }) {
    return Style(
      name: name ?? this.name,
      expandChildHorizontal: expandChildHorizontal ?? this.expandChildHorizontal,
      expandChildVertical: expandChildVertical ?? this.expandChildVertical,
      boxSizing: boxSizing ?? this.boxSizing,
      margin: margin ?? this.margin,
      border: border ?? this.border,
      borderRadius: borderRadius ?? this.borderRadius,
      padding: padding ?? this.padding,
      width: width ?? this.width,
      minWidth: minWidth ?? this.minWidth,
      maxWidth: maxWidth ?? this.maxWidth,
      height: height ?? this.height,
      minHeight: minHeight ?? this.minHeight,
      maxHeight: maxHeight ?? this.maxHeight,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      color: color ?? this.color,
      overflow: overflow ?? this.overflow,
      opacity: opacity ?? this.opacity,
      flexGrow: flexGrow ?? this.flexGrow,
      flexShrink: flexShrink ?? this.flexShrink,
      flexDirection: flexDirection ?? this.flexDirection,
      justifyContent: justifyContent ?? this.justifyContent,
      alignContent: alignContent ?? this.alignContent,
      alignItems: alignItems ?? this.alignItems,
      alignSelf: alignSelf ?? this.alignSelf,
      flexWrap: flexWrap ?? this.flexWrap,
      verticalGap: verticalGap ?? this.verticalGap,
      horizontalGap: horizontalGap ?? this.horizontalGap,
    );
  }

}

class BoxShadowStyle {

  const BoxShadowStyle({
    this.offset = Offset.zero,
    this.color = Colors.black,
    this.blurStyle = BlurStyle.outer,
    this.blurRadius = 0.0,
    this.spreadRadius = 0.0,
  });

  final Offset offset;

  final Color color;

  final BlurStyle blurStyle;

  final double blurRadius;

  final double spreadRadius;

}

enum Overflow {

  VISIBLE,

  HIDDEN,

}


enum FlexDirection {

  VERTICAL,

  VERTICAL_REVERSE,

  HORIZONTAL,

  HORIZONTAL_REVERSE,

  ;

  static isReversed(FlexDirection direction) {
    return [
      FlexDirection.VERTICAL_REVERSE,
      FlexDirection.HORIZONTAL_REVERSE,
    ].contains(direction);
  }

  static isVertical(FlexDirection direction) {
    return [
      FlexDirection.VERTICAL,
      FlexDirection.VERTICAL_REVERSE,
    ].contains(direction);
  }

  static isHorizontal(FlexDirection direction) {
    return [
      FlexDirection.HORIZONTAL,
      FlexDirection.HORIZONTAL_REVERSE,
    ].contains(direction);
  }

  static getAxisFrom(FlexDirection direction) {
    if (FlexDirection.isVertical(direction)) {
      return Axis.vertical;
    }

    return Axis.horizontal;
  }

}

enum FlexWrap {

  NOWRAP,

  WRAP,

  WRAP_REVERSE,

}

enum ContentAlignment {

  FLEX_START,

  FLEX_END,

  CENTER,

  SPACE_BETWEEN,

  SPACE_AROUND,

  SPACE_EVENLY,

}



enum ItemAlignment {

  FLEX_START,

  FLEX_END,

  CENTER,

  STRETCH,

}




enum UnitType {

  // Keywords

  AUTO,

  ZERO,

  // Normal units

  PX,

  // FR,

  // Containing Block Size
  PR,

  // Relative to own box size
  // Obviously cannot be used in width and height
  // Box Model
  BM,

  /// Container Size
  CQ,

}

extension UnitTypeExtension on num {

  Unit toUnit({
    required UnitType unit,
  }) {
    return Unit(
      value: this.toDouble(),
      unit: unit,
    );
  }

  Unit get px {
    return this.toUnit(unit: UnitType.PX);
  }

  // Unit get fr {
  //   return this.toUnit(unit: UnitType.FR);
  // }

  Unit get pr {
    return this.toUnit(unit: UnitType.PR);
  }

  Unit get cq {
    return this.toUnit(unit: UnitType.CQ);
  }

}

class Unit {

  const Unit({
    required this.value,
    required this.unit,
  });

  final double value;

  final UnitType unit;

  static const auto = Unit(
    value: 0,
    unit: UnitType.AUTO,
  );

  static const zero = Unit(
    value: 0,
    unit: UnitType.ZERO,
  );

  @override
  String toString() {
    return 'Unit(value: ${this.value}, unit: ${this.unit})';
  }

}


class EdgeInsetsUnit {

  const EdgeInsetsUnit.only({
    this.top = Unit.zero,
    this.right = Unit.zero,
    this.bottom = Unit.zero,
    this.left = Unit.zero,
  });

  final Unit top;

  final Unit right;

  final Unit bottom;

  final Unit left;

  const EdgeInsetsUnit.all(Unit unit) : this.only(
      top: unit,
      right: unit,
      bottom: unit,
      left: unit,
    );

  const EdgeInsetsUnit.fromLTRB(Unit left, Unit top, Unit right, Unit bottom) : this.only(
      top: top,
      right: right,
      bottom: bottom,
      left: left,
    );

  const EdgeInsetsUnit.horizontal(Unit unit) : this.only(
      top: Unit.zero,
      right: unit,
      bottom: Unit.zero,
      left: unit,
    );

  const EdgeInsetsUnit.vertical(Unit unit) : this.only(
      top: unit,
      right: Unit.zero,
      bottom: unit,
      left: Unit.zero,
    );

  const EdgeInsetsUnit.symmetric({
    Unit horizontal = Unit.zero,
    Unit vertical = Unit.zero,
  }) : this.only(
      top: vertical,
      right: horizontal,
      bottom: vertical,
      left: horizontal,
    );

}


class BorderSideUnit {

  const BorderSideUnit({
    this.style = BorderUnitStyle.SOLID,
    required this.width,
    this.color  = Colors.transparent,
  });

  static const none = BorderSideUnit(
    width: Unit.zero,
    style: BorderUnitStyle.NONE,
  );

  final Unit width;

  final Color color;

  final BorderUnitStyle style;

}

class BorderEdgeInsetsUnit {

  const BorderEdgeInsetsUnit.only({
    this.topSide = BorderSideUnit.none,
    this.rightSide = BorderSideUnit.none,
    this.bottomSide = BorderSideUnit.none,
    this.leftSide = BorderSideUnit.none,
  });

  final BorderSideUnit topSide;

  final BorderSideUnit rightSide;

  final BorderSideUnit bottomSide;

  final BorderSideUnit leftSide;

  Unit get top {
    return this.topSide.width;
  }

  Unit get right {
    return this.rightSide.width;
  }

  Unit get bottom {
    return this.bottomSide.width;
  }

  Unit get left {
    return this.leftSide.width;
  }

  const BorderEdgeInsetsUnit.all(BorderSideUnit side)
    : this.only(
      topSide: side,
      rightSide: side,
      bottomSide: side,
      leftSide: side,
    );

  const BorderEdgeInsetsUnit.fromLTRB(BorderSideUnit left, BorderSideUnit top, BorderSideUnit right, BorderSideUnit bottom)
    : this.only(
      topSide: top,
      rightSide: right,
      bottomSide: bottom,
      leftSide: left,
    );

  const BorderEdgeInsetsUnit.horizontal(BorderSideUnit side)
    : this.only(
      topSide: side,
      rightSide: side,
      bottomSide: side,
      leftSide: side,
    );

  const BorderEdgeInsetsUnit.vertical(BorderSideUnit side)
    : this.only(
      topSide: side,
      rightSide: side,
      bottomSide: side,
      leftSide: side,
    );

  const BorderEdgeInsetsUnit.symmetric({
    required BorderSideUnit horizontal,
    required BorderSideUnit vertical,
  }) : this.only(
      topSide: vertical,
      rightSide: horizontal,
      bottomSide: vertical,
      leftSide: horizontal,
    );

}


class BorderRadiusUnit {

  const BorderRadiusUnit({
    this.topLeft = Unit.zero,
    this.topRight = Unit.zero,
    this.bottomRight = Unit.zero,
    this.bottomLeft = Unit.zero,
  });

  const BorderRadiusUnit.all(Unit radius)
    : this(
      topLeft: radius,
      topRight: radius,
      bottomRight: radius,
      bottomLeft: radius,
    );

  const BorderRadiusUnit.horizontal({
    Unit left = Unit.zero,
    Unit right = Unit.zero,
  }) : this(
    topLeft: left,
    topRight: right,
    bottomLeft: left,
    bottomRight: right,
  );

  const BorderRadiusUnit.vertical({
    Unit top = Unit.zero,
    Unit bottom = Unit.zero,
  }) : this(
    topLeft: top,
    topRight: top,
    bottomLeft: bottom,
    bottomRight: bottom,
  );

  BorderRadiusUnit copyWith({
    Unit? topLeft,
    Unit? topRight,
    Unit? bottomRight,
    Unit? bottomLeft,
  }) {
    return BorderRadiusUnit(
      topLeft: topLeft ?? this.topLeft,
      topRight: topRight ?? this.topRight,
      bottomRight: bottomRight ?? this.bottomRight,
      bottomLeft: bottomLeft ?? this.bottomLeft,
    );
  }

  final Unit topLeft;

  final Unit topRight;

  final Unit bottomRight;

  final Unit bottomLeft;

  static const zero = BorderRadiusUnit();

}
