import 'package:enreda_empresas/app/common_widgets/custom_text.dart';
import 'package:enreda_empresas/app/home/participants/wrap_builder.dart';
import 'package:enreda_empresas/app/home/resources/list_item_builder.dart';
import 'package:enreda_empresas/app/home/resources/resource_detail_dialog.dart';
import 'package:enreda_empresas/app/models/resource.dart';
import 'package:enreda_empresas/app/services/database.dart';
import 'package:enreda_empresas/app/values/values.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ParticipantResourcesList extends StatefulWidget {
  const ParticipantResourcesList({super.key, required this.participantId, required this.organizerId});

  final String participantId;
  final String organizerId;

  @override
  State<ParticipantResourcesList> createState() => _ParticipantResourcesListState();
}

class _ParticipantResourcesListState extends State<ParticipantResourcesList> {
   late List<Resource> resourcesList;
   bool? certification = false;
   bool? _isSelected = false;
   bool? _isSelectedData = false;
   bool? _buttonDisabled = false;
   Color _selectedColor = AppColors.lightViolet;
   Color _textColor = AppColors.greyDark;
   bool isLoading = false;
   String? codeDialog;
   String? valueText;
   int? _selectedCertify;
   int? _selectedApprove;
   Color _buttonColor = AppColors.primaryColor;

  @override
  Widget build(BuildContext context) {
    return _buildContents(context);
  }

   Widget _buildContents(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);
    final textTheme = Theme.of(context).textTheme;
    return StreamBuilder<List<Resource>>(
      stream: database.participantsResourcesStream(
          widget.participantId, widget.organizerId),
      builder: (context, snapshot) {
        if (snapshot.hasData &&
            snapshot.data!.isNotEmpty &&
            snapshot.connectionState == ConnectionState.active) {
          resourcesList = snapshot.data!;
          return Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text('Invitar a un recurso'),
                const SizedBox(height: 10.0),
                Wrap(
                  direction: Axis.vertical,
                  spacing: 5.0,
                  children: List<Widget>.generate(
                    resourcesList.length,
                    (int index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
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
                              horizontal: 50.0, vertical: 10),
                          selected: _selectedCertify == index,
                          selectedColor: _selectedColor,
                          onSelected: (value) {
                            setState(() {
                              _selectResource(index);
                              _isSelected = true;
                            });
                          },
                        ),
                      );
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
