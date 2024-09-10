import 'package:enreda_empresas/app/common_widgets/alert_dialog.dart';
import 'package:enreda_empresas/app/common_widgets/custom_raised_button.dart';
import 'package:enreda_empresas/app/common_widgets/show_exception_alert_dialog.dart';
import 'package:enreda_empresas/app/models/resource.dart';
import 'package:enreda_empresas/app/models/resourceInvitation.dart';
import 'package:enreda_empresas/app/models/userEnreda.dart';
import 'package:enreda_empresas/app/services/database.dart';
import 'package:enreda_empresas/app/utils/responsive.dart';
import 'package:enreda_empresas/app/values/values.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../../models/city.dart';
import '../../models/country.dart';
import '../../models/province.dart';


class ParticipantResourcesList extends StatefulWidget {
  const ParticipantResourcesList({super.key, required this.participant, required this.organizerId});

  final UserEnreda participant;
  final String organizerId;

  @override
  State<ParticipantResourcesList> createState() => _ParticipantResourcesListState();
}

class _ParticipantResourcesListState extends State<ParticipantResourcesList> {
   late List<Resource> resourcesList;
   late Resource resource;
   bool? certification = false;
   bool? _isSelected = false;
   bool? _buttonDisabled = false;
   Color _selectedColor = AppColors.lightViolet;
   Color _textColor = AppColors.greyDark;
   bool isLoading = false;
   String? codeDialog;
   String? valueText;
   int? _selectedCertify;
   Color _buttonColor = AppColors.primaryColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20.0),
        const Text('Cursos creados recientemente:'),
        SizedBox(
            height: Responsive.isMobile(context) ? MediaQuery.of(context).size.height * 0.5 : MediaQuery.of(context).size.height * 0.4,
            child: SingleChildScrollView(
                child: _buildContents(context)
            )),
        SizedBox(height: Sizes.mainPadding / 2),
        isLoading ? const Padding(
          padding: EdgeInsets.all(30.0),
          child: Center(child: CircularProgressIndicator()),
        ) :
        CustomButton(
            text: 'Invitar recurso',
            color: _buttonColor,
            onPressed: _buttonDisabled == false ? () async {
              if (_isSelected == true) {
                final resourceInvitation = ResourceInvitation(
                  resourceId: resource.resourceId!,
                  resourceTitle: resource.title,
                  resourceDescription: '${resource.resourceCategoryName!} en ${resource.cityName!}, ${resource.provinceName!}, ${resource.countryName!}',
                  unemployedId: widget.participant.userId!,
                  unemployedName: '${widget.participant.firstName!} ${widget.participant.lastName}',
                  unemployedEmail: widget.participant.email,
                );
                try {
                  final database = Provider.of<Database>(context, listen: false);
                  setState(() => isLoading = true);
                  await database.addResourceInvitation(resourceInvitation);
                  setState(() {
                    isLoading = false;
                    _buttonColor = AppColors.grey350;
                    _buttonDisabled = true;
                  });
                  showAlertDialog(
                    context,
                    title: '¡Recurso: ${resourcesList[_selectedCertify!].title}',
                    content: '¡Ha sido enviada la invitación con éxito!',
                    defaultActionText: 'Aceptar',
                  );
                } on FirebaseException catch (e) {
                  showExceptionAlertDialog(context,
                      title: 'Error al enviar la invitación, intenta de nuevo.', exception: e).then((value) => Navigator.pop(context));
                }
              }
            } : null
        ),
      ],
    );
  }

  Widget _buildContents(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);
    final textTheme = Theme.of(context).textTheme;
    return StreamBuilder<List<Resource>>(
      stream: database.myResourcesStream(widget.organizerId),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          resourcesList = snapshot.data!;
          return Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 20.0),
                Wrap(
                  direction: Axis.vertical,
                  spacing: 5.0,
                  children: List<Widget>.generate(
                    resourcesList.length,
                    (int index) {
                      return StreamBuilder<Country>(
                          stream: database.countryStream(resourcesList[index].country),
                          builder: (context, snapshot) {
                            final country = snapshot.data;
                            resourcesList[index].countryName = country == null ? '' : country.name;
                            return StreamBuilder<Province>(
                                stream: database.provinceStream(resourcesList[index].province),
                                builder: (context, snapshot) {
                                  final province = snapshot.data;
                                  resourcesList[index].provinceName = province == null ? '' : province.name;
                                  return StreamBuilder<City>(
                                      stream: database.cityStream(resourcesList[index].city),
                                      builder: (context, snapshot) {
                                        final city = snapshot.data;
                                        resourcesList[index].cityName = city == null ? '' : city.name;
                                        return Padding(
                                          padding: const EdgeInsets.only(bottom: 5.0),
                                          child: ChoiceChip(
                                            backgroundColor: AppColors.greyLight,
                                            label: Text(
                                              resourcesList[index].title,
                                              style: textTheme.bodyMedium?.copyWith(
                                                color: _textColor,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            labelPadding: const EdgeInsets.symmetric(
                                                horizontal: 10.0, vertical: 5.0),
                                            selected: _selectedCertify == index,
                                            selectedColor: _selectedColor,
                                            onSelected: (value) {
                                              setState(() {
                                                _selectResource(index);
                                                _isSelected = true;
                                                resource = resourcesList[index];
                                                resource.setResourceCategoryName();
                                              });
                                            },
                                          ),
                                        );
                                      });
                                });
                          });
                    },
                  ).toList(),
                ),
              ],
            ),
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }



  void _selectResource(int choice) {
    setState(() {
      _selectedCertify = choice;
    });
  }

}
