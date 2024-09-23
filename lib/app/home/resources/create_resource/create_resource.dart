import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enreda_empresas/app/common_widgets/alert_dialog.dart';
import 'package:enreda_empresas/app/common_widgets/custom_stepper.dart';
import 'package:enreda_empresas/app/common_widgets/custom_stepper_button.dart';
import 'package:enreda_empresas/app/common_widgets/custom_text.dart';
import 'package:enreda_empresas/app/common_widgets/enreda_button.dart';
import 'package:enreda_empresas/app/common_widgets/flex_row_column.dart';
import 'package:enreda_empresas/app/common_widgets/show_exception_alert_dialog.dart';
import 'package:enreda_empresas/app/common_widgets/text_form_field.dart';
import 'package:enreda_empresas/app/home/resources/my_resources_list_page.dart';
import 'package:enreda_empresas/app/home/resources/validating_form_controls/stream_builder_category_create.dart';
import 'package:enreda_empresas/app/home/resources/validating_form_controls/stream_builder_competencies.dart';
import 'package:enreda_empresas/app/home/resources/validating_form_controls/stream_builder_competencies_sub_categories.dart';
import 'package:enreda_empresas/app/home/resources/validating_form_controls/stream_builder_interests_create.dart';
import 'package:enreda_empresas/app/home/resources/validating_form_controls/stream_builder_social_entities.dart';
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
import 'package:enreda_empresas/app/sign_up/validating_form_controls/stream_builder_city.dart';
import 'package:enreda_empresas/app/sign_up/validating_form_controls/stream_builder_country.dart';
import 'package:enreda_empresas/app/sign_up/validating_form_controls/stream_builder_province.dart';
import 'package:enreda_empresas/app/utils/adaptative.dart';
import 'package:enreda_empresas/app/utils/responsive.dart';
import 'package:enreda_empresas/app/values/strings.dart';
import 'package:enreda_empresas/app/values/values.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../common_widgets/bubbled_container.dart';
import '../../../common_widgets/custom_form_field.dart';
import '../../../common_widgets/rounded_container.dart';
import '../../../models/jobOffer.dart';
import '../validating_form_controls/stream_builder_competencies_categories.dart';
import 'create_revision_form.dart';
import 'package:enreda_empresas/app/home/resources/global.dart' as globals;

const double contactBtnWidthLg = 200.0;
const double contactBtnWidthSm = 100.0;
const double contactBtnWidthMd = 140.0;

class CreateJobOffer extends StatefulWidget {
  const CreateJobOffer({Key? key}) : super(key: key);

  @override
  State<CreateJobOffer> createState() => _CreateJobOfferState();
}

class _CreateJobOfferState extends State<CreateJobOffer> {
  final _formKey = GlobalKey<FormState>();
  final _formKeyOrganizer = GlobalKey<FormState>();
  bool isLoading = false;

  String? _resourceTitle;
  String? _resourceDescription;
  String? _resourceResponsibilities;
  String? _resourceFunctions;
  String? _otherRequirements;
  String? _duration;
  String? _temporality;
  String? _place;
  int? _capacity;
  String? _postalCode;
  String? _organizerText;
  String? _link;
  String? _phone;
  String? _email;
  String? _countryId;
  String? _provinceId;
  String? _cityId;
  String? resourceTypeId;
  String? resourceCategoryId;
  String? resourcePictureId;

  int currentStep = 0;
  bool _notExpire = false;
  //bool _trust = true;

  DateTime? _start;
  DateTime? _end;

  List<String> countries = [];
  List<String> provinces = [];
  List<String> cities = [];
  List<String> interests = [];
  List<String> competencies = [];
  List<String> competenciesCategories = [];
  List<String> competenciesSubCategories = [];
  Set<Interest> selectedInterests = {};
  Set<Competency> selectedCompetencies = {};
  Set<CompetencyCategory> selectedCompetenciesCategories = {};
  Set<CompetencySubCategory> selectedCompetenciesSubCategories = {};

  String writtenEmail = '';
  ResourceCategory? selectedResourceCategory;
  ResourceType? selectedResourceType;
  ResourcePicture? selectedResourcePicture;
  Company? selectedCompany;
  String? _companyId;
  String? _degree;
  String? _modality;
  String? _contractType;
  String? _salary;

  Country? selectedCountry;
  Province? selectedProvince;
  City? selectedCity;


  late String countryName;
  late String provinceName;
  late String cityName;
  String phoneCode = '+34';
  late String _formattedStartDate;
  late String _formattedEndDate;
  late String _formattedMaxDate;

  late String resourceCategoryName;
  late String resourceTypeName;
  late String resourcePictureName;
  late String interestsNames;
  late String competenciesNames;
  late String competenciesCategoriesNames;
  late String competenciesSubCategoriesNames;
  late String socialEntityName;
  String? _interestId;
  int? resourceCategoryValue;
  String? socialEntityId;

  TextEditingController textEditingControllerDateInput = TextEditingController();
  TextEditingController textEditingControllerDateEndInput = TextEditingController();
  TextEditingController textEditingControllerAbilities = TextEditingController();
  TextEditingController textEditingControllerInterests = TextEditingController();
  TextEditingController textEditingControllerCompetencies = TextEditingController();
  TextEditingController textEditingControllerCompetenciesCategories = TextEditingController();
  TextEditingController textEditingControllerCompetenciesSubCategories = TextEditingController();

  @override
  void initState() {
    super.initState();
    _companyId = globals.currentUserCompany!.companyId!;
    _resourceTitle = "";
    _duration = "";
    _temporality = "";
    _resourceDescription = "";
    _resourceResponsibilities = "";
    _resourceFunctions = "";
    _otherRequirements = "";
    _start = DateTime.now();
    _end = DateTime.now();
    textEditingControllerDateInput.text = "";
    textEditingControllerDateEndInput.text = "";
    resourceCategoryName = "";
    resourceTypeName = "";
    resourcePictureName = "";
    resourceTypeId = "";
    interestsNames = "";
    competenciesNames = "";
    competenciesCategoriesNames = "";
    competenciesSubCategoriesNames = "";
    socialEntityName = "";
    _contractType = "";
    _salary = "";
    _degree = "";
    _place = "";
    _postalCode = "";
    _capacity = 0;
    _countryId = null;
    _provinceId = null;
    _cityId = null;
    countryName = "";
    provinceName = "";
    cityName = "";
    _organizerText = "";
    _link = "";
    _phone = "";
    _email = "";
    _formattedStartDate = "";
    _formattedEndDate = "";
    _formattedMaxDate = "";
  }

  bool _validateAndSaveForm() {
    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  bool _validateAndSaveOrganizerForm() {
    final form = _formKeyOrganizer.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }


  Future<void> _submit() async {
      final address = Address(
        city: _cityId,
        country: _countryId,
        province: _provinceId,
        place: _place,
        postalCode: _postalCode,
      );

      final newResource = Resource(
        title: _resourceTitle!,
        description: _resourceDescription!,
        contactEmail: _email,
        contactPhone: _phone,
        resourceId: "",
        address: address,
        assistants: "",
        capacity: _capacity,
        contractType: _contractType,
        duration: _duration!,
        status: 'No disponible',
        //status: 'Disponible',
        resourceCategory: resourceCategoryId,
        maximumDate: _end!,
        start: _start!,
        end: _end!,
        modality: _modality!,
        salary: _salary,
        organizer: globals.currentUserCompany!.companyId!,
        link: _link,
        notExpire: _notExpire,
        degree: _degree,
        promotor: globals.currentUserCompany!.name,
        temporality: _temporality,
        participants: [],
        interests: interests,
        competencies: competencies,
        organizerType: "Empresa",
        likes: [],
        createdate: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
      );

      final newJobOffer = JobOffer(
        jobOfferId: '',
        resourceId: '',
        responsibilities: _resourceResponsibilities,
        functions: _resourceFunctions,
        otherRequirements: _otherRequirements,
        createdate: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),

      );
      try {
        final database = Provider.of<Database>(context, listen: false);
        setState(() => isLoading = true);
        String newResourceId = await database.addResource(newResource);
        String newJobOfferId = await database.addJobOffer(newJobOffer);
        await database.updateJobOffer(newJobOfferId,newResourceId);
        await database.updateResource(newResourceId, newJobOfferId);

        setState(() => isLoading = false);
        showAlertDialog(
          context,
          title: StringConst.FORM_SUCCESS,
          content: StringConst.FORM_SUCCESS_CREATED,
          defaultActionText: StringConst.FORM_ACCEPT,
        ).then(
          (value) {
            setState(() {
              MyResourcesListPage.selectedIndex.value = 0;
            });
          },
        );
      } on FirebaseException catch (e) {
        showExceptionAlertDialog(context, title: StringConst.FORM_ERROR, exception: e)
            .then((value) {
              setState(() {
                MyResourcesListPage.selectedIndex.value = 0;
              });
        });
      }
  }

  Widget _buildForm(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    double fontSize = responsiveSize(context, 14, 16, md: 15);
    List<String> degrees = <String>[
      'Sin titulación',
      'Con titulación no oficial',
      'Con titulación oficial'];
    List<String> contractTypes = <String>[
      'Contrato indefinido',
      'Contrato temporal',
      'Sin especificar'];
    return Form(
      key: _formKey,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget> [
        CustomTextMediumForm(text: StringConst.FORM_DESCRIPTION),
        CustomFormField(
          child: customTextFormField(context, _resourceTitle!, '', StringConst.FORM_COMPANY_ERROR, nameSetState),
          label: StringConst.FORM_TITLE,),
        CustomFormField(
          child: streamBuilderDropdownResourceCategoryCreate(context, selectedResourceCategory, buildResourceCategoryStreamBuilderSetState),
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
            child: streamBuilderForCountryCreate(context, selectedCountry,
                buildCountryStreamBuilderSetState),
            label: StringConst.FORM_COUNTRY,),
            childRight: CustomFormField(
              padding: const EdgeInsets.all(0),
              child: streamBuilderForProvinceCreate(
                  context,
                  selectedCountry,
                  selectedProvince,
                  buildProvinceStreamBuilderSetState),
              label: StringConst.FORM_PROVINCE,)),
        CustomFlexRowColumn(
            childLeft: CustomFormField(
              padding: const EdgeInsets.all(0),
              child: streamBuilderForCityCreate(
                  context,
                  selectedCountry,
                  selectedProvince,
                  selectedCity,
                  buildCityStreamBuilderSetState),
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
                if (selectedInterests.isEmpty) {
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
                              children: selectedInterests.map((s) =>
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
              child: TextFormField(
                controller: textEditingControllerDateInput,
                validator: (value) => value!.isNotEmpty
                    ? null
                    : StringConst.FORM_COMPANY_ERROR,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: const Icon(Icons.calendar_today),
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
                readOnly: true,
                style: textTheme.bodyMedium?.copyWith(
                  color: AppColors.greyDark,
                ),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
                    firstDate: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
                    lastDate: DateTime(DateTime.now().year + 10, DateTime.now().month, DateTime.now().day),
                  );
                  if (pickedDate != null) {
                    _formattedStartDate = DateFormat('dd-MM-yyyy').format(pickedDate);
                    setState(() {
                      textEditingControllerDateInput.text = _formattedStartDate; //set output date to TextField value.
                      _start = pickedDate;
                    });
                  }
                },
              ),
              label: StringConst.FORM_START,
            ),
            childRight: CustomFormField(
              padding: const EdgeInsets.all(0),
              child: TextFormField(
                controller: textEditingControllerDateEndInput,
                validator: (value) => value!.isNotEmpty
                    ? null
                    : StringConst.FORM_COMPANY_ERROR,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: const Icon(Icons.calendar_today),
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
                readOnly: true,
                style: textTheme.bodyMedium?.copyWith(
                  color: AppColors.greyDark,
                ),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
                    firstDate: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
                    lastDate: DateTime(DateTime.now().year + 10, DateTime.now().month, DateTime.now().day),
                  );
                  if (pickedDate != null) {
                    _formattedEndDate = DateFormat('dd-MM-yyyy').format(pickedDate);
                    setState(() {
                      textEditingControllerDateEndInput.text = _formattedEndDate; //set output date to TextField value.
                      _end = pickedDate;
                    });
                  }
                },
              ),
              label: StringConst.FORM_END,
            ),),
        SizedBox(height: 20,),
        CustomTextMediumForm(text: StringConst.FORM_REQUIREMENTS_JOB),
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

        SizedBox(height: 20,),
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

  Widget _buildFormOrganizer(BuildContext context) {
    return Form(
      key: _formKeyOrganizer,
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _organizerText != ""  ?
            CustomFlexRowColumn(
              childLeft: customTextFormField(
                  context,
                  _phone!,
                  StringConst.FORM_PHONE,
                  StringConst.FORM_COMPANY_ERROR,
                  phoneSetState),
              childRight: customTextFormField(
                  context,
                  _email!,
                  StringConst.FORM_EMAIL,
                  StringConst.FORM_COMPANY_ERROR,
                  emailSetState),
            ) : Container(),
            _organizerText != "" ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
              child: customTextFormField(
                  context,
                  _link!,
                  StringConst.FORM_LINK,
                  StringConst.FORM_COMPANY_ERROR,
                  linkSetState),
            ) : Container(),
            _organizerText != "" ? Container() : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
              child: customTextFormFieldNotValidator(
                  context,
                  _link!,
                  StringConst.FORM_LINK,
                  linkSetState),
            )
          ]),
    );
  }

  Widget _revisionForm(BuildContext context) {
    return Column(
      children: [
        resourceRevisionForm(
          context,
          _resourceTitle!,
          _resourceDescription!,
          resourceCategoryName,
          _degree!,
          _contractType!,
          _salary!,
          interestsNames,
          competenciesNames,
          competenciesCategoriesNames,
          competenciesSubCategoriesNames,
          _formattedStartDate,
          _formattedEndDate,
          _formattedMaxDate,
          _duration!,
          _temporality!,
          _place!,
          _capacity!.toString(),
          countryName,
          provinceName,
          cityName,
          _postalCode!,
          socialEntityName,
          _organizerText!,
          _link!,
          //_trust,
          _phone!,
          _email!,
        ),
      ],
    );
  }

  void buildCountryStreamBuilderSetState(Country? country) {
    setState(() {
      selectedProvince = null;
      selectedCity = null;
      selectedCountry = country;
      countryName = country != null ? country.name : "";
    });
    _countryId = country?.countryId;
  }

  void buildProvinceStreamBuilderSetState(Province? province) {
    setState(() {
      selectedCity = null;
      selectedProvince = province;
      provinceName = province != null ? province.name : "";
    });
    _provinceId = province?.provinceId;
  }

  void buildCityStreamBuilderSetState(City? city) {
    setState(() {
      selectedCity = city;
      cityName = city != null ? city.name : "";
    });
    _cityId = city?.cityId;
  }

  void buildResourceCategoryStreamBuilderSetState(
      ResourceCategory? resourceCategory) {
    setState(() {
      selectedResourceCategory = resourceCategory;
      resourceCategoryName = resourceCategory != null ? resourceCategory.name : "";
      resourceCategoryId = resourceCategory?.id;
    });
    resourceCategoryValue = resourceCategory?.order;
  }

  void buildResourcePictureStreamBuilderSetState(
      ResourcePicture? resourcePicture) {
    setState(() {
      selectedResourcePicture = resourcePicture;
      resourcePictureName = resourcePicture != null ? resourcePicture.name : "";
      resourcePictureId = resourcePicture?.id;
    });
  }

  void buildSocialEntityStreamBuilderSetState(
      Company? socialEntity) {
    setState(() {
      selectedCompany = socialEntity;
      socialEntityName = socialEntity != null ? socialEntity.name : "";
      socialEntityId = socialEntity?.companyId;
    });
  }

  void buildDegreeStreamBuilderSetState(String? degree) {
    setState(() {
      _degree = degree;
    });
  }

  void buildModalityStreamBuilderSetState(String? modality) {
    setState(() {
      _modality = modality;
    });
  }

  void buildContractStreamBuilderSetState(String? contractType) {
    setState(() {
      _contractType = contractType;
    });
  }

  void buildSalaryStreamBuilderSetState(String? salary) {
    setState(() {
      _salary = salary;
    });
  }

  void buildResourceTypeStreamBuilderSetState(ResourceType? resourceType) {
    setState(() {
      selectedResourceType = resourceType;
      resourceTypeName = resourceType != null ? resourceType.name : "";
      resourceTypeId = resourceType?.resourceTypeId;
    });
  }

  void nameSetState(String? val) {
    setState(() => _resourceTitle = val!);
  }

  void durationSetState(String? val) {
    setState(() => _duration = val!);
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

  void linkSetState(String? val) {
    setState(() => _link = val!);
  }

  void phoneSetState(String? val) {
    setState(() => _phone = val!);
  }

  void emailSetState(String? val) {
    setState(() => _email = val!);
  }

  void _showMultiSelectInterests(BuildContext context) async {
    final selectedValues = await showDialog<Set<Interest>>(
      context: context,
      builder: (BuildContext context) {
        return streamBuilderDropdownInterestsCreate(context, selectedInterests);
      },
    );
    getValuesFromKeyInterests(selectedValues);
  }

  void getValuesFromKeyInterests (selectedValues) {
    var concatenate = StringBuffer();
    List<String> interestsIds = [];
    int count = 0;
    int totalItems = selectedValues.length;
    selectedValues.forEach((item) {
      concatenate.write(item.name);
      interestsIds.add(item.interestId);
      if (count != totalItems - 1) {
        concatenate.write(' / ');
      }
      count++;
    });
    setState(() {
      this.interestsNames = concatenate.toString();
      this.textEditingControllerInterests.text = concatenate.toString();
      this.interests = interestsIds;
      this.selectedInterests = selectedValues;
    });
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
      textEditingControllerCompetenciesCategories.text = concatenate.toString();
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
      textEditingControllerCompetenciesSubCategories.text = concatenate.toString();
      competenciesSubCategories = competenciesSubCategoriesIds;
      selectedCompetenciesSubCategories = selectedValues;
    });
    print(interestsNames);
    print(competenciesSubCategoriesIds);
  }

  void _showMultiSelectCompetencies(BuildContext context) async {
    final selectedValues = await showDialog<Set<Competency>>(
      context: context,
      builder: (BuildContext context) {
        return streamBuilderDropdownCompetencies(context, selectedCompetenciesSubCategories, selectedCompetencies);
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
      competencies = competenciesIds;
      selectedCompetencies = selectedValues;
    });
    print(competenciesNames);
    print(competenciesIds);
  }


  List<CustomStep> getSteps() => [
        CustomStep(
          isActive: currentStep >= 0,
          state: currentStep > 0 ? CustomStepState.complete : CustomStepState.indexed,
          title: CustomStepperButton(color: currentStep >= 0 ? AppColors.yellow: AppColors.white,
              child: CustomTextBold(title: StringConst.FORM_GENERAL_INFO, color: AppColors.turquoiseBlue,),),
          content: _buildForm(context),
        ),
        CustomStep(
          isActive: currentStep >= 1,
          state: currentStep > 1 ? CustomStepState.complete : CustomStepState.disabled,
          title: CustomStepperButton(color: currentStep >= 1 ? AppColors.yellow: AppColors.white,
            child: CustomTextBold(title: StringConst.FORM_ORGANIZER, color: AppColors.turquoiseBlue,),),
          content: _buildFormOrganizer(context),
        ),
        CustomStep(
          isActive: currentStep >= 2,
          title: CustomStepperButton(color: currentStep >= 2 ? AppColors.yellow: AppColors.white,
            child: CustomTextBold(title: StringConst.FORM_REVISION, color: AppColors.turquoiseBlue,),),
          content: _revisionForm(context),
          //content: Container(),
        ),
      ];

  // onStepContinue() async {
  //   // If invalid form, just return
  //   if (currentStep == 0 && !_validateAndSaveForm()) {
  //     return;
  //   }
  //
  //   if (currentStep == 1 && !_validateAndSaveOrganizerForm()) {
  //     return;
  //   }
  //
  //   // If not last step, advance and return
  //   final isLastStep = currentStep == getSteps().length - 1;
  //   if (!isLastStep) {
  //     setState(() {
  //           if (currentStep == 0) {currentStep += 1;} else {currentStep += 1;}
  //         });
  //     return;
  //   }
  //   _submit();
  // }

  onStepContinue() async {
    // Validate the form on the current step
    if (currentStep == 0) {
      if (!_validateAndSaveForm()) {
        return;
      }
    } else if (currentStep == 1) {
      if (!_validateAndSaveOrganizerForm()) {
        return;
      }
    }

    // Check if the current step is the last step
    final isLastStep = currentStep == getSteps().length - 1;

    if (!isLastStep) {
      // If not the last step, advance to the next step
      setState(() {
        currentStep += 1;
      });
      return;
    }

    // If it is the last step, submit the form
    await _submit();
  }


  goToStep(int step) {
    setState(() => currentStep = step);
  }

  onStepCancel() {
    if (currentStep > 0) goToStep(currentStep - 1);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final isLastStep = currentStep == getSteps().length - 1;
    double contactBtnWidth = responsiveSize(
      context,
      contactBtnWidthSm,
      contactBtnWidthLg,
      md: contactBtnWidthMd,
    );
    return RoundedContainer(
      borderColor: Responsive.isMobile(context) ? Colors.transparent : AppColors.greyLight,
      margin: Responsive.isMobile(context) ? EdgeInsets.all(0) : EdgeInsets.all(Sizes.kDefaultPaddingDouble),
      contentPadding: Responsive.isMobile(context) ? EdgeInsets.all(0) : EdgeInsets.all(Sizes.kDefaultPaddingDouble),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(Sizes.kDefaultPaddingDouble),
            child: Text(
              StringConst.CREATE_JOB_OFFER,
              style: textTheme.titleMedium!.copyWith(
                color: AppColors.turquoiseBlue,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
          Expanded(
            child: LayoutBuilder(
                builder: (context, constraints) {
                  return  CustomStepper(
                    elevation: 0.0,
                    type: Responsive.isMobile(context) ? CustomStepperType.vertical : CustomStepperType.horizontal,
                    steps: getSteps(),
                    currentStep: currentStep,
                    onStepContinue: onStepContinue,
                    onStepTapped: (step) => goToStep(step),
                    onStepCancel: onStepCancel,
                    controlsBuilder: (context, _) {
                      return Container(
                        height: Sizes.kDefaultPaddingDouble * 2,
                        margin: EdgeInsets.only(top: Sizes.kDefaultPaddingDouble * 2),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            if(currentStep != 0)
                              EnredaButton(
                                buttonTitle: StringConst.FORM_BACK,
                                width: contactBtnWidth,
                                onPressed: onStepCancel,
                              ),
                            SizedBox(width: Sizes.kDefaultPaddingDouble),
                            isLoading ?
                            const Center(child: CircularProgressIndicator(color: AppColors.primary300,))
                                : EnredaButton(
                              buttonTitle: isLastStep ? StringConst.FORM_CONFIRM : StringConst.FORM_NEXT,
                              width: contactBtnWidth,
                              buttonColor: AppColors.primaryColor,
                              titleColor: AppColors.white,
                              onPressed: onStepContinue,
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }
            ),
          ),
        ],
      ),
    );
  }
}
