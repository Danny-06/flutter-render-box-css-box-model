import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart' hide BorderSide;
import 'package:flutter/rendering.dart' hide BorderSide;
import 'dart:math' as Math;
import 'dart:ui' as ui;

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

  Axis direction = Axis.vertical;

  double? verticalFlexSize;

  double? horizontalFlexSize;

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

  BoxConstraints? _dryLayoutConstraints;

  @override
  BoxConstraints get constraints {
    if (this._dryLayoutConstraints != null) {
      return BoxConstraints(
        maxWidth: this._dryLayoutConstraints!.maxWidth,
        maxHeight: this._dryLayoutConstraints!.maxHeight,
      );
    }

    return BoxConstraints(
      maxWidth: super.constraints.maxWidth,
      maxHeight: super.constraints.maxHeight,
    );
  }

  BoxParentData? get boxParentData {
    final parentData = this.parentData;

    if (parentData is BoxParentData) {
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

    return this.constraints.maxWidth;
  }

  double get parentConstrainedHeight {
    final parentBoxModel = this.parentBoxModel;

    if (parentBoxModel != null) {
      return parentBoxModel.contentBox.height;
    }

    return this.constraints.maxHeight;
  }

  @override
  void performLayout() {
    this._performLayout();
  }

  @override
  Size computeDryLayout(covariant BoxConstraints constraints) {
    this._dryLayoutConstraints = constraints;

    this._performLayout(isDryLayout: true);

    this._dryLayoutConstraints = null;

    return Size(
      this.boxModel!.horizontalSpace,
      this.boxModel!.verticalSpace,
    );
  }

  void _performLayout({bool isDryLayout = false}) {
    final computedMinWidth = this.resolveMinWidth(this.style.minWidth);

    final computedMaxWidth = this.resolveMaxWidth(this.style.maxWidth);

    final computedWidth = this.resolveWidth(this.style.width)?.clamp(computedMinWidth, computedMaxWidth);

    final computedMinHeight = this.resolveMinHeight(this.style.minHeight);

    final computedMaxHeight = this.resolveMaxHeight(this.style.maxHeight);

    final computedHeight = this.resolveHeight(this.style.height)?.clamp(computedMinHeight, computedMaxHeight);

    final isAutoSizedByContent = computedWidth == null || computedHeight == null;

    if (!isAutoSizedByContent) {
      final boxModel = BoxModel(
        boxSizing: this.style.boxSizing,
        width: computedWidth,
        height: computedHeight,
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
      final boxParentData = (this.parentData is BoxParentData) ? this.parentData as BoxParentData : null;

      final direction = boxParentData?.direction;
      final horizontalFlexSize = boxParentData?.horizontalFlexSize;
      final verticalFlexSize = boxParentData?.verticalFlexSize;

      final boxModel = BoxModel(
        direction: direction,
        horizontalFlexSize: horizontalFlexSize,
        verticalFlexSize: verticalFlexSize,
        boxSizing: this.style.boxSizing,
        width: computedWidth,
        height: computedHeight,
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
      final boxParentData = (this.parentData is BoxParentData) ? this.parentData as BoxParentData : null;

      final direction = boxParentData?.direction;
      final horizontalFlexSize = boxParentData?.horizontalFlexSize;
      final verticalFlexSize = boxParentData?.verticalFlexSize;

      final boxModel = BoxModel(
        direction: direction,
        horizontalFlexSize: horizontalFlexSize,
        verticalFlexSize: verticalFlexSize,
        boxSizing: this.style.boxSizing,
        width: computedWidth,
        height: computedHeight,
        contentWidth: contentWidth.clamp(computedMinWidth, computedMaxWidth),
        contentHeight: contentHeight.clamp(computedMinHeight, computedMaxHeight),
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
    final rect = boxOffset & boxModel.paddingBoxSize;

    final rRect = RRect.fromRectAndCorners(
      rect,
      topLeft: this.style.borderRadius.topLeft,
      topRight: this.style.borderRadius.topRight,
      bottomLeft: this.style.borderRadius.bottomLeft,
      bottomRight: this.style.borderRadius.bottomRight,
    );

    canvas.drawRRect(rRect, paint);

    if (this.style.overflow == Overflow.HIDDEN) {
      canvas.clipRRect(rRect);
    }

    this.defaultPaint(context, offset + boxModel.contentBoxOffset);
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

    // To support scrollers
    if (this.style.expandChild) {
      if (this.childCount > 1) {
        throw AssertionError('Cannot use expandChild if children length is greater than 1');
      }

      final child = this.firstChild!;

      child.layout(
        BoxConstraints(
          maxWidth: boxModel.contentBox.width,
          minWidth: boxModel.contentBox.width,
          maxHeight: boxModel.contentBox.height,
          minHeight: boxModel.contentBox.height,
        ),
      );

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

    final childConstraints = (
      isAutoSizedByContent
        ? BoxConstraints(
          maxWidth: this.constraints.maxWidth,
          maxHeight: this.constraints.maxHeight,
        )
        : BoxConstraints(
            maxWidth: boxModel.contentBox.width,
            maxHeight: boxModel.contentBox.height,
          )
    );

    final isMainAxisAutoSized = (
      FlexDirection.isVertical(this.style.flexDirection)
        ? this.style.height == Unit.auto
        : this.style.width == Unit.auto
    );

    var contentWidth = 0.0;
    var contentHeight = 0.0;

    var maxChildWidth = 0.0;
    var maxChildHeight = 0.0;

    var totalDx = 0.0;
    var totalDy = 0.0;

    var totalFlexGrow = 0.0;

    for (final (child, _) in childrenIterable) {
      final childParentData = child.parentData as ContainerBoxParentData<RenderBox>;

      if (childParentData is BoxParentData) {
        childParentData.direction = FlexDirection.getAxisFrom(this.style.flexDirection);
      }

      if (!isMainAxisAutoSized && child is StyledRenderBox) {
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
          if (childParentData is BoxParentData) {
            childParentData.horizontalFlexSize = boxModel.contentBox.width;
          }
        }
        else {
          if (childParentData is BoxParentData) {
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

      final hasSize = (
        FlexDirection.isVertical(this.style.flexDirection) && (this.style.width != Unit.auto || this.boxParentData?.horizontalFlexSize != null)
        || !FlexDirection.isVertical(this.style.flexDirection) && (this.style.height != Unit.auto || this.boxParentData?.verticalFlexSize != null)
      );

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
      }
      else {
        contentWidth += childSize.width + columnGap;
        totalDx += childSize.width + columnGap;
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
        ? boxModel.contentBox.height - contentHeight
        : boxModel.contentBox.width - contentWidth
    );

    if (!isDry) {
      var totalDx = 0.0;
      var totalDy = 0.0;

      for (final (child, _) in childrenIterable) {
        final childParentData = child.parentData;

        if (child is! StyledRenderBox) {
          continue;
        }

        if (childParentData is! BoxParentData) {
          continue;
        }

        if (child.style.flexGrow > 0) {
          if (FlexDirection.isVertical(this.style.flexDirection)) {
            childParentData.verticalFlexSize = availableSpaceInMainAxis * child.style.flexGrow / totalFlexGrow;
          }
          else {
            childParentData.horizontalFlexSize = availableSpaceInMainAxis * child.style.flexGrow / totalFlexGrow;
          }
        }

        child.layout(childConstraints, parentUsesSize: true);

        if (FlexDirection.isVertical(this.style.flexDirection)) {
          childParentData.offset = Offset(childParentData.offset.dx, totalDy);
          totalDy += child.size.height + rowGap;
        }
        else {
          childParentData.offset = Offset(totalDx, childParentData.offset.dy);
          totalDx += child.size.width + columnGap;
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
                final translationValue = boxModel.contentBox.height - contentHeight;

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
