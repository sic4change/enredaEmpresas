import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:email_validator/email_validator.dart';
import 'package:enreda_empresas/app/common_widgets/alert_dialog.dart';
import 'package:enreda_empresas/app/common_widgets/custom_text.dart';
import 'package:enreda_empresas/app/common_widgets/enreda_button.dart';
import 'package:enreda_empresas/app/common_widgets/flex_row_column.dart';
import 'package:enreda_empresas/app/common_widgets/rounded_container.dart';
import 'package:enreda_empresas/app/common_widgets/show_exception_alert_dialog.dart';
import 'package:enreda_empresas/app/common_widgets/text_form_field.dart';
import 'package:enreda_empresas/app/home/home_page.dart';
import 'package:enreda_empresas/app/models/addressUser.dart';
import 'package:enreda_empresas/app/models/city.dart';
import 'package:enreda_empresas/app/models/country.dart';
import 'package:enreda_empresas/app/models/company.dart';
import 'package:enreda_empresas/app/models/companyUser.dart';
import 'package:enreda_empresas/app/models/province.dart';
import 'package:enreda_empresas/app/models/userEnreda.dart';
import 'package:enreda_empresas/app/services/database.dart';
import 'package:enreda_empresas/app/sign_up/validating_form_controls/checkbox_form.dart';
import 'package:enreda_empresas/app/sign_up/validating_form_controls/stream_builder_city.dart';
import 'package:enreda_empresas/app/sign_up/validating_form_controls/stream_builder_country.dart';
import 'package:enreda_empresas/app/sign_up/validating_form_controls/stream_builder_province.dart';
import 'package:enreda_empresas/app/utils/adaptative.dart';
import 'package:enreda_empresas/app/utils/responsive.dart';
import 'package:enreda_empresas/app/values/strings.dart';
import 'package:enreda_empresas/app/values/values.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common_widgets/custom_drop_down.dart';
import '../../common_widgets/custom_form_field.dart';
import '../../common_widgets/custom_stepper.dart';
import '../../home/resources/validating_form_controls/stream_builder_category_create.dart';
import '../../models/socialEntitiesCategories.dart';
import '../validating_form_controls/stream_builder_social_entity_category.dart';
import 'company_revision_form.dart';

const double contactBtnWidthLg = 200.0;
const double contactBtnWidthSm = 120.0;
const double contactBtnWidthMd = 150.0;

class CompanyRegistering extends StatefulWidget {
  const CompanyRegistering({Key? key}) : super(key: key);

  @override
  State<CompanyRegistering> createState() => _CompanyRegisteringState();
}

class _CompanyRegisteringState extends State<CompanyRegistering> {
  final _formKey = GlobalKey<FormState>();
  final _formKeyContact = GlobalKey<FormState>();
  final _checkFieldKey = GlobalKey<FormState>();
  String? _emailContact;
  String? _emailCompany;
  String? _companyId;
  String? _name;
  String? _cif;
  String? _mission;
  String? _linkedin;
  String? _otherSocialMedia;
  String? _firstName;
  String? _lastName;
  String _phone = '';
  String _phoneCompany = '';
  String _phoneWithCode = '';
  String _phoneWithCodeCompany = '';
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

  String writtenEmail = '';
  Country? selectedCountry;
  Province? selectedProvince;
  City? selectedCity;
  late String countryName;
  late String provinceName;
  late String cityName;
  SocialEntityCategory? _selectedSocialEntityCategory;
  String? _companyCategoryName;
  String? _companyCategoryId;
  String phoneCode = '+34';
  String initialCountryCode = 'ES';
  TextTheme? textTheme;
  String? _geographicZone, _subGeographicZone;
  List<DropdownMenuItem<String>> geographicZone = ['Global', 'Regional', 'Local'].map<DropdownMenuItem<String>>((String value){
    return DropdownMenuItem<String>(
      value: value,
      child: Text(value),
    );
  }).toList();
  List<DropdownMenuItem<String>> subGeographicZone = ['Iberoamérica', 'España', 'Canarias'].map<DropdownMenuItem<String>>((String value){
    return DropdownMenuItem<String>(
      value: value,
      child: Text(value),
    );
  }).toList();

  @override
  void initState() {
    super.initState();
    _companyId = "";
    _name = "";
    _cif = "";
    _mission = "";
    _linkedin = "";
    _otherSocialMedia = "";
    _geographicZone = "";
    _subGeographicZone = "";
    _companyCategoryName = "";
    _companyCategoryId = "";
    _emailCompany = "";
    _emailContact = "";
    _firstName = "";
    _lastName = "";
    _country = "";
    _province = "";
    _city = "";
    _postalCode = "";
    countryName = "";
    provinceName = "";
    cityName = "";
  }

  bool _validateAndSaveForm() {
    final form = _formKey.currentState;
    if (form!.validate() && isRegistered == 0) {
      form.save();
      return true;
    }
    return false;
  }

  bool _validateAndSaveInterestsForm() {
    final form = _formKeyContact.currentState;
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
      final company = Company(
        companyId: _companyId,
        name: _name!,
        cif: _cif!,
        mision: _mission,
        category: _companyCategoryId,
        geographicZone : _geographicZone,
        subGeographicZone : _subGeographicZone,
        email: _emailCompany,
        contactEmail: _emailContact,
        phone: _phoneWithCodeCompany,
        linkedin: _linkedin,
        otherSocialMedia: _otherSocialMedia,
        address: address,
      );
      final companyUser = CompanyUser(
        firstName: _firstName,
        lastName: _lastName,
        email: _emailContact!,
        phone: _phoneWithCode,
        address: address,
        role: 'Empresa',
      );
      try {
        final database = Provider.of<Database>(context, listen: false);
        await database.addCompanyUser(companyUser);
        await database.addCompany(company);
        showAlertDialog(
          context,
          title: StringConst.FORM_SUCCESS,
          content: StringConst.FORM_SUCCESS_MAIL,
          defaultActionText: StringConst.FORM_ACCEPT,
        ).then((value) => {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute<void>(
              fullscreenDialog: true,
              builder: (context) => const HomePage(),
            ),
          )
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
    textTheme = Theme.of(context).textTheme;
    return
      Form(
        key: _formKey,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget> [
              CustomFormField(
                child: customTextFormField(context, _name!, '', StringConst.FORM_GENERIC_ERROR, _name_setState),
                label: StringConst.FORM_COMPANY_NAME,),
              CustomFormField(
                child: customTextFormField(context, _cif!, '', StringConst.FORM_GENERIC_ERROR, _cif_setState),
                label: StringConst.FORM_COMPANY_CIF,),
              CustomFormField(
                child: streamBuilderDropdownSocialEntityCategory(context, _selectedSocialEntityCategory, buildResourceCategoryStreamBuilderSetState),
                label: StringConst.FORM_COMPANY_CATEGORY,),
              CustomFormField(
                child: customTextFormField(context, _mission!, '', StringConst.FORM_GENERIC_ERROR, _mission_setState),
                label: StringConst.FORM_COMPANY_MISSION,),
              CustomFlexRowColumn(
                  contentPadding: const EdgeInsets.all(Sizes.kDefaultPaddingDouble / 2),
                  childLeft: CustomDropDownButton(
                    labelText: 'Zona geográfica de influencia',
                    source: geographicZone,
                    onChanged: (value){
                      _geographicZone = value;
                    },
                    validator: (value) => value != null ? null : StringConst.FORM_GENERIC_ERROR,
                  ),
                  childRight: CustomDropDownButton(
                    labelText: 'Sub Zona geográfica de influencia',
                    source: subGeographicZone,
                    onChanged: (value){
                      _subGeographicZone = value;
                    },
                    validator: (value) => value != null ? null : StringConst.FORM_GENERIC_ERROR,
                  )
              ),
              CustomFlexRowColumn(
                  childLeft: streamBuilderForCountryCreate(context, selectedCountry, _buildCountryStreamBuilder_setState),
                  childRight: streamBuilderForProvinceCreate(context, selectedCountry, selectedProvince, _buildProvinceStreamBuilder_setState)
              ),
              CustomFlexRowColumn(
                childLeft: streamBuilderForCityCreate(context, selectedCountry, selectedProvince, selectedCity, _buildCityStreamBuilder_setState),
                childRight: customTextFormField(context, _postalCode!, StringConst.FORM_POSTAL_CODE, StringConst.POSTAL_CODE_ERROR, _postalCode_setState),
              ),
              CustomFlexRowColumn(
                  contentPadding: const EdgeInsets.all(0),
                  childLeft: CustomFormField(
                    child: customTextFormField(context, _emailCompany!, '', StringConst.FORM_GENERIC_ERROR, _email_Company_setState),
                    label: StringConst.FORM_COMPANY_EMAIL,),
                  childRight: CustomFormField(
                    child: TextFormField(
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: AppColors.white,
                        labelStyle: textTheme?.bodySmall?.copyWith(
                          height: 1.5,
                          color: AppColors.greyDark,
                          fontWeight: FontWeight.w400,
                        ),
                        prefixIcon: CountryCodePicker(
                          dialogSize: Size(350.0, MediaQuery.of(context).size.height * 0.6),
                          onChanged: (code){
                            initialCountryCode = code.code!;
                            _onCountryChange(code);
                          },
                          initialSelection: initialCountryCode,
                          showFlagDialog: true,
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
                      initialValue: _phoneCompany,
                      validator: (value) =>
                      value!.isNotEmpty ? null : StringConst.PHONE_ERROR,
                      onSaved: (value) {
                        _phoneCompany = value!;
                        _phoneWithCodeCompany = phoneCode + _phoneCompany;
                      },
                      textCapitalization: TextCapitalization.sentences,
                      keyboardType: TextInputType.phone,
                      style: textTheme?.bodyMedium?.copyWith(
                        height: 1.5,
                        letterSpacing: 1.5,
                        color: AppColors.greyDark,
                      ),
                    ),
                    label: StringConst.FORM_PHONE,
                  )
              ),
              CustomFlexRowColumn(
                  contentPadding: const EdgeInsets.all(0),
                  childLeft: CustomFormField(
                    child: customTextFormField(context, _linkedin!, '', StringConst.FORM_GENERIC_ERROR, _linkedin_setState),
                    label: StringConst.FORM_LINKEDIN,),
                  childRight: CustomFormField(
                    child: customTextFormField(context, _otherSocialMedia!, '', StringConst.FORM_GENERIC_ERROR, _otherSocialMedia_setState),
                    label: StringConst.FORM_OTHER_SOCIAL_MEDIA,),
              ),
            ]),
      );
  }

  Widget _buildFormContact(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);
    textTheme = Theme.of(context).textTheme;
    double fontSize = responsiveSize(context, 14, 18, md: 15);
    return
      Form(
        key: _formKeyContact,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget> [
              CustomFlexRowColumn(
                contentPadding: const EdgeInsets.all(0),
                childLeft: CustomFormField(
                  child: customTextFormField(context, _firstName!, '', StringConst.FORM_GENERIC_ERROR, _firsName_setState),
                  label: StringConst.FORM_CONTACT_NAME,),
                childRight: CustomFormField(
                  child: customTextFormField(context, _lastName!, '', StringConst.FORM_GENERIC_ERROR, _lastName_setState),
                  label: StringConst.FORM_CONTACT_LASTNAME,),
              ),
              CustomFlexRowColumn(
                contentPadding: const EdgeInsets.all(0),
                childLeft: CustomFormField(
                  child: TextFormField(
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: AppColors.white,
                      labelStyle: textTheme?.bodySmall?.copyWith(
                        height: 1.5,
                        color: AppColors.greyDark,
                        fontWeight: FontWeight.w400,
                      ),
                      prefixIcon: CountryCodePicker(
                        dialogSize: Size(350.0, MediaQuery.of(context).size.height * 0.6),
                        onChanged: (code) {
                          initialCountryCode = code.code!;
                          _onCountryChange(code);
                        },
                        initialSelection: initialCountryCode,
                        showFlagDialog: true,
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
                    initialValue: _phone,
                    validator: (value) => value!.isNotEmpty ? null : StringConst.PHONE_ERROR,
                    onSaved: (value) {
                      _phone = value!;
                      _phoneWithCode = phoneCode + _phone;
                    },
                    textCapitalization: TextCapitalization.sentences,
                    keyboardType: TextInputType.phone,
                    style: textTheme?.bodyMedium?.copyWith(
                      height: 1.5,
                      letterSpacing: 1.5,
                      color: AppColors.greyDark,
                    ),
                  ),
                  label: StringConst.FORM_PHONE,
                ),
                childRight: StreamBuilder <List<UserEnreda>>(
                      stream:
                      // Empty stream (no call to firestore) if email not valid
                      !EmailValidator.validate(writtenEmail)
                          ? const Stream<List<UserEnreda>>.empty()
                          : database.checkIfUserEmailRegistered(writtenEmail),
                      builder:  (context, snapshotUsers) {

                        var usersListLength = snapshotUsers.data != null ? snapshotUsers.data?.length : 0;
                        isRegistered = usersListLength! > 0 ? 1 : 0;

                        validationMessage(value) => EmailValidator.validate(value!)
                            ? (isRegistered == 0 ? null : StringConst.EMAIL_REGISTERED)
                            : StringConst.EMAIL_ERROR;
                        return CustomFormField(
                          child: TextFormField(
                            decoration: InputDecoration(
                              labelStyle: textTheme?.bodySmall?.copyWith(
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
                            initialValue: _emailContact,
                            validator: validationMessage,
                            onSaved: (value) => _emailContact = value,
                            keyboardType: TextInputType.emailAddress,
                            onChanged: (value) => setState(() => writtenEmail = value),
                            style: textTheme?.bodyMedium?.copyWith(
                              color: AppColors.greyDark,
                            ),
                          ),
                          label: StringConst.FORM_EMAIL,);
                      }
                  ),
              ),
            ]),
      );
  }

  Widget _buildRevision(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(ImagePath.LOGO_LINES),
          //fit: BoxFit.cover,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RoundedContainer(
            width: Responsive.isMobile(context) ? MediaQuery.of(context).size.width : MediaQuery.of(context).size.width * 0.5,
            margin: Responsive.isMobile(context) ? EdgeInsets.all(0) : EdgeInsets.all(Sizes.kDefaultPaddingDouble),
            contentPadding: Responsive.isMobile(context) ? EdgeInsets.all(0) : EdgeInsets.all(Sizes.kDefaultPaddingDouble),
            borderColor: Responsive.isMobile(context) ? Colors.transparent : AppColors.greyLight,
            child: companyRevisionForm(
              context,
              _name!,
              _cif!,
              _companyCategoryName!,
              _mission!,
              _geographicZone!,
              _subGeographicZone!,
              _phoneWithCodeCompany,
              _linkedin!,
              _otherSocialMedia!,
              countryName,
              provinceName,
              cityName,
              _postalCode!,
              _firstName!,
              _lastName!,
              _phoneWithCode,
              _emailContact!,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              checkboxForm(context, _checkFieldKey, _isChecked, functionSetState),
            ],
          )
        ],
      ),
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

  void _name_setState(String? val) {
    setState(() => _name = val!);
  }

  void _cif_setState(String? val) {
    setState(() => _cif = val!);
  }

  void _mission_setState(String? val) {
    setState(() => _mission = val!);
  }

  void buildResourceCategoryStreamBuilderSetState(
    SocialEntityCategory? companyCategory) {
    setState(() {
      _selectedSocialEntityCategory = companyCategory;
      _companyCategoryName = companyCategory != null ? companyCategory.name : "";
      _companyCategoryId = companyCategory?.socialEntityCategoryId;
    });
  }

  void _email_Company_setState(String? val) {
    setState(() => _emailCompany = val!);
  }

  void _linkedin_setState(String? val) {
    setState(() => _linkedin = val!);
  }

  void _otherSocialMedia_setState(String? val) {
    setState(() => _otherSocialMedia = val!);
  }

  void _firsName_setState(String? val) {
    setState(() => _firstName = val!);
  }

  void _lastName_setState(String? val) {
    setState(() => _lastName = val!);
  }

  void _email_setState(String? val) {
    setState(() => _emailContact = val!);
  }

  void _postalCode_setState(String? val) {
    setState(() => _postalCode = val!);
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
          StringConst.FORM_SOCIAL_COMPANY_INFO,
          style: textTheme?.titleSmall!.copyWith(
              color: AppColors.primary900
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
          StringConst.FORM_CONTACT_DATA_INFO,
          style: textTheme?.titleSmall!.copyWith(
              color: AppColors.turquoiseBlue
          ),
        ),
      ),
      content: _buildFormContact(context),
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
          style: textTheme?.titleSmall!.copyWith(
              color: AppColors.turquoiseBlue
          ),
        ),
      ),
      content: _buildRevision(context),
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
      setState(() => currentStep += 1);
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
    final isLastStep = currentStep == getSteps().length - 1;
    double contactBtnWidth = responsiveSize(
      context,
      contactBtnWidthSm,
      contactBtnWidthLg,
      md: contactBtnWidthMd
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
              color: AppColors.blueDark, //change your color here
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Responsive.isMobile(context) ? Container() : Padding(
                  padding: EdgeInsets.all(Sizes.mainPadding),
                  child: Image.asset(
                    ImagePath.LOGO,
                    height: Sizes.HEIGHT_30,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(Sizes.kDefaultPaddingDouble / 2),
                  child: CustomTextMediumBold(text: StringConst.FORM_COMPANY_REGISTER,))
              ],
            ),
          ),
          body: Center(
            child: Container(
              constraints: BoxConstraints(
                maxHeight: Responsive.isMobile(context) ? MediaQuery.of(context).size.height : MediaQuery.of(context).size.height * 0.9,
                maxWidth: Responsive.isMobile(context) ? MediaQuery.of(context).size.height : MediaQuery.of(context).size.width * 0.7,
              ),
              child: RoundedContainer(
                color: AppColors.grey80,
                borderColor: Responsive.isMobile(context) ? Colors.transparent : AppColors.gre600,
                margin: Responsive.isMobile(context) ? EdgeInsets.all(0) : EdgeInsets.all(Sizes.kDefaultPaddingDouble),
                contentPadding: Responsive.isMobile(context) ? EdgeInsets.all(0) : EdgeInsets.all(Sizes.kDefaultPaddingDouble),
                child: Stack(
                  alignment: Alignment.topLeft,
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: Sizes.kDefaultPaddingDouble * 3),
                      child: CustomStepper(
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
                    ),
                    Padding(
                      padding: const EdgeInsets.all(Sizes.kDefaultPaddingDouble),
                      child: CustomTextMedium(text: StringConst.CREATE_NEW_COMPANY,),
                    ),
                  ],
                ),
              ),
            ),
          )
      ),
    );
  }
}