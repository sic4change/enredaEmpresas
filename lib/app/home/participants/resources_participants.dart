import 'package:enreda_empresas/app/common_widgets/custom_text.dart';
import 'package:enreda_empresas/app/home/participants/wrap_builder.dart';
import 'package:enreda_empresas/app/home/resources/resource_detail_dialog.dart';
import 'package:enreda_empresas/app/models/resource.dart';
import 'package:enreda_empresas/app/services/database.dart';
import 'package:enreda_empresas/app/values/values.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ParticipantResourcesPage extends StatelessWidget {
  const ParticipantResourcesPage({super.key, required this.participantId});

  final String? participantId;

  @override
  Widget build(BuildContext context) {
    return _buildContents(context);
  }

  Widget _buildContents(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);

    return StreamBuilder<List<Resource>>(
        stream: database.participantsResourcesStream(participantId!),
        builder: (context, snapshot) {
          return snapshot.connectionState == ConnectionState.active &&
                  snapshot.hasData &&
                  snapshot.data!.isNotEmpty
              ? WrapBuilder<Resource>(
                  emptyTitle: 'Sin recursos',
                  emptyMessage: 'El participante no tiene recursos',
                  snapshot: snapshot,
                  itemBuilder: (context, resource) {
                    return Container(
                        key: Key(
                            'resource-${resource.resourceId}'),
                        child: Container(
                            margin: const EdgeInsets.all(5),
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
                                  title: resource.title),
                            )));
                  },

                )
              : snapshot.connectionState == ConnectionState.active
                  ? const CustomTextTitle(
                      title: '¡El participante aun no tiene recursos!')
                  : const Center(child: CircularProgressIndicator());
          ;
        });
  }

}
