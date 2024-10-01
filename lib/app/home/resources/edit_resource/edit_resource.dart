import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield_new/datetime_picker_formfield.dart';
import 'package:enreda_empresas/app/common_widgets/alert_dialog.dart';
import 'package:enreda_empresas/app/common_widgets/custom_form_field.dart';
import 'package:enreda_empresas/app/common_widgets/enreda_button.dart';
import 'package:enreda_empresas/app/common_widgets/flex_row_column.dart';
import 'package:enreda_empresas/app/common_widgets/show_exception_alert_dialog.dart';
import 'package:enreda_empresas/app/common_widgets/text_form_field.dart';
import 'package:enreda_empresas/app/home/resources/create_resource/criteria_card.dart';
import 'package:enreda_empresas/app/home/resources/manage_offers_page.dart';
import 'package:enreda_empresas/app/home/resources/validating_form_controls/stream_builder_competencies.dart';
import 'package:enreda_empresas/app/home/resources/validating_form_controls/stream_builder_competencies_categories.dart';
import 'package:enreda_empresas/app/home/resources/validating_form_controls/stream_builder_competencies_sub_categories.dart';
import 'package:enreda_empresas/app/home/resources/validating_form_controls/stream_builder_interests.dart';
import 'package:enreda_empresas/app/home/resources/validating_form_controls/stream_builder_social_entities.dart';
import 'package:enreda_empresas/app/home/resources/validating_form_controls/stream_builder_province.dart';
import 'package:enreda_empresas/app/home/resources/validating_form_controls/stream_builder_resource_category.dart';
import 'package:enreda_empresas/app/models/addressUser.dart';
import 'package:enreda_empresas/app/models/city.dart';
import 'package:enreda_empresas/app/models/competency.dart';
import 'package:enreda_empresas/app/models/competencyCategory.dart';
import 'package:enreda_empresas/app/models/competencySubCategory.dart';
import 'package:enreda_empresas/app/models/country.dart';
import 'package:enreda_empresas/app/models/interest.dart';
import 'package:enreda_empresas/app/models/company.dart';
import 'package:enreda_empresas/app/models/resource.dart';
import 'package:enreda_empresas/app/models/resourceCategory.dart';
import 'package:enreda_empresas/app/models/province.dart';
import 'package:enreda_empresas/app/models/resourcePicture.dart';
import 'package:enreda_empresas/app/models/resourcetype.dart';
import 'package:enreda_empresas/app/services/database.dart';
import 'package:enreda_empresas/app/home/resources/validating_form_controls/stream_builder_city.dart';
import 'package:enreda_empresas/app/home/resources/validating_form_controls/stream_builder_country.dart';
import 'package:enreda_empresas/app/utils/adaptative.dart';
import 'package:enreda_empresas/app/utils/responsive.dart';
import 'package:enreda_empresas/app/values/strings.dart';
import 'package:enreda_empresas/app/values/values.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:enreda_empresas/app/home/resources/global.dart' as globals;

import '../../../common_widgets/bubbled_container.dart';
import '../../../common_widgets/custom_text.dart';
import '../../../models/criteria.dart';

const double contactBtnWidthLg = 200.0;
const double contactBtnWidthSm = 100.0;
const double contactBtnWidthMd = 140.0;

class EditResource extends StatefulWidget {
  EditResource(
      {Key? key}) : super(key: key);

  @override
  State<EditResource> createState() => _EditResourceState();
}

class _EditResourceState extends State<EditResource> {
  late Resource resource;
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  int currentStep = 0;
  String? _resourceId;
  String? _resourceTitle;
  String? _resourceDescription;
  String? _resourceResponsibilities;
  String? _resourceFunctions;
  String? _otherRequirements;
  String? _degree;
  String? _contractType;
  String? _salary;
  bool? _notExpire;
  bool selectedNotExpire = false;
  String? _duration;
  String? _temporality;
  String? _place;
  int? _capacity;
  String? _postalCode;
  String? _organizer;
  String? _organizerType;
  String? _resourceLink;
  String? _organizerText;
  String? _countryId;
  String? _provinceId;
  String? _cityId;
  String? _resourceTypeId;
  String? _resourceCategoryId;
  DateTime? _start;
  DateTime? _end;
  DateTime? _max;
  DateTime? _createdate;
  String? _modality;
  String? _assistants;
  String? _status;
  String? interestsNamesString;
  String? competenciesNames;
  String? competenciesCategoriesNames;
  String? competenciesSubCategoriesNames;
  double criteriaValuesSum = 0.0;

  List<Criteria> criteria = [];
  List<String> interests = [];
  List<String> _interests = [];
  List<String> _competencies = [];
  List<String> _competenciesCategories = [];
  List<String> _competenciesSubCategories = [];
  List<String> _participants = [];
  Set<Interest> selectedInterestsSet = {};
  Set<Competency> selectedCompetenciesSet = {};
  Set<CompetencyCategory> selectedCompetenciesCategoriesSet = {};
  Set<CompetencySubCategory> selectedCompetenciesSubCategoriesSet = {};
  ResourceCategory? selectedResourceCategory;
  ResourcePicture? selectedResourcePicture;
  Company? selectedSocialEntity;

  ResourceType? selectedResourceType;
  Country? selectedCountry;
  Province? selectedProvince;
  City? selectedCity;

  int? resourceCategoryValue;
  String? organizationId;

  TextEditingController? textEditingControllerInterests = TextEditingController();
  TextEditingController textEditingControllerCompetencies = TextEditingController();
  TextEditingController textEditingControllerCompetenciesCategories = TextEditingController();
  TextEditingController textEditingControllerCompetenciesSubCategories = TextEditingController();

  @override
  void initState() {
    super.initState();
    resource = globals.currentResource!;
    _resourceId = globals.currentResource?.resourceId;
    _interests = globals.currentResource?.interests ?? [];
    _competencies = globals.currentResource?.competencies ?? [];
    _resourceTitle = globals.currentResource?.title;
    _duration = globals.currentResource?.duration ?? '';
    _temporality = globals.currentResource?.temporality ?? '';
    _resourceDescription = globals.currentResource?.description;
    _resourceResponsibilities = globals.currentJobOffer?.responsibilities;
    _resourceFunctions = globals.currentJobOffer?.functions;
    _otherRequirements = globals.currentJobOffer?.otherRequirements;
    _modality = globals.currentResource?.modality;
    _start = globals.currentResource?.start ?? DateTime.now();
    _end = globals.currentResource?.end ?? DateTime.now();
    _max = globals.currentResource?.maximumDate ?? DateTime.now();
    _resourceTypeId = globals.currentResource?.resourceType ?? '';
    _resourceCategoryId = globals.currentResource?.resourceCategory ?? '';
    _contractType = globals.currentResource?.contractType ?? '';
    _salary = globals.currentResource?.salary ?? '';
    _degree = globals.currentResource?.degree ?? '';
    _place = globals.currentResource?.address?.place ?? '';
    _postalCode = globals.currentResource?.address?.postalCode ?? '';
    _capacity = globals.currentResource?.capacity ?? 0;
    _countryId = globals.currentResource?.address?.country ?? '';
    _provinceId = globals.currentResource?.address?.province ?? '';
    _provinceId = globals.currentResource?.address?.province ?? '';
    _cityId = globals.currentResource?.address?.city ?? '';
    _organizerText = globals.currentResource?.promotor ?? '';
    _notExpire = globals.currentResource?.notExpire ?? false;
    _createdate = globals.currentResource?.createdate;
    _organizer = globals.currentResource?.organizer;
    _organizerType = globals.currentResource?.organizerType ?? '';
    _resourceLink = globals.currentResource?.resourceLink ?? '';
    _participants = globals.currentResource?.participants ?? [];
    _assistants = globals.currentResource?.assistants ?? '';
    _status = globals.currentResource?.status ?? '';
    interestsNamesString = globals.interestsNamesCurrentResource!;
    selectedInterestsSet = globals.selectedInterestsCurrentResource;
    competenciesNames = globals.competenciesNamesCurrentResource!;
    selectedCompetenciesSet = globals.selectedCompetenciesCurrentResource;
    selectedSocialEntity = globals.organizerCurrentResource;
    textEditingControllerInterests = TextEditingController(text: globals.interestsNamesCurrentResource!);
    textEditingControllerCompetencies = TextEditingController(text: globals.competenciesNamesCurrentResource!);
    textEditingControllerCompetenciesCategories = TextEditingController();
    textEditingControllerCompetenciesSubCategories = TextEditingController();
    criteria = [
      Criteria(type: globals.currentJobOffer?.criteria?[0].type ?? '', requirementText: globals.currentJobOffer?.criteria?[0].requirementText ?? '', weight: globals.currentJobOffer?.criteria?[0].weight ?? 0),
      Criteria(type: globals.currentJobOffer?.criteria?[1].type ?? '', requirementText: globals.currentJobOffer?.criteria?[1].requirementText ?? '', weight: globals.currentJobOffer?.criteria?[1].weight ?? 0),
      Criteria(type: globals.currentJobOffer?.criteria?[2].type ?? '', requirementText: globals.currentJobOffer?.criteria?[2].requirementText ?? '', weight: globals.currentJobOffer?.criteria?[2].weight ?? 0),
      Criteria(type: globals.currentJobOffer?.criteria?[3].type ?? '', competencies: globals.currentJobOffer?.criteria?[3].competencies ?? [], weight: globals.currentJobOffer?.criteria?[3].weight ?? 0),
    ];
  }

  bool _validateAndSaveForm() {
    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return _buildContent(context);
  }

  Widget _buildContent(BuildContext context) {
    double contactBtnWidth = responsiveSize(
      context,
      contactBtnWidthSm,
      contactBtnWidthLg,
      md: contactBtnWidthMd,
    );
    return Center(
      child: Container(
        height: Responsive.isMobile(context) ||
            Responsive.isTablet(context)
            ? MediaQuery.of(context).size.height
            : MediaQuery.of(context).size.height * 0.80,
        width: Responsive.isMobile(context) ||
            Responsive.isTablet(context)
            ? MediaQuery.of(context).size.width
            : MediaQuery.of(context).size.width * 0.80,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(
              Sizes.kDefaultPaddingDouble / 2),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildForm(context),
              Container(
                height: Sizes.kDefaultPaddingDouble * 2,
                margin: const EdgeInsets.only(
                    top: Sizes.kDefaultPaddingDouble * 2),
                padding: const EdgeInsets.symmetric(
                    horizontal:
                    Sizes.kDefaultPaddingDouble / 2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    if (currentStep == 0)
                      EnredaButton(
                        buttonTitle:
                        StringConst.CANCEL,
                        width: contactBtnWidth,
                        onPressed: onStepCancel,
                        padding: EdgeInsets.all(0.0),
                      ),
                    const SizedBox(
                        width: Sizes.kDefaultPaddingDouble),
                    isLoading
                        ? const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primary300,
                        ))
                        : EnredaButton(
                      buttonTitle:
                      StringConst.FORM_UPDATE,
                      width: contactBtnWidth,
                      buttonColor: AppColors.primaryColor,
                      titleColor: AppColors.white,
                      onPressed: onStepContinue,
                      padding: EdgeInsets.all(4.0),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    double fontSize = responsiveSize(context, 14, 16, md: 15);
    List<String> strings = <String>[
      'Sin titulación',
      'Con titulación no oficial',
      'Con titulación oficial'
    ];
    List<String> contractTypes = <String>[
      'Contrato indefinido',
      'Contrato temporal',
      'Sin especificar',];
    return Form(
      key: _formKey,
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            CustomTextMediumForm(text: StringConst.FORM_DESCRIPTION),
            CustomFormField(
              child: customTextFormField(context, _resourceTitle!, '', StringConst.FORM_COMPANY_ERROR, nameSetState),
              label: StringConst.FORM_TITLE,),
            CustomFormField(
              child: streamBuilderDropdownResourceCategory(
                  context,
                  selectedResourceCategory,
                  buildResourceCategoryStreamBuilderSetState,
                  resource),
              label: StringConst.FORM_RESOURCE_CATEGORY,),
            CustomFormField(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.greyUltraLight),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: CustomTextSmall(text: globals.currentUserCompany!.name),
                  ),
                ],
              ),
              label: StringConst.FORM_YOUR_COMPANY_NAME,),
            SizedBox(height: 20,),
            CustomTextMediumForm(text: StringConst.FORM_JOB_PLACE),
            CustomFlexRowColumn(
                childLeft: CustomFormField(
                  padding: const EdgeInsets.all(0),
                  child: streamBuilderForCountry(context, selectedCountry,
                      buildCountryStreamBuilderSetState, resource),
                  label: StringConst.FORM_COUNTRY,),
                childRight: CustomFormField(
                  padding: const EdgeInsets.all(0),
                  child: streamBuilderForProvince(
                      context,
                      selectedCountry == null
                          ? resource.address?.country
                          : selectedCountry?.countryId,
                      selectedProvince,
                      buildProvinceStreamBuilderSetState,
                      resource),
                  label: StringConst.FORM_PROVINCE,)),
            CustomFlexRowColumn(
                childLeft: CustomFormField(
                  padding: const EdgeInsets.all(0),
                  child: streamBuilderForCity(
                      context,
                      selectedCountry == null
                          ? resource.address?.country
                          : selectedCountry?.countryId,
                      selectedProvince == null
                          ? resource.address?.province
                          : selectedProvince?.provinceId,
                      selectedCity,
                      buildCityStreamBuilderSetState,
                      resource),
                  label: StringConst.FORM_CITY,),
                childRight: CustomFormField(
                  padding: const EdgeInsets.all(0),
                  child: customTextFormField(
                      context,
                      _postalCode!,
                      '',
                      StringConst.FORM_COMPANY_ERROR,
                      addressSetState),
                  label: StringConst.FORM_POSTAL_CODE,)),
            CustomFlexRowColumn(
                childLeft: CustomFormField(
                  padding: const EdgeInsets.all(0),
                  child: customTextFormField(
                      context,
                      _place!,
                      '',
                      StringConst.FORM_COMPANY_ERROR,
                      placeSetState),
                  label: StringConst.FORM_PLACE,
                ),
                childRight: Container()),
            SizedBox(height: 20,),
            CustomTextMediumForm(text: StringConst.FORM_ABOUT_JOB),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FormField(
                  validator: (value) {
                    if (selectedInterestsSet.isEmpty) {
                      return 'Por favor seleccione al menos un sector';
                    }
                    return null;
                  },
                  builder: (FormFieldState<dynamic> field) {
                    return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget> [
                          CustomTextBold(title: StringConst.FORM_INTERESTS_QUESTION,),
                          InkWell(
                            onTap: () => {_showMultiSelectInterests(context) },
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
                                  children: selectedInterestsSet.map((s) =>
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
            CustomFormField(
              child: FormField(
                  builder: (FormFieldState<dynamic> field) {
                    return customTextFormMultiline(
                        context,
                        _resourceDescription!,
                        '',
                        StringConst.FORM_COMPANY_ERROR,
                        descriptionSetState, 4000);
                  }
              ),
              label: StringConst.DESCRIPTION,
            ),
            CustomFormField(
              child: FormField(
                  builder: (FormFieldState<dynamic> field) {
                    return customTextFormMultiline(
                        context,
                        _resourceResponsibilities!,
                        '',
                        StringConst.FORM_COMPANY_ERROR,
                        responsibilitiesSetState, 2000);
                  }
              ),
              label: StringConst.RESPONSIBILITIES,
            ),
            CustomFormField(
              child: FormField(
                  builder: (FormFieldState<dynamic> field) {
                    return customTextFormMultiline(
                        context,
                        _resourceFunctions!,
                        '',
                        StringConst.FORM_COMPANY_ERROR,
                        functionsSetState, 2000);
                  }
              ),
              label: StringConst.FUNCTIONS,
            ),
            CustomFormField(
              child: customTextFormField(context, _otherRequirements!, '', StringConst.FORM_COMPANY_ERROR, resourceRequirementsSetState),
              label: StringConst.FORM_OTHER_REQUIREMENTS,),
            CustomFlexRowColumn(
              childLeft: CustomFormField(
                padding: const EdgeInsets.all(0),
                child: DateTimeField(
                  initialValue: _start,
                  format: DateFormat('dd/MM/yyyy'),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: const Icon(Icons.calendar_today),
                    labelStyle: textTheme.bodyLarge?.copyWith(
                      height: 1.5,
                      color: AppColors.greyDark,
                      fontWeight: FontWeight.w400,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: const BorderSide(
                        color: AppColors.greyUltraLight,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: const BorderSide(
                        color: AppColors.greyUltraLight,
                        width: 1.0,
                      ),
                    ),
                  ),
                  style: textTheme.bodyMedium?.copyWith(
                    height: 1.5,
                    color: AppColors.greyDark,
                    fontWeight: FontWeight.w400,
                  ),
                  onShowPicker: (context, currentValue) {
                    return showDatePicker(
                      context: context,
                      locale: Locale('es', 'ES'),
                      firstDate: _start!,
                      initialDate: currentValue ?? DateTime.now(),
                      lastDate: DateTime(DateTime.now().year + 10,
                          DateTime.now().month, DateTime.now().day),
                    );
                  },
                  onSaved: (dateTime) {
                    setState(() {
                      _start = dateTime;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return StringConst.FORM_START_ERROR;
                    }
                    return null;
                  },
                ),
                label: StringConst.FORM_START,
              ),
              childRight: CustomFormField(
                padding: const EdgeInsets.all(0),
                child: DateTimeField(
                  initialValue: _end,
                  format: DateFormat('dd/MM/yyyy'),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: const Icon(Icons.calendar_today),
                    labelStyle: textTheme.bodyLarge?.copyWith(
                      height: 1.5,
                      color: AppColors.greyDark,
                      fontWeight: FontWeight.w400,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: const BorderSide(
                        color: AppColors.greyUltraLight,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: const BorderSide(
                        color: AppColors.greyUltraLight,
                        width: 1.0,
                      ),
                    ),
                  ),
                  style: textTheme.bodyMedium?.copyWith(
                    height: 1.5,
                    color: AppColors.greyDark,
                    fontWeight: FontWeight.w400,
                  ),
                  onShowPicker: (context, currentValue) {
                    return showDatePicker(
                      context: context,
                      locale: Locale('es', 'ES'),
                      firstDate: _end!,
                      initialDate: currentValue ?? DateTime.now(),
                      lastDate: DateTime(DateTime.now().year + 10,
                          DateTime.now().month, DateTime.now().day),
                    );
                  },
                  onSaved: (dateTime) {
                    setState(() {
                      _end = dateTime;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return StringConst.FORM_COMPANY_ERROR;
                    }
                    return null;
                  },
                ),
                label: StringConst.FORM_END,
              ),),
            SizedBox(height: 20,),
            CustomTextMediumForm(text: StringConst.FORM_REQUIREMENTS_JOB),
            SizedBox(height: 20,),
            Center(
              child: Wrap(
                spacing: 16.0,
                runSpacing: 16.0,
                children: criteria.map((c) => CriteriaCard(
                  criteria: c,
                  criteriaValuesSum: criteriaValuesSum,
                  onSliderChange: () {
                    setState(() {
                      final sum = criteria.map((e) => e.weight).reduce((value, element) => value + element);
                      criteriaValuesSum = sum > 100 ? 100 : sum;
                    });
                  },
                  onTextFieldChange: (newDescription) {
                    setState(() {
                      c.requirementText = newDescription;
                    });
                  },
                  onListFieldChange: (newList, competenciesNames) {
                    setState(() {
                      c.competencies = newList;
                      c.competenciesNames = competenciesNames;
                      _competencies = newList;
                    });
                  },
                  selectedCompetencies: selectedCompetenciesSet,
                ))
                    .toList(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: FormField(
                  validator: (value) {
                    if (criteriaValuesSum < 100) {
                      return 'La suma total de los pesos debe ser igual a 100%';
                    }
                    return null;
                  },
                  builder: (FormFieldState<dynamic> field) {
                    return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget> [
                          Slider(
                            value: criteriaValuesSum.toDouble(),
                            onChanged: null,
                            min: 0,
                            max: 100,
                          ),
                          if (!field.isValid && field.errorText != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Center(
                                child: Text(
                                  field.errorText!,
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            ),
                        ]);
                  }
              ),
            ),
            Center(
                child: CustomTextBoldCenter(
                  title: criteriaValuesSum.round() == 0 ? "-" : criteriaValuesSum.round().toString(), color: AppColors.primary900,
                )),
            SizedBox(height: 20,),
            // CustomFlexRowColumn(
            //   childLeft: Padding(
            //     padding: const EdgeInsets.all(0.0),
            //     child: FormField(
            //         validator: (value) {
            //           if (selectedCompetenciesCategoriesSet.isEmpty) {
            //             return 'Por favor seleccione al menos una categoría';
            //           }
            //           return null;
            //         },
            //         builder: (FormFieldState<dynamic> field) {
            //           return Column(
            //               crossAxisAlignment: CrossAxisAlignment.start,
            //               children: <Widget> [
            //                 CustomTextBold(title: StringConst.FORM_COMPETENCIES_CATEGORIES,),
            //                 InkWell(
            //                   onTap: () => {_showMultiSelectCompetenciesCategories(context) },
            //                   child: Container(
            //                     width: double.infinity,
            //                     constraints: BoxConstraints(minHeight: 50),
            //                     decoration: BoxDecoration(
            //                         color: Colors.white,
            //                         borderRadius: BorderRadius.circular(5.0),
            //                         border: Border.all(
            //                             color: AppColors.greyUltraLight
            //                         )
            //                     ),
            //                     child: Padding(
            //                       padding: const EdgeInsets.all(Sizes.kDefaultPaddingDouble / 2),
            //                       child: Wrap(
            //                         spacing: 5,
            //                         children: selectedCompetenciesCategoriesSet.map((s) =>
            //                             BubbledContainer(s.name),
            //                         ).toList(),
            //                       ),
            //                     ),
            //                   ),
            //                 ),
            //                 if (!field.isValid && field.errorText != null)
            //                   Padding(
            //                     padding: const EdgeInsets.only(top: 8.0),
            //                     child: Text(
            //                       field.errorText!,
            //                       style: TextStyle(color: Colors.red),
            //                     ),
            //                   ),
            //               ]);
            //         }
            //     ),
            //   ),
            //   childRight: Padding(
            //     padding: const EdgeInsets.all(0.0),
            //     child: FormField(
            //         validator: (value) {
            //           if (selectedCompetenciesSubCategoriesSet.isEmpty) {
            //             return 'Por favor seleccione al menos una sub categoría';
            //           }
            //           return null;
            //         },
            //         builder: (FormFieldState<dynamic> field) {
            //           return Column(
            //               crossAxisAlignment: CrossAxisAlignment.start,
            //               children: <Widget> [
            //                 CustomTextBold(title: StringConst.FORM_COMPETENCIES_SUB_CATEGORIES,),
            //                 InkWell(
            //                   onTap: () => {_showMultiSelectCompetenciesSubCategories(context) },
            //                   child: Container(
            //                     width: double.infinity,
            //                     constraints: BoxConstraints(minHeight: 50),
            //                     decoration: BoxDecoration(
            //                         color: Colors.white,
            //                         borderRadius: BorderRadius.circular(5.0),
            //                         border: Border.all(
            //                             color: AppColors.greyUltraLight
            //                         )
            //                     ),
            //                     child: Padding(
            //                       padding: const EdgeInsets.all(Sizes.kDefaultPaddingDouble / 2),
            //                       child: Wrap(
            //                         spacing: 5,
            //                         children: selectedCompetenciesSubCategoriesSet.map((s) =>
            //                             BubbledContainer(s.name),
            //                         ).toList(),
            //                       ),
            //                     ),
            //                   ),
            //                 ),
            //                 if (!field.isValid && field.errorText != null)
            //                   Padding(
            //                     padding: const EdgeInsets.only(top: 8.0),
            //                     child: Text(
            //                       field.errorText!,
            //                       style: TextStyle(color: Colors.red),
            //                     ),
            //                   ),
            //               ]);
            //         }
            //     ),
            //   ),
            // ),
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: FormField(
            //       validator: (value) {
            //         if (selectedCompetenciesSet.isEmpty) {
            //           return 'Por favor seleccione al menos una competencia';
            //         }
            //         return null;
            //       },
            //       builder: (FormFieldState<dynamic> field) {
            //         return Column(
            //             crossAxisAlignment: CrossAxisAlignment.start,
            //             children: <Widget> [
            //               CustomTextBold(title: StringConst.FORM_COMPETENCIES,),
            //               InkWell(
            //                 onTap: () => {_showMultiSelectCompetencies(context) },
            //                 child: Container(
            //                   width: double.infinity,
            //                   constraints: BoxConstraints(minHeight: 50),
            //                   decoration: BoxDecoration(
            //                       color: Colors.white,
            //                       borderRadius: BorderRadius.circular(5.0),
            //                       border: Border.all(
            //                           color: AppColors.greyUltraLight
            //                       )
            //                   ),
            //                   child: Padding(
            //                     padding: const EdgeInsets.all(Sizes.kDefaultPaddingDouble / 2),
            //                     child: Wrap(
            //                       spacing: 5,
            //                       children: selectedCompetenciesSet.map((s) =>
            //                           BubbledContainer(s.name),
            //                       ).toList(),
            //                     ),
            //                   ),
            //                 ),
            //               ),
            //               if (!field.isValid && field.errorText != null)
            //                 Padding(
            //                   padding: const EdgeInsets.only(top: 8.0),
            //                   child: Text(
            //                     field.errorText!,
            //                     style: TextStyle(color: Colors.red),
            //                   ),
            //                 ),
            //             ]);
            //       }
            //   ),
            // ),
            // SizedBox(height: 20,),
            CustomTextMediumForm(text: StringConst.FORM_OFFER),
            CustomFlexRowColumn(
              childLeft: CustomFormField(
                padding: const EdgeInsets.all(0),
                child: DropdownButtonFormField<String>(
                  value: _contractType == "" ? null : _contractType,
                  items: contractTypes.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: textTheme.bodySmall?.copyWith(
                          height: 1.5,
                          color: AppColors.greyDark,
                          fontWeight: FontWeight.w400,
                          fontSize: fontSize,
                        ),
                      ),
                    );
                  }).toList(),
                  validator: (value) => _contractType != null
                      ? null
                      : StringConst.FORM_COMPANY_ERROR,
                  onChanged: (value) => buildContractStreamBuilderSetState(value),
                  iconDisabledColor: AppColors.greyDark,
                  iconEnabledColor: AppColors.primaryColor,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: const BorderSide(
                        color: AppColors.greyUltraLight,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: const BorderSide(
                        color: AppColors.greyUltraLight,
                        width: 1.0,
                      ),
                    ),
                  ),
                  style: textTheme.bodySmall?.copyWith(
                    height: 1.5,
                    color: AppColors.greyDark,
                    fontWeight: FontWeight.w400,
                    fontSize: fontSize,
                  ),
                ),
                label: StringConst.FORM_CONTRACT,
              ),
              childRight: CustomFormField(
                padding: const EdgeInsets.all(0),
                child: customTextFormMultilineNotValidator(
                    context, _temporality!, '', scheduleSetState),
                label: StringConst.FORM_SCHEDULE,
              ),
            ),
            CustomFlexRowColumn(
              childLeft: CustomFormField(
                padding: const EdgeInsets.all(0),
                child: DropdownButtonFormField<String>(
                  value: _modality,
                  items: <String>[
                    'Presencial',
                    'Semipresencial',
                    'Online'
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: textTheme.bodySmall?.copyWith(
                          height: 1.5,
                          color: AppColors.greyDark,
                          fontWeight: FontWeight.w400,
                          fontSize: fontSize,
                        ),
                      ),
                    );
                  }).toList(),
                  validator: (value) => _modality != null
                      ? null
                      : StringConst.FORM_COMPANY_ERROR,
                  onChanged: (value) => buildModalityStreamBuilderSetState(value),
                  iconDisabledColor: AppColors.greyDark,
                  iconEnabledColor: AppColors.primaryColor,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    labelStyle: textTheme.bodySmall?.copyWith(
                      height: 1.5,
                      color: AppColors.greyDark,
                      fontWeight: FontWeight.w400,
                      fontSize: fontSize,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: const BorderSide(
                        color: AppColors.greyUltraLight,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: const BorderSide(
                        color: AppColors.greyUltraLight,
                        width: 1.0,
                      ),
                    ),
                  ),
                  style: textTheme.bodySmall?.copyWith(
                    height: 1.5,
                    color: AppColors.greyDark,
                    fontWeight: FontWeight.w400,
                    fontSize: fontSize,
                  ),
                ),
                label: StringConst.FORM_MODALITY,),
              childRight: CustomFormField(
                padding: const EdgeInsets.all(0),
                child: customTextFormFieldNotValidator(
                    context,
                    _salary!,
                    '',
                    buildSalaryStreamBuilderSetState),
                label: StringConst.FORM_SALARY,
              ),
            ),
            CustomFlexRowColumn(
              childLeft: CustomFormField(
                padding: const EdgeInsets.all(0),
                child: customTextFormFieldNum(
                    context,
                    _capacity! > 0 ? _capacity.toString() : '',
                    '',
                    StringConst.FORM_COMPANY_ERROR,
                    capacitySetState),
                label: StringConst.FORM_CAPACITY,
              ),
              childRight:  Container(),
            ),
          ]),
    );
  }

  void nameSetState(String? val) {
    setState(() => _resourceTitle = val!);
  }

  void descriptionSetState(String? val) {
    setState(() => _resourceDescription = val!);
  }

  void responsibilitiesSetState(String? val) {
    setState(() => _resourceResponsibilities = val!);
  }

  void functionsSetState(String? val) {
    setState(() => _resourceFunctions = val!);
  }

  void resourceRequirementsSetState(String? val) {
    setState(() => _otherRequirements = val!);
  }


  void buildResourceTypeStreamBuilderSetState(ResourceType? resourceType) {
    setState(() {
      selectedResourceType = resourceType;
    });
    _resourceTypeId = resourceType?.resourceTypeId;
  }

  void buildResourceCategoryStreamBuilderSetState(
      ResourceCategory? resourceCategory) {
    setState(() {
      selectedResourceCategory = resourceCategory;
    });
    _resourceCategoryId = resourceCategory?.id;
  }

  void buildDegreeStreamBuilderSetState(String? degree) {
    setState(() => _degree = degree);
  }

  void buildContractStreamBuilderSetState(String? contract) {
    setState(() => _contractType = contract);
  }

  void buildSalaryStreamBuilderSetState(String? salary) {
    setState(() => _salary = salary);
  }

  void buildCountryStreamBuilderSetState(Country? country) {
    setState(() {
      selectedProvince = null;
      selectedCity = null;
      selectedCountry = country;
    });
    _countryId = country?.countryId;
  }

  void buildProvinceStreamBuilderSetState(Province? province) {
    setState(() {
      selectedCity = null;
      selectedProvince = province;
    });
    _provinceId = province?.provinceId;
  }

  void buildCityStreamBuilderSetState(City? city) {
    setState(() {
      selectedCity = city;
    });
    _cityId = city?.cityId;
  }

  void buildSocialEntityStreamBuilderSetState(Company? socialEntity) {
    setState(() {
      selectedSocialEntity = socialEntity;
      organizationId = socialEntity?.companyId;
    });
  }

  buildModalityStreamBuilderSetState(String? modality) {
    setState(() => _modality = modality!);
  }

  void durationSetState(String? val) {
    setState(() => _duration = val!);
  }

  void scheduleSetState(String? val) {
    setState(() => _temporality = val!);
  }

  void placeSetState(String? val) {
    setState(() => _place = val!);
  }

  void capacitySetState(String? val) {
    setState(() => _capacity = int.parse(val!));
  }

  void addressSetState(String? val) {
    setState(() => _postalCode = val!);
  }

  void _showMultiSelectInterests(BuildContext context) async {
    final selectedValues = await showDialog<Set<Interest>>(
      context: context,
      builder: (BuildContext context) {
        return streamBuilderDropdownInterests(
            context, globals.interestsCurrentResource, selectedInterestsSet, resource);
      },
    );
    getValuesFromKeyInterests(selectedValues);
  }

  void getValuesFromKeyInterests(selectedValues) {
    var concatenate = StringBuffer();
    List<String> interestsIds = [];
    selectedValues.forEach((item) {
      concatenate.write(item.name + ' / ');
      interestsIds.add(item.interestId);
    });
    setState(() {
      interestsNamesString = concatenate.toString();
      textEditingControllerInterests?.text = concatenate.toString();
      _interests = interestsIds;
      selectedInterestsSet = selectedValues;
    });
  }

  void _showMultiSelectCompetenciesCategories(BuildContext context) async {
    final selectedValues = await showDialog<Set<CompetencyCategory>>(
      context: context,
      builder: (BuildContext context) {
        return streamBuilderDropdownCompetenciesCategoriesCreate(context, selectedCompetenciesCategoriesSet);
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
      textEditingControllerCompetenciesCategories.text = concatenate.toString();
      _competenciesCategories = competenciesCategoriesIds;
      selectedCompetenciesCategoriesSet = selectedValues;
    });
  }

  void _showMultiSelectCompetenciesSubCategories(BuildContext context) async {
    final selectedValues = await showDialog<Set<CompetencySubCategory>>(
      context: context,
      builder: (BuildContext context) {
        return streamBuilderDropdownCompetenciesSubCategories(context, selectedCompetenciesCategoriesSet, selectedCompetenciesSubCategoriesSet);
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
      textEditingControllerCompetenciesSubCategories.text = concatenate.toString();
      _competenciesSubCategories = competenciesSubCategoriesIds;
      selectedCompetenciesSubCategoriesSet = selectedValues;
    });
    print(competenciesSubCategoriesIds);
  }

  void _showMultiSelectCompetencies(BuildContext context) async {
    final selectedValues = await showDialog<Set<Competency>>(
      context: context,
      builder: (BuildContext context) {
        return streamBuilderDropdownCompetencies(context, selectedCompetenciesSubCategoriesSet, selectedCompetenciesSet);
      },
    );
    print(selectedValues);
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
      _competencies = competenciesIds;
      selectedCompetenciesSet = selectedValues;
    });
    print(competenciesNames);
    print(competenciesIds);
  }

  onStepContinue() async {
    if (currentStep == 0 && !_validateAndSaveForm()) {
      return;
    }
    _submit();
  }

  onStepCancel() {
    setState(() {
      ManageOffersPage.selectedIndex.value = 1;
    });
  }

  Future<void> _submit() async {
    final address = Address(
      country: _countryId,
      province: _provinceId,
      city: _cityId,
      place: _place,
      postalCode: _postalCode,
    );
    final newResource = Resource(
      resourceId: _resourceId,
      title: _resourceTitle!,
      description: _resourceDescription!,
      resourceType: _resourceTypeId,
      resourceCategory: _resourceCategoryId,
      interests: _interests,
      competencies: _competencies,
      duration: _duration!,
      temporality: _temporality,
      notExpire: _notExpire,
      start: _start!,
      end: _end!,
      maximumDate: _max!,
      modality: _modality!,
      address: address,
      capacity: _capacity,
      organizer: _organizer!,
      promotor: _organizerText,
      contractType: _contractType,
      salary: _salary,
      degree: _degree,
      resourcePictureId: selectedResourcePicture?.id ?? resource.resourcePictureId,
      createdate: _createdate!,
      resourceLink: _resourceLink,
      organizerType: _organizerType,
      participants: _participants,
      assistants: _assistants,
      status: _status,
    );
    try {
      final database = Provider.of<Database>(context, listen: false);
      setState(() => isLoading = true);
      await database.setResource(newResource);
      setState(() => isLoading = false);
      showAlertDialog(
        context,
        title: StringConst.FORM_SUCCESS,
        content: StringConst.FORM_SUCCESS_UPDATED,
        defaultActionText: StringConst.FORM_ACCEPT,
      ).then((value) {
          setState(() {
            ManageOffersPage.selectedIndex.value = 1;
          });
        },
      );
    } on FirebaseException catch (e) {
      showExceptionAlertDialog(context,
          title: StringConst.FORM_ERROR, exception: e)
          .then((value) {
            setState(() {
              ManageOffersPage.selectedIndex.value = 1;
            });
      });
    }
  }
}
