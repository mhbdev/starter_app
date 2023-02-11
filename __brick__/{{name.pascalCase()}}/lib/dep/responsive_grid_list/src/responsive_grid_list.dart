import 'package:flutter/widgets.dart';
import 'abstract_responsive_grid_list.dart';

///
/// An [AbstractResponsiveGridList] returning the grid inside a
/// [ListView.builder()]
///
class ResponsiveGridList extends AbstractResponsiveGridList {
  /// shrinkWrap property of [ListView.builder].
  final bool shrinkWrap;

  final ScrollController? controller;

  final ScrollPhysics? physics;

  const ResponsiveGridList({
    required double minItemWidth,
    int minItemsPerRow = 1,
    int? maxItemsPerRow,
    double horizontalGridSpacing = 16,
    double verticalGridSpacing = 16,
    double? horizontalGridMargin,
    double? verticalGridMargin,
    MainAxisAlignment rowMainAxisAlignment = MainAxisAlignment.start,
    this.shrinkWrap = false,
    this.controller,
    this.physics,
    required List<Widget> children,
    // coverage:ignore-start
  }) : super(
          minItemWidth: minItemWidth,
          minItemsPerRow: minItemsPerRow,
          maxItemsPerRow: maxItemsPerRow,
          horizontalGridSpacing: horizontalGridSpacing,
          verticalGridSpacing: verticalGridSpacing,
          horizontalGridMargin: horizontalGridMargin,
          verticalGridMargin: verticalGridMargin,
          rowMainAxisAlignment: rowMainAxisAlignment,
          children: children,
        ); // coverage:ignore-end

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        // Get the grid list items
        final items = getResponsiveGridListItems(constraints.maxWidth);

        return ListView.builder(
          itemCount: items.length,
          shrinkWrap: shrinkWrap,
          controller: controller,
          physics: physics,
          itemBuilder: (BuildContext context, int index) {
            return items[index];
          },
        );
      },
    );
  }
}
