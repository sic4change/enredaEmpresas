import 'package:enreda_empresas/app/common_widgets/custom_date_picker_title.dart';
import 'package:enreda_empresas/app/common_widgets/custom_drop_down_button_form_field_title.dart';
import 'package:enreda_empresas/app/common_widgets/custom_multi_selection_radio_list.dart';
import 'package:enreda_empresas/app/common_widgets/custom_text.dart';
import 'package:enreda_empresas/app/common_widgets/custom_text_form_field_title.dart';
import 'package:enreda_empresas/app/common_widgets/enreda_button.dart';
import 'package:enreda_empresas/app/common_widgets/flex_row_column.dart';
import 'package:enreda_empresas/app/common_widgets/spaces.dart';
import 'package:enreda_empresas/app/common_widgets/text_form_field.dart';
import 'package:enreda_empresas/app/models/initialReport.dart';
import 'package:enreda_empresas/app/models/userEnreda.dart';
import 'package:enreda_empresas/app/services/auth.dart';
import 'package:enreda_empresas/app/services/database.dart';
import 'package:enreda_empresas/app/values/strings.dart';
import 'package:enreda_empresas/app/values/values.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

Widget initialReport(BuildContext context, UserEnreda user){
  final database = Provider.of<Database>(context, listen: false);

  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 30),
    child: Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: AppColors.greyBorder)
      ),
      child:
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CustomTextBoldTitle(title: 'Informe inicial'.toUpperCase()),
                ],
              ),
            ),
            Divider(color: AppColors.greyBorder,),
            StreamBuilder<InitialReport>(
              stream: database.initialReportsStreamByUserId(user.userId),
              builder: (context, snapshot) {
                if(snapshot.hasData){
                  InitialReport initialReportSaved = snapshot.data!;
                  return completeInitialForm(context, initialReportSaved);
                }
                else{
                  if(user.initialReportId == null){
                    database.addInitialReport(InitialReport(
                      userId: user.userId,
                    ));
                  }
                  return Container(
                    height: 300,
                  );
                }

              }
            ),
          ]
        ),
    )
  );
}

Widget informSectionTitle(String title){
  return Padding(
    padding: const EdgeInsets.only(top: 30, bottom: 15),
    child: Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        fontFamily: GoogleFonts.outfit().fontFamily,
        color: AppColors.bluePetrol,
      ),
    ),
  );
}

Widget informSubSectionTitle(String title){
  return Padding(
    padding: const EdgeInsets.only(top: 30, bottom: 15),
    child: Text(
      title,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        fontFamily: GoogleFonts.outfit().fontFamily,
        color: AppColors.bluePetrol,
      ),
    ),
  );
}

Widget multiSelectionList(List<String> options, void Function(String? value)? onChanged, List<String> selected){
  return Wrap(
    alignment: WrapAlignment.spaceEvenly,
    direction: Axis.horizontal,

    children: <Widget>[
      for(var option in options)
        SizedBox(
          width: 300, //TODO make responsive
          child: RadioListTile<String>(
            title: Text(option),
            value: option,
            groupValue: null,
            onChanged: onChanged,
            dense: true,
          ),
        )
    ],
  );
}

Widget multiSelectionListTitle(BuildContext context, List<String> options, String title){
  final textTheme = Theme.of(context).textTheme;
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Text(
          title,
          style: textTheme.button?.copyWith(
            height: 1.5,
            color: AppColors.greyDark,
            fontWeight: FontWeight.w700,
            fontSize: 14,
          ),
        ),
      ),
      Container(
        height: 50,
        child: Center(child:
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              for(var option in options)
                SizedBox(
                  width: 110, //TODO make responsive
                  child: RadioListTile(
                    title: Text(option),
                    value: null,
                    groupValue: null,
                    onChanged: (Null? value) {  },
                    dense: true,
                  ),
                )
            ],
          )
        ),
      ),
    ]
  );
}

Widget completeInitialForm(BuildContext context, InitialReport report){
  final database = Provider.of<Database>(context, listen: false);
  final _formKey = GlobalKey<FormState>();

  bool _finished = report.finished ?? false;

  List<DropdownMenuItem<String>> _yesNoSelection = ['Si', 'No'].map<DropdownMenuItem<String>>((String value){
    return DropdownMenuItem<String>(
      value: value,
      child: Text(value),
    );
  }).toList();

  List<DropdownMenuItem<String>> _subsidySelection = ['xxxxxx1', 'xxxxxx2', 'xxxxxx3', 'xxxxxx4', 'xxxxxx5', 'xxxxxx6'].map<DropdownMenuItem<String>>((String value){
    return DropdownMenuItem<String>(
      value: value,
      child: Text(value),
    );
  }).toList();

  //Pre-Selection
  String? _subsidy = report.subsidy ?? '';

  //Section 1
  String _orientation1 = report.orientation1 ?? '';
  DateTime? _arriveDate = report.arriveDate;
  String _receptionResources =  report.receptionResources ?? '';
  String _externalResources = report.externalResources ?? '';
  String _administrativeSituation =  report.administrativeSituation ?? '';

  List<DropdownMenuItem<String>> _arriveTypeSelection = ['Segura', 'Insegura'].map<DropdownMenuItem<String>>((String value){
    return DropdownMenuItem<String>(
      value: value,
      child: Text(value),
    );
  }).toList();

  //Section 2
  DateTime? _expirationDate = report.expirationDate;
  String? _orientation2 = report.orientation2 ?? '';
  String? _healthCard = report.healthCard ?? '';
  String? _disease = report.disease ?? '';
  String? _medication = report.medication ?? '';
  List<DropdownMenuItem<String>> _healthCardSelection = ['Si', 'No', 'Caducidad'].map<DropdownMenuItem<String>>((String value){
    return DropdownMenuItem<String>(
      value: value,
      child: Text(value),
    );
  }).toList();

  //Subsection 2.1
  String? _orientation2_1 = report.orientation2_1 ?? '';
  String? _rest = report.rest ?? '';
  String? _diagnosis = report.diagnosis ?? '';
  String? _treatment = report.treatment ?? '';
  String? _tracking = report.tracking ?? '';
  String? _psychosocial = report.psychosocial ?? '';

  //Subsection 2.2
  String? _orientation2_2 = report.orientation2_2 ?? '';
  String? _disabilityState = report.disabilityState ?? '';
  String? _referenceProfessionalDisability = report.referenceProfessionalDisability ?? '';
  String? _disabilityGrade = report.disabilityGrade ?? '';
  List<DropdownMenuItem<String>> _stateSelection = ['En trámite', 'Concedida'].map<DropdownMenuItem<String>>((String value){
    return DropdownMenuItem<String>(
      value: value,
      child: Text(value),
    );
  }).toList();
  List<DropdownMenuItem<String>> _disabilityGradeSelection = ['1', '2', '3', '4', '5'].map<DropdownMenuItem<String>>((String value){
    return DropdownMenuItem<String>(
      value: value,
      child: Text(value),
    );
  }).toList();

  //Subsection 2.3
  String? _orientation2_3 = report.orientation2_3 ?? '';
  String? _dependenceState = report.dependenceState ?? '';
  String? _referenceProfessionalDependence = report.referenceProfessionalDependence ?? '';
  String? _homeAssistance = report.homeAssistance ?? '';
  String? _teleassistance = report.teleassistance ?? '';
  String? _dependenceGrade = report.dependenceGrade ?? '';
  List<DropdownMenuItem<String>> _dependencyGradeSelection = ['1', '2', '3'].map<DropdownMenuItem<String>>((String value){
    return DropdownMenuItem<String>(
      value: value,
      child: Text(value),
    );
  }).toList();

  //Subsection 2.4
  String? _orientation2_4 = report.orientation2_4 ?? '';
  String? _externalDerivation = report.externalDerivation ?? '';
  String? _consumptionLevel = report.consumptionLevel ?? '';
  String? _addictionTreatment = report.addictionTreatment ?? '';

  //Section 3
  String? _orientation3 = report.orientation3 ?? '';
  String? _openLegalProcess = report.openLegalProcess ?? '';
  String? _closeLegalProcess = report.closeLegalProcess ?? '';
  String? _legalRepresentation = report.legalRepresentation ?? '';

  //Section 4
  String? _orientation4 = report.orientation4 ?? '';
  String? _ownershipType = report.ownershipType ?? '';
  String? _location = report.location ?? '';
  String? _livingUnit = report.livingUnit ?? '';
  String? _centerContact = report.centerContact ?? '';
  List<String>? _hostingObservations = report.hostingObservations ?? [];

  const List<String> _optionsSectionFour = ['Habitabilidad', 'Luz', 'Gas', 'Hacinamiento', 'Accesibilidad', 'Agua corriente', 'Baño', 'Agua caliente', 'Mobiliario básico'];

  //Section 5
  String? _orientation5 = report.orientation5 ?? '';
  String? _informationNetworks = report.informationNetworks ?? '';

  //Section 6
  String? _orientation6 = report.orientation6 ?? '';
  String? _socialStructureKnowledge = report.socialStructureKnowledge ?? '';
  String? _autonomyPhysicMental = report.autonomyPhysicMental ?? '';
  String? _socialSkills = report.socialSkills ?? '';

  //Section 7
  String? _orientation7 = report.orientation7 ?? '';
  String? _language = report.language ?? '';
  String? _languageLevel = report.languageLevel ?? '';

  //Section 8
  String? _orientation8 = report.orientation8 ?? '';
  String? _economicProgramHelp = report.economicProgramHelp ?? '';
  String? _familySupport = report.familySupport ?? '';
  String? _familyResponsibilities = report.familyResponsibilities ?? '';

  //Section 9
  String? _orientation9 = report.orientation9 ?? '';
  String? _socialServiceAccess = report.socialServiceAccess ?? '';
  String? _centerTSReference = report.centerTSReference ?? '';
  String? _subsidyBeneficiary = report.subsidyBeneficiary ?? '';
  String? _socialServicesUser = report.socialServicesUser ?? '';
  String? _socialExclusionCertificate = report.socialExclusionCertificate ?? '';

  //Section 10
  String? _orientation10 = report.orientation10 ?? '';
  String? _digitalSkillsLevel = report.digitalSkillsLevel ?? '';

  List<DropdownMenuItem<String>> _digitalSkillsSelection = ['Bajo', 'Medio', 'Alto'].map<DropdownMenuItem<String>>((String value){
    return DropdownMenuItem<String>(
      value: value,
      child: Text(value),
    );
  }).toList();

  //Section 11
  String? _orientation11 = report.orientation11 ?? '';
  String? _laborMarkerInterest = report.laborMarkerInterest ?? '';
  String? _laborExpectations = report.laborExpectations ?? '';

  //Section 12
  String? _orientation12 = report.orientation12 ?? '';
  List<String>? _vulnerabilityOptions = report.vulnerabilityOptions ?? [];

  List<String> _optionsSectionTwelve = ['Barrera ideomática', 'Situación sinhogarismo', 'Colectivo LGTBI', 'Salud mental grave', 'Joven ex tutelado/a', 'Responsabilidades familiares',
    'Madre monomarental', 'Minoría étnica', 'Falta de red de apoyo', 'Violencia de Género', 'Adicciones', 'Rularidad'];

  //Section 13
  String? _orientation13 = report.orientation13 ?? '';
  String? _educationLevel = report.educationLevel ?? '';
  String? _laborSituation = report.laborSituation ?? '';
  String? _laborExternalResources = report.laborExternalResources ?? '';
  String? _educationalEvaluation = report.educationalEvaluation ?? '';
  String? _formativeItinerary = report.formativeItinerary ?? '';
  String? _laborInsertion = report.laborInsertion  ?? '';
  String? _accompanimentPostLabor = report.accompanimentPostLabor ?? '';
  String? _laborUpgrade = report.laborUpgrade ?? '';

  List<DropdownMenuItem<String>> _educationalLevelSelection = ['1er ciclo 2ria (Max CINE 0-2)', '2do ciclo 2ria (CINE 3) o postsecundaria (CINE 4)', 'Superior o 3ria (CINE 5 a 8)',].map<DropdownMenuItem<String>>((String value){
    return DropdownMenuItem<String>(
      value: value,
      child: Text(value),
    );
  }).toList();

  List<DropdownMenuItem<String>> _laborSituationSelection = ['Ocupada', 'Desempleada de larga duración (12 meses o más)', 'Desempleada (menos de 12 meses)',].map<DropdownMenuItem<String>>((String value){
    return DropdownMenuItem<String>(
      value: value,
      child: Text(value),
    );
  }).toList();


  return Padding(
    padding: const EdgeInsets.only(left: 50, right: 30),
    child: Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          SpaceH20(),
          _subsidy == '' ? CustomDropDownButtonFormFieldTittle(
            labelText: 'Subvención a la que el/la participante está imputado/a',
            source: _subsidySelection,
            onChanged: _finished ? null : (value){
              _subsidy = value;
            },
            validator: (value) => value != null ? null : StringConst.FORM_GENERIC_ERROR,
          ):
          CustomDropDownButtonFormFieldTittle(
            labelText: 'Subvención a la que el/la participante está imputado/a',
            source: _subsidySelection,
            value: _subsidy,
            onChanged: _finished ? null : (value){
              _subsidy = value;
            },
            validator: (value) => (value!.isNotEmpty || value != '') ? null : StringConst.FORM_GENERIC_ERROR,
          ),

          //Section 1
          informSectionTitle('1. Itinerario en España'),
          CustomTextFormFieldTitle(
            labelText: 'Orientaciones',
            initialValue: _orientation1,
            onChanged: (value){
              _orientation1 = value ?? '';
            },
            validator: (value) => (value!.isNotEmpty || value != '') ? null : StringConst.FORM_GENERIC_ERROR,
            enabled: !_finished,
          ),
          SpaceH12(),
          CustomFlexRowColumn(
              contentPadding: EdgeInsets.zero,
              separatorSize: 20,
              childLeft: CustomDatePickerTitle(
                labelText: 'Fecha de llegada a España',
                initialValue: _arriveDate,
                onChanged: (value){
                  _arriveDate = value;
                },
                enabled: !_finished,
                validator: (value) => (value != null) ? null : StringConst.FORM_GENERIC_ERROR,
              ),

              childRight: CustomTextFormFieldTitle(
                labelText: 'Recursos de Acogida',
                initialValue: _receptionResources,
                onChanged: (value){
                  _receptionResources = value ?? '';
                },
                validator: (value) => (value!.isNotEmpty || value != '') ? null : StringConst.FORM_GENERIC_ERROR,
                enabled: !_finished,
              ),
          ),
          SpaceH12(),
          CustomFlexRowColumn(
              contentPadding: EdgeInsets.zero,
              separatorSize: 20,
              childLeft: CustomTextFormFieldTitle(
                labelText: 'Recursos externos de apoyo',
                initialValue: _externalResources,
                onChanged: (value){
                  _externalResources = value ?? '';
                },
                validator: (value) => (value!.isNotEmpty || value != '') ? null : StringConst.FORM_GENERIC_ERROR,
                enabled: !_finished,
              ),

              childRight: CustomTextFormFieldTitle(
                labelText: 'Situación administrativa',
                hintText: 'Ley de asilo, arraigo, ex-menor tutelado...',
                initialValue: _administrativeSituation,
                onChanged: (value){
                  _administrativeSituation = value ?? '';
                },
                validator: (value) => (value!.isNotEmpty || value != '') ? null : StringConst.FORM_GENERIC_ERROR,
                enabled: !_finished,
              ),
          ),

          //Section 2
          informSectionTitle('2. Situación Sanitaria'),
          CustomTextFormFieldTitle(
            labelText: 'Orientaciones',
            initialValue: _orientation2,
            onChanged: (value){
              _orientation2 = value;
            },
            validator: (value) => (value!.isNotEmpty || value != '') ? null : StringConst.FORM_GENERIC_ERROR,
            enabled: !_finished,
          ),
          SpaceH12(),
          CustomFlexRowColumn(
            contentPadding: EdgeInsets.zero,
            separatorSize: 20,
            childLeft: _healthCard == '' ?  CustomDropDownButtonFormFieldTittle(
              labelText: 'Tarjeta sanitaria',
              source: _healthCardSelection,
              onChanged: _finished ? null : (value){
                _healthCard = value;
              },
              validator: (value) => value != null ? null : StringConst.FORM_GENERIC_ERROR,
            ) :
            CustomDropDownButtonFormFieldTittle(
              labelText: 'Tarjeta sanitaria',
              value: _healthCard,
              source: _healthCardSelection,
              onChanged: _finished ? null : (value){
                _healthCard = value;
              },
              validator: (value) => value != null ? null : StringConst.FORM_GENERIC_ERROR,
            ),
            childRight: CustomDatePickerTitle(
              labelText: 'Fecha de caducidad',
              initialValue: _expirationDate,
              onChanged: (value){
                _expirationDate = value;
              },
              enabled: !_finished,
              validator: (value) => (value != null) ? null : StringConst.FORM_GENERIC_ERROR,
            ),
          ),
          SpaceH12(),
          CustomFlexRowColumn(
            contentPadding: EdgeInsets.zero,
            separatorSize: 20,
            childLeft: CustomTextFormFieldTitle(
              labelText: 'Enfermedad',
              initialValue: _disease,
              onChanged: (value){
                _disease = value;
              },
              validator: (value) => (value!.isNotEmpty || value != '') ? null : StringConst.FORM_GENERIC_ERROR,
              enabled: !_finished,
            ),
            childRight: CustomTextFormFieldTitle(
              labelText: 'Medicación/Tratamiento',
              initialValue: _medication,
              onChanged: (value){
                _medication = value;
              },
              validator: (value) => (value!.isNotEmpty || value != '') ? null : StringConst.FORM_GENERIC_ERROR,
              enabled: !_finished,
            ),
          ),

          //Subsection 2.1
          informSubSectionTitle('2.1 Salud mental'),
          CustomTextFormFieldTitle(
            labelText: 'Orientaciones',
            initialValue: _orientation2_1,
            onChanged: (value){
              _orientation2_1 = value;
            },
            validator: (value) => (value!.isNotEmpty || value != '') ? null : StringConst.FORM_GENERIC_ERROR,
            enabled: !_finished,
          ),
          SpaceH12(),
          CustomFlexRowColumn(
            contentPadding: EdgeInsets.zero,
            separatorSize: 20,
            childLeft: CustomTextFormFieldTitle(
              labelText: 'Sueño y descanso',
              initialValue: _rest,
              onChanged: (value){
                _rest = value;
              },
              validator: (value) => (value!.isNotEmpty || value != '') ? null : StringConst.FORM_GENERIC_ERROR,
              enabled: !_finished,
            ),
            childRight: _diagnosis == '' ? CustomDropDownButtonFormFieldTittle(
              labelText: 'Diagnóstico',
              source: _yesNoSelection,
              onChanged: _finished ? null : (value){
                _diagnosis = value;
              },
              validator: (value) => value != null ? null : StringConst.FORM_GENERIC_ERROR,
            ):
            CustomDropDownButtonFormFieldTittle(
              labelText: 'Diagnóstico',
              source: _yesNoSelection,
              value: _diagnosis,
              onChanged: _finished ? null : (value){
                _diagnosis = value;
              },
              validator: (value) => value != null ? null : StringConst.FORM_GENERIC_ERROR,
            ),
          ),
          SpaceH12(),
          CustomFlexRowColumn(
            contentPadding: EdgeInsets.zero,
            separatorSize: 20,
            childLeft: CustomTextFormFieldTitle(
              labelText: 'Tratamiento',
              initialValue: _treatment,
              onChanged: (value){
                _treatment = value;
              },
              validator: (value) => (value!.isNotEmpty || value != '') ? null : StringConst.FORM_GENERIC_ERROR,
              enabled: !_finished,
            ),
            childRight: CustomTextFormFieldTitle(
              labelText: 'Seguimiento',
              initialValue: _tracking,
              onChanged: (value){
                _tracking = value;
              },
              validator: (value) => (value!.isNotEmpty || value != '') ? null : StringConst.FORM_GENERIC_ERROR,
              enabled: !_finished,
            ),
          ),
          SpaceH12(),
          _psychosocial == '' ? CustomDropDownButtonFormFieldTittle(
            labelText: 'Derivación interna al área psicosocial',
            source: _yesNoSelection,
            onChanged: _finished ? null : (value){
              _psychosocial = value;
            },
            validator: (value) => value != null ? null : StringConst.FORM_GENERIC_ERROR,
          ):
          CustomDropDownButtonFormFieldTittle(
            labelText: 'Derivación interna al área psicosocial',
            source: _yesNoSelection,
            value: _psychosocial,
            onChanged: _finished ? null : (value){
              _psychosocial = value;
            },
            validator: (value) => value != null ? null : StringConst.FORM_GENERIC_ERROR,
          ),

          //Subsection 2.2
          informSubSectionTitle('2.2 Discapacidad'),
          CustomTextFormFieldTitle(
            labelText: 'Orientaciones',
            initialValue: _orientation2_2,
            onChanged: (value){
              _orientation2_2 = value;
            },
            validator: (value) => (value!.isNotEmpty || value != '') ? null : StringConst.FORM_GENERIC_ERROR,
            enabled: !_finished,
          ),
          SpaceH12(),
          CustomFlexRowColumn(
            contentPadding: EdgeInsets.zero,
            separatorSize: 20,
            childLeft: _disabilityState == '' ? CustomDropDownButtonFormFieldTittle(
              labelText: 'Estado',
              source: _stateSelection,
              onChanged: _finished ? null : (value){
                _disabilityState = value;
              },
              validator: (value) => value != null ? null : StringConst.FORM_GENERIC_ERROR,
            ) :
            CustomDropDownButtonFormFieldTittle(
              labelText: 'Estado',
              source: _stateSelection,
              value: _disabilityState,
              onChanged: _finished ? null : (value){
                _disabilityState = value;
              },
              validator: (value) => value != null ? null : StringConst.FORM_GENERIC_ERROR,
            ),
            childRight: CustomTextFormFieldTitle(
              labelText: 'Profesional de referencia',
              initialValue: _referenceProfessionalDisability,
              onChanged: (value){
                _referenceProfessionalDisability = value;
              },
              validator: (value) => (value!.isNotEmpty || value != '') ? null : StringConst.FORM_GENERIC_ERROR,
              enabled: !_finished,
            ),
          ),
          SpaceH12(),
          _disabilityGrade == '' ? CustomDropDownButtonFormFieldTittle(
            labelText: 'Grado de discapacidad',
            source: _disabilityGradeSelection,
            onChanged: _finished ? null : (value){
              _disabilityGrade = value;
            },
            validator: (value) => value != null ? null : StringConst.FORM_GENERIC_ERROR,
          ) :
          CustomDropDownButtonFormFieldTittle(
            labelText: 'Grado de discapacidad',
            source: _disabilityGradeSelection,
            value: _disabilityGrade,
            onChanged: _finished ? null : (value){
              _disabilityGrade = value;
            },
            validator: (value) => value != null ? null : StringConst.FORM_GENERIC_ERROR,
          ),

          //Subsection 2.3
          informSubSectionTitle('2.3 Dependencia'),
          CustomTextFormFieldTitle(
            labelText: 'Orientaciones',
            initialValue: _orientation2_3,
            onChanged: (value){
              _orientation2_3 = value;
            },
            validator: (value) => (value!.isNotEmpty || value != '') ? null : StringConst.FORM_GENERIC_ERROR,
            enabled: !_finished,
          ),
          SpaceH12(),
          CustomFlexRowColumn(
            contentPadding: EdgeInsets.zero,
            separatorSize: 20,
            childLeft: _dependenceState == '' ? CustomDropDownButtonFormFieldTittle(
              labelText: 'Estado',
              source: _stateSelection,
              onChanged: _finished ? null : (value){
                _dependenceState = value;
              },
              validator: (value) => value != null ? null : StringConst.FORM_GENERIC_ERROR,
            ) :
            CustomDropDownButtonFormFieldTittle(
              labelText: 'Estado',
              source: _stateSelection,
              value: _dependenceState,
              onChanged: _finished ? null : (value){
                _dependenceState = value;
              },
              validator: (value) => value != null ? null : StringConst.FORM_GENERIC_ERROR,
            ),
            childRight: CustomTextFormFieldTitle(
              labelText: 'Profesional de referencia',
              initialValue: _referenceProfessionalDependence,
              onChanged: (value){
                _referenceProfessionalDependence = value;
              },
              validator: (value) => (value!.isNotEmpty || value != '') ? null : StringConst.FORM_GENERIC_ERROR,
              enabled: !_finished,
            ),
          ),
          SpaceH12(),
          CustomFlexRowColumn(
            contentPadding: EdgeInsets.zero,
            separatorSize: 20,
            childLeft: CustomTextFormFieldTitle(
              labelText: 'Servicio de ayuda a domicilio',
              initialValue: _homeAssistance,
              onChanged: (value){
                _homeAssistance = value;
              },
              validator: (value) => (value!.isNotEmpty || value != '') ? null : StringConst.FORM_GENERIC_ERROR,
              enabled: !_finished,
            ),
            childRight: CustomTextFormFieldTitle(
              labelText: 'Teleasistencia',
              initialValue: _teleassistance,
              onChanged: (value){
                _teleassistance = value;
              },
              validator: (value) => (value!.isNotEmpty || value != '') ? null : StringConst.FORM_GENERIC_ERROR,
              enabled: !_finished,
            ),
          ),
          SpaceH12(),
          _dependenceGrade == '' ? CustomDropDownButtonFormFieldTittle(
            labelText: 'Grado de dependencia',
            source: _dependencyGradeSelection,
            onChanged: _finished ? null : (value){
              _dependenceGrade = value;
            },
            validator: (value) => value != null ? null : StringConst.FORM_GENERIC_ERROR,
          ):
          CustomDropDownButtonFormFieldTittle(
            labelText: 'Grado de dependencia',
            source: _dependencyGradeSelection,
            value: _dependenceGrade,
            onChanged: _finished ? null : (value){
              _dependenceGrade = value;
            },
            validator: (value) => value != null ? null : StringConst.FORM_GENERIC_ERROR,
          ),

          //Subsection 2.4
          informSubSectionTitle('2.4 Adicciones'),
          CustomTextFormFieldTitle(
            labelText: 'Orientaciones',
            initialValue: _orientation2_4,
            onChanged: (value){
              _orientation2_4 = value;
            },
            validator: (value) => (value!.isNotEmpty || value != '') ? null : StringConst.FORM_GENERIC_ERROR,
            enabled: !_finished,
          ),
          SpaceH12(),
          CustomFlexRowColumn(
            contentPadding: EdgeInsets.zero,
            separatorSize: 20,
            childLeft: CustomTextFormFieldTitle(
              labelText: 'Derivación externa',
              initialValue: _externalDerivation,
              onChanged: (value){
                _externalDerivation = value;
              },
              validator: (value) => (value!.isNotEmpty || value != '') ? null : StringConst.FORM_GENERIC_ERROR,
              enabled: !_finished,
            ),
            childRight: CustomTextFormFieldTitle(
              labelText: 'Nivel de consumo',
              initialValue: _consumptionLevel,
              onChanged: (value){
                _consumptionLevel = value;
              },
              validator: (value) => (value!.isNotEmpty || value != '') ? null : StringConst.FORM_GENERIC_ERROR,
              enabled: !_finished,
            ),
          ),
          SpaceH12(),
          CustomTextFormFieldTitle(
            labelText: 'Tratamiento',
            initialValue: _addictionTreatment,
            onChanged: (value){
              _addictionTreatment = value;
            },
            validator: (value) => (value!.isNotEmpty || value != '') ? null : StringConst.FORM_GENERIC_ERROR,
            enabled: !_finished,
          ),

          //Section 3
          informSectionTitle('3. Situación legal'),
          CustomTextFormFieldTitle(
            labelText: 'Orientaciones',
            initialValue: _orientation3,
            onChanged: (value){
              _orientation3 = value;
            },
            validator: (value) => (value!.isNotEmpty || value != '') ? null : StringConst.FORM_GENERIC_ERROR,
            enabled: !_finished,
          ),
          SpaceH12(),
          CustomFlexRowColumn(
            contentPadding: EdgeInsets.zero,
            separatorSize: 20,
            childLeft: CustomTextFormFieldTitle(
              labelText: 'Procesos legales abiertos',
              initialValue: _openLegalProcess,
              onChanged: (value){
                _openLegalProcess = value;
              },
              validator: (value) => (value!.isNotEmpty || value != '') ? null : StringConst.FORM_GENERIC_ERROR,
              enabled: !_finished,
            ),
            childRight: CustomTextFormFieldTitle(
              labelText: 'Procesos legales cerrados',
              initialValue: _closeLegalProcess,
              onChanged: (value){
                _closeLegalProcess = value;
              },
              validator: (value) => (value!.isNotEmpty || value != '') ? null : StringConst.FORM_GENERIC_ERROR,
              enabled: !_finished,
            ),
          ),
          SpaceH12(),
          CustomTextFormFieldTitle(
            labelText: 'Representación legal',
            hintText: 'De oficio, privada, datos de contacto',
            initialValue: _legalRepresentation,
            onChanged: (value){
              _legalRepresentation = value;
            },
            validator: (value) => (value!.isNotEmpty || value != '') ? null : StringConst.FORM_GENERIC_ERROR,
            enabled: !_finished,
          ),

          //Section 4
          informSectionTitle('4. Situación alojativa'),
          CustomTextFormFieldTitle(
            labelText: 'Orientaciones',
            initialValue: _orientation4,
            onChanged: (value){
              _orientation4 = value;
            },
            validator: (value) => (value!.isNotEmpty || value != '') ? null : StringConst.FORM_GENERIC_ERROR,
            enabled: !_finished,
          ),
          SpaceH12(),
          CustomFlexRowColumn(
            contentPadding: EdgeInsets.zero,
            separatorSize: 20,
            childLeft: CustomTextFormFieldTitle(
              labelText: 'Tipo de tenencia',
              hintText: 'Alquiler, ocupación, compra, etc',
              initialValue: _ownershipType,
              onChanged: (value){
                _ownershipType = value;
              },
              validator: (value) => (value!.isNotEmpty || value != '') ? null : StringConst.FORM_GENERIC_ERROR,
              enabled: !_finished,
            ),
            childRight: CustomTextFormFieldTitle(
              labelText: 'Ubicación',
              initialValue: _location,
              onChanged: (value){
                _location = value;
              },
              validator: (value) => (value!.isNotEmpty || value != '') ? null : StringConst.FORM_GENERIC_ERROR,
              enabled: !_finished,
            ),
          ),
          SpaceH12(),
          CustomFlexRowColumn(
            contentPadding: EdgeInsets.zero,
            separatorSize: 20,
            childLeft: CustomTextFormFieldTitle(
              labelText: 'Unidad de convivencia',
              hintText: 'Parentesco y relación de convivencia',
              initialValue: _livingUnit,
              onChanged: (value){
                _livingUnit = value;
              },
              validator: (value) => (value!.isNotEmpty || value != '') ? null : StringConst.FORM_GENERIC_ERROR,
              enabled: !_finished,
            ),
            childRight: CustomTextFormFieldTitle(
              labelText: 'Datos de contacto del centro y persona de referencia',
              initialValue: _centerContact,
              onChanged: (value){
                _centerContact = value;
              },
              validator: (value) => (value!.isNotEmpty || value != '') ? null : StringConst.FORM_GENERIC_ERROR,
              enabled: !_finished,
            ),
          ),
          SpaceH12(),
          Align(
            alignment: Alignment.center,
              child: CustomMultiSelectionRadioList(options: _optionsSectionFour, selections: _hostingObservations, enabled: !_finished)),

          //Section 5
          informSectionTitle('5. Redes de apoyo'),
          CustomTextFormFieldTitle(
            labelText: 'Orientaciones',
            initialValue: _orientation5,
            onChanged: (value){
              _orientation5 = value;
            },
            validator: (value) => (value!.isNotEmpty || value != '') ? null : StringConst.FORM_GENERIC_ERROR,
            enabled: !_finished,
          ),
          SpaceH12(),
          CustomTextFormFieldTitle(
            labelText: 'Redes informales',
            initialValue: _informationNetworks,
            hintText: 'Asociación vecinal, grupo de facebook, whatsap, etc',
            onChanged: (value){
              _informationNetworks = value;
            },
            validator: (value) => (value!.isNotEmpty || value != '') ? null : StringConst.FORM_GENERIC_ERROR,
            enabled: !_finished,
          ),

          //Section 6
          informSectionTitle('6. Situación social integral'),
          CustomTextFormFieldTitle(
            labelText: 'Orientaciones',
            initialValue: _orientation6,
            onChanged: (value){
              _orientation6 = value;
            },
            validator: (value) => (value!.isNotEmpty || value != '') ? null : StringConst.FORM_GENERIC_ERROR,
            enabled: !_finished,
          ),
          SpaceH12(),
          CustomTextFormFieldTitle(
            labelText: 'Conocimiento de la estructura social',
            initialValue: _socialStructureKnowledge,
            hintText: 'Sistema sanitario, sistema educativo',
            onChanged: (value){
              _socialStructureKnowledge = value;
            },
            validator: (value) => (value!.isNotEmpty || value != '') ? null : StringConst.FORM_GENERIC_ERROR,
            enabled: !_finished,
          ),
          SpaceH12(),
          CustomFlexRowColumn(
            contentPadding: EdgeInsets.zero,
            separatorSize: 20,
            childLeft: CustomTextFormFieldTitle(
              labelText: 'Nivel de autonomía física y psicológica',
              initialValue: _autonomyPhysicMental,
              onChanged: (value){
                _autonomyPhysicMental = value;
              },
              validator: (value) => (value!.isNotEmpty || value != '') ? null : StringConst.FORM_GENERIC_ERROR,
              enabled: !_finished,
            ),
            childRight: CustomTextFormFieldTitle(
              labelText: 'Habilidades sociales',
              initialValue: _socialSkills,
              onChanged: (value){
                _socialSkills = value;
                print(_socialSkills);
              },
              validator: (value) => (value!.isNotEmpty || value != '') ? null : StringConst.FORM_GENERIC_ERROR,
              enabled: !_finished,
            ),
          ),

          //Section 7
          informSectionTitle('7. Idiomas'),
          CustomTextFormFieldTitle(
            labelText: 'Orientaciones',
            initialValue: _orientation7,
            onChanged: (value){
              _orientation7 = value;
            },
            validator: (value) => (value!.isNotEmpty || value != '') ? null : StringConst.FORM_GENERIC_ERROR,
            enabled: !_finished,
          ),
          SpaceH12(),
          StreamBuilder<List<String>>(
            stream: database.languagesStream(),
            builder: (context, snapshot) {
              if(!snapshot.hasData){
                return Container();
              }
              final _languages = snapshot.data;
              final _languageOptions = _languages!.map<DropdownMenuItem<String>>((String value){
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList();
              return CustomFlexRowColumn(
                contentPadding: EdgeInsets.zero,
                separatorSize: 20,
                childLeft: _language == '' ? CustomDropDownButtonFormFieldTittle(
                  labelText: 'Idioma',
                  source: _languageOptions, //TODO libreria de idiomas ?
                  onChanged: _finished ? null : (value){
                    _language = value;
                  },
                  validator: (value) => value != null ? null : StringConst.FORM_GENERIC_ERROR,
                ) :
                CustomDropDownButtonFormFieldTittle(
                  labelText: 'Idioma',
                  value: _language,
                  source: _languageOptions, //TODO libreria de idiomas ?
                  onChanged: _finished ? null : (value){
                    _language = value;
                  },
                  validator: (value) => value != null ? null : StringConst.FORM_GENERIC_ERROR,
                ),
                childRight: CustomTextFormFieldTitle(
                  labelText: 'Reconocimiento / acreditación - nivel',
                  initialValue: _languageLevel,
                  onChanged: (value){
                    _languageLevel = value;
                  },
                  validator: (value) => (value!.isNotEmpty || value != '') ? null : StringConst.FORM_GENERIC_ERROR,
                  enabled: !_finished,
                ),
              );
            }
          ),

          //Section 8
          informSectionTitle('8. Economía'),
          CustomTextFormFieldTitle(
            labelText: 'Orientaciones',
            initialValue: _orientation8,
            onChanged: (value){
              _orientation8 = value;
            },
            validator: (value) => (value!.isNotEmpty || value != '') ? null : StringConst.FORM_GENERIC_ERROR,
            enabled: !_finished,
          ),
          SpaceH12(),
          CustomFlexRowColumn(
            contentPadding: EdgeInsets.zero,
            separatorSize: 20,
            childLeft: CustomTextFormFieldTitle(
              initialValue: _economicProgramHelp,
              labelText: 'Acogida a algún programa de ayuda económica',
              onChanged: (value){
                _economicProgramHelp = value;
              },
              validator: (value) => (value!.isNotEmpty || value != '') ? null : StringConst.FORM_GENERIC_ERROR,
              enabled: !_finished,
            ),
            childRight: CustomTextFormFieldTitle(
              labelText: 'Ayuda familiar',
              initialValue: _familySupport,
              onChanged: (value){
                _familySupport = value;
              },
              validator: (value) => (value!.isNotEmpty || value != '') ? null : StringConst.FORM_GENERIC_ERROR,
              enabled: !_finished,
            ),
          ),
          SpaceH12(),
          CustomTextFormFieldTitle(
            labelText: 'Responsabilidades familiares',
            initialValue: _familyResponsibilities,
            onChanged: (value){
              _familyResponsibilities = value;
            },
            validator: (value) => (value!.isNotEmpty || value != '') ? null : StringConst.FORM_GENERIC_ERROR,
            enabled: !_finished,
          ),

          //Section 9
          informSectionTitle('9. Servicios sociales'),
          CustomTextFormFieldTitle(
            labelText: 'Orientaciones',
            initialValue: _orientation9,
            onChanged: (value){
              _orientation9 = value;
            },
            validator: (value) => (value!.isNotEmpty || value != '') ? null : StringConst.FORM_GENERIC_ERROR,
            enabled: !_finished,
          ),
          SpaceH12(),
          CustomFlexRowColumn(
            contentPadding: EdgeInsets.zero,
            separatorSize: 20,
            childLeft: CustomTextFormFieldTitle(
              labelText: 'Acceso a Servicios Sociales',
              initialValue: _socialServiceAccess,
              onChanged: (value){
                _socialServiceAccess = value;
              },
              validator: (value) => (value!.isNotEmpty || value != '') ? null : StringConst.FORM_GENERIC_ERROR,
              enabled: !_finished,
            ),
            childRight: CustomTextFormFieldTitle(
              labelText: 'Centro y TS de referencia',
              initialValue: _centerTSReference,
              onChanged: (value){
                _centerTSReference = value;
              },
              validator: (value) => (value!.isNotEmpty || value != '') ? null : StringConst.FORM_GENERIC_ERROR,
              enabled: !_finished,
            ),
          ),
          SpaceH12(),
          CustomFlexRowColumn(
            contentPadding: EdgeInsets.zero,
            separatorSize: 20,
            childLeft: CustomTextFormFieldTitle(
              labelText: 'Beneficiario de subvención y/o programa de apoyo',
              initialValue: _subsidyBeneficiary,
              onChanged: (value){
                _subsidyBeneficiary = value;
              },
              validator: (value) => (value!.isNotEmpty || value != '') ? null : StringConst.FORM_GENERIC_ERROR,
              enabled: !_finished,
            ),
            childRight: _socialServicesUser == '' ? CustomDropDownButtonFormFieldTittle(
              labelText: 'Usuaria',
              source: _yesNoSelection,
              onChanged: _finished ? null : (value){
                _socialServicesUser = value;
              },
              validator: (value) => value != null ? null : StringConst.FORM_GENERIC_ERROR,
            ) :
            CustomDropDownButtonFormFieldTittle(
              labelText: 'Certificado de Exclusión Social',
              source: _yesNoSelection,
              value: _socialServicesUser,
              onChanged: _finished ? null : (value){
                _socialServicesUser = value;
              },
              validator: (value) => value != null ? null : StringConst.FORM_GENERIC_ERROR,
            ),
          ),
          SpaceH12(),
          _socialExclusionCertificate == '' ? CustomDropDownButtonFormFieldTittle(
            labelText: 'Usuaria',
            source: _yesNoSelection,
            onChanged: _finished ? null : (value){
              _socialExclusionCertificate = value;
            },
            validator: (value) => value != null ? null : StringConst.FORM_GENERIC_ERROR,
          ) :
          CustomDropDownButtonFormFieldTittle(
            labelText: 'Certificado de Exclusión Social',
            source: _yesNoSelection,
            value: _socialExclusionCertificate,
            onChanged: _finished ? null : (value){
              _socialExclusionCertificate = value;
            },
            validator: (value) => value != null ? null : StringConst.FORM_GENERIC_ERROR,
          ),

          //Section 10
          informSectionTitle('10. Tecnología'),
          CustomTextFormFieldTitle(
            labelText: 'Orientaciones',
            initialValue: _orientation10,
            onChanged: (value){
              _orientation10 = value;
            },
            validator: (value) => (value!.isNotEmpty || value != '') ? null : StringConst.FORM_GENERIC_ERROR,
            enabled: !_finished,
          ),
          SpaceH12(),
          _digitalSkillsLevel == '' ? CustomDropDownButtonFormFieldTittle(
            labelText: 'Nivel de competencias digitales',
            source: _digitalSkillsSelection,
            onChanged: _finished ? null : (value){
              _digitalSkillsLevel = value;
            },
            validator: (value) => value != null ? null : StringConst.FORM_GENERIC_ERROR,
          ) :
          CustomDropDownButtonFormFieldTittle(
            labelText: 'Nivel de competencias digitales',
            source: _digitalSkillsSelection,
            value: _digitalSkillsLevel,
            onChanged: _finished ? null : (value){
              _digitalSkillsLevel = value;
            },
            validator: (value) => value != null ? null : StringConst.FORM_GENERIC_ERROR,
          ),

          //Section 11
          informSectionTitle('11. Objetivos de vida y laborales'),
          CustomTextFormFieldTitle(
            labelText: 'Orientaciones',
            initialValue: _orientation11,
            onChanged: (value){
              _orientation11 = value;
            },
            validator: (value) => (value!.isNotEmpty || value != '') ? null : StringConst.FORM_GENERIC_ERROR,
            enabled: !_finished,
          ),
          SpaceH12(),
          CustomFlexRowColumn(
              contentPadding: EdgeInsets.zero,
              separatorSize: 20,
              childLeft: CustomTextFormFieldTitle(
                labelText: 'Intereses en el mercado laboral',
                initialValue: _laborMarkerInterest,
                onChanged: (value){
                  _laborMarkerInterest = value;
                },
                validator: (value) => (value!.isNotEmpty || value != '') ? null : StringConst.FORM_GENERIC_ERROR,
                enabled: !_finished,
              ),
              childRight: CustomTextFormFieldTitle(
                labelText: 'Expectativas laborales',
                initialValue: _laborExpectations,
                onChanged: (value){
                  _laborExpectations = value;
                },
                validator: (value) => (value!.isNotEmpty || value != '') ? null : StringConst.FORM_GENERIC_ERROR,
                enabled: !_finished,
              ),
          ),

          //Section 12
          informSectionTitle('12. Situación de Vulnerabilidad'),
          CustomTextFormFieldTitle(
            labelText: 'Orientaciones',
            initialValue: _orientation12,
            onChanged: (value){
              _orientation12 = value;
            },
            validator: (value) => (value!.isNotEmpty || value != '') ? null : StringConst.FORM_GENERIC_ERROR,
            enabled: !_finished,
          ),
          SpaceH12(),
          CustomMultiSelectionRadioList(options: _optionsSectionTwelve, selections: _vulnerabilityOptions, enabled: !_finished),

          //Section 13
          informSectionTitle('13. Itinerario formativo laboral'),
          CustomTextFormFieldTitle(
            labelText: 'Orientaciones',
            initialValue: _orientation13,
            onChanged: (value){
              _orientation13 = value;
            },
            validator: (value) => (value!.isNotEmpty || value != '') ? null : StringConst.FORM_GENERIC_ERROR,
            enabled: !_finished,
          ),
          SpaceH12(),
          CustomFlexRowColumn(
            contentPadding: EdgeInsets.zero,
            separatorSize: 20,
            childLeft: _educationLevel == '' ? CustomDropDownButtonFormFieldTittle(
              labelText: 'Nivel educativo',
              source: _educationalLevelSelection,
              onChanged: _finished ? null : (value){
                _educationLevel = value;
              },
              validator: (value) => value != null ? null : StringConst.FORM_GENERIC_ERROR,
            ) :
            CustomDropDownButtonFormFieldTittle(
              labelText: 'Nivel educativo',
              source: _educationalLevelSelection,
              value: _educationLevel,
              onChanged: _finished ? null : (value){
                _educationLevel = value;
              },
              validator: (value) => value != null ? null : StringConst.FORM_GENERIC_ERROR,
            ),
            childRight: _laborSituation == '' ? CustomDropDownButtonFormFieldTittle(
              labelText: 'Situación laboral',
              source: _laborSituationSelection,
              onChanged: _finished ? null : (value){
                _laborSituation = value;
              },
              validator: (value) => value != null ? null : StringConst.FORM_GENERIC_ERROR,
            ) :
            CustomDropDownButtonFormFieldTittle(
              labelText: 'Situación laboral',
              source: _laborSituationSelection,
              value: _laborSituation,
              onChanged: _finished ? null : (value){
                _laborSituation = value;
              },
              validator: (value) => value != null ? null : StringConst.FORM_GENERIC_ERROR,
            ),
          ),
          SpaceH12(),
          CustomTextFormFieldTitle(
            labelText: 'Recursos externos',
            initialValue: _laborExternalResources,
            onChanged: (value){
              _laborExternalResources = value;
            },
            validator: (value) => (value!.isNotEmpty || value != '') ? null : StringConst.FORM_GENERIC_ERROR,
            enabled: !_finished,
          ),
          SpaceH12(),
          CustomTextFormFieldTitle(
            labelText: 'Valoración educativa',
            hintText: 'Autopercepción, ajuste de expectativas, intereses iniciales y evolución de los mismos, adquisición o reconocimiento de competencias...',
            initialValue: _educationalEvaluation,
            onChanged: (value){
              _educationalEvaluation = value;
            },
            validator: (value) => (value!.isNotEmpty || value != '') ? null : StringConst.FORM_GENERIC_ERROR,
            enabled: !_finished,
          ),
          SpaceH12(),
          CustomTextFormFieldTitle(
            labelText: 'Itinerario Formativo',
            hintText: 'Nombre, tipo de formación. Fecha, duración, lugar de realización. Posibilidad de homologación en caso de migrantes.',
            initialValue: _formativeItinerary,
            onChanged: (value){
              _formativeItinerary = value;
            },
            validator: (value) => (value!.isNotEmpty || value != '') ? null : StringConst.FORM_GENERIC_ERROR,
            enabled: !_finished,
          ),
          SpaceH12(),
          CustomFlexRowColumn(
            contentPadding: EdgeInsets.zero,
            separatorSize: 20,
            childLeft: CustomTextFormFieldTitle(
              labelText: 'Inserción laboral',
              initialValue: _laborInsertion,
              onChanged: (value){
                _laborInsertion = value;
              },
              validator: (value) => (value!.isNotEmpty || value != '') ? null : StringConst.FORM_GENERIC_ERROR,
              enabled: !_finished,
            ),
            childRight: CustomTextFormFieldTitle(
              labelText: 'Acompañamiento post laboral',
              initialValue: _accompanimentPostLabor,
              onChanged: (value){
                _accompanimentPostLabor = value;
              },
              validator: (value) => (value!.isNotEmpty || value != '') ? null : StringConst.FORM_GENERIC_ERROR,
              enabled: !_finished,
            ),
          ),
          SpaceH12(),
          _laborUpgrade == '' ? CustomDropDownButtonFormFieldTittle(
            labelText: 'Mejora laboral',
            source: _yesNoSelection,
            onChanged: _finished ? null : (value){
              _laborUpgrade = value;
            },
            validator: (value) => value != null ? null : StringConst.FORM_GENERIC_ERROR,
          ) :
          CustomDropDownButtonFormFieldTittle(
            labelText: 'Mejora laboral',
            source: _yesNoSelection,
            value: _laborUpgrade,
            onChanged: _finished ? null : (value){
              _laborUpgrade = value;
            },
            validator: (value) => value != null ? null : StringConst.FORM_GENERIC_ERROR,
          ),

          _finished ? Container() : Padding(
            padding: const EdgeInsets.only(top: 40, bottom: 30),
            child: Center(
              child: Container(
                height: 50,
                width: 250,
                child: ElevatedButton(
                    onPressed: () async {
                      database.setInitialReport(
                        InitialReport(
                          userId: report.userId,
                          initialReportId: report.initialReportId,
                          subsidy: _subsidy,
                          orientation1: _orientation1,
                          arriveDate: _arriveDate,
                          receptionResources: _receptionResources,
                          externalResources: _externalResources,
                          administrativeSituation: _administrativeSituation,
                          expirationDate: _expirationDate,
                          orientation2: _orientation2,
                          healthCard: _healthCard,
                          disease: _disease,
                          medication: _medication,
                          orientation2_1: _orientation2_1,
                          rest: _rest,
                          diagnosis: _diagnosis,
                          treatment: _treatment,
                          tracking: _tracking,
                          psychosocial: _psychosocial,
                          orientation2_2: _orientation2_2,
                          disabilityState: _disabilityState,
                          referenceProfessionalDisability: _referenceProfessionalDisability,
                          disabilityGrade: _disabilityGrade,
                          orientation2_3: _orientation2_3,
                          dependenceState: _dependenceState,
                          referenceProfessionalDependence: _referenceProfessionalDependence,
                          homeAssistance: _homeAssistance,
                          teleassistance: _teleassistance,
                          dependenceGrade: _dependenceGrade,
                          orientation2_4: _orientation2_4,
                          externalDerivation: _externalDerivation,
                          consumptionLevel: _consumptionLevel,
                          addictionTreatment: _addictionTreatment,
                          orientation3: _orientation3,
                          openLegalProcess: _openLegalProcess,
                          closeLegalProcess: _closeLegalProcess,
                          legalRepresentation: _legalRepresentation,
                          orientation4: _orientation4,
                          ownershipType: _ownershipType,
                          location: _location,
                          livingUnit: _livingUnit,
                          centerContact: _centerContact,
                          hostingObservations: _hostingObservations,
                          orientation5: _orientation5,
                          informationNetworks: _informationNetworks,
                          orientation6: _orientation6,
                          socialStructureKnowledge: _socialStructureKnowledge,
                          autonomyPhysicMental: _autonomyPhysicMental,
                          socialSkills: _socialSkills,
                          orientation7: _orientation7,
                          language: _language,
                          languageLevel: _languageLevel,
                          orientation8: _orientation8,
                          economicProgramHelp: _economicProgramHelp,
                          familySupport: _familySupport,
                          familyResponsibilities: _familyResponsibilities,
                          orientation9: _orientation9,
                          socialServiceAccess: _socialServiceAccess,
                          centerTSReference: _centerTSReference,
                          subsidyBeneficiary: _subsidyBeneficiary,
                          socialServicesUser: _socialServicesUser,
                          socialExclusionCertificate: _socialExclusionCertificate,
                          orientation10: _orientation10,
                          digitalSkillsLevel: _digitalSkillsLevel,
                          orientation11: _orientation11,
                          laborMarkerInterest: _laborMarkerInterest,
                          laborExpectations: _laborExpectations,
                          orientation12: _orientation12,
                          vulnerabilityOptions: _vulnerabilityOptions,
                          orientation13: _orientation13,
                          educationLevel: _educationLevel,
                          laborSituation: _laborSituation,
                          laborExternalResources: _laborExternalResources,
                          educationalEvaluation: _educationalEvaluation,
                          formativeItinerary: _formativeItinerary,
                          laborInsertion: _laborInsertion,
                          accompanimentPostLabor: _accompanimentPostLabor,
                          laborUpgrade: _laborUpgrade,
                          finished: false,
                        )
                      );
                        showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                                title: Text('Se ha guardado con exito',
                                    style: TextStyle(
                                      color: AppColors.greyDark,
                                      height: 1.5,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 16,
                                    )),
                                actions: <Widget>[
                                  ElevatedButton(
                                      onPressed: (){
                                        Navigator.of(context).pop();
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text('Ok',
                                            style: TextStyle(
                                                color: AppColors.black,
                                                height: 1.5,
                                                fontWeight: FontWeight.w400,
                                                fontSize: 14)),
                                      )),
                                ]
                            )
                        );
                      },
                    child: Text(
                      'Guardar y seguir más tarde',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.turquoiseButton,
                      shadowColor: Colors.transparent,
                    )
                ),
              ),
            ),
          ),

          _finished ? Container() : Center(
            child: Container(
              height: 50,
              width: 160,
              child: ElevatedButton(
                  onPressed: () {
                    if(!_formKey.currentState!.validate()){
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Aún quedan campos por completar',
                              style: TextStyle(
                                color: AppColors.greyDark,
                                height: 1.5,
                                fontWeight: FontWeight.w800,
                                fontSize: 16,
                              )),
                          actions: <Widget>[
                            ElevatedButton(
                                onPressed: (){
                                  Navigator.of(context).pop();
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text('Ok',
                                      style: TextStyle(
                                          color: AppColors.black,
                                          height: 1.5,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14)),
                                )),
                          ],
                        )
                      );
                      return;
                    }
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                            title: Text('¿Está seguro de que desea finalizar el informe inicial? \nNo podra volver a modifiar ningun campo',
                                style: TextStyle(
                                  color: AppColors.greyDark,
                                  height: 1.5,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 16,
                                )),
                            actions: <Widget>[
                              ElevatedButton(
                                  onPressed: () async {
                                    database.setInitialReport(
                                        InitialReport(
                                          userId: report.userId,
                                          initialReportId: report.initialReportId,
                                          subsidy: _subsidy,
                                          orientation1: _orientation1,
                                          arriveDate: _arriveDate,
                                          receptionResources: _receptionResources,
                                          externalResources: _externalResources,
                                          administrativeSituation: _administrativeSituation,
                                          expirationDate: _expirationDate,
                                          orientation2: _orientation2,
                                          healthCard: _healthCard,
                                          disease: _disease,
                                          medication: _medication,
                                          orientation2_1: _orientation2_1,
                                          rest: _rest,
                                          diagnosis: _diagnosis,
                                          treatment: _treatment,
                                          tracking: _tracking,
                                          psychosocial: _psychosocial,
                                          orientation2_2: _orientation2_2,
                                          disabilityState: _disabilityState,
                                          referenceProfessionalDisability: _referenceProfessionalDisability,
                                          disabilityGrade: _disabilityGrade,
                                          orientation2_3: _orientation2_3,
                                          dependenceState: _dependenceState,
                                          referenceProfessionalDependence: _referenceProfessionalDependence,
                                          homeAssistance: _homeAssistance,
                                          teleassistance: _teleassistance,
                                          dependenceGrade: _dependenceGrade,
                                          orientation2_4: _orientation2_4,
                                          externalDerivation: _externalDerivation,
                                          consumptionLevel: _consumptionLevel,
                                          addictionTreatment: _addictionTreatment,
                                          orientation3: _orientation3,
                                          openLegalProcess: _openLegalProcess,
                                          closeLegalProcess: _closeLegalProcess,
                                          legalRepresentation: _legalRepresentation,
                                          orientation4: _orientation4,
                                          ownershipType: _ownershipType,
                                          location: _location,
                                          livingUnit: _livingUnit,
                                          centerContact: _centerContact,
                                          hostingObservations: _hostingObservations,
                                          orientation5: _orientation5,
                                          informationNetworks: _informationNetworks,
                                          orientation6: _orientation6,
                                          socialStructureKnowledge: _socialStructureKnowledge,
                                          autonomyPhysicMental: _autonomyPhysicMental,
                                          socialSkills: _socialSkills,
                                          orientation7: _orientation7,
                                          language: _language,
                                          languageLevel: _languageLevel,
                                          orientation8: _orientation8,
                                          economicProgramHelp: _economicProgramHelp,
                                          familySupport: _familySupport,
                                          familyResponsibilities: _familyResponsibilities,
                                          orientation9: _orientation9,
                                          socialServiceAccess: _socialServiceAccess,
                                          centerTSReference: _centerTSReference,
                                          subsidyBeneficiary: _subsidyBeneficiary,
                                          socialServicesUser: _socialServicesUser,
                                          socialExclusionCertificate: _socialExclusionCertificate,
                                          orientation10: _orientation10,
                                          digitalSkillsLevel: _digitalSkillsLevel,
                                          orientation11: _orientation11,
                                          laborMarkerInterest: _laborMarkerInterest,
                                          laborExpectations: _laborExpectations,
                                          orientation12: _orientation12,
                                          vulnerabilityOptions: _vulnerabilityOptions,
                                          orientation13: _orientation13,
                                          educationLevel: _educationLevel,
                                          laborSituation: _laborSituation,
                                          laborExternalResources: _laborExternalResources,
                                          educationalEvaluation: _educationalEvaluation,
                                          formativeItinerary: _formativeItinerary,
                                          laborInsertion: _laborInsertion,
                                          accompanimentPostLabor: _accompanimentPostLabor,
                                          laborUpgrade: _laborUpgrade,
                                          finished: true,
                                        )
                                    );
                                    Navigator.of(context).pop();
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text('Si',
                                        style: TextStyle(
                                            color: AppColors.black,
                                            height: 1.5,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 14)),
                                  )),
                              ElevatedButton(
                                  onPressed: (){
                                    Navigator.of(context).pop();
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text('No',
                                        style: TextStyle(
                                            color: AppColors.black,
                                            height: 1.5,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 14)),
                                  )),
                            ]
                        )
                    );
                  },
                  child: Text(
                    'Finalizar',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.turquoiseButton,
                    shadowColor: Colors.transparent,
                  )
              ),
            ),
          ),


          SpaceH40(),



        ],
      ),
    ),
  );
}