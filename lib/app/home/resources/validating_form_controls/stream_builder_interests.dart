import 'package:enreda_empresas/app/home/resources/validating_form_controls/multi_select_button.dart';
import 'package:enreda_empresas/app/models/interest.dart';
import 'package:enreda_empresas/app/models/resource.dart';
import 'package:enreda_empresas/app/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Widget streamBuilderDropdownInterests (BuildContext context, List<String>selectedInterestsIdList, Set<Interest> selectedInterests, Resource? resource) {
  final database = Provider.of<Database>(context, listen: false);
  Interest selectedInterest;
  return StreamBuilder<List<Interest>>(
      stream: database.interestStream(),
      builder: (context, snapshotInterests){

        List<MultiSelectDialogItem<Interest>> interestItems = [];
        if (snapshotInterests.hasData) {
          interestItems = snapshotInterests.data!.map( (Interest interest) {
            if(selectedInterestsIdList.isEmpty && resource != null) {
              for (var interestId in resource.interests!) {
                if (interest.interestId == interestId) {
                  selectedInterest = interest;
                  selectedInterests.add(selectedInterest);
                }
              }
            }

            return MultiSelectDialogItem<Interest>(
                  interest,
                  interest.name
              );
          })
              .toList();
        }

        return MultiSelectDialog<Interest>(
          items: interestItems,
          initialSelectedValues: selectedInterests,
        );
      });
}