import 'package:enreda_empresas/app/common_widgets/custom_text.dart';
import 'package:enreda_empresas/app/home/resources/resource_detail_dialog.dart';
import 'package:enreda_empresas/app/home/resources/wrap_builder_list.dart';
import 'package:enreda_empresas/app/models/interest.dart';
import 'package:enreda_empresas/app/services/database.dart';
import 'package:enreda_empresas/app/values/values.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InterestsByResource extends StatelessWidget {
  const InterestsByResource({super.key, required this.interestsIdList});

  final List<String?> interestsIdList;

  @override
  Widget build(BuildContext context) {
    return _buildContents(context);
  }

  Widget _buildContents(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);
    Interest selectedInterest;
    return StreamBuilder<List<Interest>>(
        stream: database.interestStream(),
        builder: (context, snapshot) {
          return snapshot.connectionState == ConnectionState.active &&
              snapshot.hasData &&
              snapshot.data!.isNotEmpty
              ? WrapBuilderList<Interest>(
            emptyTitle: 'Sin intereses',
            emptyMessage: 'El recurso no tiene intereses',
            snapshot: snapshot,
            itemBuilder: (context, interest) {
              for (var interestId in interestsIdList) {
                if (interest.interestId == interestId) {
                  selectedInterest = interest;
                  return Container(
                      key: Key(
                          'resource-${interest.interestId}'),
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
                                title: interest.name),
                          )));
                }

              }
              return Container();
            },

          )
              : snapshot.connectionState == ConnectionState.active
              ? const CustomTextTitle(
              title: '¡El recurso aun no tiene intereses!')
              : const Center(child: CircularProgressIndicator());
          ;
        });
  }

}
