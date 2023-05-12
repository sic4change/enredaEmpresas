import 'package:enreda_empresas/app/models/ability.dart';
import 'package:enreda_empresas/app/services/database.dart';
import 'package:enreda_empresas/app/sign_up/validating_form_controls/multi_select_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Widget streamBuilderDropdownAbilities (BuildContext context, Set<Ability> selectedAbilities) {
  final database = Provider.of<Database>(context, listen: false);
  return StreamBuilder<List<Ability>>(
      stream: database.abilityStream(),
      builder: (context, snapshotAbilities){

        List<MultiSelectDialogItem<Ability>> abilityItems = [];
        if (snapshotAbilities.hasData) {
          abilityItems = snapshotAbilities.data!.map( (Ability ability) =>
              MultiSelectDialogItem<Ability>(
                  ability,
                  ability.name
              ))
              .toList();
        }

        return MultiSelectDialog<Ability>(
          items: abilityItems,
          initialSelectedValues: selectedAbilities,
        );
      });
}