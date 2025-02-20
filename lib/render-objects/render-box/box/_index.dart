import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart' hide BorderSide;
import 'package:flutter/rendering.dart';
import 'dart:math' as Math;

import '/render-objects/render-box/box/style.dart';
import '/render-objects/render-box/box/box_model.dart';



class Box extends MultiChildRenderObjectWidget {

  const Box({
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

}

class BoxParentData extends ContainerBoxParentData<RenderBox> {

  BoxParentData();

}

/// A custom RenderBox that draws a blue rectangle
class StyledRenderBox extends RenderBox with ContainerRenderObjectMixin<RenderBox, BoxParentData>, RenderBoxContainerDefaultsMixin<RenderBox, BoxParentData> {

  StyledRenderBox({
    this.style = const Style(),
  });

  final Style style;

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

    child.parentData ??= BoxParentData();
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

  @override
  BoxConstraints get constraints {
    return BoxConstraints(
      maxWidth: super.constraints.maxWidth,
      maxHeight: super.constraints.maxHeight,
    );
  }

  late BoxModel boxModel;

  var parentBoxModel = null as BoxModel?;

  get parentConstrainedWidth {
    final parent = this.parent;

    if (parent is StyledRenderBox) {
      return parent.boxModel.contentBox.width;
    }

    return super.constraints.maxWidth;
  }

  get parentConstrainedHeight {
    final parent = this.parent;

    if (parent is StyledRenderBox) {
      return parent.boxModel.contentBox.height;
    }

    return super.constraints.maxHeight;
  }

  @override
  void performLayout() {
    final style = this.style;

    if (this.parent is StyledRenderBox) {
      this.parentBoxModel = (this.parent as StyledRenderBox).boxModel;
    }

    final computedMinWidth = this.resolveMinWidth(style.minWidth);

    final computedMaxWidth = this.resolveMaxWidth(style.maxWidth);

    final computedWidth = this.resolveWidth(style.width)?.clamp(computedMinWidth, computedMaxWidth);

    final computedMinHeight = this.resolveMinHeight(style.minHeight);

    final computedMaxHeight = this.resolveMaxHeight(style.maxHeight);

    final computedHeight = this.resolveHeight(style.height)?.clamp(computedMinHeight, computedMaxHeight);

    final isParentAutoSizedByContent = computedWidth == null || computedHeight == null;

    if (!isParentAutoSizedByContent) {
      this.boxModel = BoxModel(
        boxSizing: style.boxSizing,
        width: computedWidth,
        height: computedHeight,
        margin: EdgeInsets.only(
          top: this.resolveUnit(style.margin?.top) ?? 0,
          right: this.resolveUnit(style.margin?.right) ?? 0,
          bottom: this.resolveUnit(style.margin?.bottom) ?? 0,
          left: this.resolveUnit(style.margin?.left) ?? 0,
        ),
        paddingBox: EdgeInsets.only(
          top: this.resolveUnit(style.padding?.top) ?? 0,
          right: this.resolveUnit(style.padding?.right) ?? 0,
          bottom: this.resolveUnit(style.padding?.bottom) ?? 0,
          left: this.resolveUnit(style.padding?.left) ?? 0,
        ),
      );

      this.size = Size(
        this.boxModel.horizontalSpace,
        this.boxModel.verticalSpace,
      );
    }

    final (contentWidth, contentHeight) = (
      this.flexLayout(isParentAutoSizedByContent)
    );

    if (isParentAutoSizedByContent) {
      this.boxModel = BoxModel(
        boxSizing: style.boxSizing,
        width: computedWidth,
        height: computedHeight,
        contentWidth: contentWidth,
        contentHeight: contentHeight,
        margin: EdgeInsets.only(
          top: this.resolveUnit(style.margin?.top) ?? 0,
          right: this.resolveUnit(style.margin?.right) ?? 0,
          bottom: this.resolveUnit(style.margin?.bottom) ?? 0,
          left: this.resolveUnit(style.margin?.left) ?? 0,
        ),
        paddingBox: EdgeInsets.only(
          top: this.resolveUnit(style.padding?.top) ?? 0,
          right: this.resolveUnit(style.padding?.right) ?? 0,
          bottom: this.resolveUnit(style.padding?.bottom) ?? 0,
          left: this.resolveUnit(style.padding?.left) ?? 0,
        ),
      );

      this.size = Size(
        this.boxModel.horizontalSpace,
        this.boxModel.verticalSpace,
      );
    }
  }

  Offset offset = Offset(0, 0);

  @override
  void paint(PaintingContext context, Offset offset) {
    this.offset = offset;

    // Obtain the canvas from the context and create a blue paint object
    final Canvas canvas = context.canvas;
    final Paint paint = Paint();

    paint.color = this.style.backgroundColor ?? Colors.transparent;

    final boxOffset = offset + this.boxModel.paddingBoxOffset;

    // Define the rectangle to be drawn (based on size and offset)
    final rect = boxOffset & this.boxModel.paddingBoxSize;

    final rRect = RRect.fromRectAndCorners(
      rect,
      topLeft: const Radius.circular(0),
      topRight: const Radius.circular(0),
      bottomLeft: const Radius.circular(0),
      bottomRight: const Radius.circular(0),
    );

    canvas.drawRRect(rRect, paint);

    if (this.style.overflow == Overflow.HIDDEN) {
      canvas.clipRRect(rRect);
    }

    this.defaultPaint(context, offset + this.boxModel.contentBoxOffset);
  }

  @override
  bool hitTestSelf(Offset position) {
    final boxOffset = this.offset + this.boxModel.borderBoxOffset;

    final rect = boxOffset & this.boxModel.borderBoxSize;

    return rect.contains(position);
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

  (double contentWidth, double contentHeight) flexLayout(isParentAutoSizedByContent) {
    final childrenIterable = (
      FlexDirection.isReversed(this.style.flexDirection)
        ? this.childrenReverseIterator()
        : this.childrenIterator()
    );

    var contentWidth = 0.0;
    var contentHeight = 0.0;

    var maxChildWidth = 0.0;
    var maxChildHeight = 0.0;

    var totalDx = 0.0;
    var totalDy = 0.0;

    final rowGap = this.resolveUnit(this.style.rowGap, direction: Axis.vertical) ?? 0;
    final columnGap = this.resolveUnit(this.style.columnGap, direction: Axis.vertical) ?? 0;

    final childConstraints = (
      isParentAutoSizedByContent
        ? BoxConstraints(
          maxWidth: double.infinity,
          maxHeight: double.infinity,
        )
        : this.parentBoxModel != null
            ? BoxConstraints(
              maxWidth: this.parentBoxModel!.contentBox.width,
              maxHeight: this.parentBoxModel!.contentBox.height,
            )
            : BoxConstraints(
              maxWidth: this.size.width,
              maxHeight: this.size.height,
            )
    );

    for (final (child, _) in childrenIterable) {
      final childParentData = child.parentData as ContainerBoxParentData<RenderBox>;

      final itemAlignment = () {
        if (child is StyledRenderBox && child.style.alignSelf != null) {
          return child.style.alignSelf!;
        }
        else {
          return this.style.alignItems;
        }
      }();

      child.layout(
        childConstraints,
        parentUsesSize: true,
      );

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
            childParentData.offset = Offset(this.boxModel.contentBox.width - child.size.width, totalDy);
          }
          else {
            childParentData.offset = Offset(totalDx, this.boxModel.contentBox.height - child.size.height);
          }
        break;

        case ItemAlignment.CENTER:
          if (FlexDirection.isVertical(this.style.flexDirection)) {
            childParentData.offset = Offset(this.boxModel.contentBox.width / 2 - child.size.width / 2, totalDy);
          }
          else {
            childParentData.offset = Offset(totalDx, this.boxModel.contentBox.height / 2 - child.size.height / 2);
          }
        break;

        case ItemAlignment.STRETCH:

        break;

      }

      maxChildWidth = Math.max(maxChildWidth, child.size.width);
      maxChildHeight = Math.max(maxChildHeight, child.size.height);

      if (FlexDirection.isVertical(this.style.flexDirection)) {
        contentHeight += child.size.height;
        totalDy += child.size.height + rowGap;
      }
      else {
        contentWidth += child.size.width;
        totalDx += child.size.width + columnGap;
      }
    }

    totalDx -= columnGap;
    totalDy -= rowGap;

    // TESTING Justity Content

    if (this.style.justifyContent == ContentAlignment.CENTER) {
      final totalHeight = this.boxModel.contentBox.height;

      final translationValue = (totalHeight - contentHeight) / 2;

      for (final (child, _) in childrenIterable) {
        final childParentData = child.parentData as ContainerBoxParentData<RenderBox>;

        childParentData.offset = childParentData.offset.translate(0, translationValue);
      }
    }

    if (FlexDirection.isVertical(this.style.flexDirection)) {
      contentWidth = maxChildWidth;
    }
    else {
      contentHeight = maxChildHeight;
    }

    return (contentWidth, contentHeight);
  }

  double resolveMinWidth(Unit? unit) {
    if (unit == null) {
      return 0;
    }

    final computedValue = this.resolveUnit(unit, direction: Axis.horizontal)!;

    return Math.max(computedValue, this.constraints.minWidth);
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

    return Math.max(computedValue, this.constraints.minHeight);
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

}
