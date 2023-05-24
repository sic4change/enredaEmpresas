import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:enreda_empresas/app/common_widgets/alert_dialog.dart';
import 'package:enreda_empresas/app/common_widgets/precached_avatar.dart';
import 'package:enreda_empresas/app/common_widgets/show_exception_alert_dialog.dart';
import 'package:enreda_empresas/app/common_widgets/spaces.dart';
import 'package:enreda_empresas/app/models/contact.dart';
import 'package:enreda_empresas/app/models/resource.dart';
import 'package:enreda_empresas/app/services/auth.dart';
import 'package:enreda_empresas/app/services/database.dart';
import 'package:enreda_empresas/app/utils/adaptative.dart';
import 'package:enreda_empresas/app/values/strings.dart';
import 'package:enreda_empresas/app/values/values.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ResourceListTile extends StatefulWidget {
  const ResourceListTile({Key? key, required this.resource, this.onTap})
      : super(key: key);
  final Resource resource;
  final VoidCallback? onTap;

  @override
  State<ResourceListTile> createState() => _ResourceListTileState();
}

class _ResourceListTileState extends State<ResourceListTile> {
  final _formKey = GlobalKey<FormState>();
  String? _email;
  String? _name;
  String? _text;
  String? codeDialog;
  String? valueText;
  TextEditingController _textFieldController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _email = "";
    _name = "";
    _text = "";
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    double fontSize = responsiveSize(context, 15, 15, md: 13);
    double sidePadding = responsiveSize(context, 15, 20, md: 17);

    return Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          margin: const EdgeInsets.all(5.0),
          child: InkWell(
            mouseCursor: MaterialStateMouseCursor.clickable,
            onTap: widget.onTap,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.greyLight2.withOpacity(0.3), width: 1),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.greyAlt.withOpacity(0.15),
                    spreadRadius: 1,
                    blurRadius: 1,
                    offset: const Offset(1, 1), // changes position of shadow
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(10),
                          topLeft: Radius.circular(10)),
                      color: Colors.white,
                    ),
                    height: 115,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(10),
                                topLeft: Radius.circular(10)),
                          ),
                          height: 60,
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: sidePadding, right: sidePadding, top: 10),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                widget.resource.organizerImage == null ||
                                        widget.resource.organizerImage!.isEmpty
                                    ? Container()
                                    : LayoutBuilder(
                                        builder: (context, constraints) {
                                        return CircleAvatar(
                                          radius: 15,
                                          backgroundColor: AppColors.white,
                                          backgroundImage: NetworkImage(
                                              widget.resource.organizerImage!),
                                        );
                                      }),
                                widget.resource.organizerImage == null ||
                                        widget.resource.organizerImage!.isEmpty
                                    ? Container()
                                    : const SizedBox(
                                        width: 5,
                                      ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        widget.resource.promotor != null
                                            ? widget.resource.promotor!
                                            : widget.resource.organizerName ??
                                                '',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: textTheme.bodySmall?.copyWith(
                                          color: AppColors.greyDark,
                                          height: 1.5,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.place,
                                            color: AppColors.greyDark,
                                            size: 12,
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(
                                                  horizontal: 8.0),
                                              child: Text(
                                                getLocationText(widget.resource),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style:
                                                    textTheme.bodySmall?.copyWith(
                                                  color: AppColors.greyDark,
                                                  height: 1.5,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SpaceH4(),
                        SizedBox(
                          height: 45,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(
                                    left: sidePadding, right: sidePadding),
                                child: Text(
                                  widget.resource.resourceTypeName!
                                      .toUpperCase(),
                                  textAlign: TextAlign.left,
                                  maxLines: 1,
                                  style: TextStyle(
                                      letterSpacing: 1,
                                      fontSize: fontSize,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.lilac),
                                ),
                              ),
                              const SpaceH4(),
                              Padding(
                                padding: EdgeInsets.only(
                                    right: sidePadding, left: sidePadding),
                                child: Text(
                                  widget.resource.title,
                                  textAlign: TextAlign.left,
                                  maxLines: 2,
                                  style: TextStyle(
                                    letterSpacing: 1,
                                    fontSize: fontSize,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.penBlue,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  !kIsWeb ? Expanded(
                    child: widget.resource.resourcePhoto == null ||
                        widget.resource.resourcePhoto == ""
                        ? Container()
                        : CachedNetworkImage(
                            width: 400,
                            fit: BoxFit.cover,
                            progressIndicatorBuilder:
                                (context, url, downloadProgress) => Container(
                                  child: Image.asset(ImagePath.IMAGE_DEFAULT),
                            ),
                            alignment: Alignment.center,
                            imageUrl: widget.resource.resourcePhoto!),
                  ):
                  Expanded(
                    child: widget.resource.resourcePhoto == null ||
                        widget.resource.resourcePhoto == ""
                        ? Container()
                        : PrecacheResourceCard(
                            imageUrl: widget.resource.resourcePhoto!,
                          )
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(10),
                          bottomLeft: Radius.circular(10)),
                      color: AppColors.white,
                    ),
                    height: 40,
                    child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: sidePadding),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [

                        Spacer(),
                        // buildShareButton(
                        //     context, widget.resource, AppColors.greyDark),
                      ],
                    ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
    );
  }

  String getLocationText(Resource resource) {
    switch (resource.modality) {
      case StringConst.FACE_TO_FACE:
      case StringConst.BLENDED:
        {
          if (resource.cityName != null) {
            return '${resource.cityName}, ${resource.provinceName}, ${resource.countryName}';
          }

          if (resource.cityName == null && resource.provinceName != null) {
            return '${resource.provinceName}, ${resource.countryName}';
          }

          if (resource.provinceName == null && resource.countryName != null) {
            return resource.countryName!;
          }

          if (resource.provinceName != null) {
            return resource.provinceName!;
          } else if (resource.countryName != null) {
            return resource.countryName!;
          }
          return resource.modality;
        }

      case StringConst.ONLINE_FOR_COUNTRY:
      /*return StringConst.ONLINE_FOR_COUNTRY
            .replaceAll('país', resource.countryName!);*/

      case StringConst.ONLINE_FOR_PROVINCE:
      /*return StringConst.ONLINE_FOR_PROVINCE.replaceAll(
            'provincia', '${resource.provinceName!}, ${resource.countryName!}');*/

      case StringConst.ONLINE_FOR_CITY:
      /*return StringConst.ONLINE_FOR_CITY.replaceAll('ciudad',
            '${resource.cityName!}, ${resource.provinceName!}, ${resource.countryName!}');*/

      case StringConst.ONLINE:
        return StringConst.ONLINE;

      default:
        return resource.modality;
    }
  }

  Future<void> _displayReportDialogVisitor(
      BuildContext context, Resource resource) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Denunciar recurso'),
            content: _buildForm(context, resource),
          );
        });
  }

  Widget _buildForm(BuildContext context, Resource resource) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: 500,
          height: 350,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: _buildFormChildren(context, resource),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildFormChildren(BuildContext context, Resource resource) {
    TextTheme textTheme = Theme.of(context).textTheme;
    double fontSize = responsiveSize(context, 14, 16, md: 15);
    return [
      Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
                decoration: const InputDecoration(labelText: 'Nombre'),
                initialValue: '',
                validator: (value) =>
                value!.isNotEmpty ? null : 'El nombre no puede estar vacío',
                onSaved: (value) => _name = value,
                textCapitalization: TextCapitalization.sentences,
                keyboardType: TextInputType.name,
                style: textTheme.button?.copyWith(
                  height: 1.5,
                  color: AppColors.greyDark,
                  fontWeight: FontWeight.w400,
                  fontSize: fontSize,
                ),
            ),
            TextFormField(
                decoration: const InputDecoration(labelText: 'Email'),
                initialValue: _email,
                validator: (value) => EmailValidator.validate(value!) ? null : "El email no es válido",
                onSaved: (value) => _email = value,
                keyboardType: TextInputType.emailAddress,
                style: textTheme.button?.copyWith(
                  height: 1.5,
                  color: AppColors.greyDark,
                  fontWeight: FontWeight.w400,
                  fontSize: fontSize,
                ),
            ),
            TextFormField(
                decoration: const InputDecoration(labelText: 'Descripción de la denuncia'),
                initialValue: _text,
                validator: (value) =>
                value!.isNotEmpty ? null : 'La descripción no puede estar vacía',
                onSaved: (value) => _text = value,
                minLines: 4,
                maxLines: 4,
                textCapitalization: TextCapitalization.sentences,
                keyboardType: TextInputType.multiline,
                style: textTheme.button?.copyWith(
                  height: 1.5,
                  color: AppColors.greyDark,
                  fontWeight: FontWeight.w400,
                  fontSize: fontSize,
                ),
            ),
            const SizedBox(height: 40),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: ElevatedButton(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(StringConst.CANCEL.toUpperCase(),
                        style: textTheme.button?.copyWith(
                          height: 1.5,
                          color: AppColors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: fontSize,
                        ),
                      ),
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                const SpaceW20(),
                Expanded(
                  flex: 1,
                  child: ElevatedButton(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(StringConst.SEND.toUpperCase(),
                        style: textTheme.button?.copyWith(
                        height: 1.5,
                        color: AppColors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: fontSize,
                      ),
                      ),
                    ),
                    onPressed: () => _submit(resource),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 8.0,
            ),
          ])
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

  Future<void> _submit(Resource resource) async {
    if (_validateAndSaveForm()) {
      final contact = Contact(
        email: _email!,
        name: _name!,
        text:
            'Tenemos una queja de este recurso: ${resource.title}.  ${_text!}',
      );
      try {
        final database = Provider.of<Database>(context, listen: false);
        //await database.addContact(contact);
        showAlertDialog(
          context,
          title: 'Mensaje ensaje enviado',
          content:
              'Hemos recibido satisfactoriamente tu mensaje, nos comunicaremos contigo a la brevedad.',
          defaultActionText: 'Aceptar',
        ).then((value) => Navigator.pop(context));
      } on FirebaseException catch (e) {
        showExceptionAlertDialog(context,
                title: 'Error al enviar contacto', exception: e)
            .then((value) => Navigator.pop(context));
      }
    }
  }

  Future<void> _addUserToLike(Resource resource) async {
    if (_checkAnonimousUser()) {
      _showAlertUserAnonimousLike();
    } else {
      final auth = Provider.of<AuthBase>(context, listen: false);
      final database = Provider.of<Database>(context, listen: false);
      resource.likes.add(auth.currentUser!.uid);
      //await database.setResource(resource);
      setState(() {
        widget.resource;
      });
    }
  }

  Future<void> _removeUserToLike(Resource resource, String userId) async {
    final database = Provider.of<Database>(context, listen: false);
    resource.likes.remove(userId);
    //await database.setResource(resource);
    setState(() {
      widget.resource;
    });
  }

  bool _checkAnonimousUser() {
    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
      return auth.currentUser!.isAnonymous;
    } catch (e) {
      print(e.toString());
      return true;
    }
  }

  _showAlertUserAnonimousLike() async {
    final didRequestSignOut = await showAlertDialog(context,
        title: '¿Te interesa este recurso?',
        content:
            'Solo los usuarios registrados pueden guardar como favoritos los recursos. ¿Desea entrar como usuario registrado?',
        cancelActionText: 'Cancelar',
        defaultActionText: 'Entrar');
    if (didRequestSignOut == true) {
      _signOut(context);
      Navigator.of(context).pop();
    }
  }

  Future<void> _signOut(BuildContext context) async {
    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
      await auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _displayReportDialog(
    BuildContext context, Resource resource) async {
    TextTheme textTheme = Theme.of(context).textTheme;
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Denunciar recurso',
            style: textTheme.button?.copyWith(
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
                hintText: "Escribe la queja",
                hintStyle: textTheme.button?.copyWith(
                color: AppColors.greyDark,
                height: 1.5,
                fontWeight: FontWeight.w400,
              ),),
              style: textTheme.button?.copyWith(
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
                    if (valueText != null && valueText!.isNotEmpty) {
                      final auth =
                          Provider.of<AuthBase>(context, listen: false);
                      final contact = Contact(
                          email: auth.currentUser!.email ?? '',
                          name: auth.currentUser!.displayName ?? '',
                          text:
                              'Tenemos una queja de este recurso: ${resource.title}.  ${valueText}');
                      final database =
                          Provider.of<Database>(context, listen: false);
                      //database.addContact(contact);
                      showAlertDialog(
                        context,
                        title: 'Mensaje ensaje enviado',
                        content:
                        'Hemos recibido satisfactoriamente tu mensaje, nos comunicaremos contigo a la brevedad.',
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
}
