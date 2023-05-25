import 'package:enreda_empresas/app/models/nature.dart';
import 'package:enreda_empresas/app/services/database.dart';
import 'package:enreda_empresas/app/values/strings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Widget streamBuilderDropdownNature (BuildContext context, Nature? selectedNature,  functionToWriteBackThings ) {
  final database = Provider.of<Database>(context, listen: false);
  return StreamBuilder<List<Nature>>(
      stream: database.natureStream(),
      builder: (context, snapshotNatures){

        List<DropdownMenuItem<Nature>> natureItems = [];
        if (snapshotNatures.hasData) {
          natureItems = snapshotNatures.data!.map((Nature nature) =>
              DropdownMenuItem<Nature>(
                value: nature,
                child: Text(nature.label),
              ))
              .toList();
        }

        return DropdownButtonFormField<Nature>(
          hint: Text(StringConst.FORM_NATURE),
          isExpanded: true,
          value: selectedNature,
          items: natureItems,
          validator: (value) => selectedNature != null ? null : StringConst.FORM_NATURE_ERROR,
          onChanged: (value) => functionToWriteBackThings(value),
        );
      });
}