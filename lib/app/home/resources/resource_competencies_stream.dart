import 'package:enreda_empresas/app/common_widgets/custom_text.dart';
import 'package:enreda_empresas/app/home/resources/resource_detail_dialog.dart';
import 'package:enreda_empresas/app/home/resources/wrap_builder_list.dart';
import 'package:enreda_empresas/app/models/competency.dart';
import 'package:enreda_empresas/app/models/interest.dart';
import 'package:enreda_empresas/app/services/database.dart';
import 'package:enreda_empresas/app/values/values.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CompetenciesByResource extends StatelessWidget {
  const CompetenciesByResource({super.key, required this.competenciesIdList});

  final List<String?> competenciesIdList;

  @override
  Widget build(BuildContext context) {
    return _buildContents(context);
  }

  Widget _buildContents(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);
    return StreamBuilder<List<Competency>>(
        stream: database.competenciesStream(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            return WrapBuilderList<Competency>(
              emptyTitle: 'Sin competencias',
              emptyMessage: 'El recurso no tiene competencias',
              snapshot: snapshot,
              itemBuilder: (context, competency) {
                for (var competencyId in competenciesIdList) {
                  if (competency.id == competencyId) {
                    return Container(
                        key: Key(
                            'resource-${competency.id}'),
                        child: Container(
                            margin: const EdgeInsets.only(left: 0, right: 4, top: 4, bottom: 4),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                  color: AppColors
                                      .greyLight2
                                      .withOpacity(0.2),
                                  width: 1),
                              borderRadius:
                              BorderRadius.circular(
                                  Consts.padding),
                            ),
                            child: Padding(
                              padding: const EdgeInsets
                                  .symmetric(
                                  vertical: 4.0,
                                  horizontal: 8),
                              child: CustomText(
                                  title: competency.name),
                            )));
                  }
                }
                return Container();
              },
            );
          }
          return CustomTextTitle(
              title: '¡La oferta aún no tiene competencias!');
            });
      }
}
