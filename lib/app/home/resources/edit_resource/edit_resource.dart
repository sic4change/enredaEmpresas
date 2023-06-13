import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:enreda_empresas/app/common_widgets/alert_dialog.dart';
import 'package:enreda_empresas/app/common_widgets/enreda_button.dart';
import 'package:enreda_empresas/app/common_widgets/expanded_row.dart';
import 'package:enreda_empresas/app/common_widgets/flex_row_column.dart';
import 'package:enreda_empresas/app/common_widgets/show_exception_alert_dialog.dart';
import 'package:enreda_empresas/app/common_widgets/text_form_field.dart';
import 'package:enreda_empresas/app/home/resources/validating_form_controls/stream_builder_interests.dart';
import 'package:enreda_empresas/app/home/resources/validating_form_controls/stream_builder_organizations.dart';
import 'package:enreda_empresas/app/home/resources/validating_form_controls/stream_builder_province.dart';
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
import 'package:enreda_empresas/app/home/resources/validating_form_controls/stream_builder_city.dart';
import 'package:enreda_empresas/app/home/resources/validating_form_controls/stream_builder_country.dart';
import 'package:enreda_empresas/app/utils/adaptative.dart';
import 'package:enreda_empresas/app/utils/responsive.dart';
import 'package:enreda_empresas/app/values/strings.dart';
import 'package:enreda_empresas/app/values/values.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

const double contactBtnWidthLg = 200.0;
const double contactBtnWidthSm = 120.0;
const double contactBtnWidthMd = 150.0;

class EditResource extends StatefulWidget {
  const EditResource({Key? key, required this.resourceId, required this.organizer}) : super(key: key);
  final String resourceId;
  final Organization organizer;

  @override
  State<EditResource> createState() => _EditResourceState();
}

class _EditResourceState extends State<EditResource> {
  late Resource resource;

  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  int currentStep = 0;

  bool _trust = true;

  String? _resourceId;
  String? _resourceTitle;
  String? _resourceDescription;
  String? _resourceCategoryName;
  String? _resourceTypeName;
  String? _degree;
  String? _contractType;
  String? _salary;
  bool? _notExpire;
  bool selectedNotExpire = false;
  String? _duration;
  String? _temporality;
  String? _place;
  int? _capacity;
  String? _street;
  String? _organizer;
  String? _organizerType;
  String? _resourceLink;
  String? _organizerText;
  String? _link;
  String? _phone;
  String? _email;
  String? _countryId;
  String? _provinceId;
  String? _cityId;
  String? resourceTypeId;
  String? resourceCategoryId;
  DateTime? _start;
  DateTime? _end;
  DateTime? _max;
  DateTime? _createdate;
  String? _modality;
  String? _resourcePictureId;
  String? _assistants;
  String? _status;

  String _countryName = "";
  String _provinceName = "";
  String _cityName = "";

  List<String> interests = [];
  List<String> _participants = [];
  Set<Interest> selectedInterests = {};
  ResourceCategory? selectedResourceCategory;
  Organization? selectedOrganization;

  ResourceType? selectedResourceType;
  Country? selectedCountry;
  Province? selectedProvince;
  City? selectedCity;

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
  TextEditingController textEditingControllerInterests =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    textEditingControllerDateInput.text = "";
    textEditingControllerDateEndInput.text = "";
    textEditingControllerDateMaxInput.text = "";
    selectedOrganization = widget.organizer;
  }

  bool _validateAndSaveForm() {
    final form = _formKey.currentState;
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
      street: _street,
    );

    final newResource = Resource(
      resourceId: _resourceId,
      title: _resourceTitle!,
      description: _resourceDescription!,
      resourceType: resourceTypeId,
      resourceCategory: resourceCategoryId,
      interests: interests,
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
      link: _link,
      contactEmail: _email,
      contactPhone: _phone,
      contractType: _contractType,
      salary: _salary,
      degree: _degree,
      resourcePictureId: _resourcePictureId,
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

  Widget _buildForm(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    double fontSize = responsiveSize(context, 14, 16, md: 15);
    List<String> strings = <String>[
      'Sin titulación',
      'Con titulación no oficial',
      'Con titulación oficial'
    ];
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
              selectedResourceType, buildResourceTypeStreamBuilderSetState, resource),
          childRight: streamBuilderDropdownResourceCategory(
              context,
              selectedResourceCategory,
              buildResourceCategoryStreamBuilderSetState, resource),
        ),
        CustomFlexRowColumn(
          childLeft: _resourceTypeName == "Formación"
              ? DropdownButtonFormField<String>(
                  hint: const Text(StringConst.FORM_DEGREE),
                  value: _degree == "" ? null : _degree,
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
                  validator: (value) => _degree != null
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
          childLeft: _resourceTypeName == "Bolsa de empleo" ||
              _resourceTypeName == "Oferta de empleo"
              ? customTextFormField(
                  context,
                  _contractType!,
                  StringConst.FORM_CONTRACT,
                  StringConst.FORM_COMPANY_ERROR,
                  buildContractStreamBuilderSetState)
              : Container(),
          childRight: _resourceTypeName == "Bolsa de empleo" ||
              _resourceTypeName == "Oferta de empleo"
              ? customTextFormField(
                  context,
                  _salary!,
                  StringConst.FORM_SALARY,
                  StringConst.FORM_COMPANY_ERROR,
                  buildSalaryStreamBuilderSetState)
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
              context, _temporality!, StringConst.FORM_SCHEDULE, scheduleSetState),
        ),
        CustomFlexRowColumn(
            childLeft: CheckboxListTile(
                title: Text(
                  'El recurso no expira',
                  style: textTheme.bodySmall?.copyWith(
                    height: 1.5,
                    color: AppColors.greyDark,
                    fontWeight: FontWeight.w700,
                    fontSize: fontSize,
                  ),
                ),
                value: selectedNotExpire,
                onChanged: (bool? value) =>
                    setState(() {
                      selectedNotExpire = value!;
                      _notExpire = selectedNotExpire;
                    })),
            childRight: Container()),
        selectedNotExpire == false
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
                        child: DateTimePicker(
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.calendar_today),
                            labelText: StringConst.FORM_START,
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
                            fontSize: fontSize,),
                          locale: const Locale('es', 'ES'),
                          dateMask: 'dd/MM/yyyy',
                          initialValue: _start.toString(),
                          firstDate: _start!,
                          lastDate: DateTime(DateTime.now().year + 10, DateTime.now().month, DateTime.now().day),
                          onChanged: (dateTime) {
                            setState(() {
                              _start = DateTime.parse(dateTime);
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return StringConst.FORM_START_ERROR;
                            }
                            return null;
                          },
                        ),
                      )),
                  Expanded(
                      flex: Responsive.isMobile(context) ? 0 : 1,
                      child: Padding(
                        padding: const EdgeInsets.all(
                            Sizes.kDefaultPaddingDouble / 2),
                        child: DateTimePicker(
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.calendar_today),
                            labelText: StringConst.FORM_END,
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
                              fontSize: fontSize,),
                          locale: const Locale('es', 'ES'),
                          dateMask: 'dd/MM/yyyy',
                          initialValue: _end.toString(),
                          firstDate: _end!,
                          lastDate: DateTime(DateTime.now().year + 10, DateTime.now().month, DateTime.now().day),
                          onChanged: (dateTime) {
                            setState(() {
                              _end = DateTime.parse(dateTime);
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return StringConst.FORM_COMPANY_ERROR;
                            }
                            return null;
                          },
                        ),
                      )),
                  Expanded(
                      flex: Responsive.isMobile(context) ? 0 : 1,
                      child: Padding(
                        padding: const EdgeInsets.all(
                            Sizes.kDefaultPaddingDouble / 2),
                        child: DateTimePicker(
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.calendar_today),
                            labelText: StringConst.FORM_MAX,
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
                            fontSize: fontSize,),
                          locale: const Locale('es', 'ES'),
                          dateMask: 'dd/MM/yyyy',
                          initialValue: _max.toString(),
                          firstDate: _max!,
                          lastDate: DateTime(DateTime.now().year + 10, DateTime.now().month, DateTime.now().day),
                          onChanged: (dateTime) {
                            setState(() {
                              _max = DateTime.parse(dateTime);
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return StringConst.FORM_COMPANY_ERROR;
                            }
                            return null;
                          },
                        ),
                      )),
                ],
              )
            : Container(),
        CustomFlexRowColumn(
          childLeft: DropdownButtonFormField<String>(
            hint: const Text(StringConst.FORM_MODALITY),
            value: _modality,
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
            validator: (value) => _modality != null
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
              _capacity!.toString(),
              StringConst.FORM_CAPACITY,
              StringConst.FORM_COMPANY_ERROR,
              capacitySetState),
        ),
        _modality != "Online"
            ? CustomFlexRowColumn(
            childLeft: streamBuilderForCountry(context, selectedCountry,
                buildCountryStreamBuilderSetState, resource),
            childRight:
            _modality != 'Online para residentes en país'
                ? streamBuilderForProvince(
                context,
                selectedCountry == null ? resource.address?.country : selectedCountry?.countryId,
                selectedProvince,
                buildProvinceStreamBuilderSetState, resource)
                : Container())
            : Container(),
        _modality != "Online"
            ? CustomFlexRowColumn(
          childLeft:
          _modality != 'Online para residentes en país' &&
              _modality !=
                  'Online para residentes en provincia'
              ? streamBuilderForCity(
              context,
              selectedCountry == null ? resource.address?.country : selectedCountry?.countryId,
              selectedProvince == null ? resource.address?.province : selectedProvince?.provinceId,
              selectedCity,
              buildCityStreamBuilderSetState, resource)
              : Container(),
          childRight:
          _modality != 'Online para residentes en país' &&
              _modality !=
                  'Online para residentes en provincia' &&
              _modality !=
                  'Online para residentes en ciudad'
              ? customTextFormFieldNotValidator(
              context,
              _street!,
              StringConst.FORM_ADDRESS,
              addressSetState)
              : Container(),
        )
            : Container(),
        CustomFlexRowColumn(
          childLeft: streamBuilderDropdownOrganizations(
              context,
              selectedOrganization,
              widget.organizer.organizationId!,
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
        _organizerText != ""
            ? CustomFlexRowColumn(
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
        )
            : Container(),
        CustomFlexRowColumn(
          childLeft: customTextFormFieldNotValidator(
              context, _link!, StringConst.FORM_LINK, linkSetState),
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


  void nameSetState(String? val) {
    setState(() {
      _resourceTitle = val!;
    });
  }

  void descriptionSetState(String? val) {
    setState(() {
      _resourceDescription = val!;
    });
  }

  void buildResourceTypeStreamBuilderSetState(ResourceType? resourceType) {
    setState(() {
      selectedResourceType = resourceType;
      _resourceTypeName = resourceType != null ? resourceType.name : "";
      resourceTypeId = resourceType?.resourceTypeId;
    });
  }

  void buildResourceCategoryStreamBuilderSetState(
      ResourceCategory? resourceCategory) {
    setState(() {
      selectedResourceCategory = resourceCategory;
      _resourceCategoryName =
      resourceCategory != null ? resourceCategory.name : "";
      resourceCategoryId = resourceCategory?.id;
    });
    resourceCategoryValue = resourceCategory?.order;
  }

  void buildDegreeStreamBuilderSetState(String? degree) {
    setState(() {
      _degree = degree;
    });
  }

  void buildContractStreamBuilderSetState(String? contract) {
    setState(() {
      _contractType = contract;
    });
  }

  void buildSalaryStreamBuilderSetState(String? salary) {
    setState(() {
      _salary = salary;
    });
  }


  void buildCountryStreamBuilderSetState(Country? country) {
    setState(() {
      selectedProvince = null;
      selectedCity = null;
      selectedCountry = country;
      _countryName = country != null ? country.name : "";
    });
    _countryId = country?.countryId;
  }

  void buildProvinceStreamBuilderSetState(Province? province) {
    setState(() {
      selectedCity = null;
      selectedProvince = province;
      _provinceName = province != null ? province.name : "";
    });
    _provinceId = province?.provinceId;
  }

  void buildCityStreamBuilderSetState(City? city) {
    setState(() {
      selectedCity = city;
      _cityName = city != null ? city.name : "";
    });
    _cityId = city?.cityId;
  }

  void buildOrganizationStreamBuilderSetState(Organization? organization) {
    setState(() {
      selectedOrganization = organization;
      organizationName = organization != null ? organization.name : "";
      organizationId = organization?.organizationId;
    });
  }



  void buildModalityStreamBuilderSetState(String? modality) {
    setState(() {
      _modality = modality;
    });
  }

  void durationSetState(String? val) {
    setState(() {
      _duration = val!;
    });
  }

  void scheduleSetState(String? val) {
    setState(() {
      _temporality = val!;
    });
  }

  void placeSetState(String? val) {
    setState(() => _place = val!);
  }

  void capacitySetState(String? val) {
    setState(() => _capacity = int.parse(val!));
  }

  void addressSetState(String? val) {
    setState(() => _street = val!);
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
        return streamBuilderDropdownInterests(context, interests, selectedInterests, resource);
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
          isActive: currentStep == 0,
          state: currentStep == 0 ? StepState.complete : StepState.indexed,
          title: Text(StringConst.FORM_EDIT.toUpperCase()),
          content: _buildForm(context),
        ),
      ];

  onStepContinue() async {
    if (currentStep == 0 && !_validateAndSaveForm()) {
      return;
    }
    _submit();
  }

  onStepCancel() {
    Navigator.of(context).pop();
    return true;
  }


  @override
  Widget build(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);
    return StreamBuilder<Resource>(
        stream: database.resourceStream(widget.resourceId),
        builder: (context, snapshotResource) {
          if (snapshotResource.hasData) {
            resource = snapshotResource.data!;
            _resourceId = resource.resourceId;
            _resourceTitle = resource.title;
            _duration = resource.duration ?? '';
            _temporality = resource.temporality ?? '';
            _resourceDescription = resource.description;
            _modality = resource.modality;
            _start = resource.start ?? DateTime.now();
            _end = resource.end ?? DateTime.now();
            _max = resource.maximumDate ?? DateTime.now();
            resourceTypeId = resource.resourceType ?? '';
            resourceCategoryId = resource.resourceCategory ?? '';
            interestsNames = "";
            organizationName = "";
            _contractType = resource.contractType ?? '';
            _salary = resource.salary ?? '';
            _degree = resource.degree ?? '';
            _place = resource.address?.place ?? '';
            _street = resource.street ?? '';
            _capacity = resource.capacity ?? 0;
            _countryId = resource.address?.country ?? '';
            _provinceId = resource.address?.province ?? '';
            _cityId = resource.address?.city ?? '';
            _countryName = "";
            _provinceName = "";
            _cityName = "";
            _organizerText = resource.promotor ?? '';
            _link = resource.link ?? '';
            _phone = resource.contactPhone ?? '';
            _email = resource.contactEmail ?? '';
            _resourcePictureId = resource.resourcePictureId ?? '';
            _notExpire = resource.notExpire ?? false;
            _createdate = resource.createdate;
            _organizer = resource.organizer;
            _organizerType = resource.organizerType ?? '';
            _resourceLink = resource.resourceLink ?? '';
            _participants = resource.participants ?? [];
            _assistants = resource.assistants ?? '';
            _status = resource.status ?? '';
            return _buildContent(context);
          } else {
            return Container();
          }
        });
  }

  Widget _buildContent(BuildContext context) {
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
                  child: Text(StringConst.FORM_EDIT.toUpperCase(),
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
                                    if (currentStep == 0)
                                      EnredaButton(
                                        buttonTitle: StringConst.CANCEL.toUpperCase(),
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
                                            buttonTitle: StringConst.FORM_UPDATE,
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
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )),
    );
  }
}
