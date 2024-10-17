import 'package:flutter/material.dart';
import 'empty_content.dart';

typedef ItemWidgetBuilder<T> = Widget Function(BuildContext context, T item);

class ListItemBuilderHorizontal<T> extends StatelessWidget {
  const ListItemBuilderHorizontal(
      {Key? key,
        this.snapshot,
        this.itemBuilder,
        this.emptyTitle,
        this.emptyMessage,
        this.scrollController})
      : super(key: key);
  final AsyncSnapshot<List<T>>? snapshot;
  final ItemWidgetBuilder<T>? itemBuilder;
  final String? emptyTitle;
  final String? emptyMessage;
  final ScrollController? scrollController;

  @override
  Widget build(BuildContext context) {
    if (snapshot!.hasData) {
      final List<T> items = snapshot!.data!;
      if (items.isNotEmpty) {
        return _build(items, context);
      } else {
        return EmptyContent(title: emptyTitle!, message: emptyMessage!);
      }
    } else if (snapshot!.hasError) {
      return EmptyContent(title: 'Algo fue mal', message: 'No se pudo cargar los datos');
    }
    return Center(child: CircularProgressIndicator());
  }

  Widget _build(List<T> items, BuildContext context) {
    return ListView.builder(
      controller: scrollController,
      padding: EdgeInsets.all(20),
      shrinkWrap: true,
      itemCount: items.length,
      scrollDirection: Axis.horizontal,
      physics: AlwaysScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Container(
            color: Colors.transparent,
            width: 400,
            alignment: Alignment.topCenter,
            child: itemBuilder!(context, items[index])
        );
      },
    );
  }
}
