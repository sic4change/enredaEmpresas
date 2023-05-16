import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'empty_content.dart';

typedef ItemWidgetBuilder<T> = Widget Function(BuildContext context, T item);

class ListItemBuilderGrid<T> extends StatelessWidget {
  const ListItemBuilderGrid(
      {Key? key,
      required this.snapshot,
      required this.itemBuilder,
      this.emptyTitle,
      this.emptyMessage,
      this.fitSmallerLayout = false})
      : super(key: key);
  final AsyncSnapshot<List<T>> snapshot;
  final ItemWidgetBuilder<T> itemBuilder;
  final String? emptyTitle;
  final String? emptyMessage;
  final bool? fitSmallerLayout;

  @override
  Widget build(BuildContext context) {
    if (snapshot.hasData) {
      final List<T> items = snapshot.data!;
      if (items.isNotEmpty) {
        return _build(context, items);
      } else {
        return EmptyContent(
            title: emptyTitle ?? '', message: emptyMessage ?? '');
      }
    } else if (snapshot.hasError) {
      return const EmptyContent(
          title: 'Algo fue mal', message: 'No se pudo cargar los datos');
    }
    return const Center(child: CircularProgressIndicator());
  }

  Widget _build(BuildContext context, List<T> items) {
    return LayoutBuilder(builder: (context, constraints) {
      var crossAxisCount =
      constraints.maxWidth < 550 ? 1
          : constraints.maxWidth > 550 && constraints.maxWidth < 650 ? 2
          : constraints.maxWidth >= 650 && constraints.maxWidth < 900 ? 3
              : constraints.maxWidth >= 900 && constraints.maxWidth < 1321 ? 4
                  : 5;
      if (fitSmallerLayout ?? false) {
        crossAxisCount =
        constraints.maxWidth < 650 ? 1
            : constraints.maxWidth > 650 && constraints.maxWidth < 900 ? 3
                  : 4;
      }

      final tileWidth = (constraints.maxWidth / crossAxisCount) + 60;

      return MasonryGridView.count(
        controller: ScrollController(),
        shrinkWrap: constraints.maxWidth < 550 ? true : false,
        padding: const EdgeInsets.all(4.0),
        itemCount: items.length,
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: 15,
        crossAxisSpacing: 15,
        itemBuilder: (context, index) {
          return SizedBox(
              height: tileWidth / 1.1,
              child: itemBuilder(context, items[index]));
        },
      );
    });
  }
}
