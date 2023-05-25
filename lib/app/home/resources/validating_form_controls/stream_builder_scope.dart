import 'package:enreda_empresas/app/models/scope.dart';
import 'package:enreda_empresas/app/services/database.dart';
import 'package:enreda_empresas/app/values/strings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Widget streamBuilderForScope (BuildContext context, Scope? selectedScope,  functionToWriteBackThings ) {
  final database = Provider.of<Database>(context, listen: false);
  return StreamBuilder<List<Scope>>(
      stream: database.scopeStream(),
      builder: (context, snapshotScopes){

        List<DropdownMenuItem<Scope>> scopeItems = [];
        if (snapshotScopes.hasData) {
          scopeItems = snapshotScopes.data!.map((Scope scope) => DropdownMenuItem<Scope>(
            value: scope,
            child: Text(scope.label),
          ))
              .toList();
        }

        return DropdownButtonFormField<Scope>(
          hint: Text(StringConst.FORM_SCOPE),
          isExpanded: true,
          value: selectedScope,
          items: scopeItems,
          validator: (value) => selectedScope != null ? null : StringConst.FORM_SCOPE_ERROR,
          onChanged: (value) => functionToWriteBackThings(value),
        );
      });
}