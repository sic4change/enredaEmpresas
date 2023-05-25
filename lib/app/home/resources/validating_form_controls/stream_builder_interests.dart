import 'package:enreda_empresas/app/home/resources/validating_form_controls/multi_select_button.dart';
import 'package:enreda_empresas/app/models/interest.dart';
import 'package:enreda_empresas/app/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Widget streamBuilderDropdownInterests (BuildContext context, Set<Interest> selectedInterests) {
  final database = Provider.of<Database>(context, listen: false);
  return StreamBuilder<List<Interest>>(
      stream: database.interestStream(),
      builder: (context, snapshotInterests){

        List<MultiSelectDialogItem<Interest>> interestItems = [];
        if (snapshotInterests.hasData) {
          interestItems = snapshotInterests.data!.map( (Interest interest) =>
              MultiSelectDialogItem<Interest>(
                  interest,
                  interest.name
              ))
              .toList();
        }

        return MultiSelectDialog<Interest>(
          items: interestItems,
          initialSelectedValues: selectedInterests,
        );
      });
}