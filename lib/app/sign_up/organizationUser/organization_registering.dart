import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:email_validator/email_validator.dart';
import 'package:enreda_empresas/app/common_widgets/alert_dialog.dart';
import 'package:enreda_empresas/app/common_widgets/custom_padding.dart';
import 'package:enreda_empresas/app/common_widgets/custom_padding_title.dart';
import 'package:enreda_empresas/app/common_widgets/enreda_button.dart';
import 'package:enreda_empresas/app/common_widgets/flex_row_column.dart';
import 'package:enreda_empresas/app/common_widgets/show_exception_alert_dialog.dart';
import 'package:enreda_empresas/app/common_widgets/text_form_field.dart';
import 'package:enreda_empresas/app/home/home_page.dart';
import 'package:enreda_empresas/app/models/addressUser.dart';
import 'package:enreda_empresas/app/models/city.dart';
import 'package:enreda_empresas/app/models/country.dart';
import 'package:enreda_empresas/app/models/nature.dart';
import 'package:enreda_empresas/app/models/organization.dart';
import 'package:enreda_empresas/app/models/organizationUser.dart';
import 'package:enreda_empresas/app/models/province.dart';
import 'package:enreda_empresas/app/models/scope.dart';
import 'package:enreda_empresas/app/models/size.dart';
import 'package:enreda_empresas/app/models/userEnreda.dart';
import 'package:enreda_empresas/app/services/database.dart';
import 'package:enreda_empresas/app/sign_up/organizationUser/organization_revision_form.dart';
import 'package:enreda_empresas/app/sign_up/validating_form_controls/checkbox_form.dart';
import 'package:enreda_empresas/app/sign_up/validating_form_controls/stream_builder_city.dart';
import 'package:enreda_empresas/app/sign_up/validating_form_controls/stream_builder_country.dart';
import 'package:enreda_empresas/app/sign_up/validating_form_controls/stream_builder_nature.dart';
import 'package:enreda_empresas/app/sign_up/validating_form_controls/stream_builder_province.dart';
import 'package:enreda_empresas/app/sign_up/validating_form_controls/stream_builder_scope.dart';
import 'package:enreda_empresas/app/sign_up/validating_form_controls/stream_builder_size.dart';
import 'package:enreda_empresas/app/utils/adaptative.dart';
import 'package:enreda_empresas/app/utils/responsive.dart';
import 'package:enreda_empresas/app/values/strings.dart';
import 'package:enreda_empresas/app/values/values.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

const double contactBtnWidthLg = 200.0;
const double contactBtnWidthSm = 120.0;
const double contactBtnWidthMd = 150.0;

class OrganizationRegistering extends StatefulWidget {
  const OrganizationRegistering({Key? key}) : super(key: key);

  @override
  State<OrganizationRegistering> createState() => _OrganizationRegisteringState();
}

class _OrganizationRegisteringState extends State<OrganizationRegistering> {
  final _formKey = GlobalKey<FormState>();
  final _checkFieldKey = GlobalKey<FormState>();
  String? _email;
  String? _organizationId;
  String? _name;
  String? _firstName;
  String _phone = '';
  String _phoneWithCode = '';
  String? _country;
  String? _province;
  String? _city;
  String? _postalCode;
  late String _natureValue;
  late String _scopeValue;
  late String _sizeOrgValue;

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
  String phoneCode = '+502';
  String initialCountryCode = 'GT';

  Nature? selectedNature;
  late String natureName;

  Scope? selectedScope;
  late String scopeName;

  SizeOrg? selectedSizeOrg;
  late String sizeOrgName;

  @override
  void initState() {
    super.initState();
    _email = "";
    _organizationId = "";
    _name = "";
    _firstName = "";
    _country = "";
    _province = "";
    _city = "";
    _postalCode = "";
    countryName = "";
    provinceName = "";
    cityName = "";
    natureName = "";
    scopeName = "";
    sizeOrgName = "";
  }

  bool _validateAndSaveForm() {
    final form = _formKey.currentState;

    if (form!.validate() && isRegistered == 0) {
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
      final nature = Nature(
        label: natureName,
        value: _natureValue,
      );
      final scope = Scope(
        label: scopeName,
        value: _scopeValue,
        order: 0,
      );
      final size = SizeOrg(
        label: sizeOrgName,
        value: _sizeOrgValue,
        order: 0,
      );
      final address = Address(
        country: _country,
        province: _province,
        city: _city,
        postalCode: _postalCode,
      );
      final organization = Organization(
        organizationId: _organizationId,
        name: _name!,
        email: _email,
        phone: _phoneWithCode,
        nature: nature,
        scope: scope,
        size: size,
        address: address,
      );
      final organizationUser = OrganizationUser(
        firstName: _firstName,
        email: _email,
        phone: _phoneWithCode,
        address: address,
        role: 'Organización',
      );
      try {
        final database = Provider.of<Database>(context, listen: false);
        await database.addOrganizationUser(organizationUser);
        await database.addOrganization(organization);
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
    final database = Provider.of<Database>(context, listen: false);
    TextTheme textTheme = Theme.of(context).textTheme;
    double fontSize = responsiveSize(context, 14, 18, md: 15);
    return
      Form(
        key: _formKey,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget> [
              CustomPaddingTitle(child: Text(
                StringConst.FORM_ORGANIZATION_INFO,
                style: textTheme.bodyText1?.copyWith(
                  height: 1.5,
                  color: AppColors.greyDark,
                  fontWeight: FontWeight.w700,
                  fontSize: fontSize,
                ),)),
              CustomPadding(
                  child: customTextFormFieldName(context, _name!, StringConst.FORM_ORGANIZATION, StringConst.NAME_ERROR, _name_setState)),
              CustomFlexRowColumn(
                  childLeft: streamBuilderForCountry(context, selectedCountry, _buildCountryStreamBuilder_setState),
                  childRight: streamBuilderForProvince(context, selectedCountry, selectedProvince, _buildProvinceStreamBuilder_setState)
              ),
              CustomFlexRowColumn(
                childLeft: streamBuilderForCity(context, selectedCountry, selectedProvince, selectedCity, _buildCityStreamBuilder_setState),
                childRight: customTextFormFieldName(context, _postalCode!, StringConst.FORM_POSTAL_CODE, StringConst.POSTAL_CODE_ERROR, _postalCode_setState),
              ),
              CustomFlexRowColumn(
                  childLeft: streamBuilderDropdownNature(context, selectedNature, _buildNatureStreamBuilder_setState),
                  childRight: streamBuilderForScope(context, selectedScope, _buildScopeStreamBuilder_setState)
              ),
              Padding(
                  padding: const EdgeInsets.all(Sizes.kDefaultPaddingDouble / 2),
                  child: streamBuilderForSizeOrg(context, selectedSizeOrg, _buildSizeOrgStreamBuilder_setState)
              ),
              CustomPaddingTitle(child: Text(
                StringConst.FORM_CONTACT_INFO,
                style: textTheme.bodyText1?.copyWith(
                  height: 1.5,
                  color: AppColors.greyDark,
                  fontWeight: FontWeight.w700,
                  fontSize: fontSize,
                ),)),
              CustomPadding(
                child: customTextFormFieldName(context, _firstName!, StringConst.FORM_CONTACT_NAME, StringConst.NAME_ERROR, _firsName_setState),
              ),
              CustomFlexRowColumn(
                  childLeft: TextFormField(
                      decoration: InputDecoration(
                        labelText: StringConst.FORM_PHONE,
                        labelStyle: textTheme.bodyText1?.copyWith(
                          height: 1.5,
                          color: AppColors.greyDark,
                          fontWeight: FontWeight.w400,
                          fontSize: fontSize,
                        ),
                        prefixIcon:CountryCodePicker(
                          onChanged: (code){
                            initialCountryCode = code.code!;
                            _onCountryChange(code);
                            },
                          initialSelection: initialCountryCode,
                          countryFilter: ['ES', 'PE', 'GT'],
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
                      validator: (value) =>
                      value!.isNotEmpty ? null : StringConst.PHONE_ERROR,
                      onSaved: (value) {
                        _phone = value!;
                        _phoneWithCode = phoneCode + _phone;
                      },
                      textCapitalization: TextCapitalization.sentences,
                      keyboardType: TextInputType.phone,
                      style: textTheme.bodyText1?.copyWith(
                        height: 1.5,
                        color: AppColors.greyDark,
                        fontWeight: FontWeight.w700,
                        fontSize: fontSize,
                      ),
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
                        return
                          TextFormField(
                              decoration: InputDecoration(
                                labelText: StringConst.FORM_EMAIL,
                                labelStyle: textTheme.bodyText1?.copyWith(
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
                              initialValue: _email,
                              validator: validationMessage,
                              onSaved: (value) => _email = value,
                              keyboardType: TextInputType.emailAddress,
                              onChanged: (value) => setState(() => writtenEmail = value),
                              style: textTheme.bodyText1?.copyWith(
                                height: 1.5,
                                color: AppColors.greyDark,
                                fontWeight: FontWeight.w700,
                                fontSize: fontSize,
                              ),
                          );

                      }
                  ),
              ),
            ]),
      );
  }

  Widget _buildRevision(BuildContext context) {
    return Column(
      children: [
        organizationRevisionForm(
            context,
            _name!,
            _firstName!, _email!,
            _phoneWithCode,
            countryName,
            provinceName,
            cityName,
            _postalCode!,
            natureName,
            scopeName,
            sizeOrgName
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

  void _buildNatureStreamBuilder_setState(Nature? nature) {
    setState(() {
      selectedNature = nature;
      natureName = nature != null ? nature.label : "";
    });
    _natureValue = (nature?.value)!;
  }

  void _buildScopeStreamBuilder_setState(Scope? scope) {
    setState(() {
      selectedScope = scope;
      scopeName = scope != null ? scope.label : "";
    });
    _scopeValue = (scope?.value)!;
  }

  void _buildSizeOrgStreamBuilder_setState(SizeOrg? sizeOrg) {
      setState(() {
        selectedSizeOrg = sizeOrg;
        sizeOrgName = sizeOrg != null ? sizeOrg.label : "";
      });
      _sizeOrgValue = (sizeOrg?.value)!;
    }

  void _name_setState(String? val) {
    setState(() => _name = val!);
  }

  void _firsName_setState(String? val) {
    setState(() => _firstName = val!);
  }

  void _postalCode_setState(String? val) {
    setState(() => _postalCode = val!);
  }


  List<Step> getSteps() => [
    Step(
      isActive: currentStep >= 0,
      state: currentStep > 0 ? StepState.complete : StepState.indexed,
      title: Text(StringConst.FORM_GENERAL_INFO.toUpperCase(), style: TextStyle(
  fontSize: Responsive.isTablet(context) ? 12 : 14,
  ),),
      content: _buildForm(context),
    ),
    Step(
      isActive: currentStep >= 1,
      title: Text(StringConst.FORM_REVISION.toUpperCase(), style: TextStyle(
        fontSize: Responsive.isTablet(context) ? 12 : 14,
      ),),
      content: _buildRevision(context),
    ),
  ];


  onStepContinue() async {
    // If invalid form, just return
    if (currentStep == 0 && !_validateAndSaveForm())
      return;

    // If not last step, advance and return
    final isLastStep = currentStep == getSteps().length-1;
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
    final isLastStep = currentStep == getSteps().length-1;
    double screenWidth = widthOfScreen(context);
    double screenHeight = heightOfScreen(context);
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
                    height: Sizes.HEIGHT_52,
                  ),
                ),
                Responsive.isMobile(context) ? Container() : SizedBox(width: Sizes.mainPadding),
                Container(
                  padding: const EdgeInsets.all(Sizes.kDefaultPaddingDouble / 2), child: Text(StringConst.FORM_ORGANIZATION_REGISTER.toUpperCase(),
                    style: const TextStyle(color: AppColors.greyDark)),)
              ],
            ),
          ),
          body: Stack(
            children: [
              Center(
                child: Container(
                  height: Responsive.isMobile(context) || Responsive.isTablet(context) ? MediaQuery.of(context).size.height : MediaQuery.of(context).size.height * 0.70,
                  width:  Responsive.isMobile(context) || Responsive.isTablet(context) ? MediaQuery.of(context).size.width : MediaQuery.of(context).size.width * 0.70,
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
                            margin: const EdgeInsets.only(top: Sizes.kDefaultPaddingDouble * 2),
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
                                const SizedBox(width: Sizes.kDefaultPaddingDouble),
                                EnredaButton(
                                  buttonTitle: isLastStep ? StringConst.FORM_CONFIRM : StringConst.FORM_NEXT,
                                  width: contactBtnWidth,
                                  buttonColor: AppColors.lilac,
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
                        top: screenHeight * 0.55,
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
              ),
              Responsive.isTablet(context) || Responsive.isMobile(context) ? Container() :
              Positioned(
                top: screenHeight * 0.51,
                left: Responsive.isDesktopS(context) ? screenWidth * 0.06 : screenWidth * 0.09,
                child: SizedBox(
                  height: Responsive.isTablet(context) || Responsive.isMobile(context) ? 300 * 0.8 : 300,
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