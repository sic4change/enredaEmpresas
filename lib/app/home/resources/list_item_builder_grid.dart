import 'package:flutter/material.dart';
import 'empty_content.dart';

typedef ItemWidgetBuilder<T> = Widget Function(BuildContext context, T item);

class ListItemBuilderGrid<T> extends StatelessWidget {
  const ListItemBuilderGrid(
      {Key? key,
        required this.snapshot,
        required this.itemBuilder,
        this.emptyTitle,
        this.emptyMessage,
        this.maxCrossAxisExtentValue = 520,
        this.mainAxisExtentValue = 250,
        this.fitSmallerLayout = false,
        required this.scrollController,
      })
      : super(key: key);
  final AsyncSnapshot<List<T>> snapshot;
  final ItemWidgetBuilder<T> itemBuilder;
  final String? emptyTitle;
  final String? emptyMessage;
  final bool? fitSmallerLayout;
  final double? maxCrossAxisExtentValue;
  final double? mainAxisExtentValue;
  final ScrollController? scrollController;

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
      return EmptyContent(
          title: 'Algo fue mal', message: 'No se pudo cargar los datos');
    }
    return Center(child: CircularProgressIndicator());
  }

  Widget _build(BuildContext context, List<T> items) {
    return LayoutBuilder(builder: (context, constraints) {
      return GridView.builder(
        controller: scrollController,
        shrinkWrap: constraints.maxWidth < 300 ? true : false,
        padding: EdgeInsets.all(4.0),
        itemCount: items.length,
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          //maxCrossAxisExtent: 520,
            maxCrossAxisExtent: maxCrossAxisExtentValue!,
            //mainAxisExtent: 250,
            mainAxisExtent: mainAxisExtentValue!,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20
        ),
        itemBuilder: (context, index) {
          return Container(
              key: Key('resource-${items[index]}'),
              height: 230,
              width: 300,
              child: itemBuilder(context, items[index]));
        },
      );
    });
  }
}
