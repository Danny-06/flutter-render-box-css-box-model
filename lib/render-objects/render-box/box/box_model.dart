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
    this.minWidth = 0.0,
    this.maxWidth = double.infinity,
    this.minHeight = 0.0,
    this.maxHeight = double.infinity,
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
        (width ?? contentWidth!).clamp(this.minWidth, this.maxWidth),
        (height ?? contentHeight!).clamp(this.minHeight, this.maxHeight),
      );

      this.borderBoxSize = Size(
        this.contentBox.width + this.paddingBox.horizontal + this.borderBox.horizontal,
        this.contentBox.height + this.paddingBox.vertical + this.borderBox.vertical,
      );
    }
    else {
      this.borderBoxSize = Size(
        (width ?? (contentWidth! + this.paddingBox.horizontal + this.borderBox.horizontal)).clamp(this.minWidth, this.maxWidth),
        (height ?? (contentHeight! + this.paddingBox.vertical + this.borderBox.vertical)).clamp(this.minHeight, this.maxHeight),
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

    this.center = Offset(
      this.contentBoxOffset.dx + this.contentBox.width / 2,
      this.contentBoxOffset.dy + this.contentBox.height / 2,
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
  /// Use [double.nan] to explicitly pass null in [BoxModel.copyWith]
  final double? width;

  /// Null means auto sized
  /// Use [double.nan] to explicitly pass null in [BoxModel.copyWith]
  final double? height;

  final double minWidth;

  final double maxWidth;

  final double minHeight;

  final double maxHeight;

  final double? contentWidth;

  final double? contentHeight;

  final EdgeInsets margin;

  final BorderEdgeInsets borderBox;

  final EdgeInsets paddingBox;

  late Size contentBox;

  late final Offset center;

  RRect getBorderBoxRRect(Offset offset) {
    final borderRRect = RRect.fromRectAndCorners(
      (offset + this.borderBoxOffset) & this.borderBoxSize,
      topLeft: this.borderRadius.topLeft,
      topRight: this.borderRadius.topRight,
      bottomLeft: this.borderRadius.bottomLeft,
      bottomRight: this.borderRadius.bottomRight,
    );

    return borderRRect;
  }

  RRect getPaddingBoxRRect(Offset offset) {
    final paddingRRect = RRect.fromRectAndCorners(
      (offset + this.paddingBoxOffset) & this.paddingBoxSize,
      topLeft: this.borderRadius.topLeft,
      topRight: this.borderRadius.topRight,
      bottomLeft: this.borderRadius.bottomLeft,
      bottomRight: this.borderRadius.bottomRight,
    );

    return paddingRRect;
  }
  
  // fully implement copyWith
  BoxModel copyWith({
    BoxSizing? boxSizing,
    double? width,
    double? height,
    double? minWidth,
    double? maxWidth,
    double? minHeight,
    double? maxHeight,
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
      width: (width?.isNaN == true) ? null : this.width,
      height: (height?.isNaN == true) ? null : this.height,
      minWidth: minWidth ?? this.minWidth,
      maxWidth: maxWidth ?? this.maxWidth,
      minHeight: minHeight ?? this.minHeight,
      maxHeight: maxHeight ?? this.maxHeight,
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
