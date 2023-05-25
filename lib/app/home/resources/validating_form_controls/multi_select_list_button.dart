import 'package:enreda_empresas/app/utils/adaptative.dart';
import 'package:enreda_empresas/app/values/strings.dart';
import 'package:enreda_empresas/app/values/values.dart';
import 'package:flutter/material.dart';


class MultiSelectDialogItem<V> {
  const MultiSelectDialogItem(this.value, this.label, this.title);

  final V value;
  final String label;
  final String title;
}

class MultiSelectListDialog<V> extends StatefulWidget {
  MultiSelectListDialog({Key? key, this.itemsSet, this.initialSelectedValuesSet}) : super(key: key);

  final Set<List<MultiSelectDialogItem<V>>>? itemsSet;
  final Set<V>? initialSelectedValuesSet;

  @override
  State<StatefulWidget> createState() => _MultiSelectListDialogState<V>();
}

class _MultiSelectListDialogState<V> extends State<MultiSelectListDialog<V>> {
  final selectedValuesSet = Set<V>();

  void initState() {
    super.initState();
    if (widget.initialSelectedValuesSet != null) {
      for (var itemValue in widget.initialSelectedValuesSet!) {
        selectedValuesSet.add(itemValue);
      }
    }
  }

  void _onItemCheckedChange(V itemValue, bool checked) {
    setState(() {
      if (checked == false && this.selectedValuesSet.where((e) => e  == itemValue).length > 0) {
        this.selectedValuesSet.removeWhere((e) => e  == itemValue);
        print(selectedValuesSet);
      }
      else
        this.selectedValuesSet.add(itemValue);
    });
  }

  void _onSubmitTap() {
    Navigator.of(context, rootNavigator: true).pop(this.selectedValuesSet);
    setState(() {
      this.selectedValuesSet;
    });
    print(this.selectedValuesSet);
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    double fontSize = responsiveSize(context, 14, 18, md: 15);
    return AlertDialog(
      title: Text(StringConst.FORM_SELECT, style: textTheme.bodyText2?.copyWith(
        height: 1.5,
        fontWeight: FontWeight.w700,
        fontSize: fontSize,
      ),),
      contentPadding: EdgeInsets.only(top: 12.0),
      content: SingleChildScrollView(
        child: ListTileTheme(
          contentPadding: EdgeInsets.fromLTRB(14.0, 0.0, 24.0, 0.0),
          child: Column(
              children: <Widget> [
                for (List<MultiSelectDialogItem<V>> items in widget.itemsSet!)
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                        child: Text(items[0].title, style: textTheme.bodyText1?.copyWith(
                          height: 1.5,
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.w700,
                          fontSize: fontSize,
                        ),),
                      ),
                      ListBody(
                        children: items.map(_buildItem).toList(),
                      ),
                    ],
                  ),
              ]
          ),
        ),
      ),
      actions: <Widget>[
        ElevatedButton(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(StringConst.FORM_ACCEPT, style: TextStyle(
                color: AppColors.white,
                fontWeight: FontWeight.bold)),
          ),
          onPressed: _onSubmitTap,
        )
      ],
    );
  }

  Widget _buildItem(MultiSelectDialogItem<V> item) {
    final bool checked = selectedValuesSet.where((e) => e  == item.value).length > 0;
    TextTheme textTheme = Theme.of(context).textTheme;
    double fontSize = responsiveSize(context, 14, 16, md: 15);
    return CheckboxListTile(
      value: checked,
      title: Text(item.label,
        style: textTheme.button?.copyWith(
          height: 1.5,
          color: AppColors.greyDark,
          fontWeight: FontWeight.w400,
          fontSize: fontSize,
        ), ),
      controlAffinity: ListTileControlAffinity.leading,
      onChanged: (checked) => _onItemCheckedChange(item.value, checked!),
    );
  }
}