import 'package:enreda_empresas/app/models/company.dart';
import 'package:enreda_empresas/app/services/database.dart';
import 'package:enreda_empresas/app/utils/adaptative.dart';
import 'package:enreda_empresas/app/values/strings.dart';
import 'package:enreda_empresas/app/values/values.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Widget streamBuilderForSocialEntity (BuildContext context, Company? selectedSocialEntity,  functionToWriteBackThings ) {
  final database = Provider.of<Database>(context, listen: false);
  TextTheme textTheme = Theme.of(context).textTheme;
  double fontSize = responsiveSize(context, 14, 16, md: 15);
  return StreamBuilder<List<Company>>(
      stream: database.socialEntitiesStream(),
      builder: (context, snapshotSocialEntities){

        List<DropdownMenuItem<Company>> socialEntityItems = [];
        if (snapshotSocialEntities.hasData) {
          final socialEntities = [Company(name: "Ninguna")].followedBy(snapshotSocialEntities.data!);
          socialEntityItems = socialEntities.map((Company s) =>
              DropdownMenuItem<Company>(
                value: s,
                child: Text(s.name),
              ))
              .toList();
          if(selectedSocialEntity == null || socialEntities.contains(selectedSocialEntity)){
            return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      StringConst.FORM_SOCIAL_COMPANY,
                      style: textTheme.bodySmall?.copyWith(
                        height: 1.5,
                        color: AppColors.greyDark,
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  Container(
                    height: 55,
                    child: DropdownButtonFormField(
                      value: selectedSocialEntity,
                      items: socialEntityItems,
                      isExpanded: true,
                      //onChanged: (value) => functionToWriteBackThings(value),
                      onChanged: null,
                      decoration: InputDecoration(
                        errorStyle: TextStyle(height: 0.01),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          borderSide: BorderSide(
                            color: AppColors.greyUltraLight,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          borderSide: BorderSide(
                            color: AppColors.greyUltraLight,
                            width: 1.0,
                          ),
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          borderSide: BorderSide(
                            color: AppColors.greyUltraLight,
                            width: 1.0,
                          ),
                        ),
                      ),
                      style: textTheme.bodySmall?.copyWith(
                        height: 1.4,
                        color: AppColors.greyDark,
                        fontWeight: FontWeight.w400,
                        fontSize: fontSize,
                      ),
                    ),
                  ),
                ]
            );
          }else{
            return Container();
          }
        }
        else{
          return Container();
        }
      });
}