import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:enreda_empresas/app/common_widgets/alert_dialog.dart';
import 'package:enreda_empresas/app/common_widgets/enreda_button.dart';
import 'package:enreda_empresas/app/common_widgets/flex_row_column.dart';
import 'package:enreda_empresas/app/common_widgets/show_exception_alert_dialog.dart';
import 'package:enreda_empresas/app/common_widgets/text_form_field.dart';
import 'package:enreda_empresas/app/home/resources/validating_form_controls/checkbox_form.dart';
import 'package:enreda_empresas/app/home/resources/validating_form_controls/stream_builder_resource_category.dart';
import 'package:enreda_empresas/app/home/resources/validating_form_controls/stream_builder_resource_type.dart';
import 'package:enreda_empresas/app/models/addressUser.dart';
import 'package:enreda_empresas/app/models/city.dart';
import 'package:enreda_empresas/app/models/country.dart';
import 'package:enreda_empresas/app/models/resourceCategory.dart';
import 'package:enreda_empresas/app/models/province.dart';
import 'package:enreda_empresas/app/models/resourcetype.dart';
import 'package:enreda_empresas/app/models/timeSearching.dart';
import 'package:enreda_empresas/app/services/database.dart';
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
  const ResourceCreationForm({Key? key}) : super(key: key);

  @override
  State<ResourceCreationForm> createState() => _ResourceCreationFormState();
}

class _ResourceCreationFormState extends State<ResourceCreationForm> {
  final _formKey = GlobalKey<FormState>();
  final _formKeyMotivations = GlobalKey<FormState>();
  final _formKeyInterests = GlobalKey<FormState>();
  final _checkFieldKey = GlobalKey<FormState>();
  bool isLoading = false;

  String? _email;
  String? _resourceTitle;
  String? _resourceDescription;
  DateTime? _birthday;
  String? _phone;
  String? _country;
  String? _province;
  String? _city;
  String? _postalCode;

  int? isRegistered;
  int usersIds = 0;
  int currentStep = 0;
  bool _isChecked = false;

  List<String> countries = [];
  List<String> provinces = [];
  List<String> cities = [];
  List abilities = [];
  List<String> interests = [];
  List<String> specificInterests = [];
  // Set<Ability> selectedAbilities = {};
  // Set<Interest> selectedInterests = {};
  // Set<SpecificInterest> selectedSpecificInterests = {};

  String writtenEmail = '';
  Country? selectedCountry;
  Province? selectedProvince;
  City? selectedCity;
  //Ability? selectedAbility;
  ResourceCategory? selectedResourceCategory;
  TimeSearching? selectedTimeSearching;
  // TimeSpentWeekly? selectedTimeSpentWeekly;
  // Education? selectedEducation;
  ResourceType? selectedResourceType;
  late String countryName;
  late String provinceName;
  late String cityName;
  String phoneCode = '+34';
  late String _formattedBirthdayDate;

  late String abilitesNames;
  late String resourceCategoryName;
  late String timeSearchingName;
  late String timeSpentWeeklyName;
  late String educationName;
  late String resourceTypeName;
  late String interestsNames;
  late String specificInterestsNames;
  String? _abilityId;
  String? _interestId;
  int? resourceCategoryValue;
  String? resourceCategoryId;
  int? timeSearchingValue;
  String? timeSearchingId;
  int? timeSpentWeeklyValue;
  String? timeSpentWeeklyId;
  String? educationValue;
  String? unemployedType;

  TextEditingController textEditingControllerDateInput = TextEditingController();
  TextEditingController textEditingControllerAbilities = TextEditingController();
  TextEditingController textEditingControllerInterests = TextEditingController();
  TextEditingController textEditingControllerSpecificInterests = TextEditingController();

  int sum = 0;

  @override
  void initState() {
    super.initState();
    _email = "";
    _resourceTitle = "";
    _resourceDescription = "";
    _birthday = DateTime.now();
    textEditingControllerDateInput.text = "";
    _phone = "";
    _country = "";
    _province = "";
    _city = "";
    _postalCode = "";
    countryName = "";
    provinceName = "";
    cityName = "";
    abilitesNames = "";
    resourceCategoryName = "";
    timeSearchingName = "";
    timeSpentWeeklyName = "";
    educationName = "";
    resourceTypeName = "";
    interestsNames = "";
    specificInterestsNames = "";
    unemployedType = "";
  }

  bool _validateAndSaveForm() {
    final form = _formKey.currentState;
    if (form!.validate() && isRegistered == 0) {
      form.save();
      return true;
    }
    return false;
  }

  bool _validateAndSaveMotivationForm() {
    final form = _formKeyMotivations.currentState;
    if (form!.validate()) {
      form.save();
      setState(() {
        sum = resourceCategoryValue! + timeSearchingValue! + timeSpentWeeklyValue!;
      });
      return true;
    }
    return false;
  }

  bool _validateAndSaveInterestsForm() {
    final form = _formKeyInterests.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  bool _validateCheckField() {
    final checkKey = _checkFieldKey.currentState;
    if (checkKey!.validate() && isRegistered == 0) {
      checkKey.save();
      return true;
    }
    return false;
  }

  Future<void> _submit() async {
    if (_validateCheckField()) {

      final address = Address(
        country: _country,
        province: _province,
        city: _city,
        postalCode: _postalCode,
      );

      final ResourceCategory resourceCategory = ResourceCategory(
          name: resourceCategoryName,
          order: resourceCategoryValue!,
          id: resourceCategoryId!,
      );

      final TimeSearching timeSearching = TimeSearching(
        label: timeSearchingName,
        value: timeSearchingValue!,
      );

      // final TimeSpentWeekly? timeSpentWeekly = TimeSpentWeekly(
      //     label: timeSpentWeeklyName,
      //     value: timeSearchingValue!
      // );
      //
      // final motivation = Motivation(
      //   abilities: abilities,
      //   resourceCategory: resourceCategory,
      //   timeSearching: timeSearching,
      //   timeSpentWeekly: timeSpentWeekly,
      // );
      //
      // final education = Education(
      //     label: educationName,
      //     value: educationValue!,
      //     order: 0
      // );
      //
      // final interestsSet = Interests(
      //   interests: interests,
      //   specificInterests: specificInterests,
      // );

      if(sum >= 0 && sum <= 3)
        setState(() {
          unemployedType = 'T1';
        });
      if(sum >= 4 && sum <= 6)
        setState(() {
          unemployedType = 'T2';
        });
      if(sum >= 7 && sum <= 9)
        setState(() {
          unemployedType = 'T3';
        });
      if(sum > 9)
        setState(() {
          unemployedType = 'T4';
        });

      // final create_resource_form = UnemployedUser(
      //     firstName: _resourceTitle,
      //     lastName: _resourceDescription,
      //     email: _email,
      //     phone: _phone,
      //     gender: genderName,
      //     birthday: _birthday,
      //     motivation: motivation,
      //     interests: interestsSet,
      //     education: education,
      //     address: address,
      //     role: 'Desempleado',
      //     unemployedType: unemployedType
      // );
      try {
        final database = Provider.of<Database>(context, listen: false);
        setState(() => isLoading = true);
        //await database.addUnemployedUser(create_resource_form);
        setState(() => isLoading = false);
        showAlertDialog(
          context,
          title: StringConst.FORM_SUCCESS,
          content: StringConst.FORM_SUCCESS_MAIL,
          defaultActionText: StringConst.FORM_ACCEPT,
        ).then((value) => {
          // Navigator.of(this.context).push(
          //   MaterialPageRoute<void>(
          //     builder: ((context) => EmailSignInPage()),
          //   ),
          // )
        },
        );
      } on FirebaseException catch (e) {
        showExceptionAlertDialog(context,
            title: StringConst.FORM_ERROR, exception: e).then((value) => Navigator.pop(context));
      }
    }
  }

  void _onCountryChange(CountryCode countryCode) {
    phoneCode =  countryCode.toString();
  }

  /*
    Avoid call to database if email not properly written.
    Return empty stream if email not properly written
  */

  Widget _buildForm(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);
    TextTheme textTheme = Theme.of(context).textTheme;
    double fontSize = responsiveSize(context, 14, 16, md: 15);
    return
      Form(
        key: _formKey,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget> [
              CustomFlexRowColumn(
                childLeft: customTextFormFieldName(context, _resourceTitle!, StringConst.FORM_TITLE, StringConst.NAME_ERROR, _name_setState),
                childRight: customTextFormFieldName(context, _resourceDescription!, StringConst.DESCRIPTION, StringConst.FORM_LASTNAME_ERROR, _description_setState),
              ),
              CustomFlexRowColumn(
                childLeft: streamBuilderDropdownResourceType(context, selectedResourceType, buildResourceTypeStreamBuilderSetState),
                childRight: streamBuilderDropdownResourceCategory(context, selectedResourceCategory, buildResourceCategoryStreamBuilderSetState),
              ),
              // CustomFlexRowColumn(
              //     childLeft: childLeft,
              //     childRight: childRight
              // ),
              // Flex(
              //   direction: Responsive.isMobile(context) ? Axis.vertical : Axis.horizontal,
              //   children: [
              //     Expanded(
              //       flex: Responsive.isMobile(context) ? 0 : 1,
              //       child: Padding(
              //         padding: const EdgeInsets.all(Sizes.kDefaultPaddingDouble / 2),
              //         child: TextFormField(
              //           decoration: InputDecoration(
              //             labelText: StringConst.FORM_PHONE,
              //             prefixIcon:CountryCodePicker(
              //               onChanged: _onCountryChange,
              //               initialSelection: 'ES',
              //               countryFilter: const ['ES', 'PE', 'GT'],
              //               showFlagDialog: true,
              //             ),
              //             focusColor: AppColors.turquoise,
              //             labelStyle: textTheme.button?.copyWith(
              //               height: 1.5,
              //               color: AppColors.greyDark,
              //               fontWeight: FontWeight.w400,
              //               fontSize: fontSize,
              //             ),
              //             focusedBorder: OutlineInputBorder(
              //               borderRadius: BorderRadius.circular(5.0),
              //               borderSide: const BorderSide(
              //                 color: AppColors.greyUltraLight,
              //               ),
              //             ),
              //             enabledBorder: OutlineInputBorder(
              //               borderRadius: BorderRadius.circular(5.0),
              //               borderSide: const BorderSide(
              //                 color: AppColors.greyUltraLight,
              //                 width: 1.0,
              //               ),
              //             ),
              //           ),
              //           initialValue: _phone,
              //           validator: (value) =>
              //           value!.isNotEmpty ? null : StringConst.PHONE_ERROR,
              //           onSaved: (value) => _phone = phoneCode +' '+ value!,
              //           textCapitalization: TextCapitalization.sentences,
              //           keyboardType: TextInputType.phone,
              //           style: textTheme.button?.copyWith(
              //             height: 1.5,
              //             color: AppColors.greyDark,
              //             fontWeight: FontWeight.w400,
              //             fontSize: fontSize,
              //           ),
              //           inputFormatters: <TextInputFormatter>[
              //             FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
              //           ],
              //         ),
              //       ),
              //     ),
              //     Expanded(
              //         flex: Responsive.isMobile(context) ? 0 : 1,
              //         child: Padding(
              //           padding: const EdgeInsets.all(Sizes.kDefaultPaddingDouble / 2),
              //           child: TextFormField(
              //             controller: textEditingControllerDateInput, //editing controller of this TextField
              //             validator: (value) => value!.isNotEmpty ? null : StringConst.FORM_START_ERROR,
              //             decoration: InputDecoration(
              //               prefixIcon: const Icon(Icons.calendar_today), //icon of text field
              //               labelText: StringConst.FORM_START, //label text of field
              //               labelStyle: textTheme.button?.copyWith(
              //                 height: 1.5,
              //                 color: AppColors.greyDark,
              //                 fontWeight: FontWeight.w400,
              //                 fontSize: fontSize,
              //               ),
              //               focusedBorder: OutlineInputBorder(
              //                 borderRadius: BorderRadius.circular(5.0),
              //                 borderSide: const BorderSide(
              //                   color: AppColors.greyUltraLight,
              //                 ),
              //               ),
              //               enabledBorder: OutlineInputBorder(
              //                 borderRadius: BorderRadius.circular(5.0),
              //                 borderSide: const BorderSide(
              //                   color: AppColors.greyUltraLight,
              //                   width: 1.0,
              //                 ),
              //               ),
              //             ),
              //             readOnly: true,  //set it true, so that user will not able to edit text
              //             style: textTheme.button?.copyWith(
              //               height: 1.5,
              //               color: AppColors.greyDark,
              //               fontWeight: FontWeight.w400,
              //               fontSize: fontSize,
              //             ),
              //             onTap: () async {
              //               DateTime? pickedDate = await showDatePicker(
              //                 context: context,
              //                 initialDate: DateTime(DateTime.now().year - 16, DateTime.now().month, DateTime.now().day),
              //                 firstDate: DateTime(DateTime.now().year - 100, DateTime.now().month, DateTime.now().day),
              //                 lastDate: DateTime(DateTime.now().year - 16, DateTime.now().month, DateTime.now().day),
              //               );
              //               if(pickedDate != null ){
              //                 print(pickedDate);  //pickedDate output format => 2021-03-10 00:00:00.000
              //                 _formattedBirthdayDate = DateFormat('dd-MM-yyyy').format(pickedDate);
              //                 print(_formattedBirthdayDate); //formatted date output using intl package =>  2021-03-16
              //                 setState(() {
              //                   textEditingControllerDateInput.text = _formattedBirthdayDate; //set output date to TextField value.
              //                   _birthday = pickedDate;
              //                 });
              //               }
              //             },
              //           ),
              //         )
              //     ),
              //   ],
              // ),
              // CustomFlexRowColumn(
              //   childLeft: streamBuilderForCountry(context, selectedCountry, _buildCountryStreamBuilder_setState),
              //   childRight: streamBuilderForProvince(context, selectedCountry, selectedProvince, _buildProvinceStreamBuilder_setState),
              // ),
              // CustomFlexRowColumn(
              //   childLeft: streamBuilderForCity(context, selectedCountry, selectedProvince, selectedCity, _buildCityStreamBuilder_setState),
              //   childRight: customTextFormFieldName(context, _postalCode!, StringConst.FORM_POSTAL_CODE, StringConst.POSTAL_CODE_ERROR, _postalCode_setState),
              // ),
            ]),
      );
  }

  // Widget _buildFormMotivations(BuildContext context) {
  //   TextTheme textTheme = Theme.of(context).textTheme;
  //   double fontSize = responsiveSize(context, 14, 16, md: 15);
  //   return
  //     Form(
  //       key: _formKeyMotivations,
  //       child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: <Widget> [
  //             CustomPadding(child: streamBuilderDropdownDedication(context, selectedDedication, _buildDedicationStreamBuilder_setState)),
  //             CustomPadding(child: streamBuilderDropdownTimeSearching(context, selectedTimeSearching, _buildTimeSearchingStreamBuilder_setState)),
  //             CustomPadding(child: streamBuilderDropdownTimeSpentWeekly(context, selectedTimeSpentWeekly, _buildTimeSpentWeeklyStreamBuilder_setState)),
  //             CustomPadding(
  //               child: TextFormField(
  //                 controller: textEditingControllerAbilities,
  //                 decoration: InputDecoration(
  //                   hintText: StringConst.FORM_ABILITIES,
  //                   hintMaxLines: 2,
  //                   labelStyle: textTheme.button?.copyWith(
  //                     color: AppColors.greyDark,
  //                     height: 1.5,
  //                     fontWeight: FontWeight.w400,
  //                     fontSize: fontSize,
  //                   ),
  //                   focusedBorder: OutlineInputBorder(
  //                     borderRadius: BorderRadius.circular(5.0),
  //                     borderSide: const BorderSide(
  //                       color: AppColors.greyUltraLight,
  //                     ),
  //                   ),
  //                   enabledBorder: OutlineInputBorder(
  //                     borderRadius: BorderRadius.circular(5.0),
  //                     borderSide: const BorderSide(
  //                       color: AppColors.greyUltraLight,
  //                       width: 1.0,
  //                     ),
  //                   ),
  //                 ),
  //                 onTap: () => {_showMultiSelectAbilities(context) },
  //                 validator: (value) => value!.isNotEmpty ?
  //                 null : StringConst.FORM_MOTIVATION_ERROR,
  //                 onSaved: (value) => value = _abilityId,
  //                 maxLines: 2,
  //                 readOnly: true,
  //                 style: textTheme.button?.copyWith(
  //                   height: 1.5,
  //                   color: AppColors.greyDark,
  //                   fontWeight: FontWeight.w400,
  //                   fontSize: fontSize,
  //                 ),
  //               ), ),
  //             CustomPadding(child: streamBuilderDropdownEducation(context, selectedEducation, _buildEducationStreamBuilder_setState)),
  //           ]),
  //     );
  // }

  Widget _buildFormInterests(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    double fontSize = responsiveSize(context, 14, 16, md: 15);
    return
      Form(
        key: _formKeyInterests,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget> [
              Padding(
                padding: const EdgeInsets.all(Sizes.kDefaultPaddingDouble / 2),
                child: TextFormField(
                  controller: textEditingControllerInterests,
                  decoration: InputDecoration(
                    hintText: StringConst.FORM_INTERESTS_QUESTION,
                    hintMaxLines: 2,
                    labelStyle: textTheme.bodyText1?.copyWith(
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
                  //onTap: () => {_showMultiSelectInterests(context) },
                  onTap: () => {},
                  validator: (value) => value!.isNotEmpty ?
                  null : StringConst.FORM_MOTIVATION_ERROR,
                  onSaved: (value) => value = _interestId,
                  maxLines: 2,
                  readOnly: true,
                  style: textTheme.button?.copyWith(
                    height: 1.5,
                    color: AppColors.greyDark,
                    fontWeight: FontWeight.w400,
                    fontSize: fontSize,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(Sizes.kDefaultPaddingDouble / 2),
                child: TextFormField(
                  controller: textEditingControllerSpecificInterests,
                  decoration: InputDecoration(
                    labelText: StringConst.FORM_SPECIFIC_INTERESTS,
                    labelStyle: textTheme.button?.copyWith(
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
                  //onTap: () => {_showMultiSelectSpecificInterests(context) },
                  onTap: () => {},
                  validator: (value) => value!.isNotEmpty ?
                  null : StringConst.FORM_MOTIVATION_ERROR,
                  onSaved: (value) => value = _interestId,
                  maxLines: 2,
                  readOnly: true,
                  style: textTheme.button?.copyWith(
                    height: 1.5,
                    color: AppColors.greyDark,
                    fontWeight: FontWeight.w400,
                    fontSize: fontSize,
                  ),
                ),
              ),
            ]),
      );
  }

  Widget _revisionForm(BuildContext context) {
    return Column(
      children: [
        ResourceRevisionForm(
          context,
          _resourceTitle!,
          _resourceDescription!,
          _email!,
          resourceTypeName,
          countryName,
          provinceName,
          cityName,
          _postalCode!,
          abilitesNames,
          resourceCategoryName,
          timeSearchingName,
          timeSpentWeeklyName,
          educationName,
          specificInterestsNames,
          interestsNames,
        ),
        checkboxForm(context, _checkFieldKey, _isChecked, functionSetState)
      ],
    );
  }

  void functionSetState(bool? val) {
    setState(() {
      _isChecked = val!;
    });
  }

  void _buildCountryStreamBuilder_setState(Country? country) {
    setState(() {
      selectedProvince = null;
      selectedCity = null;
      selectedCountry = country;
      countryName = country != null ? country.name : "";
    });
    _country = country?.countryId;
  }

  void _buildProvinceStreamBuilder_setState(Province? province) {
    setState(() {
      selectedCity = null;
      selectedProvince = province;
      provinceName = province != null ? province.name : "";
    });
    _province = province?.provinceId;
  }

  void _buildCityStreamBuilder_setState(City? city) {
    setState(() {
      selectedCity = city;
      cityName = city != null ? city.name : "";
    });
    _city = city?.cityId;
  }

  void buildResourceCategoryStreamBuilderSetState(ResourceCategory? resourceCategory) {
    setState(() {
      selectedResourceCategory = resourceCategory;
      resourceCategoryName = resourceCategory != null ? resourceCategory.name : "";
      resourceCategoryId = resourceCategory?.id;
    });
    resourceCategoryValue = resourceCategory?.order;
  }

  void _buildTimeSearchingStreamBuilder_setState(TimeSearching? timeSearching) {
    setState(() {
      selectedTimeSearching = timeSearching;
      timeSearchingName = timeSearching != null ? timeSearching.label : "";
      timeSearchingId = timeSearching?.timeSearchingId;
    });
    timeSearchingValue = timeSearching?.value;
  }

  // void _buildTimeSpentWeeklyStreamBuilder_setState(TimeSpentWeekly? timeSpentWeekly) {
  //   setState(() {
  //     this.selectedTimeSpentWeekly = timeSpentWeekly;
  //     timeSpentWeeklyName = timeSpentWeekly != null ? timeSpentWeekly.label : "";
  //     timeSpentWeeklyId = timeSpentWeekly?.timeSpentWeeklyId;
  //   });
  //   timeSpentWeeklyValue = timeSpentWeekly?.value;
  // }
  //
  // void _buildEducationStreamBuilder_setState(Education? education) {
  //   setState(() {
  //     this.selectedEducation = education;
  //     educationName = (education != null ? education.label : "");
  //   });
  //   educationValue = education?.value;
  // }
  //
  void buildResourceTypeStreamBuilderSetState(ResourceType? resourceType) {
    setState(() {
      selectedResourceType = resourceType;
      resourceTypeName = resourceType != null ? resourceType.name : "";
    });
  }

  void _name_setState(String? val) {
    setState(() => _resourceTitle = val!);
  }

  void _description_setState(String? val) {
    setState(() => _resourceDescription = val!);
  }

  void _postalCode_setState(String? val) {
    setState(() => _postalCode = val!);
  }

  // void _showMultiSelectAbilities(BuildContext context) async {
  //   final selectedValues = await showDialog<Set<Ability>>(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return streamBuilderDropdownAbilities(context, selectedAbilities);
  //     },
  //   );
  //   print(selectedValues);
  //   getValuesFromKeyAbilities(selectedValues);
  // }

  void getValuesFromKeyAbilities (selectedValues) {
    var concatenate = StringBuffer();
    var abilitiesIds = [];
    selectedValues.forEach((item){
      concatenate.write(item.name +' / ');
      abilitiesIds.add(item.abilityId);
    });
    setState(() {
      abilitesNames = concatenate.toString();
      textEditingControllerAbilities.text = concatenate.toString();
      abilities = abilitiesIds;
      //this.selectedAbilities = selectedValues;
    });
    print(abilitesNames);
    print(abilitiesIds);
  }

  // void _showMultiSelectInterests(BuildContext context) async {
  //   final selectedValues = await showDialog<Set<Interest>>(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return streamBuilderDropdownInterests(context, selectedInterests);
  //     },
  //   );
  //   print(selectedValues);
  //   getValuesFromKeyInterests(selectedValues);
  // }

  void getValuesFromKeyInterests (selectedValues) {
    var concatenate = StringBuffer();
    List<String> interestsIds = [];
    selectedValues.forEach((item){
      concatenate.write(item.name +' / ');
      interestsIds.add(item.interestId);
    });
    setState(() {
      interestsNames = concatenate.toString();
      textEditingControllerInterests.text = concatenate.toString();
      interests = interestsIds;
      //this.selectedInterests = selectedValues;
    });
    print(interestsNames);
    print(interestsIds);
  }

  // void _showMultiSelectSpecificInterests(BuildContext context) async {
  //   final selectedValues = await showDialog<Set<SpecificInterest>>(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return streamBuilderDropdownSpecificInterests(context, selectedInterests, selectedSpecificInterests);
  //     },
  //   );
  //   print(selectedValues);
  //   getValuesFromKeySpecificInterests(selectedValues);
  // }

  void getValuesFromKeySpecificInterests (selectedValues) {
    var concatenate = StringBuffer();
    List<String> specificInterestsIds = [];
    selectedValues.forEach((item){
      concatenate.write(item.name +' / ');
      specificInterestsIds.add(item.specificInterestId);
    });
    setState(() {
      specificInterestsNames = concatenate.toString();
      textEditingControllerSpecificInterests.text = concatenate.toString();
      specificInterests = specificInterestsIds;
      //this.selectedSpecificInterests = selectedValues;
    });
    print(interestsNames);
    print(specificInterestsIds);
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
      title: Text(StringConst.FORM_MOTIVATION.toUpperCase()),
      //content: _buildFormMotivations(context),
      content: Container(),
    ),
    Step(
      isActive: currentStep >= 2,
      state: currentStep > 2 ? StepState.complete : StepState.disabled,
      title: Text(StringConst.FORM_INTERESTS.toUpperCase()),
      content: _buildFormInterests(context),
    ),
    Step(
      isActive: currentStep >= 3,
      title: Text(StringConst.FORM_REVISION.toUpperCase()),
      content: _revisionForm(context),
    ),
  ];


  onStepContinue() async {
    // If invalid form, just return
    if (currentStep == 0 && !_validateAndSaveForm())
      return;

    if (currentStep == 1 && !_validateAndSaveMotivationForm())
      return;

    if (currentStep == 2 && !_validateAndSaveInterestsForm())
      return;

    // If not last step, advance and return
    final isLastStep = currentStep == getSteps().length-1;
    if (!isLastStep) {
      setState(() => {
        if(currentStep == 1 && sum >= 0 && sum <= 6 ) {
          currentStep += 2
        }
        else {
          currentStep += 1
        }
      });
      return;
    }
    _submit();
  }

  goToStep(int step){
      setState(() => currentStep = step);
  }

  onStepCancel() {
    if (currentStep > 0)
      goToStep(currentStep - 1);
  }

  @override
  Widget build(BuildContext context) {
    final isLastStep = currentStep == getSteps().length-1;
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
                Responsive.isMobile(context) ? Container() : Padding(
                  padding: EdgeInsets.all(Sizes.mainPadding),
                  child: Image.asset(
                    ImagePath.LOGO,
                    height: Sizes.HEIGHT_24,
                  ),
                ),
                Responsive.isMobile(context) ? Container() : SizedBox(width: Sizes.mainPadding),
                Container(
                  padding: const EdgeInsets.all(Sizes.kDefaultPaddingDouble / 2), child: Text(StringConst.FORM_CREATE.toUpperCase(),
                    style: const TextStyle(color: AppColors.greyDark)),)
              ],
            ),
          ),
          body: Stack(
            children: [
              Center(
                child: Stack(
                  children: [
                    Container(
                      height: Responsive.isMobile(context) || Responsive.isTablet(context) ? MediaQuery.of(context).size.height : MediaQuery.of(context).size.height * 0.70,
                      width: Responsive.isMobile(context) || Responsive.isTablet(context) ? MediaQuery.of(context).size.width : MediaQuery.of(context).size.width * 0.70,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(Sizes.kDefaultPaddingDouble / 2),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 2,
                            blurRadius: 2,
                            offset: const Offset(0, 2), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          Stepper(
                            type: Responsive.isMobile(context) ? StepperType.vertical : StepperType.horizontal,
                            steps: getSteps(),
                            currentStep: currentStep,
                            onStepContinue: onStepContinue,
                            onStepTapped: (step) => goToStep(step),
                            onStepCancel: onStepCancel,
                            controlsBuilder: (context, _) {
                              return Container(
                                height: Sizes.kDefaultPaddingDouble * 2,
                                margin: EdgeInsets.only(top: Sizes.kDefaultPaddingDouble * 2),
                                padding: const EdgeInsets.symmetric(horizontal: Sizes.kDefaultPaddingDouble / 2),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    if(currentStep !=0)
                                      EnredaButton(
                                        buttonTitle: StringConst.FORM_BACK,
                                        width: contactBtnWidth,
                                        onPressed: onStepCancel,
                                      ),
                                    SizedBox(width: Sizes.kDefaultPaddingDouble),
                                    isLoading ? const Center(child: CircularProgressIndicator(color: AppColors.primary300,)) :
                                    EnredaButton(
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
                          ),
                          Responsive.isTablet(context) || Responsive.isMobile(context) ?
                          Positioned(
                            top: screenHeight * 0.45,
                            left: -10,
                            child: Container(
                              height: 300 * 0.50,
                              child: ClipRRect(
                                child: Image.asset(ImagePath.CHICA_LATERAL),
                              ),
                            ),
                          ) : Container(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Responsive.isTablet(context) || Responsive.isMobile(context) ? Container() :
              Positioned(
                top: screenHeight * 0.51,
                left: Responsive.isDesktopS(context) ? screenWidth * 0.06 : screenWidth * 0.09,
                child: Container(
                  height: 300,
                  child: ClipRRect(
                    child: Image.asset(ImagePath.CHICA_LATERAL),
                  ),
                ),
              ),
            ],
          )
      ),
    );
  }
}