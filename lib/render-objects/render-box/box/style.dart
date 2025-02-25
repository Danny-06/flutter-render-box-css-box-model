import 'package:flutter/material.dart' hide CrossAxisAlignment;
import '/render-objects/render-box/box/box_model.dart';

class Style {

  const Style({
    this.expandChild = false,
    this.boxSizing = BoxSizing.BORDER_BOX,
    this.margin,
    this.border,
    this.borderRadius = BorderRadiusUnit.zero,
    this.padding,
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

    this.alignSelf,
    this.flexGrow = 0,
    this.flexShrink = 0,
    this.flexDirection = FlexDirection.VERTICAL,
    this.justifyContent = ContentAlignment.FLEX_START,
    this.alignContent = ContentAlignment.FLEX_START,
    this.alignItems = ItemAlignment.FLEX_START,
    this.flexWrap = FlexWrap.NOWRAP,
    this.rowGap = Unit.zero,
    this.columnGap = Unit.zero,
  });

  final bool expandChild;

  final BoxSizing boxSizing;

  final EdgeInsetsUnit? margin;

  final BorderEdgeInsetsUnit? border;

  final BorderRadiusUnit borderRadius;

  final EdgeInsetsUnit? padding;

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

  // FlexBox

  final double flexGrow;

  final double flexShrink;

  final FlexDirection flexDirection;

  final ContentAlignment justifyContent;

  final ContentAlignment alignContent;

  final ItemAlignment alignItems;

  final ItemAlignment? alignSelf;

  final FlexWrap flexWrap;

  final Unit rowGap;

  final Unit columnGap;

  Style merge() {
    return Style();
  }

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

  FR,

  // Containing Block Size
  PR,

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

  Unit get fr {
    return this.toUnit(unit: UnitType.FR);
  }

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
