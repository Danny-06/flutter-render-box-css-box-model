import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart' hide BorderSide;
import 'package:flutter/material.dart' as material;
import 'package:flutter/rendering.dart' hide BorderSide;
import 'dart:math' as Math;
import 'dart:ui' as ui;

import '/extensions/string.extension.dart';
import './style.dart';
import './box_model.dart';
// NOTE: If parent is a scroller, the box wont update its size if the scroller size changes (not sure how to fix it)


class Box extends MultiChildRenderObjectWidget {

  const Box({
    super.key,
    super.children,
    this.name,
    this.style,
  });

  final String? name;

  final Style? style;

  Box.child({
    super.key,
    this.name,
    this.style,
    Widget? child,
  }) : super(children: child != null ? [child] : []);

  static Box builder({
    Key? key,
    String? name,
    Style? style,
    required Widget Function(BuildContext context, StyledRenderBox styledRenderBox) builder,
  }) {
    return Box.child(
      key: key,
      name: name,
      style: style,
      child: Builder(
        builder: (context) {
          final styledRenderBox = context.findAncestorRenderObjectOfType<StyledRenderBox>()!;

          return builder(context, styledRenderBox);
        },
      ),
    );
  }

  @override
  RenderBox createRenderObject(BuildContext context) {
    final renderObject = StyledRenderBox(
      name: this.name,
      style: this.style ?? const Style(),
    );

    return renderObject;
  }

  @override
  void updateRenderObject(BuildContext context, covariant StyledRenderBox renderObject) {
    // Fix error when name is somehow null.
    // I think this happens because the renderObject is not created by the widget but is reused.
    renderObject._name = this.name;

    renderObject.style = this.style ?? Style();

    // This somehow fixes hot reload not updating layout properly
    renderObject.styledParentData
      ?..horizontalFlexSize = null
      ..verticalFlexSize = null
    ;
  }

}


// class StyledRenderBoxParentData extends MultiChildLayoutParentData {
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

class StyledRenderBox extends RenderBox with ContainerRenderObjectMixin<RenderBox, StyledRenderBoxParentData>, RenderBoxContainerDefaultsMixin<RenderBox, StyledRenderBoxParentData> {

  StyledRenderBox({
    Style style = const Style(),
    String? name,
  }) :
    this._style = style,
    this._name = name
  ;

  String? _name;

  String? get name {
    return this._name;
  }

  Style _style;

  Style get style {
    return this._style;
  }

  void set style(Style value) {
    if (this._style == value) {
      return;
    }

    this._style = value;

    this.markNeedsLayout();
  }

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return (
      '''
      ${this.name == null ? '' : 'Name: ${this.name}; '}${super.toString(minLevel: minLevel)}
      '''.trimIndent()
    );
  }

  StyledRenderBoxParentData? _styledParentData;

  StyledRenderBoxParentData? get styledParentData {
    return this._styledParentData;
  }

  ParentData? _parentData;

  ParentData? get parentData {
    return this._parentData;
  }

  void set parentData(ParentData? parentData) {
    this._parentData = parentData;

    if (parentData is StyledRenderBoxParentData?) {
      this._styledParentData = parentData;
    }
    else
    if (parentData is ContainerBoxParentData<RenderBox>) {
      this._styledParentData = (
        StyledRenderBoxParentData()
          ..offset = parentData.offset
          ..previousSibling = parentData.previousSibling
          ..nextSibling = parentData.nextSibling
      );
    }
    else
    if (parentData is BoxParentData) {
      this._styledParentData = (
        StyledRenderBoxParentData()
          ..offset = parentData.offset
      );
    }
    else {
      this._styledParentData = StyledRenderBoxParentData();
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
    final parent = this.parent;

    if (this._dryLayoutConstraints != null) {
      final dryLayoutConstraints = this._dryLayoutConstraints!;

      return dryLayoutConstraints;
    }

    if (parent == null) {
      return BoxConstraints(
        maxWidth: super.constraints.maxWidth,
        maxHeight: super.constraints.maxHeight,
      );
    }

    if (parent is StyledRenderBox) {
      return super.constraints;
    }

    var maxWidth = super.constraints.maxWidth;
    var maxHeight = super.constraints.maxHeight;

    if (parent is RenderBox) {
      late final Size parentSize;

      try {
        parentSize = parent.size;
      }
      catch (reason) {
        // if (this.parent is RenderSemanticsAnnotations || super.constraints.maxWidth == double.infinity || super.constraints.maxHeight == double.infinity) {
        //   this._skipDryLayout = true;
        // }

        parentSize = parent.getDryLayout(parent.constraints);
      }

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

  BoxModel boxModel = BoxModel();

  BoxModel? get parentBoxModel {
    final parent = this.parent;

    if (parent is StyledRenderBox) {
      return parent.boxModel;
    }

    return null;
  }

  @override
  void performLayout() {
    this._performLayout();
  }

  bool _skipDryLayout = false;

  // @override
  // void layout(Constraints constraints, {bool parentUsesSize = false}) {
  //   super.layout(constraints, parentUsesSize: parentUsesSize);
  // }

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
      this.boxModel.horizontalSpace,
      this.boxModel.verticalSpace,
    );
  }

  void _performLayout({bool isDryLayout = false}) {
    this.flexLayout(isDry: isDryLayout);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (this.style.opacity == 0) {
      return;
    }

    // Obtain the canvas from the context and create a blue paint object
    final Canvas canvas = context.canvas;
    final Paint paint = Paint();

    paint.color = (
      this.style.backgroundColor ?? Colors.transparent
    );

    final boxOffset = offset + this.boxModel.paddingBoxOffset;

    // Define the rectangle to be drawn (based on size and offset)
    final backgroundRRect = RRect.fromRectAndCorners(
      boxOffset & this.boxModel.paddingBoxSize,
      topLeft: this.boxModel.borderRadius.topLeft,
      topRight: this.boxModel.borderRadius.topRight,
      bottomLeft: this.boxModel.borderRadius.bottomLeft,
      bottomRight: this.boxModel.borderRadius.bottomRight,
    );

    final borderRRect = this.boxModel.getBorderBoxRRect(offset);

    // final borderRRect = RRect.fromRectAndCorners(
    //   (offset + boxModel.borderBoxOffset) & boxModel.borderBoxSize,
    //   topLeft: Radius.elliptical(rRect.tlRadiusX, rRect.tlRadiusY),
    //   topRight: Radius.elliptical(rRect.trRadiusX, rRect.trRadiusY),
    //   bottomLeft: Radius.elliptical(rRect.blRadiusX, rRect.blRadiusY),
    //   bottomRight: Radius.elliptical(rRect.brRadiusX, rRect.brRadiusY),
    // );

    if (this.style.boxShadow?.blurStyle == BlurStyle.inner) {
      canvas.drawRRect(backgroundRRect, paint);

      this.drawBoxShadow(
        context: context,
        borderRRect: borderRRect,
      );
    }
    else {
      this.drawBoxShadow(
        context: context,
        borderRRect: borderRRect,
      );

      canvas.drawRRect(backgroundRRect, paint);
    }

    if (this.style.border != null) {
      this.drawBorder(context, offset, borderRRect);
    }

    if (this.style.overflow == Overflow.HIDDEN) {
      canvas.save();

      canvas.clipRRect(borderRRect);
      this.defaultPaint(context, offset + this.boxModel.contentBoxOffset);

      if (!this.needsCompositing) {
        canvas.restore();
      }
    }
    else {
      this.defaultPaint(context, offset + this.boxModel.contentBoxOffset);
    }
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

  void drawBoxShadow({
    required PaintingContext context,
    required RRect borderRRect,
  }) {
    if (this.style.boxShadow != null) block: {
      final boxShadow = this.style.boxShadow!;

      if (boxShadow.blurRadius == 0 || boxShadow.color == Colors.transparent) {
        break block;
      }

      final canvas = context.canvas;

      final boxShadowPaint = (
        Paint()
          ..color = boxShadow.color
          ..maskFilter = MaskFilter.blur(boxShadow.blurStyle, boxShadow.blurRadius)
      );

      canvas.save();

      canvas.translate(boxShadow.offset.dx, boxShadow.offset.dy);

      canvas.drawDRRect(
        borderRRect.inflate(boxShadow.spreadRadius),
        boxShadow.blurStyle == BlurStyle.inner ? borderRRect.deflate(boxShadow.blurRadius) : RRect.zero,
        boxShadowPaint,
      );

      canvas.restore();
    }
  }

  void drawBorder(PaintingContext context, Offset offset, RRect rRect) {
    final border = this.style.border;

    if (border == null) {
      return;
    }

    final boxModel = this.boxModel;

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
    final boxOffset = this.boxModel.borderBoxOffset;

    final rect = boxOffset & this.boxModel.borderBoxSize;

    return rect.contains(position);
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    RenderBox? child = lastChild;

    while (child != null) {
      // The x, y parameters have the top left of the node's box as the origin.
      final childParentData = child.parentData! as ContainerBoxParentData<RenderBox>;

      final bool isHit = result.addWithPaintOffset(
        offset: childParentData.offset + this.boxModel.contentBoxOffset,
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
            : this.parentBoxModel!.borderBoxSize.height
          );
      break;

      case UnitType.PR:
        final parentBoxModel = this.parentBoxModel;

        if (parentBoxModel != null) {
          computedValue = unit.value * (
            direction == Axis.horizontal
              ? parentBoxModel.contentBox.width
              : parentBoxModel.contentBox.height
          );

          break;
        }

        computedValue = unit.value * (
          direction == Axis.horizontal
            ? this.constraints.maxWidth
            : this.constraints.maxHeight
        );
      break;

      default:
        throw Exception('Cannot handle unit type ${unit.unit}');
    }

    return computedValue;
  }

  void flexLayout({required bool isDry}) {
    final childrenIterable = (
      FlexDirection.isReversed(this.style.flexDirection)
        ? this.childrenReverseIterator()
        : this.childrenIterator()
    );

    final boxParentData = (this.parentData is StyledRenderBoxParentData) ? this.parentData as StyledRenderBoxParentData : null;

    final direction = boxParentData?.direction ?? Axis.vertical;

    final horizontalFlexSize = (
      (this.parent is! StyledRenderBox && this.style.alignSelf == ItemAlignment.STRETCH)
        ? this.constraints.maxWidth
        : boxParentData?.horizontalFlexSize
    );
    final verticalFlexSize = boxParentData?.verticalFlexSize;

    this.boxModel = BoxModel(
      isDry: isDry,
      name: this.name,
      direction: direction,
      horizontalFlexSize: horizontalFlexSize,
      verticalFlexSize: verticalFlexSize,
      shrink: this.style.flexShrink > 0,
      boxSizing: this.style.boxSizing,
      width: this.resolveWidth(this.style.width),
      height: this.resolveHeight(this.style.height),
      minWidth: this.resolveMinWidth(this.style.minWidth),
      maxWidth: this.resolveMaxWidth(this.style.maxWidth),
      minHeight: this.resolveMinHeight(this.style.minHeight),
      maxHeight: this.resolveMaxHeight(this.style.maxHeight),
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

    if (!isDry) {
      this.size = Size(
        this.boxModel.horizontalSpace,
        this.boxModel.verticalSpace,
      );
    }

    final contentSize = this.flexLayoutHandle(childrenIterable, isDry: isDry);

    this.boxModel = this.boxModel.copyWith(
      contentSize: contentSize,
    );

    if (!isDry) {
      this.size = Size(
        this.boxModel.horizontalSpace,
        this.boxModel.verticalSpace,
      );
    }
  }

  Size flexLayoutHandle(Iterable<(RenderBox, int)> childrenIterable, {required bool isDry}) {
    late final BoxConstraints childConstraints;

    // // Try to fix weird behavior when using flex-shrink
    // if (this.boxModel.shrink == true) {
    //   final baseConstrainsts = this.boxModel.getChildConstraints();

    //   childConstraints = baseConstrainsts.copyWith(
    //     maxWidth: Math.min(baseConstrainsts.maxWidth, this.constraints.maxWidth),
    //     maxHeight: Math.min(baseConstrainsts.maxHeight, this.constraints.maxHeight),
    //   );
    // }
    // else {
      final baseConstrainsts = this.boxModel.getChildConstraints();

      childConstraints = baseConstrainsts.enforce(
        BoxConstraints(
          maxWidth: this.constraints.maxWidth,
          maxHeight: this.constraints.maxHeight,
        )
      );
    // }

    // To support scrollers
    if (this.style.expandChildHorizontal && this.style.expandChildVertical) {
      if (this.childCount == 0) {
        return Size.zero;
      }

      if (this.childCount > 1) {
        throw AssertionError('Cannot use expandChild if children length is greater than 1');
      }

      final child = this.firstChild!;

      final singleChildConstraints = BoxConstraints(
        maxWidth: boxModel.contentBox.width,
        minWidth: boxModel.contentBox.width,
        maxHeight: boxModel.contentBox.height,
        minHeight: boxModel.contentBox.height,
      );

      if (isDry) {
        child.getDryLayout(singleChildConstraints);
      }
      else {
        child.layout(singleChildConstraints);
      }

      final childParentData = child.parentData as ContainerBoxParentData<RenderBox>;

      childParentData.offset = Offset(0, 0);

      return Size.zero;
    }
    else
    if (this.style.expandChildHorizontal) {
      if (this.childCount == 0) {
        return Size.zero;
      }

      if (this.childCount > 1) {
        throw AssertionError('Cannot use expandChildHorizontal if children length is greater than 1');
      }

      final child = this.firstChild!;

      final singleChildConstraints = BoxConstraints(
        maxWidth: boxModel.contentBox.width,
        minWidth: boxModel.contentBox.width,
        maxHeight: childConstraints.maxHeight,
      );

      // // Avoid relayout boundary error when using `flexGrow` on parent
      // final childSize = child.getDryLayout(singleChildConstraints);

      // child.layout(singleChildConstraints);

      // final childParentData = child.parentData as ContainerBoxParentData<RenderBox>;

      // childParentData.offset = Offset(0, 0);

      // return Size(0, childSize.height);

      late final Size childSize;

      try {
        child.layout(singleChildConstraints, parentUsesSize: true);

        childSize = child.size;
      }
      catch (reason) {
        childSize = child.getDryLayout(singleChildConstraints);

        child.layout(singleChildConstraints);
      }

      final childParentData = child.parentData as ContainerBoxParentData<RenderBox>;

      childParentData.offset = Offset(0, 0);

      return Size(0, childSize.height);
    }
    else
    if (this.style.expandChildVertical) {
      if (this.childCount == 0) {
        return Size.zero;
      }

      if (this.childCount > 1) {
        throw AssertionError('Cannot use expandChildVertical if children length is greater than 1');
      }

      final child = this.firstChild!;

      final singleChildConstraints = BoxConstraints(
        maxWidth: childConstraints.maxWidth,
        maxHeight: boxModel.contentBox.height,
        minHeight: boxModel.contentBox.height,
      );

      // // Avoid relayout boundary error when using `flexGrow` on parent
      // final childSize = child.getDryLayout(singleChildConstraints);

      // child.layout(singleChildConstraints);

      // final childParentData = child.parentData as ContainerBoxParentData<RenderBox>;

      // childParentData.offset = Offset(0, 0);

      // return Size(childSize.width, 0);

      late final Size childSize;

      try {
        child.layout(singleChildConstraints, parentUsesSize: true);

        childSize = child.size;
      }
      catch (reason) {
        childSize = child.getDryLayout(singleChildConstraints);

        child.layout(singleChildConstraints);
      }

      final childParentData = child.parentData as ContainerBoxParentData<RenderBox>;

      childParentData.offset = Offset(0, 0);

      return Size(childSize.width, 0);
    }

    final gap = Gap(
      vertical: this.resolveUnit(this.style.gap.vertical, direction: Axis.vertical)!,
      horizontal: this.resolveUnit(this.style.gap.horizontal, direction: Axis.horizontal)!,
    );

    var contentWidth = 0.0;
    var contentHeight = 0.0;

    var maxChildWidth = 0.0;
    var maxChildHeight = 0.0;

    var currentDx = 0.0;
    var currentDy = 0.0;

    var totalFlexGrow = 0.0;
    var totalFlexShrink = 0.0;

    var flexGrowChildContentWidth = 0.0;
    var flexGrowChildContentHeight = 0.0;

    final hasSize = (
      FlexDirection.isVertical(this.style.flexDirection) && (this.style.width != Unit.auto || this.styledParentData?.horizontalFlexSize != null)
      || FlexDirection.isHorizontal(this.style.flexDirection) && (this.style.height != Unit.auto || this.styledParentData?.verticalFlexSize != null)
    );

    // 1st Pass

    for (final (child, _) in childrenIterable) {
      final childParentData = child.parentData as ContainerBoxParentData<RenderBox>;

      if (childParentData is StyledRenderBoxParentData) {
        childParentData.direction = FlexDirection.getAxisFrom(this.style.flexDirection);

        // Reset bad state from dryLayout

        if (childParentData.horizontalFlexSize == double.infinity) {
          childParentData.horizontalFlexSize = null;
        }

        if (childParentData.verticalFlexSize == double.infinity) {
          childParentData.verticalFlexSize = null;
        }
      }

      if (child is StyledRenderBox) {
        totalFlexGrow += child.style.flexGrow;
        totalFlexShrink += child.style.flexShrink;
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
            childParentData.horizontalFlexSize = this.boxModel.contentBox.width;
          }
        }
        else {
          if (childParentData is StyledRenderBoxParentData) {
            childParentData.verticalFlexSize = this.boxModel.contentBox.height;
          }
        }
      }

      late final Size childSize;

      if (isDry) {
        childSize = child.getDryLayout(
          childConstraints.copyWith(
            // Avoid dry layout cache retuning wrong size when `childConstraints.maxHeight` is `double.infinity`.
            // Assigning `minHeight` to `1` will force the dry layout to not use the cache.
            // Fix added because of `RefreshIndicator` widget that caused infinite max height being computed.
            minHeight: childConstraints.maxHeight.isInfinite ? 1 : childConstraints.minHeight,
          )
        );
      }
      else {
        if (child is StyledRenderBox && (child.style.flexGrow > 0 || child.style.flexShrink > 0)) {
          // try {
            childSize = child.getDryLayout(childConstraints);
          // }
          // catch (reason) {
          //   childSize = child.size;
          // }
        }
        else {
          child.layout(
            childConstraints,
            parentUsesSize: true,
          );

          childSize = child.size;
        }
      }

      if (this.style.flexWrap == FlexWrap.NOWRAP) {
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
              childParentData.offset = Offset(this.boxModel.contentBox.width - childSize.width, childParentData.offset.dy);
            }
            else {
              childParentData.offset = Offset(childParentData.offset.dx, this.boxModel.contentBox.height - childSize.height);
            }
          break;

          case ItemAlignment.CENTER:
            if (FlexDirection.isVertical(this.style.flexDirection)) {
              childParentData.offset = Offset(this.boxModel.contentBox.width / 2 - childSize.width / 2, childParentData.offset.dy);
            }
            else {
              childParentData.offset = Offset(childParentData.offset.dx, this.boxModel.contentBox.height / 2 - childSize.height / 2);
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
      else {
        childParentData.offset = Offset(currentDx, currentDy);
      }

      maxChildWidth = Math.max(maxChildWidth, childSize.width);
      maxChildHeight = Math.max(maxChildHeight, childSize.height);

      if (FlexDirection.isVertical(this.style.flexDirection)) {
        contentHeight += childSize.height + gap.vertical;
        currentDy += childSize.height + gap.vertical;

        if (child is StyledRenderBox && child.style.flexGrow > 0) {
          flexGrowChildContentHeight += childSize.height;
        }
      }
      else {
        contentWidth += childSize.width + gap.horizontal;
        currentDx += childSize.width + gap.horizontal;

        if (child is StyledRenderBox && child.style.flexGrow > 0) {
          flexGrowChildContentWidth += childSize.width;
        }
      }
    }

    currentDx -= gap.horizontal;
    currentDy -= gap.vertical;

    if (FlexDirection.isVertical(this.style.flexDirection)) {
      contentHeight -= gap.vertical;
      contentWidth = maxChildWidth;
    }
    else {
      contentWidth -= gap.horizontal;
      contentHeight = maxChildHeight;
    }

    this.boxModel = this.boxModel.copyWith(
      contentSize: Size(contentWidth, contentHeight),
    );

    // if (isDry) {
    //   return Size(contentWidth, contentHeight);
    // }

    // 2nd Pass

    final availableSpaceInMainAxis = (
      FlexDirection.isVertical(this.style.flexDirection)
        ? boxModel.contentBox.height - (this.boxModel.contentSize.height - flexGrowChildContentHeight)
        : boxModel.contentBox.width - (this.boxModel.contentSize.width - flexGrowChildContentWidth)
    );

    contentWidth = 0.0;
    contentHeight = 0.0;

    maxChildWidth = 0.0;
    maxChildHeight = 0.0;

    flexGrowChildContentWidth = 0.0;
    flexGrowChildContentHeight = 0.0;

    // This first loop is to handle the flexGrow children that can affect the size of their parent
    for (final (child, _) in childrenIterable) {
      final childParentData = child.parentData;

      if (childParentData is! BoxParentData) {
        continue;
      }

      if (child is StyledRenderBox && childParentData is StyledRenderBoxParentData && child.style.flexGrow > 0) {
        final flexGrowSize = availableSpaceInMainAxis * child.style.flexGrow / Math.max(1, totalFlexGrow);

        if (FlexDirection.isVertical(this.style.flexDirection)) {
          childParentData.verticalFlexSize = flexGrowSize;
        }
        else {
          childParentData.horizontalFlexSize = flexGrowSize;
        }
      }

      late final Size childSize;

      if (isDry) {
        childSize = child.getDryLayout(childConstraints);
      }
      // else
      // if (child is StyledRenderBox && child.style.flexShrink == 0) {
      //   child.layout(childConstraints, parentUsesSize: true);

      //   childSize = child.size;
      // }
      else {
        // childSize = child.getDryLayout(childConstraints);
        child.layout(childConstraints, parentUsesSize: true);

        childSize = child.size;
      }

      maxChildWidth = Math.max(maxChildWidth, childSize.width);
      maxChildHeight = Math.max(maxChildHeight, childSize.height);

      if (FlexDirection.isVertical(this.style.flexDirection)) {
        contentHeight += childSize.height + gap.vertical;

        if (child is StyledRenderBox && (child.style.flexGrow > 0 && childParentData is StyledRenderBoxParentData)) {
          flexGrowChildContentHeight += childSize.height;
        }
      }
      else {
        contentWidth += childSize.width + gap.horizontal;

        if (child is StyledRenderBox && (child.style.flexGrow > 0 && childParentData is StyledRenderBoxParentData)) {
          flexGrowChildContentWidth += childSize.width;
        }
      }
    }

    if (FlexDirection.isVertical(this.style.flexDirection)) {
      contentHeight -= gap.vertical;
      contentWidth = maxChildWidth;
    }
    else {
      contentWidth -= gap.horizontal;
      contentHeight = maxChildHeight;
    }

    this.boxModel = this.boxModel.copyWith(
      contentSize: Size(contentWidth, contentHeight),
    );


    currentDx = 0.0;
    currentDy = 0.0;

    // final isMainAxisContentBoxLowerThanContentSize = (
    //   FlexDirection.isVertical(this.style.flexDirection)
    //     ? this.boxModel.contentBox.height < this.boxModel.contentSize.height
    //     : this.boxModel.contentBox.width < this.boxModel.contentSize.width
    // );

    final childSizeMap = Map<RenderBox, Size>();

    for (final (child, _) in childrenIterable) {
      final childParentData = child.parentData;

      if (childParentData is! BoxParentData) {
        continue;
      }

      // if (isMainAxisContentBoxLowerThatContentSize && child is StyledRenderBox && childParentData is StyledRenderBoxParentData && child.style.flexShrink > 0) {
      //   final flexShrinkSize = availableSpaceInMainAxis * (totalFlexShrink - child.style.flexShrink) / Math.max(1, totalFlexShrink);

      //   if (FlexDirection.isVertical(this.style.flexDirection)) {
      //     childParentData.verticalFlexSize = flexShrinkSize;
      //   }
      //   else {
      //     childParentData.horizontalFlexSize = flexShrinkSize;
      //   }
      // }

      late final Size childSize;

      if (isDry) {
        childSize = child.getDryLayout(childConstraints);
      }
      else {
        child.layout(childConstraints, parentUsesSize: true);

        childSize = child.size;
      }

      childSizeMap[child] = childSize;

      if (FlexDirection.isVertical(this.style.flexDirection)) {
        childParentData.offset = Offset(childParentData.offset.dx, currentDy);
        currentDy += childSize.height + gap.vertical;
      }
      else {
        childParentData.offset = Offset(currentDx, childParentData.offset.dy);

        final offsetDx = childSize.width + gap.horizontal;

        // if ((this.boxModel.width != null || this.style.flexShrink > 0) && this.style.flexWrap != FlexWrap.NOWRAP && currentDx + offsetDx > this.boxModel.contentBox.width) {
        //   currentDx = 0.0;
        //   currentDy += maxChildHeight + gap.vertical;
        // }
        // else {
          currentDx += offsetDx;
        // }
      }

      final itemAlignment = () {
        if (child is StyledRenderBox && child.style.alignSelf != null) {
          return child.style.alignSelf!;
        }
        else {
          return this.style.alignItems;
        }
      }();

      // The additional logic solves a Hot Reload bug when resetting flexSize of the parentData in
      // the updateRenderObject method
      final hasToReComputeItemAlignment = (
        !hasSize
        || (
          child is StyledRenderBox && (
            (child.style.flexGrow > 0 && (child.styledParentData?.verticalFlexSize == null || child.styledParentData?.horizontalFlexSize == null))
          )
        )
      );

      // Support cross axis alignment on boxes with auto size

      if (hasToReComputeItemAlignment) {
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
              childParentData.offset = Offset(this.boxModel.contentBox.width - childSize.width, childParentData.offset.dy);
            }
            else {
              childParentData.offset = Offset(childParentData.offset.dx, this.boxModel.contentBox.height - childSize.height);
            }
          break;

          case ItemAlignment.CENTER:
            if (FlexDirection.isVertical(this.style.flexDirection)) {
              childParentData.offset = Offset(this.boxModel.contentBox.width / 2 - childSize.width / 2, childParentData.offset.dy);
            }
            else {
              childParentData.offset = Offset(childParentData.offset.dx, this.boxModel.contentBox.height / 2 - childSize.height / 2);
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

    currentDx -= gap.horizontal;
    currentDy -= gap.vertical;

    // if (isDry) {
    //   Size(this.boxModel.contentSize.width, this.boxModel.contentSize.height);
    // }

    final canJustifyContent = (
      totalFlexGrow == 0
      && (
        (FlexDirection.isVertical(this.style.flexDirection) && boxModel.contentBox.height > 0)
        || (FlexDirection.isHorizontal(this.style.flexDirection) && boxModel.contentBox.width > 0)
      )
    );

    if (canJustifyContent) {
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

              // if (boxModel.height == null && boxModel.minHeight > 0) {
              //   translationValue = boxModel.minHeight - contentHeight;
              // }

              for (final (child, _) in childrenIterable) {
                final childParentData = child.parentData as ContainerBoxParentData<RenderBox>;

                childParentData.offset = childParentData.offset.translate(0, translationValue);
              }
            break;

            case FlexDirection.VERTICAL_REVERSE:
              // Nothing to do
            break;

            case FlexDirection.HORIZONTAL:
              var translationValue = boxModel.contentBox.width - contentWidth;

              // if (boxModel.width == null && boxModel.minWidth > 0) {
              //   translationValue = boxModel.minWidth - contentWidth;
              // }

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
            if ((boxModel.contentSize.height + gap.vertical * (this.childCount - 1)) > boxModel.contentBox.height) {
              break;
            }

            final translationValue = (boxModel.contentBox.height - (boxModel.contentSize.height - (gap.vertical * (this.childCount - 1)))) / (this.childCount - 1);

            if (translationValue <= 0) {
              break;
            }

            var currentChildrenSizeOffset = 0.0;

            for (final (child, index) in childrenIterable) {
              final childParentData = child.parentData as ContainerBoxParentData<RenderBox>;

              currentChildrenSizeOffset += childSizeMap[childParentData.previousSibling]?.height ?? 0.0;

              childParentData.offset = Offset(childParentData.offset.dx, translationValue * index + currentChildrenSizeOffset);
            }
          }
          else {
            if ((boxModel.contentSize.width + gap.horizontal * (this.childCount - 1)) > boxModel.contentBox.width) {
              break;
            }

            final translationValue = (boxModel.contentBox.width - (boxModel.contentSize.width - (gap.horizontal * (this.childCount - 1)))) / (this.childCount - 1);

            if (translationValue <= 0) {
              break;
            }

            var currentChildrenSizeOffset = 0.0;

            for (final (child, index) in childrenIterable) {
              final childParentData = child.parentData as ContainerBoxParentData<RenderBox>;

              currentChildrenSizeOffset += childSizeMap[childParentData.previousSibling]?.width ?? 0.0;

              childParentData.offset = Offset(translationValue * index + currentChildrenSizeOffset, childParentData.offset.dy);
            }
          }
        break;

        case ContentAlignment.SPACE_AROUND:
          if (this.childCount == 1) {
            break;
          }

          if (FlexDirection.isVertical(this.style.flexDirection)) {
            if ((boxModel.contentSize.height + gap.vertical * (this.childCount - 1)) > boxModel.contentBox.height) {
              break;
            }

            final translationValue = (
              (boxModel.contentBox.height - (boxModel.contentSize.height - (gap.vertical * (this.childCount - 1)))) / this.childCount
            ) / 2;

            if (translationValue <= 0) {
              break;
            }

            var currentTranslationOffset = 0.0;

            for (final (child, index) in childrenIterable) {
              final childParentData = child.parentData as ContainerBoxParentData<RenderBox>;

              currentTranslationOffset += translationValue;

              if (index == 0) {
                currentTranslationOffset -= gap.vertical * (this.childCount - 1) / 2;
              }

              if (index > 0) {
                currentTranslationOffset += childSizeMap[childParentData.previousSibling]!.height + translationValue + gap.vertical;
              }

              childParentData.offset = Offset(childParentData.offset.dx, currentTranslationOffset);
            }
          }
          else {
            if ((boxModel.contentSize.width + gap.horizontal * (this.childCount - 1)) > boxModel.contentBox.width) {
              break;
            }

            final translationValue = (
              (boxModel.contentBox.width - (boxModel.contentSize.width - (gap.horizontal * (this.childCount - 1)))) / this.childCount
            ) / 2;

            if (translationValue <= 0) {
              break;
            }

            var currentTranslationOffset = 0.0;

            for (final (child, index) in childrenIterable) {
              final childParentData = child.parentData as ContainerBoxParentData<RenderBox>;

              currentTranslationOffset += translationValue;

              if (index == 0) {
                currentTranslationOffset -= gap.horizontal * (this.childCount - 1) / 2;
              }

              if (index > 0) {
                currentTranslationOffset += childSizeMap[childParentData.previousSibling]!.width + translationValue + gap.horizontal;
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
            if ((boxModel.contentSize.height + gap.vertical * (this.childCount - 1)) > boxModel.contentBox.height) {
              break;
            }

            final translationValue = (
              (boxModel.contentBox.height - (contentHeight - (gap.vertical * (this.childCount - 1)))) / (this.childCount + 1)
            );

            if (translationValue <= 0) {
              break;
            }

            var currentTranslationOffset = 0.0;

            for (final (child, index) in childrenIterable) {
              final childParentData = child.parentData as ContainerBoxParentData<RenderBox>;

              currentTranslationOffset += translationValue;

              if (index == 0) {
                currentTranslationOffset -= gap.vertical * (this.childCount - 1) / 2;
              }

              if (index > 0) {
                currentTranslationOffset += childSizeMap[childParentData.previousSibling]!.height + gap.vertical;
              }

              childParentData.offset = Offset(childParentData.offset.dx, currentTranslationOffset);
            }
          }
          else {
            if ((boxModel.contentSize.width + gap.horizontal * (this.childCount - 1)) > boxModel.contentBox.width) {
              break;
            }

            final translationValue = (
              (boxModel.contentBox.width - (contentWidth - (gap.horizontal * (this.childCount - 1)))) / (this.childCount + 1)
            );

            if (translationValue <= 0) {
              break;
            }

            var currentTranslationOffset = 0.0;

            for (final (child, index) in childrenIterable) {
              final childParentData = child.parentData as ContainerBoxParentData<RenderBox>;

              currentTranslationOffset += translationValue;

              if (index == 0) {
                currentTranslationOffset -= gap.horizontal * (this.childCount - 1) / 2;
              }

              if (index > 0) {
                currentTranslationOffset += childSizeMap[childParentData.previousSibling]!.width + gap.horizontal;
              }

              childParentData.offset = Offset(currentTranslationOffset, childParentData.offset.dy);
            }
          }
        break;

      }
    }

    return Size(this.boxModel.contentSize.width, this.boxModel.contentSize.height);
  }

  double resolveMinWidth(Unit? unit) {
    if (unit == null) {
      return 0;
    }

    final computedValue = this.resolveUnit(unit, direction: Axis.horizontal)!;

    return computedValue;
  }

  double resolveMaxWidth(Unit? unit) {
    if (unit == null) {
      return double.infinity;
    }

    final computedValue = this.resolveUnit(unit, direction: Axis.horizontal)!;

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

    // Avoid computing a infinite max height if possible to avoid issues.
    // Fix added because of `RefreshIndicator` widget that caused infinite max height being computed.
    if (computedValue.isInfinite) {
      final parent = this.parent;

      if (parent is RenderBox && parent.hasSize) {
        return parent.size.height;
      }
    }

    return computedValue;
  }

  double resolveMaxHeight(Unit? unit) {
    if (unit == null) {
      return double.infinity;
    }

    final computedValue = this.resolveUnit(unit, direction: Axis.vertical)!;

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
