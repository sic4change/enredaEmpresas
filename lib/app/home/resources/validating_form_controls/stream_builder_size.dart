import 'package:enreda_empresas/app/models/size.dart';
import 'package:enreda_empresas/app/values/strings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../services/database.dart';

Widget streamBuilderForSizeOrg (BuildContext context, SizeOrg? selectedSizeOrg,  functionToWriteBackThings ) {
  final database = Provider.of<Database>(context, listen: false);
  return StreamBuilder<List<SizeOrg>>(
      stream: database.sizeStream(),
      builder: (context, snapshotSizes){

        List<DropdownMenuItem<SizeOrg>> sizeOrgItems = [];
        if(snapshotSizes.hasData) {
          sizeOrgItems = snapshotSizes.data!.map((SizeOrg sizeOrg) =>
              DropdownMenuItem<SizeOrg>(
                value: sizeOrg,
                child: Text(sizeOrg.label),
              ))
              .toList();
        }

        return DropdownButtonFormField<SizeOrg>(
          hint: Text(StringConst.FORM_SIZE),
          isExpanded: true,
          value: selectedSizeOrg,
          items: sizeOrgItems,
          validator: (value) => selectedSizeOrg != null ? null : StringConst.FORM_SIZE_ERROR,
          onChanged: (value) => functionToWriteBackThings(value),
        );
      });
}