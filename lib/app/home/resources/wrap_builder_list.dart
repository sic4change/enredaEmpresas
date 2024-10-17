import 'package:enreda_empresas/app/home/resources/builders/empty_content.dart';
import 'package:flutter/material.dart';


typedef ItemWidgetBuilder<T> = Widget Function(BuildContext context, T item);

class WrapBuilderList<T> extends StatelessWidget {
  const WrapBuilderList(
      {Key? key,
        this.snapshot,
        this.itemBuilder,
        this.emptyTitle,
        this.emptyMessage})
      : super(key: key);
  final AsyncSnapshot<List<T>>? snapshot;
  final ItemWidgetBuilder<T>? itemBuilder;
  final String? emptyTitle;
  final String? emptyMessage;

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
      return const EmptyContent(
          title: 'Algo fue mal', message: 'No se pudo cargar los datos');
    }
    return const Center(child: CircularProgressIndicator());
  }

  Widget _build(List<T> items, context) {
    return Wrap(
        direction: Axis.horizontal,
        spacing: 5,
        children: List.generate(
            items.length + 2, (index) {
          if (index == 0 || index == items.length + 1) {
            return Container();
          }
          return itemBuilder!(context, items[index - 1]);

        })
    );
  }
}
