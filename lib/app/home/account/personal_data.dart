import 'package:cached_network_image/cached_network_image.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:enreda_empresas/app/common_widgets/alert_dialog.dart';
import 'package:enreda_empresas/app/common_widgets/custom_raised_button.dart';
import 'package:enreda_empresas/app/common_widgets/flex_row_column.dart';
import 'package:enreda_empresas/app/common_widgets/rounded_container.dart';
import 'package:enreda_empresas/app/common_widgets/show_exception_alert_dialog.dart';
import 'package:enreda_empresas/app/common_widgets/spaces.dart';
import 'package:enreda_empresas/app/common_widgets/text_form_field.dart';
import 'package:enreda_empresas/app/home/resources/validating_form_controls/stream_builder_city.dart';
import 'package:enreda_empresas/app/home/resources/validating_form_controls/stream_builder_country.dart';
import 'package:enreda_empresas/app/home/resources/validating_form_controls/stream_builder_province.dart';
import 'package:enreda_empresas/app/models/addressUser.dart';
import 'package:enreda_empresas/app/models/city.dart';
import 'package:enreda_empresas/app/models/contact.dart';
import 'package:enreda_empresas/app/models/country.dart';
import 'package:enreda_empresas/app/models/province.dart';
import 'package:enreda_empresas/app/models/userEnreda.dart';
import 'package:enreda_empresas/app/services/auth.dart';
import 'package:enreda_empresas/app/services/database.dart';
import 'package:enreda_empresas/app/utils/adaptative.dart';
import 'package:enreda_empresas/app/utils/functions.dart';
import 'package:enreda_empresas/app/values/strings.dart';
import 'package:enreda_empresas/app/values/values.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

import '../../utils/responsive.dart';

class PersonalData extends StatefulWidget {
  const PersonalData({Key? key}) : super(key: key);

  @override
  State<PersonalData> createState() => _PersonalDataState();
}

class _PersonalDataState extends State<PersonalData> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _textFieldController = TextEditingController();
  final ImagePicker _imagePicker = new ImagePicker();
  bool isLoading = false;
  String _userId = '';
  String _email = '';
  String _firstName = '';
  String _lastName = '';
  String _photo = '';
  String _phone = '';
  final String _gender = '';
  DateTime? _birthday;
  String _postalCode = '';
  String codeDialog = '';
  String valueText = '';
  String _phoneCode = '+34';
  UserEnreda? userEnreda;
  Country? selectedCountry;
  Province? selectedProvince;
  City? selectedCity;

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    final database = Provider.of<Database>(context, listen: false);

    return StreamBuilder<User?>(
        stream: Provider.of<AuthBase>(context).authStateChanges(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Container();
          if (snapshot.hasData) {
            return StreamBuilder<List<UserEnreda>>(
              stream: database.userStream(auth.currentUser!.email),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return Container();
                if (snapshot.hasData) {
                  userEnreda = snapshot.data![0];
                  _userId = userEnreda?.userId ?? '';
                  _email = userEnreda!.email;
                  _firstName = userEnreda?.firstName ?? '';
                  _lastName = userEnreda?.lastName ?? '';
                  _photo = userEnreda?.photo ?? '';
                  if (_phone.isEmpty) _phone = userEnreda?.phone ?? '';
                  _phoneCode =
                      '${userEnreda?.phone?[0]}${userEnreda?.phone?[1]}${userEnreda?.phone?[2]}';
                  _birthday = _birthday ?? userEnreda?.birthday;
                  _postalCode = userEnreda?.address?.postalCode ?? '';
                  return RoundedContainer(
                      borderColor: Responsive.isMobile(context) ? Colors.transparent : AppColors.greyLight,
                      margin: Responsive.isMobile(context) ? EdgeInsets.all(0) : EdgeInsets.all(Sizes.kDefaultPaddingDouble),
                      contentPadding: Responsive.isMobile(context) ? EdgeInsets.all(Sizes.kDefaultPaddingDouble / 2) :
                        EdgeInsets.all(Sizes.kDefaultPaddingDouble),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            _buildMainDataContainer(context, userEnreda!),
                            const SpaceH40(),
                            _buildMyParameters(context, userEnreda!),
                            const SpaceH20(),
                          ],
                        ),
                      ));
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }

  Widget _buildSaveDataButton(BuildContext context, UserEnreda userEnreda) {
    return isLoading
        ? const Center(
        child: CircularProgressIndicator(
          color: AppColors.primary300,
        ))
        : CustomButton(
      text: 'Actualizar mis datos',
      color: AppColors.turquoise,
      onPressed: () => _submit(userEnreda),
    );
  }

  Widget _buildMainDataContainer(BuildContext context, UserEnreda userEnreda) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      children: [
        Container(
          alignment: Alignment.topLeft,
          margin: EdgeInsets.only(top: Sizes.mainPadding),
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Text(StringConst.PERSONAL_DATA,
              style: textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.greyDark2),),
          ),
        ),
        _buildForm(context, userEnreda),
        _buildSaveDataButton(context, userEnreda),
      ],
    );
  }

  Widget _buildForm(BuildContext context, UserEnreda userEnreda) {
    final textTheme = Theme.of(context).textTheme;
    double fontSize = responsiveSize(context, 14, 16, md: 15);
    return Form(
      key: _formKey,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: InkWell(
            mouseCursor: MaterialStateMouseCursor.clickable,
            onTap: () => !kIsWeb
                ? _displayPickImageDialog()
                : _onImageButtonPressed(ImageSource.gallery),
            child: Container(
              width: 120,
              height: 120,
              color: Colors.transparent,
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(120),
                    ),
                    child: !kIsWeb
                        ? ClipRRect(
                      borderRadius:
                      const BorderRadius.all(Radius.circular(60)),
                      child: Center(
                        child: _photo == ""
                            ? Container(
                          color: Colors.transparent,
                          height: 120,
                          width: 120,
                          child:
                          Image.asset(ImagePath.USER_DEFAULT),
                        )
                            : CachedNetworkImage(
                            width: 120,
                            height: 120,
                            fit: BoxFit.cover,
                            alignment: Alignment.center,
                            imageUrl: _photo),
                      ),
                    )
                        : ClipRRect(
                      borderRadius:
                      const BorderRadius.all(Radius.circular(60)),
                      child: Center(
                        child: _photo == ""
                            ? Container(
                          color: Colors.transparent,
                          height: 120,
                          width: 120,
                          child:
                          Image.asset(ImagePath.USER_DEFAULT),
                        )
                            : FadeInImage.assetNetwork(
                          placeholder: ImagePath.USER_DEFAULT,
                          width: 120,
                          height: 120,
                          fit: BoxFit.cover,
                          image: _photo,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 6,
                    top: 6,
                    child: Container(
                      padding: const EdgeInsets.all(2.0),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        shape: BoxShape.circle,
                        border:
                        Border.all(color: AppColors.penBlue, width: 1.0),
                      ),
                      child: const Icon(
                        Icons.mode_edit_outlined,
                        size: 22,
                        color: AppColors.penBlue,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        CustomFlexRowColumn(
          childLeft: customTextFormField(context, _firstName,
              StringConst.FIRST_NAME, StringConst.NAME_ERROR, nameSetState),
          childRight: customTextFormField(context, _lastName,
              StringConst.LAST_NAME, StringConst.LAST_NAME_ERROR, lastNameSetState),
        ),
        CustomFlexRowColumn(
          childLeft: customDatePicker(context, _birthday!, StringConst.FORM_BIRTHDAY_DATE, StringConst.FORM_COMPANY_ERROR, dateSetState),
          childRight: streamBuilderForCountry(context, selectedCountry,
              buildCountryStreamBuilderSetState, userEnreda),
        ),
        CustomFlexRowColumn(
          childLeft: streamBuilderForProvince(
              context,
              selectedCountry == null ? userEnreda.address?.country : selectedCountry?.countryId,
              selectedProvince,
              buildProvinceStreamBuilderSetState, userEnreda),
          childRight: streamBuilderForCity(
              context,
              selectedCountry == null ? userEnreda.address?.country : selectedCountry?.countryId,
              selectedProvince == null ? userEnreda.address?.province : selectedProvince?.provinceId,
              selectedCity,
              buildCityStreamBuilderSetState,
              userEnreda),
        ),
        CustomFlexRowColumn(
          childLeft: customTextFormFieldNum(context, _postalCode,
              StringConst.FORM_POSTAL_CODE, StringConst.POSTAL_CODE_ERROR, postalCodeSetState),
          childRight: TextFormField(
            decoration: InputDecoration(
              labelText: StringConst.FORM_PHONE,
              prefixIcon: CountryCodePicker(
                onChanged: _onCountryChange,
                initialSelection: _phoneCode == '+34'
                    ? 'ES'
                    : _phoneCode == '+51'
                        ? 'PE'
                        : 'GT',
                countryFilter: const ['ES', 'PE', 'GT'],
                showFlagDialog: true,
              ),
              focusColor: AppColors.turquoise,
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
            initialValue: _phone.indexOf(' ') < 0 && _phone.length > 3
                ? _phone.substring(3)
                : _phone.substring(_phone.indexOf(' ') + 1),
            validator: (value) =>
                value!.isNotEmpty ? null : StringConst.PHONE_ERROR,
            onSaved: (value) => this._phone = _phoneCode + ' ' + value!,
            textCapitalization: TextCapitalization.sentences,
            keyboardType: TextInputType.phone,
            style: textTheme.bodySmall?.copyWith(
              height: 1.5,
              color: AppColors.greyDark,
              fontWeight: FontWeight.w400,
              fontSize: fontSize,
            ),
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
            ],
          ),
        ),
      ]),
    );
  }

  void _onCountryChange(CountryCode countryCode) {
    _phoneCode = countryCode.toString();
  }

  Future<void> _submit(UserEnreda userEnreda) async {

    if (_validateAndSaveForm()) {

      final newAddress = Address(
        country: selectedCountry == null ? userEnreda.address?.country : selectedCountry?.countryId,
        province: selectedProvince == null ? userEnreda.address?.province : selectedProvince?.provinceId,
        city: selectedCity?.cityId ?? userEnreda.address?.city,
        postalCode: _postalCode,
      );

      final updatedUserEnreda = userEnreda.copyWith(
          userId: _userId,
          address: newAddress,
          firstName: _firstName,
          lastName: _lastName,
          email: _email,
          phone: _phone,
          gender: _gender,
          birthday: _birthday,
      );
      try {
        final database = Provider.of<Database>(context, listen: false);
        setState(() => isLoading = true);
        await database.setUserEnreda(updatedUserEnreda);
        setState(() => isLoading = false);
        showAlertDialog(
          context,
          title: 'Actualizado',
          content: 'Se han actualizado los datos de tu usuario',
          defaultActionText: 'Ok',
        );
      } on FirebaseException catch (e) {
        showExceptionAlertDialog(context,
            title: 'Error al actualizar el usuario', exception: e);
      }
    }
  }

  bool _validateAndSaveForm() {
    final form = _formKey.currentState;
    if (form != null && form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void buildCountryStreamBuilderSetState(Country? country) {
    setState(() {
      selectedProvince = null;
      selectedCity = null;
      selectedCountry = country;
    });
  }

  void buildProvinceStreamBuilderSetState(Province? province) {
    setState(() {
      selectedCity = null;
      selectedProvince = province;
    });
  }

  void buildCityStreamBuilderSetState(City? city) {
    setState(() {
      selectedCity = city;
    });
  }

  void nameSetState(String? val) {
    setState(() {
      _firstName = val!;
    });
  }

  void lastNameSetState(String? val) {
    setState(() {
      _lastName = val!;
    });
  }

  void postalCodeSetState(String? val) {
    setState(() {
      _postalCode = val!;
    });
  }

  void dateSetState(String? val) {
    setState(() {
      _birthday = DateTime.parse(val!);
    });
  }

  Future<void> _displayPickImageDialog() async {
    final textTheme = Theme.of(context).textTheme;
    return showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 150,
            child: Padding(
              padding: const EdgeInsets.only(top: 16.0, left: 24.0),
              child: Row(
                children: <Widget>[
                  Column(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.camera,
                          color: Colors.indigo,
                          size: 30,
                        ),
                        onPressed: () {
                          _onImageButtonPressed(ImageSource.camera);
                          Navigator.of(context).pop();
                        },
                      ),
                      Text(
                        'Cámara',
                        style: textTheme.bodyMedium?.copyWith(fontSize: 12.0),
                      ),
                    ],
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Column(children: [
                    IconButton(
                        icon: const Icon(
                          Icons.photo,
                          color: Colors.indigo,
                          size: 30,
                        ),
                        onPressed: () {
                          _onImageButtonPressed(ImageSource.gallery);
                          Navigator.of(context).pop();
                        }),
                    Text(
                      'Galería',
                      style: textTheme.bodyMedium?.copyWith(fontSize: 12.0),
                    ),
                  ]),
                ],
              ),
            ),
          );
        });
  }

  Future<XFile?> _cropImage({required XFile imageFile}) async {
    CroppedFile? croppedImage = await ImageCropper().cropImage(
        sourcePath: imageFile.path,
        uiSettings: [
          WebUiSettings(
              context: context,
              presentStyle: WebPresentStyle.dialog,
              viewwMode: WebViewMode.mode_1,
              dragMode: WebDragMode.move,
              size: const CropperSize(
                width: 520,
                height: 520,
              ),
              cropBoxMovable: true,
              cropBoxResizable: true,
              movable: true,
              toggleDragModeOnDblclick: true,
              translations: WebTranslations(
                title: 'Recortar imagen',
                rotateLeftTooltip: 'Rotar 90 grados a la izquierda',
                rotateRightTooltip: 'Rotar 90 grados a la derecha',
                cancelButton: 'Cancelar',
                cropButton: 'Recortar',
              )
          ),
        ]
    );
    if(croppedImage == null) return null;
    return XFile(croppedImage.path);
  }

  Future<void> _onImageButtonPressed(ImageSource source) async {
    try {
      XFile? pickedFile = await _imagePicker.pickImage(
        source: source,
      );
      if (pickedFile != null) {
        pickedFile = await _cropImage(imageFile: pickedFile);
        setState(() async {
          final database = Provider.of<Database>(context, listen: false);
          await database.uploadUserAvatar(
              _userId, await pickedFile!.readAsBytes());
        });
      }
    } catch (e) {
      setState(() {
        //_pickImageError = e;
      });
    }
  }

  Widget _buildMyParameters(BuildContext context, UserEnreda user) {
    final textTheme = Theme.of(context).textTheme;
    return CustomFlexRowColumn(
        childLeft: Container(
            padding: EdgeInsets.all(Sizes.mainPadding),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.greyLight, width: 1),
              borderRadius: const BorderRadius.all(Radius.circular(15.0)),
              color: Colors.white,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'CONFIGURACIÓN DE LA CUENTA',
                    style: textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                      color: AppColors.penBlue),
                  ),
                ),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: InkWell(
                    child: const Text('Cambiar contraseña'),
                    onTap: () => _confirmChangePassword(context),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: InkWell(
                    child: const Text('Política de privacidad'),
                    onTap: () => launchURL(StringConst.POLICIES_URL),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: InkWell(
                    child: const Text('Condiciones de uso'),
                    onTap: () => launchURL(StringConst.USE_CONDITIONS_URL),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: InkWell(
                    child: const Text('Ayúdanos a mejorar'),
                    onTap: () => _displayReportDialog(context),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: InkWell(
                    child: const Text('Eliminar cuenta'),
                    onTap: () => _confirmDeleteAccount(context, user),
                  ),
                ),
              ],
            )),
        childRight: Container());
  }

  Future<void> _changePasword(BuildContext context) async {
    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
      await auth.changePassword();
    } catch (e) {
      print(e);
    }
  }

  Future<void> _deleteAccount(BuildContext context, UserEnreda user) async {
    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
      final database = Provider.of<Database>(context, listen: false);
      await database.deleteUser(user);
      await auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _confirmChangePassword(BuildContext context) async {
    final didRequestSignOut = await showAlertDialog(context,
        title: 'Cambiar contraseña',
        content: 'Si pulsa en Aceptar se le envirá a su correo las acciones a '
            'realizar para cambiar su contraseña. Si no aparece, revisa las carpetas de SPAM y Correo no deseado',
        cancelActionText: 'Cancelar',
        defaultActionText: 'Aceptar');
    if (didRequestSignOut == true) {
      _changePasword(context);
    }
  }

  Future<void> _displayReportDialog(BuildContext context) async {
    final database = Provider.of<Database>(context, listen: false);
    TextTheme textTheme = Theme.of(context).textTheme;
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Ayudanos a mejorar',
              style: textTheme.bodySmall?.copyWith(
                height: 1.5,
                color: AppColors.greyDark,
                fontWeight: FontWeight.w700,
              ), ),
            content: TextField(
              onChanged: (value) {
                setState(() {
                  valueText = value;
                });
              },
              controller: _textFieldController,
              decoration: InputDecoration(
                hintText: "Escribe tus sugerencias",
                hintStyle: textTheme.bodySmall?.copyWith(
                  color: AppColors.greyDark,
                  height: 1.5,
                  fontWeight: FontWeight.w400,
                ),),
              style: textTheme.bodySmall?.copyWith(
                height: 1.5,
                color: AppColors.greyDark,
                fontWeight: FontWeight.w400,),
              minLines: 4,
              maxLines: 4,
              textCapitalization: TextCapitalization.sentences,
              keyboardType: TextInputType.multiline,
            ),
            actions: <Widget>[
              TextButton(
                style: ButtonStyle(
                  foregroundColor:
                  MaterialStateProperty.all<Color>(Colors.white),
                  backgroundColor:
                  MaterialStateProperty.all<Color>(AppColors.primaryColor),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text('Cancelar'),
                ),
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                  });
                },
              ),
              TextButton(
                style: ButtonStyle(
                  foregroundColor:
                  MaterialStateProperty.all<Color>(Colors.white),
                  backgroundColor:
                  MaterialStateProperty.all<Color>(AppColors.primaryColor),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text('Enviar'),
                ),
                onPressed: () {
                  setState(() {
                    codeDialog = valueText;
                    if (valueText.isNotEmpty) {
                      final auth =
                      Provider.of<AuthBase>(context, listen: false);
                      final contact = Contact(
                          email: auth.currentUser?.email ?? '',
                          name: auth.currentUser?.displayName ?? '',
                          text: valueText);
                      database.addContact(contact);
                      showAlertDialog(
                        context,
                        title: 'Mensaje ensaje enviado',
                        content:
                        'Hemos recibido satistactoriamente tu sugerencia. ¡Muchas gracias por tu información!',
                        defaultActionText: 'Aceptar',
                      ).then((value) => Navigator.pop(context));
                    }
                  });
                },
              ),
            ],
          );
        });
  }

  Future<void> _confirmDeleteAccount(BuildContext context, UserEnreda user) async {
    final didRequestSignOut = await showAlertDialog(context,
        title: 'Eliminar cuenta',
        content: 'Si pulsa en Aceptar se procederá a la eliminación completa '
            'de su cuenta, esta acción no se podrá deshacer, '
            '¿Está seguro que quiere continuar?',
        cancelActionText: 'Cancelar',
        defaultActionText: 'Aceptar');
    if (didRequestSignOut == true) {
      _deleteAccount(context, user);
    }
  }
}
