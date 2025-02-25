import 'package:flutter/material.dart';


enum BoxSizing {

  BORDER_BOX,

  CONTENT_BOX,

}

class BoxModel {

  BoxModel({
    this.boxSizing = BoxSizing.BORDER_BOX,
    this.width,
    this.height,
    this.contentWidth,
    this.contentHeight,
    this.margin = const EdgeInsets.all(0),
    this.borderBox = BorderEdgeInsets.none,
    this.paddingBox = const EdgeInsets.all(0),
    this.direction,
    this.horizontalFlexSize,
    this.verticalFlexSize,
    this.borderRadius = BorderRadius.zero,
  }) {
    final width = this.width;
    final height = this.height;
    final contentWidth = this.contentWidth;
    final contentHeight = this.contentHeight;

    if (width == null && contentWidth == null && this.horizontalFlexSize == null) {
      throw Exception('Both width and contentWidth cannot be null');
    }

    if (height == null && contentHeight == null && this.verticalFlexSize == null) {
      throw Exception('Both height and contentHeight cannot be null');
    }

    if (this.boxSizing == BoxSizing.CONTENT_BOX) {
      this.contentBox = Size(
        width ?? contentWidth!,
        height ?? contentHeight!,
      );

      this.borderBoxSize = Size(
        this.contentBox.width + this.paddingBox.horizontal + this.borderBox.horizontal,
        this.contentBox.height + this.paddingBox.vertical + this.borderBox.vertical,
      );
    }
    else {
      this.borderBoxSize = Size(
        width ?? (contentWidth! + this.paddingBox.horizontal + this.borderBox.horizontal),
        height ?? (contentHeight! + this.paddingBox.vertical + this.borderBox.vertical),
      );

      this.contentBox = Size(
        this.borderBoxSize.width - this.borderBox.horizontal - this.paddingBox.horizontal,
        this.borderBoxSize.height - this.borderBox.vertical - this.paddingBox.vertical,
      );
    }

    if (this.direction == Axis.vertical) {
      if (this.horizontalFlexSize != null && this.width == null) {
        this.borderBoxSize = Size(
          this.horizontalFlexSize! - this.margin.horizontal,
          this.borderBoxSize.height,
        );

        this.contentBox = Size(
          this.borderBoxSize.width - this.borderBox.horizontal - this.paddingBox.horizontal,
          this.contentBox.height,
        );
      }

      if (this.verticalFlexSize != null) {
        this.borderBoxSize = Size(
          this.borderBoxSize.width,
          this.verticalFlexSize! - this.margin.horizontal,
        );

        this.contentBox = Size(
          this.contentBox.width,
          this.borderBoxSize.height - this.borderBox.vertical - this.paddingBox.vertical,
        );
      }
    }
    else
    if (this.direction == Axis.horizontal) {
      if (this.verticalFlexSize != null && this.height == null) {
        this.borderBoxSize = Size(
          this.borderBoxSize.width,
          this.verticalFlexSize! - this.margin.vertical,
        );

        this.contentBox = Size(
          this.contentBox.width,
          this.borderBoxSize.height - this.borderBox.vertical - this.paddingBox.vertical,
        );
      }

      if (this.horizontalFlexSize != null) {
        this.borderBoxSize = Size(
          this.horizontalFlexSize! - this.margin.horizontal,
          this.borderBoxSize.height,
        );

        this.contentBox = Size(
          this.borderBoxSize.width - this.borderBox.horizontal - this.paddingBox.horizontal,
          this.contentBox.height,
        );
      }
    }

    this.horizontalSpace = this.borderBoxSize.width + this.margin.horizontal;
    this.verticalSpace = this.borderBoxSize.height + this.margin.vertical;

    this.borderBoxOffset = Offset(
      this.margin.left,
      this.margin.top,
    );

    this.paddingBoxOffset = Offset(
      this.borderBoxOffset.dx + this.borderBox.left,
      this.borderBoxOffset.dy + this.borderBox.top,
    );

    this.contentBoxOffset = Offset(
      this.paddingBoxOffset.dx + this.paddingBox.left,
      this.paddingBoxOffset.dy + this.paddingBox.top,
    );

    this.paddingBoxSize = Size(
      this.contentBox.width + this.paddingBox.horizontal,
      this.contentBox.height + this.paddingBox.vertical,
    );
  }

  final BoxSizing boxSizing;

  final BorderRadius borderRadius;

  late final double horizontalSpace;

  late final double verticalSpace;

  late final Offset borderBoxOffset;

  late final Offset paddingBoxOffset;

  late final Offset contentBoxOffset;

  late Size borderBoxSize;

  late final Size paddingBoxSize;

  final Axis? direction;

  final double? horizontalFlexSize;

  final double? verticalFlexSize;

  /// Null means auto sized
  final double? width;

  /// Null means auto sized
  final double? height;

  /// if [width] is non null this must be null
  /// if [width] is null this must be non null
  final double? contentWidth;

  /// if [height] is non null this must be null
  /// if [height] is null this must be non null
  final double? contentHeight;

  final EdgeInsets margin;

  final BorderEdgeInsets borderBox;

  final EdgeInsets paddingBox;

  late Size contentBox;
  
  // fully implement copyWith
  BoxModel copyWith({
    BoxSizing? boxSizing,
    double? width,
    double? height,
    double? contentWidth,
    double? contentHeight,
    EdgeInsets? margin,
    BorderEdgeInsets? borderBox,
    EdgeInsets? paddingBox,
    Axis? direction,
    double? horizontalFlexSize,
    double? verticalFlexSize,
    BorderRadius? borderRadius,
  }) {
    return BoxModel(
      boxSizing: boxSizing ?? this.boxSizing,
      width: width ?? this.width,
      height: height ?? this.height,
      contentWidth: contentWidth ?? this.contentWidth,
      contentHeight: contentHeight ?? this.contentHeight,
      margin: margin ?? this.margin,
      borderBox: borderBox ?? this.borderBox,
      paddingBox: paddingBox ?? this.paddingBox,
      direction: direction ?? this.direction,
      horizontalFlexSize: horizontalFlexSize ?? this.horizontalFlexSize,
      verticalFlexSize: verticalFlexSize ?? this.verticalFlexSize,
      borderRadius: borderRadius ?? this.borderRadius,
    );
  }

}



class BorderEdgeInsets {

  const BorderEdgeInsets.only({
    this.topSide = BorderSide.none,
    this.rightSide = BorderSide.none,
    this.bottomSide = BorderSide.none,
    this.leftSide = BorderSide.none,
  });

  final BorderSide topSide;

  final BorderSide rightSide;

  final BorderSide bottomSide;

  final BorderSide leftSide;

  double get top {
    return this.topSide.width;
  }

  double get right {
    return this.rightSide.width;
  }

  double get bottom {
    return this.bottomSide.width;
  }

  double get left {
    return this.leftSide.width;
  }

  double get horizontal {
    return this.left.toDouble() + this.right.toDouble();
  }

  double get vertical {
    return this.top.toDouble() + this.bottom.toDouble();
  }

  static const none = BorderEdgeInsets.only(
    topSide: BorderSide.none,
    rightSide: BorderSide.none,
    bottomSide: BorderSide.none,
    leftSide: BorderSide.none,
  );

  const BorderEdgeInsets.all(BorderSide side)
    : this.only(
      topSide: side,
      rightSide: side,
      bottomSide: side,
      leftSide: side,
    );

  const BorderEdgeInsets.fromLTRB(BorderSide left, BorderSide top, BorderSide right, BorderSide bottom)
    : this.only(
      topSide: top,
      rightSide: right,
      bottomSide: bottom,
      leftSide: left,
    );

  const BorderEdgeInsets.horizontal(BorderSide side)
    : this.only(
      topSide: side,
      rightSide: side,
      bottomSide: side,
      leftSide: side,
    );

  const BorderEdgeInsets.vertical(BorderSide side)
    : this.only(
      topSide: side,
      rightSide: side,
      bottomSide: side,
      leftSide: side,
    );

  const BorderEdgeInsets.symmetric({
    required BorderSide horizontal,
    required BorderSide vertical,
  }) : this.only(
      topSide: vertical,
      rightSide: horizontal,
      bottomSide: vertical,
      leftSide: horizontal,
    );

}

enum BorderUnitStyle {

  NONE,

  SOLID,

  DASHED,

  DOTTED,

}

class BorderSide {

  const BorderSide({
    this.style = BorderUnitStyle.SOLID,
    required this.width,
    this.color = Colors.transparent,
  });

  static const none = BorderSide(
    width: 0,
    style: BorderUnitStyle.NONE,
  );

  final double width;

  final Color color;

  final BorderUnitStyle style;

}
