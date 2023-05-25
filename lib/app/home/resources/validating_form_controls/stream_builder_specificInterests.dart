import 'package:enreda_empresas/app/models/interest.dart';
import 'package:enreda_empresas/app/models/specificinterest.dart';
import 'package:enreda_empresas/app/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../values/strings.dart';
import '../../../values/values.dart';
import 'multi_select_list_button.dart';

Widget streamBuilderDropdownSpecificInterests (BuildContext context, Set<Interest> selectedInterests, Set<SpecificInterest> selectedSpecificInterests) {
  final database = Provider.of<Database>(context, listen: false);
  Set<List<MultiSelectDialogItem<SpecificInterest>>> specificInterestSet = {};
  List<MultiSelectDialogItem<SpecificInterest>> specificInterestItems = [];
  if (selectedInterests.isNotEmpty) {
    return ListView(
    children: <Widget> [
      for (var interest in selectedInterests) ...[
        Center(
            child: StreamBuilder<List<SpecificInterest>>(
                stream: database.specificInterestStream(interest.interestId),
                builder: (context, snapshotSpecificInterests){
                  if (snapshotSpecificInterests.hasData) {
                    specificInterestItems = snapshotSpecificInterests.data!.map((SpecificInterest specificInterest) =>
                        MultiSelectDialogItem<SpecificInterest>(
                            specificInterest,
                            specificInterest.name,
                            interest.name
                        ))
                        .toList();
                  }
                  if (specificInterestItems.length > 0) specificInterestSet.add(specificInterestItems);
                  if(specificInterestSet.length == selectedInterests.length){
                    return MultiSelectListDialog<SpecificInterest>(
                      itemsSet: specificInterestSet,
                      initialSelectedValuesSet: selectedSpecificInterests,
                    );
                  }
                  return Container();
                })
        )
      ]
    ],
  );
  }
  return AlertDialog(
    content: Text(StringConst.FORM_INTEREST_EMPTY),
    actions: <Widget>[
      ElevatedButton(
          onPressed: () => Navigator.pop(context),
          child: Text(StringConst.FORM_ACCEPT, style: TextStyle(
              color: AppColors.white,
              fontWeight: FontWeight.bold))
      ),
    ],
  );
}