import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:email_validator/email_validator.dart';
import 'package:enreda_empresas/app/common_widgets/alert_dialog.dart';
import 'package:enreda_empresas/app/common_widgets/custom_date_picker_title.dart';
import 'package:enreda_empresas/app/common_widgets/custom_padding.dart';
import 'package:enreda_empresas/app/common_widgets/custom_phone_form_field_title.dart';
import 'package:enreda_empresas/app/common_widgets/custom_stepper.dart';
import 'package:enreda_empresas/app/common_widgets/custom_text_form_field_title.dart';
import 'package:enreda_empresas/app/common_widgets/enreda_button.dart';
import 'package:enreda_empresas/app/common_widgets/flex_row_column.dart';
import 'package:enreda_empresas/app/common_widgets/rounded_container.dart';
import 'package:enreda_empresas/app/common_widgets/show_exception_alert_dialog.dart';
import 'package:enreda_empresas/app/common_widgets/spaces.dart';
import 'package:enreda_empresas/app/home/participants/create_participant/validating_form_controls/checkbox_form.dart';
import 'package:enreda_empresas/app/home/participants/create_participant/validating_form_controls/chekbox_data_form.dart';
import 'package:enreda_empresas/app/home/participants/create_participant/validating_form_controls/stream_builder_abilities.dart';
import 'package:enreda_empresas/app/home/participants/create_participant/validating_form_controls/stream_builder_city.dart';
import 'package:enreda_empresas/app/home/participants/create_participant/validating_form_controls/stream_builder_country.dart';
import 'package:enreda_empresas/app/home/participants/create_participant/validating_form_controls/stream_builder_dedication.dart';
import 'package:enreda_empresas/app/home/participants/create_participant/validating_form_controls/stream_builder_education.dart';
import 'package:enreda_empresas/app/home/participants/create_participant/validating_form_controls/stream_builder_gender.dart';
import 'package:enreda_empresas/app/home/participants/create_participant/validating_form_controls/stream_builder_interests.dart';
import 'package:enreda_empresas/app/home/participants/create_participant/validating_form_controls/stream_builder_keepLearningOptions.dart';
import 'package:enreda_empresas/app/home/participants/create_participant/validating_form_controls/stream_builder_province.dart';
import 'package:enreda_empresas/app/home/participants/create_participant/validating_form_controls/stream_builder_specificInterests.dart';
import 'package:enreda_empresas/app/home/participants/create_participant/validating_form_controls/stream_builder_timeSearching.dart';
import 'package:enreda_empresas/app/home/participants/create_participant/validating_form_controls/stream_builder_timeSpentWeekly.dart';
import 'package:enreda_empresas/app/home/participants/create_participant/validating_form_controls/unemployed_revision_form.dart';
import 'package:enreda_empresas/app/home/web_home.dart';
import 'package:enreda_empresas/app/models/ability.dart';
import 'package:enreda_empresas/app/models/addressUser.dart';
import 'package:enreda_empresas/app/models/city.dart';
import 'package:enreda_empresas/app/models/country.dart';
import 'package:enreda_empresas/app/models/dedication.dart';
import 'package:enreda_empresas/app/models/education.dart';
import 'package:enreda_empresas/app/models/gender.dart';
import 'package:enreda_empresas/app/models/interest.dart';
import 'package:enreda_empresas/app/models/interests.dart';
import 'package:enreda_empresas/app/models/keepLearningOption.dart';
import 'package:enreda_empresas/app/models/province.dart';
import 'package:enreda_empresas/app/models/company.dart';
import 'package:enreda_empresas/app/models/specificinterest.dart';
import 'package:enreda_empresas/app/models/timeSearching.dart';
import 'package:enreda_empresas/app/models/timeSpentWeekly.dart';
import 'package:enreda_empresas/app/models/unemployedUser.dart';
import 'package:enreda_empresas/app/models/userEnreda.dart';
import 'package:enreda_empresas/app/services/auth.dart';
import 'package:enreda_empresas/app/services/database.dart';
import 'package:enreda_empresas/app/utils/adaptative.dart';
import 'package:enreda_empresas/app/utils/responsive.dart';
import 'package:enreda_empresas/app/values/strings.dart';
import 'package:enreda_empresas/app/values/values.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'validating_form_controls/stream_builder_nation.dart';
import 'validating_form_controls/stream_builder_social_entity.dart';
import 'package:enreda_empresas/app/home/resources/global.dart' as globals;

const double contactBtnWidthLg = 200.0;
const double contactBtnWidthSm = 120.0;
const double contactBtnWidthMd = 150.0;

class CreateParticipantPage extends StatefulWidget {
  const CreateParticipantPage({Key? key}) : super(key: key);

  @override
  _CreateParticipantPageState createState() => _CreateParticipantPageState();
}

class _CreateParticipantPageState extends State<CreateParticipantPage> {
  final _formKey = GlobalKey<FormState>();
  final _formKeyMotivations = GlobalKey<FormState>();
  final _formKeyInterests = GlobalKey<FormState>();
  final _checkFieldKey = GlobalKey<FormState>();
  final _checkFieldKeyDataProtectionPolicy = GlobalKey<FormState>();

  String? _email, _firstName, _lastName, _phone;
  DateTime? _birthday;
  String? _country, _province, _city, _postalCode;
  String? _belongOrganization;
  String? _nationality;

  int? isRegistered;
  int usersIds = 0;
  int currentStep = 0;
  bool _isChecked = false;
  bool _isCheckedDataProtectionPolicy = false;

  List<String> countries = [];
  List<String> provinces = [];
  List<String> cities = [];
  List abilities = [];
  List<String> interests = [];
  List<String> keepLearningOptions = [];
  List<String> specificInterests = [];
  Set<Ability> selectedAbilities = {};
  Set<Interest> selectedInterests = {};
  Set<KeepLearningOption> selectedKeepLearningOptions = {};
  Set<SpecificInterest> selectedSpecificInterests = {};

  String writtenEmail = '';
  Country? selectedCountry;
  String? selectedNationality;
  Province? selectedProvince;
  City? selectedCity;
  Ability? selectedAbility;
  Dedication? selectedDedication;
  String? futureLearning;
  TimeSearching? selectedTimeSearching;
  TimeSpentWeekly? selectedTimeSpentWeekly;
  Education? selectedEducation;
  Gender? selectedGender;
  Company? selectedSocialEntity;
  late String countryName, provinceName, cityName, nationalityName;
  String phoneCode = '+34';
  late String _formattedBirthdayDate;

  late String abilitesNames;
  late String dedicationName;
  late String timeSearchingName;
  late String timeSpentWeeklyName;
  late String educationName;
  late String genderName;
  late String interestsNames;
  late String keepLearningOptionsNames;
  late String specificInterestsNames;
  String? _abilityId;
  String? _interestId;
  String? _keepLearningOptionId;
  int? dedicationValue;
  String? dedicationId;
  int? timeSearchingValue;
  String? timeSearchingId;
  int? timeSpentWeeklyValue;
  String? timeSpentWeeklyId;
  String? educationValue;
  String? educationId;
  String? unemployedType;

  TextEditingController textEditingControllerDateInput = TextEditingController();
  TextEditingController textEditingControllerAbilities = TextEditingController();
  TextEditingController textEditingControllerInterests = TextEditingController();
  TextEditingController textEditingControllerKeepLearningOptions = TextEditingController();
  TextEditingController textEditingControllerSpecificInterests = TextEditingController();

  int sum = 0;

  late TextTheme textTheme;

  @override
  void initState() {
    super.initState();
    _email = "";
    _firstName = "";
    _lastName = "";
    _birthday = new DateTime.now();
    textEditingControllerDateInput.text = "";
    _phone = "";
    _country = "";
    _province = "";
    _city = "";
    _postalCode = "";
    _belongOrganization = "";
    countryName = "";
    provinceName = "";
    cityName = "";
    abilitesNames = "";
    dedicationName = "";
    timeSearchingName = "";
    timeSpentWeeklyName = "";
    educationName = "";
    educationId = "";
    genderName = "";
    interestsNames = "";
    specificInterestsNames = "";
    unemployedType = "";
    _nationality = '';
    nationalityName = '';
    keepLearningOptionsNames = '';
    selectedSocialEntity = globals.currentUserCompany;
  }

  @override
  Widget build(BuildContext context) {
    // sendBasicAnalyticsEvent(context, "enreda_app_visit_sign_in_page");
    textTheme = Theme.of(context).textTheme;
    final isLastStep = currentStep == getSteps().length-1;
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
                return CustomStepper(
                  elevation: 0.0,
                  type: constraints.maxWidth <= 650 ? CustomStepperType.vertical : CustomStepperType.horizontal,
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
                          if(currentStep !=0)
                            EnredaButton(
                              buttonTitle: StringConst.FORM_BACK,
                              width: contactBtnWidth,
                              onPressed: onStepCancel,
                            ),
                          SizedBox(width: Sizes.kDefaultPaddingDouble),
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
                );
              }
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);
    return Form(
      key: _formKey,
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget> [
            CustomFlexRowColumn(
              contentPadding: EdgeInsets.all(0.0),
              separatorSize: Sizes.kDefaultPaddingDouble,
              childLeft: CustomTextFormFieldTitle(
                  labelText: StringConst.FORM_NAME,
                  initialValue: _firstName!,
                  validator: (value) =>
                  value!.isNotEmpty ? null : StringConst.NAME_ERROR,
                  onSaved: _name_setState
              ),
              childRight: CustomTextFormFieldTitle(
                  labelText: StringConst.FORM_LASTNAME,
                  initialValue: _lastName!,
                  validator: (value) =>
                  value!.isNotEmpty ? null : StringConst.FORM_LASTNAME_ERROR,
                  onSaved: _surname_setState
              ),
            ),
              SpaceH20(),
              Flex(
                direction: Responsive.isMobile(context) ? Axis.vertical : Axis.horizontal,
                children: [
                  Expanded(
                      flex: Responsive.isMobile(context) ? 0 : 1,
                      child: CustomDatePickerTitleClosed(
                        labelText: StringConst.FORM_BIRTHDAY,
                        onChanged: (value){//pickedDate output format => 2021-03-10 00:00:00.000
                          _formattedBirthdayDate = DateFormat('dd-MM-yyyy').format(value!);
                          print(_formattedBirthdayDate); //formatted date output using intl package =>  2021-03-16
                          setState(() {
                            textEditingControllerDateInput.text = _formattedBirthdayDate; //set output date to TextField value.
                            _birthday = value;
                          });
                        },
                        validator: (value) => value != null ? null : StringConst.FORM_BIRTHDAY_ERROR,
                      ),
                  ),
                  if (Responsive.isMobile(context))
                    SpaceH20(),
                  if (!Responsive.isMobile(context))
                    SpaceW20(),
                  Expanded(
                    flex: Responsive.isMobile(context) ? 0 : 1,
                    child: streamBuilder_Dropdown_Genders(context, selectedGender, _buildGenderStreamBuilder_setState),
                  ),
                ],
              ),
              SpaceH20(),
              streamBuilderForNation(context, selectedNationality, _buildNationalityStreamBuilder_setState, 'Nacionalidad'),
              SpaceH20(),
              Flex(
                direction: Responsive.isMobile(context) ? Axis.vertical : Axis.horizontal,
                children: [
                  Expanded(
                    flex: Responsive.isMobile(context) ? 0 : 1,
                    child: CustomPhoneFormFieldTitle(
                      labelText: StringConst.FORM_PHONE,
                      phoneCode: phoneCode,
                      onCountryChange: _onCountryChange,
                      initialValue: _phone,
                      validator: (value) =>
                      value!.isNotEmpty ? null : StringConst.PHONE_ERROR,
                      onSaved: (value) => this._phone = phoneCode +' '+ value!,
                      fontSize: 15,
                    ),
                  ),
                  if (Responsive.isMobile(context))
                    SpaceH20(),
                  if (!Responsive.isMobile(context))
                    SpaceW20(),
                  Expanded(
                    flex: Responsive.isMobile(context) ? 0 : 1,
                    child: StreamBuilder <List<UserEnreda>>(
                        stream:
                        // Empty stream (no call to firestore) if email not valid
                        !EmailValidator.validate(writtenEmail)
                            ? Stream<List<UserEnreda>>.empty()
                            : database.checkIfUserEmailRegistered(writtenEmail),
                        builder:  (context, snapshotUsers) {

                          var usersListLength = snapshotUsers.data != null ? snapshotUsers.data?.length : 0;
                          isRegistered = usersListLength! > 0 ? 1 : 0;

                          final validationMessage = (value) => EmailValidator.validate(value!)
                              ? (isRegistered == 0 ? null : StringConst.EMAIL_REGISTERED)
                              : StringConst.EMAIL_ERROR;

                          return CustomTextFormFieldTitle(
                            labelText: StringConst.FORM_EMAIL,
                            initialValue: _email,
                            validator: validationMessage,
                            onSaved: (value) => _email = value,
                            keyboardType: TextInputType.emailAddress,
                            onChanged: (value) => setState(() => this.writtenEmail = value),
                          );
                        }
                    ),
                  ),
                ],
              ),
              SpaceH20(),
              CustomFlexRowColumn(
                contentPadding: EdgeInsets.all(0.0),
                separatorSize: Sizes.kDefaultPaddingDouble,
                childLeft: streamBuilderForCountry(context, selectedCountry, _buildCountryStreamBuilder_setState, StringConst.FORM_CURRENT_COUNTRY),
                childRight: streamBuilderForProvince(context, selectedCountry, selectedProvince, _buildProvinceStreamBuilder_setState),
              ),
              SpaceH20(),
              CustomFlexRowColumn(
                contentPadding: EdgeInsets.all(0.0),
                separatorSize: Sizes.kDefaultPaddingDouble,
                childLeft: streamBuilderForCity(context, selectedCountry, selectedProvince, selectedCity, _buildCityStreamBuilder_setState),
                childRight: CustomTextFormFieldTitle(
                    labelText: StringConst.FORM_POSTAL_CODE,
                    initialValue: _postalCode!,
                    onSaved: _postalCode_setState
                ),
              ),
              SpaceH20(),
              streamBuilderDropdownEducation(context, selectedEducation, _buildEducationStreamBuilder_setState),
              SpaceH20(),
              streamBuilderForSocialEntity(context, selectedSocialEntity, _buildSocialEntityStreamBuilder_setState),

            ]),
      );
  }

  Widget _buildFormMotivations(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    double fontSize = responsiveSize(context, 14, 16, md: 15);
    return
      Form(
        key: _formKeyMotivations,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget> [
              CustomPadding(child: streamBuilderDropdownDedication(context, selectedDedication, _buildDedicationStreamBuilder_setState)),
              CustomPadding(child: streamBuilderDropdownTimeSearching(context, selectedTimeSearching, _buildTimeSearchingStreamBuilder_setState)),
              CustomPadding(child: streamBuilderDropdownTimeSpentWeekly(context, selectedTimeSpentWeekly, _buildTimeSpentWeeklyStreamBuilder_setState)),
              CustomPadding(
                child: TextFormField(
                  controller: textEditingControllerAbilities,
                  decoration: InputDecoration(
                    hintText: StringConst.FORM_ABILITIES,
                    hintMaxLines: 2,
                    labelStyle: textTheme.bodySmall?.copyWith(
                      color: AppColors.greyDark,
                      height: 1.5,
                      fontWeight: FontWeight.w400,
                      fontSize: fontSize,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: BorderSide(
                        color: AppColors.greyUltraLight,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: BorderSide(
                        color: AppColors.greyUltraLight,
                        width: 1.0,
                      ),
                    ),
                  ),
                  onTap: () => {_showMultiSelectAbilities(context) },
                  validator: (value) => value!.isNotEmpty ?
                  null : StringConst.FORM_MOTIVATION_ERROR,
                  onSaved: (value) => value = _abilityId,
                  maxLines: 2,
                  readOnly: true,
                  style: textTheme.bodySmall?.copyWith(
                    height: 1.5,
                    color: AppColors.greyDark,
                    fontWeight: FontWeight.w400,
                    fontSize: fontSize,
                  ),
                ), ),
              CustomPadding(child: streamBuilderDropdownEducation(context, selectedEducation, _buildEducationStreamBuilder_setState)),
            ]),
      );
  }

  Widget _buildFormInterests(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    double fontSize = responsiveSize(context, 14, 16, md: 15);
    return
      Form(
        key: _formKeyInterests,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget> [
              CustomPadding(child: Container(
                height: 60,
                child: streamBuilderDropdownDedication(context, selectedDedication, _buildDedicationStreamBuilder_setState))),
              Padding(
                padding: const EdgeInsets.all(Sizes.kDefaultPaddingDouble / 2),
                child: Container(
                  height: 60,
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
                        borderSide: BorderSide(
                          color: AppColors.greyUltraLight,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: BorderSide(
                          color: AppColors.greyUltraLight,
                          width: 1.0,
                        ),
                      ),
                    ),
                    onTap: () => {_showMultiSelectInterests(context) },
                    validator: (value) => value!.isNotEmpty ?
                    null : StringConst.FORM_MOTIVATION_ERROR,
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
              ),
              Padding(
                padding: const EdgeInsets.all(Sizes.kDefaultPaddingDouble / 2),
                child: Container(
                  height: 60,
                  child: TextFormField(
                    controller: textEditingControllerSpecificInterests,
                    decoration: InputDecoration(
                      labelText: StringConst.FORM_SPECIFIC_INTERESTS,
                      labelStyle: textTheme.bodySmall?.copyWith(
                        color: AppColors.greyDark,
                        height: 1.5,
                        fontWeight: FontWeight.w400,
                        fontSize: fontSize,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: BorderSide(
                          color: AppColors.greyUltraLight,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: BorderSide(
                          color: AppColors.greyUltraLight,
                          width: 1.0,
                        ),
                      ),
                    ),
                    onTap: () => {_showMultiSelectSpecificInterests(context) },
                    validator: (value) => value!.isNotEmpty ?
                    null : StringConst.FORM_MOTIVATION_ERROR,
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
              ),
              Padding(
                padding: const EdgeInsets.all(Sizes.kDefaultPaddingDouble / 2),
                child: Container(
                  height: 60,
                  child: TextFormField(
                    controller: textEditingControllerKeepLearningOptions,
                    decoration: InputDecoration(
                      hintText: '¿Qué te gustaría seguir aprendiendo?',
                      hintMaxLines: 2,
                      labelStyle: textTheme.bodySmall?.copyWith(
                        color: AppColors.greyDark,
                        height: 1.5,
                        fontWeight: FontWeight.w400,
                        fontSize: fontSize,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: BorderSide(
                          color: AppColors.greyUltraLight,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: BorderSide(
                          color: AppColors.greyUltraLight,
                          width: 1.0,
                        ),
                      ),
                    ),
                    onTap: () => {_showMultiSelectKeepLearningOptions(context) },
                    validator: (value) => value!.isNotEmpty ?
                    null : StringConst.FORM_MOTIVATION_ERROR,
                    onSaved: (value) => value = _keepLearningOptionId,
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
              ),
            ]),
      );
  }

  Widget _revisionForm(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(ImagePath.LOGO_LINES),
          //fit: BoxFit.cover,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          RoundedContainer(
            width: Responsive.isMobile(context) ? MediaQuery.of(context).size.width : MediaQuery.of(context).size.width * 0.6,
            margin: Responsive.isMobile(context) ? EdgeInsets.all(0) : EdgeInsets.all(Sizes.kDefaultPaddingDouble),
            contentPadding: Responsive.isMobile(context) ? EdgeInsets.all(0) : EdgeInsets.all(Sizes.kDefaultPaddingDouble),
            borderColor: Responsive.isMobile(context) ? Colors.transparent : AppColors.greyLight,
            child: unemployedRevisionForm(
              context,
              _firstName!,
              _lastName!,
              _email!,
              _phone!,
              nationalityName,
              genderName,
              countryName,
              provinceName,
              cityName,
              _postalCode!,
              educationName,
              specificInterestsNames,
              interestsNames,
              keepLearningOptionsNames,
            ),
          ),
          Padding(
            padding: Responsive.isMobile(context) ? EdgeInsets.all(0) : const EdgeInsets.symmetric(horizontal: Sizes.kDefaultPaddingDouble * 2),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                checkboxForm(context, _checkFieldKey, _isChecked, functionSetState),
                checkboxDataForm(context, _checkFieldKeyDataProtectionPolicy, _isCheckedDataProtectionPolicy, functionDataSetState),
              ],
            ),
          )
        ],
      ),
    );
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
        sum = dedicationValue! + timeSearchingValue! + timeSpentWeeklyValue!;
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

  bool _validateCheckDataField() {
    final checkKeyData = _checkFieldKeyDataProtectionPolicy.currentState;
    if (checkKeyData!.validate() && isRegistered == 0) {
      checkKeyData.save();
      return true;
    }
    return false;
  }

  Future<void> _submit() async {
    bool checkFieldValid = _validateCheckField();
    bool checkDataFieldValid = _validateCheckDataField();

    if (checkFieldValid && checkDataFieldValid) {

      final database = Provider.of<Database>(context, listen: false);
      final auth = Provider.of<AuthBase>(context, listen: false);
      final user = await database.userEnredaStreamByUserId(auth.currentUser!.uid).first;


      final address = Address(
        country: _country,
        province: _province,
        city: _city,
        postalCode: _postalCode,
      );

      final Dedication? dedication = new Dedication(
          label: dedicationName,
          value: dedicationValue!
      );



      final education = Education(
          label: educationName,
          value: educationValue!,
          order: 0
      );

      final interestsSet = Interests(
        interests: interests,
        specificInterests: specificInterests,
        surePurpose: selectedDedication,
        continueLearning: keepLearningOptions,
      );

      if(sum >= 0 && sum <= 3)
        setState(() {
          this.unemployedType = 'T1';
        });
      if(sum >= 4 && sum <= 6)
        setState(() {
          this.unemployedType = 'T2';
        });
      if(sum >= 7 && sum <= 9)
        setState(() {
          this.unemployedType = 'T3';
        });
      if(sum > 9)
        setState(() {
          this.unemployedType = 'T4';
        });

      final unemployedUser = UnemployedUser(
          firstName: _firstName,
          lastName: _lastName,
          email: _email,
          phone: _phone,
          gender: genderName,
          birthday: _birthday,
          interests: interestsSet,
          educationId: educationId,
          address: address,
          role: 'Desempleado',
          unemployedType: unemployedType,
          nationality: selectedNationality,
          assignedEntityId: selectedSocialEntity!.companyId ?? null,
          assignedById: user.userId,
          checkAgreeCV: _isCheckedDataProtectionPolicy,
          belongOrganization: _belongOrganization,
          gamificationFlags: {
            UserEnreda.FLAG_SIGN_UP: true,
            UserEnreda.FLAG_PILL_WHAT_IS_ENREDA: true,
          },
      );
      try {
        final database = Provider.of<Database>(context, listen: false);
        await database.addUnemployedUser(unemployedUser);
        await showAlertDialog(
          context,
          title: StringConst.CREATE_PARTICIPANT_TITLE,
          content: StringConst.CREATE_PARTICIPANT_SUCCESS,
          defaultActionText: StringConst.FORM_ACCEPT,
        );
        WebHome.goToParticipants();
      } on FirebaseException catch (e) {
        showExceptionAlertDialog(context,
            title: StringConst.FORM_ERROR, exception: e).then((value) => Navigator.pop(context));
      }
    } else {
      if (!checkFieldValid) {
        showAlertDialog(
          context,
          title: 'Aviso',
          content: 'Para continuar debe aceptar las Políticas y Condiciones de uso.',
          defaultActionText: 'Aceptar',
        );
        return;
      }
      if (!checkDataFieldValid) {
        showAlertDialog(
          context,
          title: 'Aviso',
          content: 'Para continuar debe autorizar el uso de sus datos personales.',
          defaultActionText: 'Aceptar',
        );
        return;
      }
    }
  }

  void _onCountryChange(CountryCode countryCode) {
    this.phoneCode =  countryCode.toString();
  }

  void functionSetState(bool? val) {
    setState(() {
      _isChecked = val!;
    });
  }

  void functionDataSetState(bool? val) {
    setState(() {
      _isCheckedDataProtectionPolicy = val!;
    });
  }

  void _buildCountryStreamBuilder_setState(Country? country) {
    setState(() {
      this.selectedProvince = null;
      this.selectedCity = null;
      this.selectedCountry = country;
      countryName = country != null ? country.name : "";
    });
    _country = country?.countryId;
  }

  void _buildNationalityStreamBuilder_setState(String? country) {
    setState(() {
      this.selectedNationality = country;
      nationalityName = country != null ? country : "";
    });
    _nationality = country;
  }

  void _buildProvinceStreamBuilder_setState(Province? province) {
    setState(() {
      this.selectedCity = null;
      this.selectedProvince = province;
      provinceName = province != null ? province.name : "";
    });
    _province = province?.provinceId;
  }

  void _buildCityStreamBuilder_setState(City? city) {
    setState(() {
      this.selectedCity = city;
      cityName = city != null ? city.name : "";
    });
    _city = city?.cityId;
  }

  void _buildDedicationStreamBuilder_setState(Dedication? dedication) {
    setState(() {
      this.selectedDedication = dedication;
      dedicationName = dedication != null ? dedication.label : "";
      dedicationId = dedication?.dedicationId;
    });
    dedicationValue = dedication?.value;
  }

  void _buildTimeSearchingStreamBuilder_setState(TimeSearching? timeSearching) {
    setState(() {
      this.selectedTimeSearching = timeSearching;
      timeSearchingName = timeSearching != null ? timeSearching.label : "";
      timeSearchingId = timeSearching?.timeSearchingId;
    });
    timeSearchingValue = timeSearching?.value;
  }

  void _buildTimeSpentWeeklyStreamBuilder_setState(TimeSpentWeekly? timeSpentWeekly) {
    setState(() {
      this.selectedTimeSpentWeekly = timeSpentWeekly;
      timeSpentWeeklyName = timeSpentWeekly != null ? timeSpentWeekly.label : "";
      timeSpentWeeklyId = timeSpentWeekly?.timeSpentWeeklyId;
    });
    timeSpentWeeklyValue = timeSpentWeekly?.value;
  }

  void _buildEducationStreamBuilder_setState(Education? education) {
    setState(() {
      this.selectedEducation = education;
      educationName = (education != null ? education.label : "");
      educationId = education?.educationId;
    });
    educationValue = education?.value;
  }

  void _buildGenderStreamBuilder_setState(Gender? gender) {
    setState(() {
      this.selectedGender = gender;
      genderName = gender != null ? gender.name : "";
    });
  }

  void _name_setState(String? val) {
    setState(() => this._firstName = val!);
  }

  void _surname_setState(String? val) {
    setState(() => this._lastName = val!);
  }

  void _postalCode_setState(String? val) {
    setState(() => this._postalCode = val!);
  }

  void _buildSocialEntityStreamBuilder_setState(Company? socialEntity) {
    setState(() {
      this.selectedSocialEntity = socialEntity;
    });
  }

  void _showMultiSelectAbilities(BuildContext context) async {
    final selectedValues = await showDialog<Set<Ability>>(
      context: context,
      builder: (BuildContext context) {
        return streamBuilderDropdownAbilities(context, selectedAbilities);
      },
    );
    print(selectedValues);
    getValuesFromKeyAbilities(selectedValues);
  }

  void getValuesFromKeyAbilities (selectedValues) {
    var concatenate = StringBuffer();
    var abilitiesIds = [];
    selectedValues.forEach((item){
      concatenate.write(item.name +' / ');
      abilitiesIds.add(item.abilityId);
    });
    setState(() {
      this.abilitesNames = concatenate.toString();
      this.textEditingControllerAbilities.text = concatenate.toString();
      this.abilities = abilitiesIds;
      this.selectedAbilities = selectedValues;
    });
    print(abilitesNames);
    print(abilitiesIds);
  }

  void _showMultiSelectInterests(BuildContext context) async {
    final selectedValues = await showDialog<Set<Interest>>(
      context: context,
      builder: (BuildContext context) {
        return streamBuilderDropdownInterests(context, selectedInterests);
      },
    );
    print(selectedValues);
    getValuesFromKeyInterests(selectedValues);
  }

  void _showMultiSelectKeepLearningOptions(BuildContext context) async {
    final selectedOptions = await showDialog<Set<KeepLearningOption>>(
      context: context,
      builder: (BuildContext context) {
        return streamBuilderDropdownKeepLearningOptions(context, selectedKeepLearningOptions);
      },
    );
    print(selectedOptions);
    getValuesFromKeyKeepLearningOptions(selectedOptions);
  }

  void getValuesFromKeyInterests (selectedValues) {
    var concatenate = StringBuffer();
    List<String> interestsIds = [];
    selectedValues.forEach((item){
      concatenate.write(item.name +' / ');
      interestsIds.add(item.interestId);
    });
    setState(() {
      this.interestsNames = concatenate.toString();
      this.textEditingControllerInterests.text = concatenate.toString();
      this.interests = interestsIds;
      this.selectedInterests = selectedValues;
    });
    print(interestsNames);
    print(interestsIds);
  }

  void getValuesFromKeyKeepLearningOptions (selectedOptions) {
    var concatenate = StringBuffer();
    List<String> keepLearningIds = [];
    selectedOptions.forEach((item){
      concatenate.write(item.title +' / ');
      keepLearningIds.add(item.keepLearningOptionId);
    });
    setState(() {
      this.keepLearningOptionsNames = concatenate.toString();
      this.textEditingControllerKeepLearningOptions.text = concatenate.toString();
      this.keepLearningOptions = keepLearningIds;
      this.selectedKeepLearningOptions = selectedOptions;
    });
    print(keepLearningOptionsNames);
    print(keepLearningIds);
  }

  void _showMultiSelectSpecificInterests(BuildContext context) async {
    final selectedValues = await showDialog<Set<SpecificInterest>>(
      context: context,
      builder: (BuildContext context) {
        return streamBuilderDropdownSpecificInterests(context, selectedInterests, selectedSpecificInterests);
      },
    );
    print(selectedValues);
    getValuesFromKeySpecificInterests(selectedValues);
  }

  void getValuesFromKeySpecificInterests (selectedValues) {
    var concatenate = StringBuffer();
    List<String> specificInterestsIds = [];
    selectedValues.forEach((item){
      concatenate.write(item.name +' / ');
      specificInterestsIds.add(item.specificInterestId);
    });
    setState(() {
      this.specificInterestsNames = concatenate.toString();
      this.textEditingControllerSpecificInterests.text = concatenate.toString();
      this.specificInterests = specificInterestsIds;
      this.selectedSpecificInterests = selectedValues;
    });
    print(interestsNames);
    print(specificInterestsIds);
  }

  List<CustomStep> getSteps() => [
    CustomStep(
      isActive: currentStep >= 0,
      state: currentStep > 0 ? CustomStepState.complete : CustomStepState.indexed,
      title: Container(
        padding: EdgeInsets.all(Sizes.kDefaultPaddingDouble/2),
        decoration: BoxDecoration(
          color: currentStep >= 0? AppColors.yellow: AppColors.white,
          borderRadius: BorderRadius.circular(Sizes.kDefaultPaddingDouble*2),
          border: Border.all(color: AppColors.greyLight, width: 2.0,),
        ),
        child: Text(
          StringConst.FORM_GENERAL_INFO,
          style: textTheme.titleSmall!.copyWith(
            color: AppColors.turquoiseBlue
          ),
        ),
      ),
      content: _buildForm(context),
    ),

    CustomStep(
      isActive: currentStep >= 1,
      state: currentStep > 1 ? CustomStepState.complete : CustomStepState.disabled,
      title: Container(
        padding: EdgeInsets.all(Sizes.kDefaultPaddingDouble/2),
        decoration: BoxDecoration(
          color: currentStep >= 1? AppColors.yellow: AppColors.white,
          borderRadius: BorderRadius.circular(Sizes.kDefaultPaddingDouble*2),
          border: Border.all(color: AppColors.greyLight, width: 2.0,),
        ),
        child: Text(
          StringConst.FORM_INTERESTS,
          style: textTheme.titleSmall!.copyWith(
              color: AppColors.turquoiseBlue
          ),
        ),
      ),
      content: _buildFormInterests(context),
    ),
    CustomStep(
      isActive: currentStep >= 2,
      state: currentStep > 2 ? CustomStepState.complete : CustomStepState.disabled,
      title: Container(
        padding: EdgeInsets.all(Sizes.kDefaultPaddingDouble/2),
        decoration: BoxDecoration(
          color: currentStep >= 2? AppColors.yellow: AppColors.white,
          borderRadius: BorderRadius.circular(Sizes.kDefaultPaddingDouble*2),
          border: Border.all(color: AppColors.greyLight, width: 2.0,),
        ),
        child: Text(
          StringConst.FORM_REVISION,
          style: textTheme.titleSmall!.copyWith(
              color: AppColors.turquoiseBlue
          ),
        ),
      ),
      content: _revisionForm(context),
    ),
  ];

  onStepContinue() async {
    // If invalid form, just return
    if (currentStep == 0 && !_validateAndSaveForm())
      return;

    if (currentStep == 1 && !_validateAndSaveInterestsForm())
      return;


    // If not last step, advance and return
    final isLastStep = currentStep == getSteps().length - 1;
    if (!isLastStep) {
      setState(() => this.currentStep += 1);
      return;
    }
    _submit();
  }

  goToStep(int step){
      setState(() => this.currentStep = step);
  }

  onStepCancel() {
    if (currentStep > 0)
      goToStep(currentStep - 1);
  }
}