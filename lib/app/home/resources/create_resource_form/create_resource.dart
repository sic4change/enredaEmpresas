import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:enreda_empresas/app/common_widgets/alert_dialog.dart';
import 'package:enreda_empresas/app/common_widgets/enreda_button.dart';
import 'package:enreda_empresas/app/common_widgets/flex_row_column.dart';
import 'package:enreda_empresas/app/common_widgets/show_exception_alert_dialog.dart';
import 'package:enreda_empresas/app/common_widgets/text_form_field.dart';
import 'package:enreda_empresas/app/home/resources/validating_form_controls/stream_builder_interests.dart';
import 'package:enreda_empresas/app/home/resources/validating_form_controls/stream_builder_organizations.dart';
import 'package:enreda_empresas/app/home/resources/validating_form_controls/stream_builder_resource_category.dart';
import 'package:enreda_empresas/app/home/resources/validating_form_controls/stream_builder_resource_type.dart';
import 'package:enreda_empresas/app/models/addressUser.dart';
import 'package:enreda_empresas/app/models/city.dart';
import 'package:enreda_empresas/app/models/country.dart';
import 'package:enreda_empresas/app/models/interest.dart';
import 'package:enreda_empresas/app/models/organization.dart';
import 'package:enreda_empresas/app/models/resource.dart';
import 'package:enreda_empresas/app/models/resourceCategory.dart';
import 'package:enreda_empresas/app/models/province.dart';
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

import 'create_revision_form.dart';

const double contactBtnWidthLg = 200.0;
const double contactBtnWidthSm = 120.0;
const double contactBtnWidthMd = 150.0;

class ResourceCreationForm extends StatefulWidget {
  const ResourceCreationForm({Key? key, required this.organizationId}) : super(key: key);
  final String? organizationId;

  @override
  State<ResourceCreationForm> createState() => _ResourceCreationFormState();
}

class _ResourceCreationFormState extends State<ResourceCreationForm> {
  final _formKey = GlobalKey<FormState>();
  final _formKeyOrganizer = GlobalKey<FormState>();
  final _checkFieldKey = GlobalKey<FormState>();
  bool isLoading = false;

  String? _resourceTitle;
  String? _resourceDescription;
  String? _duration;
  String? _schedule;
  String? _place;
  String? _capacity;
  String? _address;
  String? _organizerText;
  String? _link;
  String? _phone;
  String? _email;
  String? _countryId;
  String? _provinceId;
  String? _cityId;
  String? resourceTypeId;
  String? resourceCategoryId;

  int currentStep = 0;
  bool _notExpire = false;
  bool _trust = true;

  DateTime? _start;
  DateTime? _end;
  DateTime? _max;

  List<String> countries = [];
  List<String> provinces = [];
  List<String> cities = [];
  List<String> interests = [];
  Set<Interest> selectedInterests = {};

  String writtenEmail = '';
  ResourceCategory? selectedResourceCategory;
  Organization? selectedOrganization;
  String? selectedDegree;
  String? selectedModality;
  String? selectedContract;
  String? selectedSalary;
  ResourceType? selectedResourceType;
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
  late String interestsNames;
  late String organizationName;
  String? _interestId;
  int? resourceCategoryValue;
  String? organizationId;

  TextEditingController textEditingControllerDateInput =
      TextEditingController();
  TextEditingController textEditingControllerDateEndInput =
      TextEditingController();
  TextEditingController textEditingControllerDateMaxInput =
      TextEditingController();
  TextEditingController textEditingControllerAbilities =
      TextEditingController();
  TextEditingController textEditingControllerInterests =
      TextEditingController();
  TextEditingController textEditingControllerSpecificInterests =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    _resourceTitle = "";
    _duration = "";
    _schedule = "";
    _resourceDescription = "";
    _start = DateTime.now();
    _end = DateTime.now();
    _max = DateTime.now();
    textEditingControllerDateInput.text = "";
    textEditingControllerDateEndInput.text = "";
    textEditingControllerDateMaxInput.text = "";
    resourceCategoryName = "";
    resourceTypeName = "";
    resourceTypeId = "";
    interestsNames = "";
    organizationName = "";
    selectedContract = "";
    selectedSalary = "";
    _formattedStartDate = "";
    _formattedEndDate = "";
    _formattedMaxDate = "";
    selectedDegree = "";
    selectedContract = "";
    selectedSalary = "";
    _place = "";
    _address = "";
    _capacity = "";
    _countryId = "";
    _provinceId = "";
    _cityId = "";
    countryName = "";
    provinceName = "";
    cityName = "";
    _organizerText = "";
    _link = "";
    _phone = "";
    _email = "";
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
        country: _countryId,
        province: _provinceId,
        city: _cityId,
        place: _place,
      );

      final newResource = Resource(
        title: _resourceTitle!,
        description: _resourceDescription!,
        contactEmail: _email,
        contactPhone: _phone,
        resourceId: "",
        address: address,
        assistants: "",
        capacity: 0,
        contractType: selectedContract,
        duration: _duration!,
        status: 'Disponible',
        resourceType: resourceTypeId,
        resourceCategory: resourceCategoryId,
        maximumDate: _max!,
        start: _start!,
        end: _end!,
        modality: selectedModality!,
        street: _place,
        salary: selectedSalary,
        organizer: widget.organizationId!,
        link: _link,
        searchText: "",
        resourcePictureId: "",
        notExpire: _notExpire,
        promotor: organizationId,
        temporality: _schedule,
        resourceLink: "",
        participants: [],
        organizerType: "Organization",
        likes: [],
        place: _place!,
        createdate: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
      );
      try {
        final database = Provider.of<Database>(context, listen: false);
        setState(() => isLoading = true);
        await database.addResource(newResource);
        setState(() => isLoading = false);
        showAlertDialog(
          context,
          title: StringConst.FORM_SUCCESS,
          content: StringConst.FORM_SUCCESS_MAIL,
          defaultActionText: StringConst.FORM_ACCEPT,
        ).then(
          (value) {
            Navigator.of(context).pop();
            return true;
          },
        );
      } on FirebaseException catch (e) {
        showExceptionAlertDialog(context,
                title: StringConst.FORM_ERROR, exception: e)
            .then((value) => Navigator.pop(context));
      }
  }

  void _onCountryChange(CountryCode countryCode) {
    phoneCode = countryCode.toString();
  }

  /*
    Avoid call to database if email not properly written.
    Return empty stream if email not properly written
  */

  Widget _buildForm(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    double fontSize = responsiveSize(context, 14, 16, md: 15);
    List<String> strings = <String>[
      'Sin titulación',
      'Con titulación no oficial',
      'Con titulación oficial'];
    return Form(
      key: _formKey,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
          Widget>[
        CustomFlexRowColumn(
          childLeft: customTextFormField(context, _resourceTitle!,
              StringConst.FORM_TITLE, StringConst.NAME_ERROR, nameSetState),
          childRight: customTextFormMultiline(
              context,
              _resourceDescription!,
              StringConst.DESCRIPTION,
              StringConst.FORM_LASTNAME_ERROR,
              descriptionSetState),
        ),
        CustomFlexRowColumn(
          childLeft: streamBuilderDropdownResourceType(context,
              selectedResourceType, buildResourceTypeStreamBuilderSetState),
          childRight: streamBuilderDropdownResourceCategory(
              context,
              selectedResourceCategory,
              buildResourceCategoryStreamBuilderSetState),
        ),
        CustomFlexRowColumn(
          childLeft: resourceTypeName == "Formación"
              ? DropdownButtonFormField<String>(
                  hint: const Text(StringConst.FORM_DEGREE),
                  value: selectedDegree == "" ? null : selectedDegree,
                  items: strings.map<DropdownMenuItem<String>>((String value) {
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
                  validator: (value) => selectedDegree != null
                      ? null
                      : StringConst.FORM_MOTIVATION_ERROR,
                  onChanged: (value) => buildDegreeStreamBuilderSetState(value),
                  iconDisabledColor: AppColors.greyDark,
                  iconEnabledColor: AppColors.primaryColor,
                  decoration: InputDecoration(
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
                )
              : Container(),
          childRight: Container(),
        ),
        CustomFlexRowColumn(
          childLeft: resourceTypeName == "Bolsa de empleo" ||
                  resourceTypeName == "Oferta de empleo"
              ? customTextFormField(
                  context,
                  selectedContract!,
                  StringConst.FORM_CONTRACT,
                  StringConst.FORM_COMPANY_ERROR,
                  buildContractStreamBuilderSetState)
              : Container(),
          childRight: resourceTypeName == "Bolsa de empleo" ||
                  resourceTypeName == "Oferta de empleo"
              ? customTextFormField(
                  context,
                  selectedSalary!,
                  StringConst.FORM_SALARY,
                  StringConst.FORM_COMPANY_ERROR,
                  buildContractStreamBuilderSetState)
              : Container(),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: TextFormField(
            controller: textEditingControllerInterests,
            decoration: InputDecoration(
              hintText: StringConst.FORM_INTERESTS_QUESTION,
              hintMaxLines: 2,
              labelStyle: textTheme.bodySmall?.copyWith(
                color: AppColors.greyDark,
                height: 1.5,
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
            onTap: () => {_showMultiSelectInterests(context)},
            validator: (value) =>
                value!.isNotEmpty ? null : StringConst.FORM_MOTIVATION_ERROR,
            onSaved: (value) => value = _interestId,
            maxLines: 2,
            readOnly: true,
            style: textTheme.bodySmall?.copyWith(
              height: 1.5,
              color: AppColors.greyDark,
              fontWeight: FontWeight.w400,
              fontSize: fontSize,
            ),
          ),
        ),
        CustomFlexRowColumn(
          childLeft: customTextFormField(
              context,
              _duration!,
              StringConst.FORM_DURATION,
              StringConst.FORM_COMPANY_ERROR,
              durationSetState),
          childRight: customTextFormMultilineNotValidator(
              context, _schedule!, StringConst.FORM_SCHEDULE, scheduleSetState),
        ),
        CustomFlexRowColumn(
            childLeft: CheckboxListTile(
                title: Text(
                  'El recurso expira',
                  style: textTheme.bodySmall?.copyWith(
                    height: 1.5,
                    color: AppColors.greyDark,
                    fontWeight: FontWeight.w700,
                    fontSize: fontSize,
                  ),
                ),
                value: _notExpire,
                onChanged: (bool? value) => setState(() => _notExpire = value!)),
            childRight: Container()),
        _notExpire == true
            ? Flex(
                direction: Responsive.isMobile(context)
                    ? Axis.vertical
                    : Axis.horizontal,
                children: [
                  Expanded(
                      flex: Responsive.isMobile(context) ? 0 : 1,
                      child: Padding(
                        padding: const EdgeInsets.all(
                            Sizes.kDefaultPaddingDouble / 2),
                        child: TextFormField(
                          controller: textEditingControllerDateInput,
                          //editing controller of this TextField
                          validator: (value) => value!.isNotEmpty
                              ? null
                              : StringConst.FORM_START_ERROR,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.calendar_today),
                            //icon of text field
                            labelText: StringConst.FORM_START,
                            //label text of field
                            labelStyle: textTheme.button?.copyWith(
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
                          readOnly: true,
                          //set it true, so that user will not able to edit text
                          style: textTheme.button?.copyWith(
                            height: 1.5,
                            color: AppColors.greyDark,
                            fontWeight: FontWeight.w400,
                            fontSize: fontSize,
                          ),
                          onTap: () async {
                            DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
                              firstDate: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
                              lastDate: DateTime(DateTime.now().year + 10, DateTime.now().month, DateTime.now().day),
                            );
                            if (pickedDate != null) {
                              print(pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                              _formattedStartDate = DateFormat('dd-MM-yyyy').format(pickedDate);
                              setState(() {
                                textEditingControllerDateInput.text = _formattedStartDate; //set output date to TextField value.
                                _start = pickedDate;
                              });
                            }
                          },
                        ),
                      )),
                  Expanded(
                      flex: Responsive.isMobile(context) ? 0 : 1,
                      child: Padding(
                        padding: const EdgeInsets.all(
                            Sizes.kDefaultPaddingDouble / 2),
                        child: TextFormField(
                          controller: textEditingControllerDateEndInput,
                          //editing controller of this TextField
                          validator: (value) => value!.isNotEmpty
                              ? null
                              : StringConst.FORM_START_ERROR,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.calendar_today),
                            //icon of text field
                            labelText: StringConst.FORM_END,
                            //label text of field
                            labelStyle: textTheme.button?.copyWith(
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
                          readOnly: true,
                          //set it true, so that user will not able to edit text
                          style: textTheme.button?.copyWith(
                            height: 1.5,
                            color: AppColors.greyDark,
                            fontWeight: FontWeight.w400,
                            fontSize: fontSize,
                          ),
                          onTap: () async {
                            DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
                              firstDate: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
                              lastDate: DateTime(DateTime.now().year + 10, DateTime.now().month, DateTime.now().day),
                            );
                            if (pickedDate != null) {
                              print(pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                              _formattedEndDate = DateFormat('dd-MM-yyyy').format(pickedDate);
                              setState(() {
                                textEditingControllerDateEndInput.text = _formattedEndDate; //set output date to TextField value.
                                _end = pickedDate;
                              });
                            }
                          },
                        ),
                      )),
                  Expanded(
                      flex: Responsive.isMobile(context) ? 0 : 1,
                      child: Padding(
                        padding: const EdgeInsets.all(
                            Sizes.kDefaultPaddingDouble / 2),
                        child: TextFormField(
                          controller: textEditingControllerDateMaxInput,
                          //editing controller of this TextField
                          validator: (value) => value!.isNotEmpty
                              ? null
                              : StringConst.FORM_START_ERROR,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.calendar_today),
                            //icon of text field
                            labelText: StringConst.FORM_MAX,
                            //label text of field
                            labelStyle: textTheme.button?.copyWith(
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
                          readOnly: true,
                          //set it true, so that user will not able to edit text
                          style: textTheme.button?.copyWith(
                            height: 1.5,
                            color: AppColors.greyDark,
                            fontWeight: FontWeight.w400,
                            fontSize: fontSize,
                          ),
                          onTap: () async {
                            DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime(DateTime.now().year - 5, DateTime.now().month, DateTime.now().day),
                              firstDate: DateTime(DateTime.now().year - 5, DateTime.now().month, DateTime.now().day),
                              lastDate: DateTime(DateTime.now().year + 10, DateTime.now().month, DateTime.now().day),
                            );
                            if (pickedDate != null) {
                              print(pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                              _formattedMaxDate = DateFormat('dd-MM-yyyy').format(pickedDate);
                              setState(() {
                                textEditingControllerDateMaxInput.text = _formattedMaxDate; //set output date to TextField value.
                                _max = pickedDate;
                              });
                            }
                          },
                        ),
                      )),
                ],
              )
            : Container(),
      ]),
    );
  }

  Widget _buildFormOrganizer(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    double fontSize = responsiveSize(context, 14, 16, md: 15);
    return Form(
      key: _formKeyOrganizer,
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            CustomFlexRowColumn(
              childLeft: DropdownButtonFormField<String>(
                hint: const Text(StringConst.FORM_MODALITY),
                value: selectedModality,
                items: <String>[
                  'Presencial',
                  'Semipresencial',
                  'Online para residentes en país',
                  'Online para residentes en provincia',
                  'Online para residentes en ciudad',
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
                validator: (value) => selectedModality != null
                    ? null
                    : StringConst.FORM_COMPANY_ERROR,
                onChanged: (value) => buildModalityStreamBuilderSetState(value),
                iconDisabledColor: AppColors.greyDark,
                iconEnabledColor: AppColors.primaryColor,
                decoration: InputDecoration(
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
              childRight: Container(),
            ),
            CustomFlexRowColumn(
              childLeft: customTextFormField(
                  context,
                  _place!,
                  StringConst.FORM_PLACE,
                  StringConst.FORM_COMPANY_ERROR,
                  placeSetState),
              childRight: customTextFormFieldNum(
                  context,
                  _capacity!,
                  StringConst.FORM_CAPACITY,
                  StringConst.FORM_COMPANY_ERROR,
                  capacitySetState),
            ),
            selectedModality != "Online"
                ? CustomFlexRowColumn(
                    childLeft: streamBuilderForCountry(context, selectedCountry,
                        _buildCountryStreamBuilder_setState),
                    childRight:
                        selectedModality != 'Online para residentes en país'
                            ? streamBuilderForProvince(
                                context,
                                selectedCountry,
                                selectedProvince,
                                _buildProvinceStreamBuilder_setState)
                            : Container())
                : Container(),
            selectedModality != "Online"
                ? CustomFlexRowColumn(
                    childLeft:
                        selectedModality != 'Online para residentes en país' &&
                                selectedModality !=
                                    'Online para residentes en provincia'
                            ? streamBuilderForCity(
                                context,
                                selectedCountry,
                                selectedProvince,
                                selectedCity,
                                _buildCityStreamBuilder_setState)
                            : Container(),
                    childRight:
                        selectedModality != 'Online para residentes en país' &&
                                selectedModality !=
                                    'Online para residentes en provincia' &&
                                selectedModality !=
                                    'Online para residentes en ciudad'
                            ? customTextFormField(
                                context,
                                _address!,
                                StringConst.FORM_ADDRESS,
                                StringConst.FORM_COMPANY_ERROR,
                                addressSetState)
                            : Container(),
                  )
                : Container(),
            CustomFlexRowColumn(
              childLeft: streamBuilderDropdownOrganizations(
                  context,
                  selectedOrganization,
                  widget.organizationId!,
                  buildOrganizationStreamBuilderSetState),
              childRight: TextFormField(
                decoration: InputDecoration(
                  labelText: StringConst.FORM_ORGANIZER_TEXT,
                  focusColor: AppColors.lilac,
                  labelStyle: textTheme.bodySmall?.copyWith(
                    color: AppColors.greyDark,
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
                initialValue: _organizerText,
                onChanged: (String? value) => setState(() {
                  _organizerText = value;
                }),
                textCapitalization: TextCapitalization.sentences,
                keyboardType: TextInputType.name,
                style: textTheme.bodySmall?.copyWith(
                  color: AppColors.greyDark,
                  fontSize: fontSize,
                ),
              ),
            ),
            _organizerText != "" ?
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
            CustomFlexRowColumn(
              childLeft: customTextFormField(
                  context,
                  _link!,
                  StringConst.FORM_LINK,
                  StringConst.FORM_COMPANY_ERROR,
                  linkSetState),
              childRight: CheckboxListTile(
                  title: Text(
                    StringConst.FORM_TRUST,
                    style: textTheme.bodySmall?.copyWith(
                      height: 1.5,
                      color: AppColors.greyDark,
                      fontWeight: FontWeight.w700,
                      fontSize: fontSize,
                    ),
                  ),
                  value: _trust,
                  onChanged: (bool? value) => setState(() => _trust = value!)),
            ),
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
          resourceTypeName,
          resourceCategoryName,
          selectedDegree!,
          selectedContract!,
          selectedSalary!,
          interestsNames,
          _formattedStartDate,
          _formattedEndDate,
          _formattedMaxDate,
          _duration!,
          _schedule!,
          _place!,
          _capacity!,
          countryName,
          provinceName,
          cityName,
          _address!,
          organizationName,
          _organizerText!,
          _link!,
          _trust,
          _phone!,
          _email!,
        ),
      ],
    );
  }

  void _buildCountryStreamBuilder_setState(Country? country) {
    setState(() {
      selectedProvince = null;
      selectedCity = null;
      selectedCountry = country;
      countryName = country != null ? country.name : "";
    });
    _countryId = country?.countryId;
  }

  void _buildProvinceStreamBuilder_setState(Province? province) {
    setState(() {
      selectedCity = null;
      selectedProvince = province;
      provinceName = province != null ? province.name : "";
    });
    _provinceId = province?.provinceId;
  }

  void _buildCityStreamBuilder_setState(City? city) {
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
      resourceCategoryName =
          resourceCategory != null ? resourceCategory.name : "";
      resourceCategoryId = resourceCategory?.id;
    });
    resourceCategoryValue = resourceCategory?.order;
  }

  void buildOrganizationStreamBuilderSetState(
      Organization? organization) {
    setState(() {
      selectedOrganization = organization;
      organizationName = organization != null ? organization.name : "";
      organizationId = organization?.organizationId;
    });
  }

  void buildDegreeStreamBuilderSetState(String? degree) {
    setState(() {
      selectedDegree = degree;
    });
  }

  void buildModalityStreamBuilderSetState(String? modality) {
    setState(() {
      selectedModality = modality;
    });
  }

  void buildContractStreamBuilderSetState(String? contract) {
    setState(() {
      selectedContract = contract;
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

  void scheduleSetState(String? val) {
    setState(() => _schedule = val!);
  }

  void placeSetState(String? val) {
    setState(() => _place = val!);
  }

  void capacitySetState(String? val) {
    setState(() => _capacity = val!);
  }

  void addressSetState(String? val) {
    setState(() => _address = val!);
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
        return streamBuilderDropdownInterests(context, selectedInterests);
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
      interestsNames = concatenate.toString();
      textEditingControllerInterests.text = concatenate.toString();
      interests = interestsIds;
      selectedInterests = selectedValues;
    });
  }

  List<Step> getSteps() => [
        Step(
          isActive: currentStep >= 0,
          state: currentStep > 0 ? StepState.complete : StepState.indexed,
          title: Text(StringConst.FORM_GENERAL_INFO.toUpperCase()),
          content: _buildForm(context),
        ),
        Step(
          isActive: currentStep >= 1,
          state: currentStep > 1 ? StepState.complete : StepState.disabled,
          title: Text(StringConst.FORM_ORGANIZER.toUpperCase()),
          content: _buildFormOrganizer(context),
        ),
        Step(
          isActive: currentStep >= 2,
          title: Text(StringConst.FORM_REVISION.toUpperCase()),
          content: _revisionForm(context),
          //content: Container(),
        ),
      ];

  onStepContinue() async {
    // If invalid form, just return
    if (currentStep == 0 && !_validateAndSaveForm()) {
      return;
    }

    if (currentStep == 1 && !_validateAndSaveOrganizerForm()) {
      return;
    }

    // If not last step, advance and return
    final isLastStep = currentStep == getSteps().length - 1;
    if (!isLastStep) {
      setState(() => {
            if (currentStep == 0) {currentStep += 1} else {currentStep += 1}
          });
      return;
    }
    _submit();
  }

  goToStep(int step) {
    setState(() => currentStep = step);
  }

  onStepCancel() {
    if (currentStep > 0) goToStep(currentStep - 1);
  }

  @override
  Widget build(BuildContext context) {
    final isLastStep = currentStep == getSteps().length - 1;
    double screenWidth = widthOfScreen(context);
    double screenHeight = heightOfScreen(context);
    double contactBtnWidth = responsiveSize(
      context,
      contactBtnWidthSm,
      contactBtnWidthLg,
      md: contactBtnWidthMd,
    );
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop();
        return true;
      },
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: AppColors.white,
            toolbarHeight: Responsive.isMobile(context) ? 50 : 74,
            iconTheme: const IconThemeData(
              color: AppColors.greyDark, //change your color here
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Responsive.isMobile(context)
                    ? Container()
                    : Padding(
                        padding: EdgeInsets.all(Sizes.mainPadding),
                        child: Image.asset(
                          ImagePath.LOGO,
                          height: Sizes.HEIGHT_24,
                        ),
                      ),
                Responsive.isMobile(context)
                    ? Container()
                    : SizedBox(width: Sizes.mainPadding),
                Container(
                  padding:
                      const EdgeInsets.all(Sizes.kDefaultPaddingDouble / 2),
                  child: Text(StringConst.FORM_CREATE.toUpperCase(),
                      style: const TextStyle(color: AppColors.greyDark)),
                )
              ],
            ),
          ),
          body: Stack(
            children: [
              Center(
                child: Stack(
                  children: [
                    Container(
                      height: Responsive.isMobile(context) ||
                              Responsive.isTablet(context)
                          ? MediaQuery.of(context).size.height
                          : MediaQuery.of(context).size.height * 0.70,
                      width: Responsive.isMobile(context) ||
                              Responsive.isTablet(context)
                          ? MediaQuery.of(context).size.width
                          : MediaQuery.of(context).size.width * 0.70,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(
                            Sizes.kDefaultPaddingDouble / 2),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 2,
                            blurRadius: 2,
                            offset: const Offset(
                                0, 2), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          Stepper(
                            type: Responsive.isMobile(context)
                                ? StepperType.vertical
                                : StepperType.horizontal,
                            steps: getSteps(),
                            currentStep: currentStep,
                            onStepContinue: onStepContinue,
                            onStepTapped: (step) => goToStep(step),
                            onStepCancel: onStepCancel,
                            controlsBuilder: (context, _) {
                              return Container(
                                height: Sizes.kDefaultPaddingDouble * 2,
                                margin: const EdgeInsets.only(
                                    top: Sizes.kDefaultPaddingDouble * 2),
                                padding: const EdgeInsets.symmetric(
                                    horizontal:
                                        Sizes.kDefaultPaddingDouble / 2),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    if (currentStep != 0)
                                      EnredaButton(
                                        buttonTitle: StringConst.FORM_BACK,
                                        width: contactBtnWidth,
                                        onPressed: onStepCancel,
                                      ),
                                    const SizedBox(
                                        width: Sizes.kDefaultPaddingDouble),
                                    isLoading
                                        ? const Center(
                                            child: CircularProgressIndicator(
                                            color: AppColors.primary300,
                                          ))
                                        : EnredaButton(
                                            buttonTitle: isLastStep
                                                ? StringConst.FORM_CONFIRM
                                                : StringConst.FORM_NEXT,
                                            width: contactBtnWidth,
                                            buttonColor: AppColors.primaryColor,
                                            titleColor: AppColors.white,
                                            onPressed: onStepContinue,
                                          ),
                                  ],
                                ),
                              );
                            },
                          ),
                          Responsive.isTablet(context) ||
                                  Responsive.isMobile(context)
                              ? Positioned(
                                  top: screenHeight * 0.45,
                                  left: -10,
                                  child: Container(
                                    height: 300 * 0.50,
                                    child: ClipRRect(
                                      child:
                                          Image.asset(ImagePath.CHICA_LATERAL),
                                    ),
                                  ),
                                )
                              : Container(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Responsive.isTablet(context) || Responsive.isMobile(context) ? Container() :
              // Positioned(
              //   top: screenHeight * 0.51,
              //   left: Responsive.isDesktopS(context) ? screenWidth * 0.06 : screenWidth * 0.09,
              //   child: Container(
              //     height: 300,
              //     child: ClipRRect(
              //       child: Image.asset(ImagePath.CHICA_LATERAL),
              //     ),
              //   ),
              // ),
            ],
          )),
    );
  }
}

// Expanded(
//   flex: Responsive.isMobile(context) ? 0 : 1,
//   child: Padding(
//     padding: const EdgeInsets.all(Sizes.kDefaultPaddingDouble / 2),
//     child: TextFormField(
//       decoration: InputDecoration(
//         labelText: StringConst.FORM_PHONE,
//         prefixIcon:CountryCodePicker(
//           onChanged: _onCountryChange,
//           initialSelection: 'ES',
//           countryFilter: const ['ES', 'PE', 'GT'],
//           showFlagDialog: true,
//         ),
//         focusColor: AppColors.turquoise,
//         labelStyle: textTheme.button?.copyWith(
//           height: 1.5,
//           color: AppColors.greyDark,
//           fontWeight: FontWeight.w400,
//           fontSize: fontSize,
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(5.0),
//           borderSide: const BorderSide(
//             color: AppColors.greyUltraLight,
//           ),
//         ),
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(5.0),
//           borderSide: const BorderSide(
//             color: AppColors.greyUltraLight,
//             width: 1.0,
//           ),
//         ),
//       ),
//       initialValue: _phone,
//       validator: (value) =>
//       value!.isNotEmpty ? null : StringConst.PHONE_ERROR,
//       onSaved: (value) => _phone = phoneCode +' '+ value!,
//       textCapitalization: TextCapitalization.sentences,
//       keyboardType: TextInputType.phone,
//       style: textTheme.button?.copyWith(
//         height: 1.5,
//         color: AppColors.greyDark,
//         fontWeight: FontWeight.w400,
//         fontSize: fontSize,
//       ),
//       inputFormatters: <TextInputFormatter>[
//         FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
//       ],
//     ),
//   ),
// ),
