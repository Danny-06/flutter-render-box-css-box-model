import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart' hide BorderSide;
import 'package:flutter/material.dart' as material;
import 'package:flutter/rendering.dart' hide BorderSide;
import 'dart:math' as Math;
import 'dart:ui' as ui;

import '/extensions/string.extension.dart';
import '/render-objects/render-box/box/style.dart';
import '/render-objects/render-box/box/box_model.dart';


class Box extends MultiChildRenderObjectWidget {

  Box({
    super.key,
    super.children,
    this.name,
    this.style,
  });

  final String? name;

  final Style? style;

  @override
  RenderBox createRenderObject(BuildContext context) {
    return StyledRenderBox(
      style: this.style ?? const Style(),
    );
  }

  @override
  void updateRenderObject(BuildContext context, covariant StyledRenderBox renderObject) {
    renderObject.style = this.style ?? Style();

    // This somehow fixes hot reload not updating layout properly
    renderObject.parentData
      ?..horizontalFlexSize = null
      ..verticalFlexSize = null
    ;
  }

  // MultiChildRenderObjectElement? _element;

  // @override
  // MultiChildRenderObjectElement createElement() {
  //   final element = super.createElement();

  //   this._element = element;

  //   return element;
  // }

}

class StyledRenderBoxParentData extends ContainerBoxParentData<RenderBox> {

  StyledRenderBoxParentData();

  Axis direction = Axis.vertical;

  double? verticalFlexSize;

  double? horizontalFlexSize;

  @override
  String toString() {
    return (
    '''
    StyledRenderBoxParentData()
      ..offset: Offset(${this.offset.dx}, ${this.offset.dy})
      ..direction: ${this.direction},
      ..verticalFlexSize: ${this.verticalFlexSize},
      ..horizontalFlexSize: ${this.horizontalFlexSize},
    '''
    ).trimIndent();
  }

}

/// A custom RenderBox that draws a blue rectangle
class StyledRenderBox extends RenderBox with ContainerRenderObjectMixin<RenderBox, StyledRenderBoxParentData>, RenderBoxContainerDefaultsMixin<RenderBox, StyledRenderBoxParentData> {

  StyledRenderBox({
    Style style = const Style(),
  }) : this._style = style;

  Style _style;

  Style get style {
    return this._style;
  }

  void set style(Style value) {
    if (this._style == value) {
      return;
    }

    this._style = value;

    // this.markNeedsLayout();
  }

  // void markParentNeedsLayout() {
  //   return super.markParentNeedsLayout();
  // }

  StyledRenderBoxParentData? _parentData;

  StyledRenderBoxParentData? get parentData {
    return this._parentData;
  }

  void set parentData(ParentData? value) {
    if (value == null) {
      this._parentData = null;
      return;
    }

    if (value is BoxParentData) {
      this._parentData = (
        StyledRenderBoxParentData()
          ..offset = value.offset
      );
    }
    else
    if (value is StyledRenderBoxParentData) {
      this._parentData = value;
    }
    else {
      this._parentData = StyledRenderBoxParentData();
    }
  }

  @override
  void debugAssertDoesMeetConstraints() {
    // Ignore default behavior of showing constrains errors in console
    // super.debugAssertDoesMeetConstraints();
  }

  late final tapGestureRecognizer = TapGestureRecognizer(debugOwner: this);

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);

    // this.tapGestureRecognizer.onTap = () {
    //   print('onTap');
    // };
  }

  @override
  void setupParentData(covariant RenderObject child) {
    // if (child.parentData is! MyParentData) {
    //   child.parentData = MyParentData();
    // }

    child.parentData ??= StyledRenderBoxParentData();
  }

  Iterable<(RenderBox, int index)> childrenIterator() sync* {
    var currentChild = this.firstChild;

    var index = 0;

    while (currentChild != null) {
      yield (currentChild, index);

      index++;

      currentChild = this.childAfter(currentChild);
    }
  }

  Iterable<(RenderBox, int index)> childrenReverseIterator() sync* {
    var currentChild = this.lastChild;

    var index = this.childCount - 1;

    while (currentChild != null) {
      yield (currentChild, index);

      index--;

      currentChild = this.childBefore(currentChild);
    }
  }

  BoxConstraints? _dryLayoutConstraints;

  @override
  BoxConstraints get constraints {
    return BoxConstraints();
  }

  BoxConstraints get customConstraints {
    if (this._dryLayoutConstraints != null) {
      return BoxConstraints(
        maxWidth: this._dryLayoutConstraints!.maxWidth,
        maxHeight: this._dryLayoutConstraints!.maxHeight,
      );
    }

    var maxWidth = super.constraints.maxWidth;
    var maxHeight = super.constraints.maxHeight;

    final parent = this.parent;

    if (parent is RenderBox) {
      this._skipDryLayout = true;

      final parentSize = parent.getDryLayout(parent.constraints);

      if (maxWidth == double.infinity) {
        maxWidth = parentSize.width;
      }

      if (maxHeight == double.infinity) {
        maxHeight = parentSize.height;
      }
    }

    return BoxConstraints(
      maxWidth: maxWidth,
      maxHeight: maxHeight,
    );
  }

  StyledRenderBoxParentData? get boxParentData {
    final parentData = this.parentData;

    if (parentData is StyledRenderBoxParentData) {
      return parentData;
    }

    return null;
  }

  BoxModel? boxModel;

  BoxModel? get parentBoxModel {
    final parent = this.parent;

    if (parent is StyledRenderBox) {
      return parent.boxModel;
    }

    return null;
  }

  double get parentConstrainedWidth {
    final parentBoxModel = this.parentBoxModel;

    if (parentBoxModel != null) {
      return parentBoxModel.contentBox.width;
    }

    return this.customConstraints.maxWidth;
  }

  double get parentConstrainedHeight {
    final parentBoxModel = this.parentBoxModel;

    if (parentBoxModel != null) {
      return parentBoxModel.contentBox.height;
    }

    return this.customConstraints.maxHeight;
  }

  @override
  void performLayout() {
    this._performLayout();
  }

  bool _skipDryLayout = false;

  @override
  Size computeDryLayout(covariant BoxConstraints constraints) {
    if (this._skipDryLayout) {
      this._skipDryLayout = false;
      return Size.zero;
    }

    this._dryLayoutConstraints = constraints;

    this._performLayout(isDryLayout: true);

    this._dryLayoutConstraints = null;

    return Size(
      this.boxModel!.horizontalSpace,
      this.boxModel!.verticalSpace,
    );
  }

  double computedMinWidth = 0.0;

  double computedMaxWidth = 0.0;

  double? computedWidth;

  double computedMinHeight = 0.0;

  double computedMaxHeight = 0.0;

  double? computedHeight = 0.0;

  void _performLayout({bool isDryLayout = false}) {
    this.computedMinWidth = this.resolveMinWidth(this.style.minWidth);

    this.computedMaxWidth = this.resolveMaxWidth(this.style.maxWidth);

    this.computedWidth = this.resolveWidth(this.style.width);

    this.computedMinHeight = this.resolveMinHeight(this.style.minHeight);

    this.computedMaxHeight = this.resolveMaxHeight(this.style.maxHeight);

    this.computedHeight = this.resolveHeight(this.style.height);

    final isAutoSizedByContent = this.computedWidth == null || this.computedHeight == null;

    if (!isAutoSizedByContent) {
      final boxModel = BoxModel(
        boxSizing: this.style.boxSizing,
        width: this.computedWidth,
        height: this.computedHeight,
        minWidth: this.computedMinWidth,
        maxWidth: this.computedMaxWidth,
        minHeight: this.computedMinHeight,
        maxHeight: this.computedMaxHeight,
        margin: EdgeInsets.only(
          top: this.resolveUnit(this.style.margin?.top, direction: Axis.vertical) ?? 0,
          right: this.resolveUnit(this.style.margin?.right, direction: Axis.horizontal) ?? 0,
          bottom: this.resolveUnit(this.style.margin?.bottom, direction: Axis.vertical) ?? 0,
          left: this.resolveUnit(this.style.margin?.left, direction: Axis.horizontal) ?? 0,
        ),
        borderBox: this.borderEdgeInsetsUnitToBorderEdgeInsets(this.style.border),
        paddingBox: EdgeInsets.only(
          top: this.resolveUnit(this.style.padding?.top, direction: Axis.vertical) ?? 0,
          right: this.resolveUnit(this.style.padding?.right, direction: Axis.horizontal) ?? 0,
          bottom: this.resolveUnit(this.style.padding?.bottom, direction: Axis.vertical) ?? 0,
          left: this.resolveUnit(this.style.padding?.left, direction: Axis.horizontal) ?? 0,
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(this.resolveUnit(this.style.borderRadius.topLeft)!),
          topRight: Radius.circular(this.resolveUnit(this.style.borderRadius.topRight)!),
          bottomLeft: Radius.circular(this.resolveUnit(this.style.borderRadius.bottomLeft)!),
          bottomRight: Radius.circular(this.resolveUnit(this.style.borderRadius.bottomRight)!),
        ),
      );

      this.boxModel = boxModel;

      if (!isDryLayout) {
        this.size = Size(
          boxModel.horizontalSpace,
          boxModel.verticalSpace,
        );
      }
    }
    else {
      final boxParentData = (this.parentData is StyledRenderBoxParentData) ? this.parentData as StyledRenderBoxParentData : null;

      final direction = boxParentData?.direction;
      final horizontalFlexSize = boxParentData?.horizontalFlexSize;
      final verticalFlexSize = boxParentData?.verticalFlexSize;

      final boxModel = BoxModel(
        direction: direction,
        horizontalFlexSize: horizontalFlexSize,
        verticalFlexSize: verticalFlexSize,
        boxSizing: this.style.boxSizing,
        width: this.computedWidth,
        height: this.computedHeight,
        minWidth: this.computedMinWidth,
        maxWidth: this.computedMaxWidth,
        minHeight: this.computedMinHeight,
        maxHeight: this.computedMaxHeight,
        contentWidth: 0,
        contentHeight: 0,
        margin: EdgeInsets.only(
          top: this.resolveUnit(this.style.margin?.top, direction: Axis.vertical) ?? 0,
          right: this.resolveUnit(this.style.margin?.right, direction: Axis.horizontal) ?? 0,
          bottom: this.resolveUnit(this.style.margin?.bottom, direction: Axis.vertical) ?? 0,
          left: this.resolveUnit(this.style.margin?.left, direction: Axis.horizontal) ?? 0,
        ),
        borderBox: this.borderEdgeInsetsUnitToBorderEdgeInsets(this.style.border),
        paddingBox: EdgeInsets.only(
          top: this.resolveUnit(this.style.padding?.top, direction: Axis.vertical) ?? 0,
          right: this.resolveUnit(this.style.padding?.right, direction: Axis.horizontal) ?? 0,
          bottom: this.resolveUnit(this.style.padding?.bottom, direction: Axis.vertical) ?? 0,
          left: this.resolveUnit(this.style.padding?.left, direction: Axis.horizontal) ?? 0,
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(this.resolveUnit(this.style.borderRadius.topLeft)!),
          topRight: Radius.circular(this.resolveUnit(this.style.borderRadius.topRight)!),
          bottomLeft: Radius.circular(this.resolveUnit(this.style.borderRadius.bottomLeft)!),
          bottomRight: Radius.circular(this.resolveUnit(this.style.borderRadius.bottomRight)!),
        ),
      );

      this.boxModel = boxModel;

      if (!isDryLayout) {
        this.size = Size(
          boxModel.horizontalSpace,
          boxModel.verticalSpace,
        );
      }
    }

    final (contentWidth, contentHeight) = (
      this.flexLayout(
        isAutoSizedByContent: isAutoSizedByContent,
        isDry: isDryLayout,
      )
    );

    if (isAutoSizedByContent) {
      final previousBoxModel = this.boxModel!;

      final boxModel = previousBoxModel.copyWith(
        contentWidth: contentWidth,
        contentHeight: contentHeight,
      );

      this.boxModel = boxModel;

      if (!isDryLayout) {
        this.size = Size(
          boxModel.horizontalSpace,
          boxModel.verticalSpace,
        );
      }
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (this.style.opacity == 0) {
      return;
    }

    final boxModel = this.boxModel!;

    // Obtain the canvas from the context and create a blue paint object
    final Canvas canvas = context.canvas;
    final Paint paint = Paint();

    paint.color = (
      this.style.backgroundColor ?? Colors.transparent
    );

    final boxOffset = offset + boxModel.paddingBoxOffset;

    // Define the rectangle to be drawn (based on size and offset)
    final backgroundRRect = RRect.fromRectAndCorners(
      boxOffset & boxModel.paddingBoxSize,
      topLeft: boxModel.borderRadius.topLeft,
      topRight: boxModel.borderRadius.topRight,
      bottomLeft: boxModel.borderRadius.bottomLeft,
      bottomRight: boxModel.borderRadius.bottomRight,
    );

    final borderRRect = boxModel.getBorderBoxRRect(offset);

    // final borderRRect = RRect.fromRectAndCorners(
    //   (offset + boxModel.borderBoxOffset) & boxModel.borderBoxSize,
    //   topLeft: Radius.elliptical(rRect.tlRadiusX, rRect.tlRadiusY),
    //   topRight: Radius.elliptical(rRect.trRadiusX, rRect.trRadiusY),
    //   bottomLeft: Radius.elliptical(rRect.blRadiusX, rRect.blRadiusY),
    //   bottomRight: Radius.elliptical(rRect.brRadiusX, rRect.brRadiusY),
    // );

    canvas.drawRRect(backgroundRRect, paint);

    if (this.style.border != null) {
      this.drawBorder(context, offset, borderRRect);
    }

    if (this.style.overflow == Overflow.HIDDEN) {
      canvas.clipRRect(borderRRect);
    }

    this.defaultPaint(context, offset + boxModel.contentBoxOffset);
  }

  Path createDashedPath({
    required PaintingContext context,
    required List<double> segments,
    required Offset offset,
    required Size size,
    required BorderRadius borderRadius,
  }) {
    // final _segments = (segments.length % 2 == 0 ? segments : [...segments, ...segments]).map((segment) => segment.abs()).toList();
    final _segments = segments.map((segment) => segment.abs()).toList();

    for (final segment in _segments) {
      if (segment <= 0) {
        return Path();
      }
    }

    final segmentsIterator = () sync* {
      var index = 0;

      while (true) {
        yield _segments[index];
        index = (index + 1) % _segments.length;
      }
    }().iterator;

    final path = (
      Path()
        ..moveTo(offset.dx, offset.dy)
    );

    var currentDx = 0.0;
    var currentDy = 0.0;

    // ignore: dead_code
    while (true) {
      // break;
      segmentsIterator.moveNext();

      path.relativeLineTo(segmentsIterator.current, 0);

      currentDx += segmentsIterator.current;

      segmentsIterator.moveNext();

      // if (currentDx + segmentsIterator.current >= size.width) {
      //   break;
      // }

      path.relativeMoveTo(segmentsIterator.current, 0);
      path.close();

      currentDx += segmentsIterator.current;

      if (currentDx >= size.width) {
        break;
      }
    }

    return path;
  }

  void drawBorder(PaintingContext context, Offset offset, RRect rRect) {
    final border = this.style.border;

    if (border == null) {
      return;
    }

    final boxModel = this.boxModel!;

    final canvas = context.canvas;

    // TOP

    if (boxModel.borderBox.top > 0) {
      final clipPath = (
        Path()
          ..moveTo(offset.dx + boxModel.paddingBoxOffset.dx, offset.dy + boxModel.paddingBoxOffset.dy)
          ..relativeLineTo(boxModel.paddingBoxSize.width / 2, boxModel.paddingBoxSize.height / 2)
          ..relativeLineTo(boxModel.paddingBoxSize.width / 2, -boxModel.paddingBoxSize.height / 2)
          ..relativeLineTo(boxModel.borderBox.right, -boxModel.borderBox.top)
          ..relativeLineTo(-boxModel.borderBoxSize.width, 0)
          ..close()

          // ..moveTo(offset.dx + boxModel.paddingBoxOffset.dx, offset.dy + boxModel.paddingBoxOffset.dy)
          // ..relativeLineTo(boxModel.paddingBoxSize.width / 2, boxModel.borderRadius.topLeft.x * boxModel.borderBox.top * 0.1)
          // ..lineTo(offset.dx + boxModel.paddingBoxOffset.dx + boxModel.paddingBoxSize.width / 2, offset.dy + boxModel.paddingBoxOffset.dy + boxModel.borderRadius.topRight.x * boxModel.borderBox.top * 0.1)
          // ..lineTo(offset.dx + boxModel.paddingBoxOffset.dx + boxModel.paddingBoxSize.width, offset.dy + boxModel.paddingBoxOffset.dy)
          // ..relativeLineTo(boxModel.borderBox.right, -boxModel.borderBox.top)
          // ..relativeLineTo(-boxModel.borderBoxSize.width, 0)
          // ..close()
      );

      switch (border.topSide.style) {

        case BorderUnitStyle.NONE:
          // 
        break;

        case BorderUnitStyle.SOLID:
          // final paint = (
          //   Paint()
          //     ..color = Colors.transparent
          //     ..color = border.topSide.color
          //     ..style = PaintingStyle.fill
          //     ..strokeWidth = boxModel.borderBox.top
          // );

          // canvas.save();

          // final rRect = boxModel.getPaddingBoxRRect(offset);

          // canvas.clipPath(clipPath);
          // // canvas.clipPath(
          // //   Path()
          // //   // ..fillType = PathFillType.evenOdd
          // //   ..addRRect(boxModel.getPaddingBoxRRect(offset))
          // // );
          // canvas.drawDRRect(rRect.inflate(boxModel.borderBox.top), rRect, paint);

          // canvas.restore();
        break;

        case BorderUnitStyle.DASHED:
          final dashSize = boxModel.borderBox.top * 3 / 2;

          final dashCountAvailable = ((boxModel.borderBoxSize.width / dashSize) * 0.8).floorToDouble();

          final dashGap = (boxModel.borderBoxSize.width - (dashCountAvailable * dashSize)) / (dashCountAvailable);

          final path = this.createDashedPath(
            context: context,
            segments: [dashSize, dashGap],
            offset: (offset + boxModel.borderBoxOffset).translate(0, boxModel.borderBox.top / 2),
            size: boxModel.borderBoxSize,
            borderRadius: boxModel.borderRadius,
          );

          final paint = (
            Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = boxModel.borderBox.top
              ..color = border.topSide.color
          );

          canvas.save();

          // canvas.clipPath(clipPath);
          canvas.drawPath(path, paint);

          canvas.restore();
        break;

        case BorderUnitStyle.DOTTED:
          
        break;

      }
    }

    // LEFT

    if (boxModel.borderBox.left > 0) {
      final clipPath = (
        Path()
          ..moveTo(offset.dx + boxModel.paddingBoxOffset.dx, offset.dy + boxModel.paddingBoxOffset.dy)
          ..relativeLineTo(boxModel.paddingBoxSize.width / 2, boxModel.paddingBoxSize.height / 2)
          ..relativeLineTo(-boxModel.paddingBoxSize.width / 2, boxModel.paddingBoxSize.height / 2)
          ..relativeLineTo(-boxModel.borderBox.left, boxModel.borderBox.bottom)
          ..relativeLineTo(0, -boxModel.borderBoxSize.height)
          ..close()
      );

      switch (border.leftSide.style) {

        case BorderUnitStyle.NONE:
          // 
        break;

        case BorderUnitStyle.SOLID:
          // final paint = (
          //   Paint()
          //     ..color = border.leftSide.color
          //     ..style = PaintingStyle.stroke
          //     ..strokeWidth = boxModel.borderBox.left
          // );

          // canvas.save();

          // final rRect = RRect.fromRectAndCorners(
          //   (offset + boxModel.borderBoxOffset + Offset(boxModel.borderBox.left / 2, boxModel.borderBox.top / 2)) & boxModel.borderBoxSize,
          //   topLeft: boxModel.borderRadius.topLeft,
          //   topRight: boxModel.borderRadius.topRight,
          //   bottomLeft: boxModel.borderRadius.bottomLeft,
          //   bottomRight: boxModel.borderRadius.bottomRight,
          // );

          // canvas.clipPath(clipPath);
          // canvas.drawRRect(rRect, paint);

          // canvas.restore();
        break;

        case BorderUnitStyle.DASHED:
          
        break;

        case BorderUnitStyle.DOTTED:
          
        break;

      }
    }

    // BOTTOM

    if (boxModel.borderBox.bottom > 0) {
      final clipPath = (
        Path()
          ..moveTo(offset.dx + boxModel.paddingBoxOffset.dx, offset.dy + boxModel.paddingBoxOffset.dy + boxModel.paddingBoxSize.height)
          ..relativeLineTo(boxModel.paddingBoxSize.width / 2, -boxModel.paddingBoxSize.height / 2)
          ..relativeLineTo(boxModel.paddingBoxSize.width / 2, boxModel.paddingBoxSize.height / 2)
          ..relativeLineTo(boxModel.borderBox.right, boxModel.borderBox.bottom)
          ..relativeLineTo(-boxModel.borderBoxSize.width, 0)
          ..close()
      );

      switch (border.bottomSide.style) {

        case BorderUnitStyle.NONE:
          // 
        break;

        case BorderUnitStyle.SOLID:
          // final paint = (
          //   Paint()
          //     ..color = border.bottomSide.color
          //     ..style = PaintingStyle.stroke
          //     ..strokeWidth = boxModel.borderBox.bottom
          // );

          // canvas.save();

          // final rRect = RRect.fromRectAndCorners(
          //   (offset + boxModel.borderBoxOffset + Offset(0, -boxModel.borderBox.bottom / 2)) & boxModel.borderBoxSize,
          //   topLeft: boxModel.borderRadius.topLeft,
          //   topRight: boxModel.borderRadius.topRight,
          //   bottomLeft: boxModel.borderRadius.bottomLeft,
          //   bottomRight: boxModel.borderRadius.bottomRight,
          // );

          // canvas.clipPath(clipPath);
          // canvas.drawRRect(rRect, paint);

          // canvas.restore();
        break;

        case BorderUnitStyle.DASHED:
          
        break;

        case BorderUnitStyle.DOTTED:
          
        break;

      }
    }

    // RIGHT

    if (boxModel.borderBox.right > 0) {
      final clipPath = (
        Path()
          ..moveTo(offset.dx + boxModel.paddingBoxOffset.dx + boxModel.paddingBoxSize.width, offset.dy + boxModel.paddingBoxOffset.dy)
          ..relativeLineTo(-boxModel.paddingBoxSize.width / 2, boxModel.paddingBoxSize.height / 2)
          ..relativeLineTo(boxModel.paddingBoxSize.width / 2, boxModel.paddingBoxSize.height / 2)
          ..relativeLineTo(boxModel.borderBox.right, boxModel.borderBox.bottom)
          ..relativeLineTo(0, -boxModel.borderBoxSize.height)
          ..close()
      );

      switch (border.rightSide.style) {

        case BorderUnitStyle.NONE:
          // 
        break;

        case BorderUnitStyle.SOLID:
          // final paint = (
          //   Paint()
          //     ..color = border.rightSide.color
          //     ..style = PaintingStyle.stroke
          //     ..strokeWidth = boxModel.borderBox.right
          // );

          // canvas.save();

          // final rRect = RRect.fromRectAndCorners(
          //   (offset + boxModel.borderBoxOffset + Offset(-boxModel.borderBox.right / 2, 0)) & boxModel.borderBoxSize,
          //   topLeft: boxModel.borderRadius.topLeft,
          //   topRight: boxModel.borderRadius.topRight,
          //   bottomLeft: boxModel.borderRadius.bottomLeft,
          //   bottomRight: boxModel.borderRadius.bottomRight,
          // );

          // canvas.clipPath(clipPath);
          // canvas.drawRRect(rRect, paint);

          // canvas.restore();
        break;

        case BorderUnitStyle.DASHED:
          
        break;

        case BorderUnitStyle.DOTTED:
          
        break;

      }
    }
  }

  @override
  bool get isRepaintBoundary => this.style.opacity != 1 && this.style.opacity != 0;

  @override
  OffsetLayer updateCompositedLayer({required covariant OpacityLayer? oldLayer}) {
    if (this.style.opacity == 0 || this.style.opacity == 1) {
      return super.updateCompositedLayer(oldLayer: oldLayer);
    }

    final OpacityLayer layer = oldLayer ?? OpacityLayer();
    layer.alpha = ui.Color.getAlphaFromOpacity(this.style.opacity);
    return layer;
  }

  @override
  bool hitTestSelf(Offset position) {
    final boxModel = this.boxModel!;

    final boxOffset = boxModel.borderBoxOffset;

    final rect = boxOffset & boxModel.borderBoxSize;

    return rect.contains(position);
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    RenderBox? child = lastChild;

    while (child != null) {
      // The x, y parameters have the top left of the node's box as the origin.
      final childParentData = child.parentData! as ContainerBoxParentData<RenderBox>;

      final bool isHit = result.addWithPaintOffset(
        offset: childParentData.offset + this.boxModel!.contentBoxOffset,
        position: position,
        hitTest: (BoxHitTestResult result, Offset transformed) {
          return child!.hitTest(result, position: transformed);
        },
      );

      if (isHit) {
        return true;
      }

      child = childParentData.previousSibling;
    }

    return false;
  }

  @override
  void handleEvent(PointerEvent event, BoxHitTestEntry entry) {
    assert(debugHandleEvent(event, entry));

    if (event is PointerDownEvent) {
      this.tapGestureRecognizer.addPointer(event);
    }
  }

  double? resolveUnit(Unit? unit, {Axis direction = Axis.horizontal}) {
    if (unit == null) {
      return null;
    }

    late double? computedValue;

    switch (unit.unit) {

      case UnitType.ZERO:
        computedValue = unit.value;
      break;

      case UnitType.AUTO:
        computedValue = unit.value;
      break;

      case UnitType.PX:
        computedValue = unit.value;
      break;

      case UnitType.CQ:
        if (this.parent is! StyledRenderBox) {
          throw AssertionError('Cannot use unit type CQ if parent is not a StyledRenderBox');
        }

        computedValue = unit.value * (
          direction == Axis.horizontal
            ? this.parentBoxModel!.borderBoxSize.width
            : this.parentBoxModel!.borderBoxSize.width
          );
      break;

      case UnitType.PR:
        computedValue = unit.value * (
          direction == Axis.horizontal
            ? this.parentConstrainedWidth
            : this.parentConstrainedHeight
          );
      break;

      default:
        throw Exception('Cannot handle unit type ${unit.unit}');
    }

    return computedValue;
  }

  (double contentWidth, double contentHeight) flexLayout({required isAutoSizedByContent, required bool isDry}) {
    final boxModel = this.boxModel!;

    final isMainAxisAutoSized = (
      FlexDirection.isVertical(this.style.flexDirection)
        ? (this.style.height == Unit.auto && boxParentData?.verticalFlexSize == null)
        : (this.style.width == Unit.auto && boxParentData?.horizontalFlexSize == null)
    );

    // To support scrollers
    if (this.style.expandChild) {
      if (this.childCount > 1) {
        throw AssertionError('Cannot use expandChild if children length is greater than 1');
      }

      final child = this.firstChild!;

      final childConstraints = BoxConstraints(
        maxWidth: boxModel.contentBox.width,
        minWidth: boxModel.contentBox.width,
        maxHeight: boxModel.contentBox.height,
        minHeight: boxModel.contentBox.height,
      );

      child.layout(childConstraints);

      final childParentData = child.parentData as ContainerBoxParentData<RenderBox>;

      childParentData.offset = Offset(0, 0);

      return (0, 0);
    }

    final childrenIterable = (
      FlexDirection.isReversed(this.style.flexDirection)
        ? this.childrenReverseIterator()
        : this.childrenIterator()
    );

    final rowGap = this.resolveUnit(this.style.rowGap, direction: Axis.vertical) ?? 0;
    final columnGap = this.resolveUnit(this.style.columnGap, direction: Axis.vertical) ?? 0;

    final maxWidth = this.computedWidth == null ? this.customConstraints.maxWidth : boxModel.contentBox.width;
    final maxHeight = this.computedHeight == null ? this.customConstraints.maxHeight : boxModel.contentBox.height;

    final childConstraints = BoxConstraints(
      maxWidth: maxWidth,
      maxHeight: maxHeight,
    );

    var contentWidth = 0.0;
    var contentHeight = 0.0;

    var flexGrowContentWidth = 0.0;
    var flexGrowContentHeight = 0.0;

    var maxChildWidth = 0.0;
    var maxChildHeight = 0.0;

    var totalDx = 0.0;
    var totalDy = 0.0;

    var totalFlexGrow = 0.0;

    final hasSize = (
      FlexDirection.isVertical(this.style.flexDirection) && (this.style.width != Unit.auto || this.boxParentData?.horizontalFlexSize != null)
      || !FlexDirection.isVertical(this.style.flexDirection) && (this.style.height != Unit.auto || this.boxParentData?.verticalFlexSize != null)
    );

    final hasMainAxisMinimunSize = (
      FlexDirection.isVertical(this.style.flexDirection)
        ? this.computedMinHeight > 0
        : this.computedMinWidth > 0
    );

    for (final (child, _) in childrenIterable) {
      final childParentData = child.parentData as ContainerBoxParentData<RenderBox>;

      if (childParentData is StyledRenderBoxParentData) {
        childParentData.direction = FlexDirection.getAxisFrom(this.style.flexDirection);
      }

      if ((!isMainAxisAutoSized || hasMainAxisMinimunSize) && child is StyledRenderBox) {
        totalFlexGrow += child.style.flexGrow;
      }

      final itemAlignment = () {
        if (child is StyledRenderBox && child.style.alignSelf != null) {
          return child.style.alignSelf!;
        }
        else {
          return this.style.alignItems;
        }
      }();

      if (itemAlignment == ItemAlignment.STRETCH) {
        if (FlexDirection.isVertical(this.style.flexDirection)) {
          if (childParentData is StyledRenderBoxParentData) {
            childParentData.horizontalFlexSize = boxModel.contentBox.width;
          }
        }
        else {
          if (childParentData is StyledRenderBoxParentData) {
            childParentData.verticalFlexSize = boxModel.contentBox.height;
          }
        }
      }

      late final Size childSize;

      if (isDry) {
        childSize = child.getDryLayout(childConstraints);
      }
      else {
        if (child is StyledRenderBox && child.style.flexGrow > 0) {
          childSize = child.getDryLayout(childConstraints);
        }
        else {
          child.layout(
            childConstraints,
            parentUsesSize: true,
          );

          childSize = child.size;
        }
      }

      if (hasSize) {
        switch (itemAlignment) {

          case ItemAlignment.FLEX_START:
            if (FlexDirection.isVertical(this.style.flexDirection)) {
              childParentData.offset = Offset(0, totalDy);
            }
            else {
              childParentData.offset = Offset(totalDx, 0);
            }
          break;

          case ItemAlignment.FLEX_END:
            if (FlexDirection.isVertical(this.style.flexDirection)) {
              childParentData.offset = Offset(boxModel.contentBox.width - childSize.width, totalDy);
            }
            else {
              childParentData.offset = Offset(totalDx, boxModel.contentBox.height - childSize.height);
            }
          break;

          case ItemAlignment.CENTER:
            if (FlexDirection.isVertical(this.style.flexDirection)) {
              childParentData.offset = Offset(boxModel.contentBox.width / 2 - childSize.width / 2, totalDy);
            }
            else {
              childParentData.offset = Offset(totalDx, boxModel.contentBox.height / 2 - childSize.height / 2);
            }
          break;

          case ItemAlignment.STRETCH:
            if (FlexDirection.isVertical(this.style.flexDirection)) {
              childParentData.offset = Offset(0, totalDy);
            }
            else {
              childParentData.offset = Offset(totalDx, 0);
            }
          break;

        }
      }
      else {
        if (FlexDirection.isVertical(this.style.flexDirection)) {
          childParentData.offset = Offset(0, totalDy);
        }
        else {
          childParentData.offset = Offset(totalDx, 0);
        }
      }

      maxChildWidth = Math.max(maxChildWidth, childSize.width);
      maxChildHeight = Math.max(maxChildHeight, childSize.height);

      if (FlexDirection.isVertical(this.style.flexDirection)) {
        contentHeight += childSize.height + rowGap;
        totalDy += childSize.height + rowGap;

        if (child is StyledRenderBox && child.style.flexGrow > 0) {
          flexGrowContentHeight += childSize.height;
        }
      }
      else {
        contentWidth += childSize.width + columnGap;
        totalDx += childSize.width + columnGap;

        if (child is StyledRenderBox && child.style.flexGrow > 0) {
          flexGrowContentWidth += childSize.width;
        }
      }
    }

    totalDx -= columnGap;
    totalDy -= rowGap;

    if (FlexDirection.isVertical(this.style.flexDirection)) {
      contentHeight -= rowGap;
      contentWidth = maxChildWidth;
    }
    else {
      contentWidth -= columnGap;
      contentHeight = maxChildHeight;
    }

    final availableSpaceInMainAxis = (
      FlexDirection.isVertical(this.style.flexDirection)
        ? boxModel.contentBox.height - (contentHeight - flexGrowContentHeight)
        : boxModel.contentBox.width - (contentWidth - flexGrowContentWidth)
    );

    if (!isDry) {
      var totalDx = 0.0;
      var totalDy = 0.0;

      for (final (child, _) in childrenIterable) {
        final childParentData = child.parentData;

        if (child is! StyledRenderBox) {
          continue;
        }

        if (childParentData is! StyledRenderBoxParentData) {
          continue;
        }

        if (availableSpaceInMainAxis >= 0 && child.style.flexGrow > 0) {
          if (FlexDirection.isVertical(this.style.flexDirection)) {
            childParentData.verticalFlexSize = availableSpaceInMainAxis * child.style.flexGrow / Math.max(1, totalFlexGrow);
          }
          else {
            childParentData.horizontalFlexSize = availableSpaceInMainAxis * child.style.flexGrow / Math.max(1, totalFlexGrow);
          }
        }

        child.layout(childConstraints, parentUsesSize: true);

        final childSize = child.size;

        if (FlexDirection.isVertical(this.style.flexDirection)) {
          childParentData.offset = Offset(childParentData.offset.dx, totalDy);
          totalDy += child.size.height + rowGap;
        }
        else {
          childParentData.offset = Offset(totalDx, childParentData.offset.dy);
          totalDx += child.size.width + columnGap;
        }

        final itemAlignment = () {
          if (child.style.alignSelf != null) {
            return child.style.alignSelf!;
          }
          else {
            return this.style.alignItems;
          }
        }();

        // Support cross axis alignment on boxed with auto size

        if (!hasSize) {
          switch (itemAlignment) {

            case ItemAlignment.FLEX_START:
              if (FlexDirection.isVertical(this.style.flexDirection)) {
                childParentData.offset = Offset(childParentData.offset.dx, childParentData.offset.dy);
              }
              else {
                childParentData.offset = Offset(childParentData.offset.dx, childParentData.offset.dy);
              }
            break;

            case ItemAlignment.FLEX_END:
              if (FlexDirection.isVertical(this.style.flexDirection)) {
                childParentData.offset = Offset(contentWidth - childSize.width, childParentData.offset.dy);
              }
              else {
                childParentData.offset = Offset(childParentData.offset.dx, contentHeight - childSize.height);
              }
            break;

            case ItemAlignment.CENTER:
              if (FlexDirection.isVertical(this.style.flexDirection)) {
                childParentData.offset = Offset(contentWidth / 2 - childSize.width / 2, childParentData.offset.dy);
              }
              else {
                childParentData.offset = Offset(childParentData.offset.dx, contentHeight / 2 - childSize.height / 2);
              }
            break;

            case ItemAlignment.STRETCH:
              if (FlexDirection.isVertical(this.style.flexDirection)) {
                childParentData.offset = Offset(childParentData.offset.dx, childParentData.offset.dy);
              }
              else {
                childParentData.offset = Offset(childParentData.offset.dx, childParentData.offset.dy);
              }
            break;

          }
        }
      }

      totalDx -= columnGap;
      totalDy -= rowGap;

      if (totalFlexGrow == 0) {
        switch (this.style.justifyContent) {

          case ContentAlignment.FLEX_START:

            switch (this.style.flexDirection) {

              case FlexDirection.VERTICAL:
                // Nothing to do
              break;

              case FlexDirection.VERTICAL_REVERSE:
                final translationValue = boxModel.contentBox.height - contentHeight;

                for (final (child, _) in childrenIterable) {
                  final childParentData = child.parentData as ContainerBoxParentData<RenderBox>;

                  childParentData.offset = childParentData.offset.translate(0, translationValue);
                }
              break;

              case FlexDirection.HORIZONTAL:
                // Nothing to do
              break;

              case FlexDirection.HORIZONTAL_REVERSE:
                final translationValue = boxModel.contentBox.width - contentWidth;

                for (final (child, _) in childrenIterable) {
                  final childParentData = child.parentData as ContainerBoxParentData<RenderBox>;

                  childParentData.offset = childParentData.offset.translate(translationValue, 0);
                }
              break;

            }

          break;

          case ContentAlignment.FLEX_END:

            switch (this.style.flexDirection) {

              case FlexDirection.VERTICAL:
                var translationValue = boxModel.contentBox.height - contentHeight;

                if (this.computedHeight == null) {
                  translationValue = this.computedMinHeight - contentHeight;
                }

                for (final (child, _) in childrenIterable) {
                  final childParentData = child.parentData as ContainerBoxParentData<RenderBox>;

                  childParentData.offset = childParentData.offset.translate(0, translationValue);
                }
              break;

              case FlexDirection.VERTICAL_REVERSE:
                // Nothing to do
              break;

              case FlexDirection.HORIZONTAL:
                final translationValue = boxModel.contentBox.width - contentWidth;

                for (final (child, _) in childrenIterable) {
                  final childParentData = child.parentData as ContainerBoxParentData<RenderBox>;

                  childParentData.offset = childParentData.offset.translate(translationValue, 0);
                }
              break;

              case FlexDirection.HORIZONTAL_REVERSE:
                // Nothing to do
              break;

            }

          break;

          case ContentAlignment.CENTER:
            if (FlexDirection.isVertical(this.style.flexDirection)) {
              final totalHeight = boxModel.contentBox.height;

              final translationValue = (totalHeight - contentHeight) / 2;

              for (final (child, _) in childrenIterable) {
                final childParentData = child.parentData as ContainerBoxParentData<RenderBox>;

                childParentData.offset = childParentData.offset.translate(0, translationValue);
              }
            }
            else {
              final totalWidth = boxModel.contentBox.width;

              final translationValue = (totalWidth - contentWidth) / 2;

              for (final (child, _) in childrenIterable) {
                final childParentData = child.parentData as ContainerBoxParentData<RenderBox>;

                childParentData.offset = childParentData.offset.translate(translationValue, 0);
              }
            }
          break;

          case ContentAlignment.SPACE_BETWEEN:
            if (this.childCount == 1) {
              break;
            }

            if (FlexDirection.isVertical(this.style.flexDirection)) {
              if (this.style.height == Unit.auto) {
                break;
              }

              final translationValue = (boxModel.contentBox.height - (contentHeight - (rowGap * (this.childCount - 1)))) / (this.childCount - 1);

              if (translationValue <= 0) {
                break;
              }

              var currentChildrenSizeOffset = 0.0;

              for (final (child, index) in childrenIterable) {
                final childParentData = child.parentData as ContainerBoxParentData<RenderBox>;

                currentChildrenSizeOffset += childParentData.previousSibling?.size.height ?? 0.0;

                childParentData.offset = Offset(childParentData.offset.dx, translationValue * index + currentChildrenSizeOffset);
              }
            }
            else {
              if (this.style.width == Unit.auto) {
                break;
              }

              final translationValue = (boxModel.contentBox.width - (contentWidth - (columnGap * (this.childCount - 1)))) / (this.childCount - 1);

              if (translationValue <= 0) {
                break;
              }

              var currentChildrenSizeOffset = 0.0;

              for (final (child, index) in childrenIterable) {
                final childParentData = child.parentData as ContainerBoxParentData<RenderBox>;

                currentChildrenSizeOffset += childParentData.previousSibling?.size.width ?? 0.0;

                childParentData.offset = Offset(translationValue * index + currentChildrenSizeOffset, childParentData.offset.dy);
              }
            }
          break;

          case ContentAlignment.SPACE_AROUND:
            if (this.childCount == 1) {
              break;
            }

            if (FlexDirection.isVertical(this.style.flexDirection)) {
              if (this.style.height == Unit.auto) {
                break;
              }

              final translationValue = (
                (boxModel.contentBox.height - (contentHeight - (rowGap * (this.childCount - 1)))) / this.childCount
              ) / 2;

              if (translationValue <= 0) {
                break;
              }

              var currentTranslationOffset = 0.0;

              for (final (child, index) in childrenIterable) {
                final childParentData = child.parentData as ContainerBoxParentData<RenderBox>;

                currentTranslationOffset += translationValue;

                if (index == 0) {
                  currentTranslationOffset -= rowGap * (this.childCount - 1) / 2;
                }

                if (index > 0) {
                  currentTranslationOffset += childParentData.previousSibling!.size.height + translationValue + rowGap;
                }

                childParentData.offset = Offset(childParentData.offset.dx, currentTranslationOffset);
              }
            }
            else {
              if (this.style.width == Unit.auto) {
                break;
              }

              final translationValue = (
                (boxModel.contentBox.width - (contentWidth - (columnGap * (this.childCount - 1)))) / this.childCount
              ) / 2;

              if (translationValue <= 0) {
                break;
              }

              var currentTranslationOffset = 0.0;

              for (final (child, index) in childrenIterable) {
                final childParentData = child.parentData as ContainerBoxParentData<RenderBox>;

                currentTranslationOffset += translationValue;

                if (index == 0) {
                  currentTranslationOffset -= columnGap * (this.childCount - 1) / 2;
                }

                if (index > 0) {
                  currentTranslationOffset += childParentData.previousSibling!.size.width + translationValue + columnGap;
                }

                childParentData.offset = Offset(currentTranslationOffset, childParentData.offset.dy);
              }
            }
          break;

          case ContentAlignment.SPACE_EVENLY:
            if (this.childCount == 1) {
              break;
            }

            if (FlexDirection.isVertical(this.style.flexDirection)) {
              if (this.style.height == Unit.auto) {
                break;
              }

              final translationValue = (
                (boxModel.contentBox.height - (contentHeight - (rowGap * (this.childCount - 1)))) / (this.childCount + 1)
              );

              if (translationValue <= 0) {
                break;
              }

              var currentTranslationOffset = 0.0;

              for (final (child, index) in childrenIterable) {
                final childParentData = child.parentData as ContainerBoxParentData<RenderBox>;

                currentTranslationOffset += translationValue;

                if (index == 0) {
                  currentTranslationOffset -= rowGap * (this.childCount - 1) / 2;
                }

                if (index > 0) {
                  currentTranslationOffset += childParentData.previousSibling!.size.height + rowGap;
                }

                childParentData.offset = Offset(childParentData.offset.dx, currentTranslationOffset);
              }
            }
            else {
              if (this.style.width == Unit.auto) {
                break;
              }

              final translationValue = (
                (boxModel.contentBox.width - (contentWidth - (columnGap * (this.childCount - 1)))) / (this.childCount + 1)
              );

              if (translationValue <= 0) {
                break;
              }

              var currentTranslationOffset = 0.0;

              for (final (child, index) in childrenIterable) {
                final childParentData = child.parentData as ContainerBoxParentData<RenderBox>;

                currentTranslationOffset += translationValue;

                if (index == 0) {
                  currentTranslationOffset -= columnGap * (this.childCount - 1) / 2;
                }

                if (index > 0) {
                  currentTranslationOffset += childParentData.previousSibling!.size.width + columnGap;
                }

                childParentData.offset = Offset(currentTranslationOffset, childParentData.offset.dy);
              }
            }
          break;

        }
      }
    }

    return (contentWidth, contentHeight);
  }

  double resolveMinWidth(Unit? unit) {
    if (unit == null) {
      return 0;
    }

    final computedValue = this.resolveUnit(unit, direction: Axis.horizontal)!;

    return Math.max(computedValue, this.customConstraints.minWidth);
  }

  double resolveMaxWidth(Unit? unit) {
    if (unit == null) {
      return double.infinity;
    }

    final computedValue = this.resolveUnit(unit, direction: Axis.horizontal)!;

    // return Math.min(computedValue, this.constraints.maxWidth);
    return computedValue;
  }

  double? resolveWidth(Unit unit) {
    if (unit == Unit.auto) {
      return null;
    }

    final computedValue = this.resolveUnit(unit, direction: Axis.horizontal);

    return computedValue;
  }

  double resolveMinHeight(Unit? unit) {
    if (unit == null) {
      return 0;
    }

    final computedValue = this.resolveUnit(unit, direction: Axis.vertical)!;

    return Math.max(computedValue, this.customConstraints.minHeight);
  }

  double resolveMaxHeight(Unit? unit) {
    if (unit == null) {
      return double.infinity;
    }

    final computedValue = this.resolveUnit(unit, direction: Axis.vertical)!;

    // return Math.min(computedValue, this.constraints.maxHeight);
    return computedValue;
  }

  double? resolveHeight(Unit unit) {
    if (unit == Unit.auto) {
      return null;
    }

    final computedValue = this.resolveUnit(unit, direction: Axis.vertical);

    return computedValue;
  }

  BorderEdgeInsets borderEdgeInsetsUnitToBorderEdgeInsets(BorderEdgeInsetsUnit? borderEdgeInsetsUnit) {
    if (borderEdgeInsetsUnit == null) {
      return BorderEdgeInsets.none;
    }

    return BorderEdgeInsets.only(
      topSide: BorderSide(
        width: this.resolveUnit(borderEdgeInsetsUnit.top, direction: Axis.vertical)!,
        color: borderEdgeInsetsUnit.topSide.color,
        style: borderEdgeInsetsUnit.topSide.style,
      ),
      rightSide: BorderSide(
        width: this.resolveUnit(borderEdgeInsetsUnit.right, direction: Axis.horizontal)!,
        color: borderEdgeInsetsUnit.rightSide.color,
        style: borderEdgeInsetsUnit.rightSide.style,
      ),
      bottomSide: BorderSide(
        width: this.resolveUnit(borderEdgeInsetsUnit.bottom, direction: Axis.vertical)!,
        color: borderEdgeInsetsUnit.bottomSide.color,
        style: borderEdgeInsetsUnit.bottomSide.style,
      ),
      leftSide: BorderSide(
        width: this.resolveUnit(borderEdgeInsetsUnit.left, direction: Axis.horizontal)!,
        color: borderEdgeInsetsUnit.leftSide.color,
        style: borderEdgeInsetsUnit.leftSide.style,
      ),
    );
  }

}
