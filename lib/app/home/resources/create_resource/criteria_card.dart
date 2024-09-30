import 'package:flutter/material.dart';
import '../../../common_widgets/bubbled_container.dart';
import '../../../common_widgets/custom_form_field.dart';
import '../../../common_widgets/custom_text.dart';
import '../../../common_widgets/flex_row_column.dart';
import '../../../models/competency.dart';
import '../../../models/competencyCategory.dart';
import '../../../models/competencySubCategory.dart';
import '../../../utils/responsive.dart';
import '../../../values/strings.dart';
import '../../../values/values.dart';
import '../../../models/criteria.dart';
import '../validating_form_controls/stream_builder_competencies.dart';
import '../validating_form_controls/stream_builder_competencies_categories.dart';
import '../validating_form_controls/stream_builder_competencies_sub_categories.dart';

class CriteriaCard extends StatefulWidget {
  final Criteria criteria;
  final double criteriaValuesSum;
  final void Function() onSliderChange;
  final Function(String) onTextFieldChange;
  final Function(List<String>, String) onListFieldChange;

  CriteriaCard({
    Key? key,
    required this.criteria,
    required this.criteriaValuesSum,
    required this.onSliderChange,
    required this.onTextFieldChange,
    required this.onListFieldChange
  }) : super(key: key);

  @override
  State<CriteriaCard> createState() => _CriteriaCardState();


}

class _CriteriaCardState extends State<CriteriaCard> {
  late TextEditingController _descriptionController;
  List<String> competencies = [];
  List<String> competenciesCategories = [];
  List<String> competenciesSubCategories = [];
  Set<Competency> selectedCompetencies = {};
  Set<CompetencyCategory> selectedCompetenciesCategories = {};
  Set<CompetencySubCategory> selectedCompetenciesSubCategories = {};
  late String competenciesNames;
  late String competenciesCategoriesNames;
  late String competenciesSubCategoriesNames;
  TextEditingController textEditingControllerCompetencies = TextEditingController();

  @override
  void initState() {
    super.initState();
    _descriptionController = TextEditingController(text: widget.criteria.requirementText);
    _descriptionController.addListener(_onDescriptionChanged);
    competencies = widget.criteria.competencies ?? [];
  }

  void _onDescriptionChanged() {
    widget.onTextFieldChange(_descriptionController.text);
  }

  void _onListFieldChange(List<String> values, String competenciesNames) {
    widget.onListFieldChange(values, competenciesNames);
  }

  @override
  void dispose() {
    _descriptionController.removeListener(_onDescriptionChanged);
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double maxValue = 100 - widget.criteriaValuesSum + widget.criteria.weight;
    int _getTypeIndex(String type) {
      switch (type) {
        case 'academic':
          return 0;
        case 'experience':
          return 1;
        case 'languages':
          return 2;
        case 'competencies':
          return 3;
        default:
          return -1; // indicate an invalid type
      }
    }
    String _getDisplayText(String type) {
      List<String> textValues = [
        'Formación académica',
        'Nivel de experiencia',
        'Idiomas',
        'Competencias',
      ];

      int index = _getTypeIndex(type);

      if (index >= 0 && index < textValues.length) {
        return textValues[index];
      } else {
        return '';
      }
    }

    return Container(
      width: Responsive.isMobile(context) ? MediaQuery.of(context).size.width * 0.9 : MediaQuery.of(context).size.width * 0.5,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(5.0),
        ),
        border: Border.all(
          color: AppColors.greyUltraLight,
          width: 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(Sizes.kDefaultPaddingDouble),
            child: Center(
              child: Text(
                _getDisplayText(widget.criteria.type),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Divider(color: AppColors.greyUltraLight, height: 0.0,),
          widget.criteria.type != 'competencies' ? Padding(
            padding: EdgeInsets.all(Sizes.kDefaultPaddingDouble),
            child: SizedBox(
              height: 80.0,
              child:  CustomFormField(
                padding: const EdgeInsets.all(0),
                child: TextField(
                  controller: _descriptionController,
                ),
                label: StringConst.FORM_REQUIREMENTS,
              ),),
            ) : Container(),
          widget.criteria.type == 'competencies' ?
              Column(
                children: [
                  CustomFlexRowColumn(
                    childLeft: Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: FormField(
                          validator: (value) {
                            if (selectedCompetenciesCategories.isEmpty) {
                              return 'Por favor seleccione al menos una categoría';
                            }
                            return null;
                          },
                          builder: (FormFieldState<dynamic> field) {
                            return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget> [
                                  CustomTextBold(title: StringConst.FORM_COMPETENCIES_CATEGORIES,),
                                  InkWell(
                                    onTap: () => {_showMultiSelectCompetenciesCategories(context) },
                                    child: Container(
                                      width: double.infinity,
                                      constraints: BoxConstraints(minHeight: 50),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(5.0),
                                          border: Border.all(
                                              color: AppColors.greyUltraLight
                                          )
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(Sizes.kDefaultPaddingDouble / 2),
                                        child: Wrap(
                                          spacing: 5,
                                          children: selectedCompetenciesCategories.map((s) =>
                                              BubbledContainer(s.name),
                                          ).toList(),
                                        ),
                                      ),
                                    ),
                                  ),
                                  if (!field.isValid && field.errorText != null)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Text(
                                        field.errorText!,
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ),
                                ]);
                          }
                      ),
                    ),
                    childRight: Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: FormField(
                          validator: (value) {
                            if (selectedCompetenciesSubCategories.isEmpty) {
                              return 'Por favor seleccione al menos una sub categoría';
                            }
                            return null;
                          },
                          builder: (FormFieldState<dynamic> field) {
                            return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget> [
                                  CustomTextBold(title: StringConst.FORM_COMPETENCIES_SUB_CATEGORIES,),
                                  InkWell(
                                    onTap: () => {_showMultiSelectCompetenciesSubCategories(context) },
                                    child: Container(
                                      width: double.infinity,
                                      constraints: BoxConstraints(minHeight: 50),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(5.0),
                                          border: Border.all(
                                              color: AppColors.greyUltraLight
                                          )
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(Sizes.kDefaultPaddingDouble / 2),
                                        child: Wrap(
                                          spacing: 5,
                                          children: selectedCompetenciesSubCategories.map((s) =>
                                              BubbledContainer(s.name),
                                          ).toList(),
                                        ),
                                      ),
                                    ),
                                  ),
                                  if (!field.isValid && field.errorText != null)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Text(
                                        field.errorText!,
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ),
                                ]);
                          }
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FormField(
                        validator: (value) {
                          if (selectedCompetencies.isEmpty) {
                            return 'Por favor seleccione al menos una competencia';
                          }
                          return null;
                        },
                        builder: (FormFieldState<dynamic> field) {
                          return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget> [
                                CustomTextBold(title: StringConst.FORM_COMPETENCIES,),
                                InkWell(
                                  onTap: () => {_showMultiSelectCompetencies(context) },
                                  child: Container(
                                    width: double.infinity,
                                    constraints: BoxConstraints(minHeight: 50),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(5.0),
                                        border: Border.all(
                                            color: AppColors.greyUltraLight
                                        )
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(Sizes.kDefaultPaddingDouble / 2),
                                      child: Wrap(
                                        spacing: 5,
                                        children: selectedCompetencies.map((s) =>
                                            BubbledContainer(s.name),
                                        ).toList(),
                                      ),
                                    ),
                                  ),
                                ),
                                if (!field.isValid && field.errorText != null)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Text(
                                      field.errorText!,
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                              ]);
                        }
                    ),
                  ),
                ]
              ): Container(),
          Divider(color: AppColors.greyUltraLight, height: 0.0,),
          Slider(
            value: widget.criteria.weight,
            divisions: 20,
            max: 100,
            onChanged: (value) => value <= maxValue
                ? setState(() {
              widget.criteria.weight = value;
              widget.onSliderChange();
            }) : {},
          ),
          Center(child:
          Text(
            widget.criteria.weight.round() == 0 ? "-" :
            widget.criteria.weight.round().toString(),
          )
          ),
          SizedBox(height: Sizes.kDefaultPaddingDouble / 2),
        ],
      ),
    );
  }

  void _showMultiSelectCompetenciesCategories(BuildContext context) async {
    final selectedValues = await showDialog<Set<CompetencyCategory>>(
      context: context,
      builder: (BuildContext context) {
        return streamBuilderDropdownCompetenciesCategoriesCreate(context, selectedCompetenciesCategories);
      },
    );
    getValuesFromKeyCompetenciesCategories(selectedValues);
  }

  void getValuesFromKeyCompetenciesCategories(selectedValues) {
    var concatenate = StringBuffer();
    List<String> competenciesCategoriesIds = [];
    selectedValues.forEach((item) {
      concatenate.write(item.name + ' / ');
      competenciesCategoriesIds.add(item.competencyCategoryId);
    });
    setState(() {
      competenciesCategoriesNames = concatenate.toString();
      competenciesCategories = competenciesCategoriesIds;
      selectedCompetenciesCategories = selectedValues;
    });
  }

  void _showMultiSelectCompetenciesSubCategories(BuildContext context) async {
    final selectedValues = await showDialog<Set<CompetencySubCategory>>(
      context: context,
      builder: (BuildContext context) {
        return streamBuilderDropdownCompetenciesSubCategories(context, selectedCompetenciesCategories, selectedCompetenciesSubCategories);
      },
    );
    print(selectedValues);
    getValuesFromKeyCompetenciesSubCategories(selectedValues);
  }

  void getValuesFromKeyCompetenciesSubCategories (selectedValues) {
    var concatenate = StringBuffer();
    List<String> competenciesSubCategoriesIds = [];
    selectedValues.forEach((item){
      concatenate.write(item.name +' / ');
      competenciesSubCategoriesIds.add(item.competencySubCategoryId);
    });
    setState(() {
      competenciesSubCategoriesNames = concatenate.toString();
      competenciesSubCategories = competenciesSubCategoriesIds;
      selectedCompetenciesSubCategories = selectedValues;
    });
  }

  void _showMultiSelectCompetencies(BuildContext context) async {
    final selectedValues = await showDialog<Set<Competency>>(
      context: context,
      builder: (BuildContext context) {
        return streamBuilderDropdownCompetencies(context, selectedCompetenciesSubCategories, selectedCompetencies);
      },
    );
    getValuesFromKeyCompetencies(selectedValues);
  }

  void getValuesFromKeyCompetencies (selectedValues) {
    var concatenate = StringBuffer();
    List<String> competenciesIds = [];
    selectedValues.forEach((item){
      concatenate.write(item.name +' / ');
      competenciesIds.add(item.id);
    });
    setState(() {
      competenciesNames = concatenate.toString();
      textEditingControllerCompetencies.text = concatenate.toString();
      competencies = competenciesIds;
      selectedCompetencies = selectedValues;
      _onListFieldChange(competencies, competenciesNames);
    });
  }


}

