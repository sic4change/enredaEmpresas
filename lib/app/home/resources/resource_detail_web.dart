import 'package:email_validator/email_validator.dart';
import 'package:enreda_empresas/app/common_widgets/show_back_icon.dart';
import 'package:enreda_empresas/app/common_widgets/spaces.dart';
import 'package:enreda_empresas/app/models/city.dart';
import 'package:enreda_empresas/app/models/country.dart';
import 'package:enreda_empresas/app/models/organization.dart';
import 'package:enreda_empresas/app/models/province.dart';
import 'package:enreda_empresas/app/models/resource.dart';
import 'package:enreda_empresas/app/models/userEnreda.dart';
import 'package:enreda_empresas/app/services/auth.dart';
import 'package:enreda_empresas/app/services/database.dart';
import 'package:enreda_empresas/app/utils/adaptative.dart';
import 'package:enreda_empresas/app/utils/responsive.dart';
import 'package:enreda_empresas/app/values/strings.dart';
import 'package:enreda_empresas/app/values/values.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ResourceDetailPageWeb extends StatefulWidget {
  const ResourceDetailPageWeb({Key? key, required this.resourceId})
      : super(key: key);
  final String resourceId;

  @override
  _ResourceDetailPageWebState createState() => _ResourceDetailPageWebState();
}

class _ResourceDetailPageWebState extends State<ResourceDetailPageWeb> {
  TextEditingController _textFieldController = TextEditingController();
  late Resource resource;

  final _formKey = GlobalKey<FormState>();
  String? _email;
  String? _name;
  String? _text;
  String? codeDialog;
  String? valueText;

  @override
  void initState() {
    super.initState();
    _email = "";
    _name = "";
    _text = "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: showBackIconButton(context, Colors.white),
      ),
      body: Stack(
        children: <Widget>[
          Opacity(opacity: 0.8, child: Container()),
          _buildContent(),
        ],
      ),
    );
  }

  Widget _buildContent() {
    final database = Provider.of<Database>(context, listen: false);

    return StreamBuilder<Resource>(
        stream: database.resourceStream(widget.resourceId),
        builder: (context, snapshotResource) {
          if (snapshotResource.hasData &&
              snapshotResource.connectionState == ConnectionState.active) {
            resource = snapshotResource.data!;
            resource.setResourceTypeName();
            resource.setResourceCategoryName();
            return StreamBuilder(
                stream: resource.organizerType == 'Organización'
                    ? database.organizationStream(resource.organizer)
                    : database.mentorStream(resource.organizer),
                builder: (context, snapshotOrganizer) {
                  if (snapshotOrganizer.hasData &&
                      snapshotOrganizer.connectionState ==
                          ConnectionState.active) {
                    if (resource.organizerType == 'Organización') {
                      final organization =
                      snapshotOrganizer.data as Organization;
                      resource.organizerName =
                      organization == null ? '' : organization.name;
                      resource.organizerImage =
                      organization == null ? '' : organization.photo;
                    } else {
                      final mentor = snapshotOrganizer.data as UserEnreda;
                      // resource.organizerName = mentor == null
                      //     ? ''
                      //     : '${mentor.firstName} ${mentor.lastName} ';
                      // resource.organizerImage =
                      // mentor == null ? '' : mentor.photo;
                    }
                  }
                  return StreamBuilder<Country>(
                      stream: database.countryStream(resource.country),
                      builder: (context, snapshot) {
                        final country = snapshot.data;
                        resource.countryName =
                        country == null ? '' : country.name;
                        return StreamBuilder<Province>(
                            stream: database.provinceStream(resource.province),
                            builder: (context, snapshot) {
                              final province = snapshot.data;
                              resource.provinceName =
                              province == null ? '' : province.name;
                              return StreamBuilder<City>(
                                  stream: database.cityStream(resource.city),
                                  builder: (context, snapshot) {
                                    final city = snapshot.data;
                                    resource.cityName =
                                    city == null ? '' : city.name;
                                    return Padding(
                                      padding: const EdgeInsets.only(top: 40.0),
                                      child: Dialog(
                                        alignment: Alignment.topCenter,
                                        clipBehavior: Clip.hardEdge,
                                        elevation: 0.0,
                                        backgroundColor: Colors.transparent,
                                        child: Stack(
                                          children: [
                                            Center(
                                              child: Container(
                                                width:  Responsive.isDesktopS(context) ? MediaQuery.of(context).size.width * 0.8 : MediaQuery.of(context).size.width * 0.6,
                                                margin: const EdgeInsets.only(
                                                    top: 50,
                                                    bottom: 20),
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    shape: BoxShape.rectangle,
                                                    borderRadius:
                                                    BorderRadius.circular(
                                                        20.0),
                                                    boxShadow: const <BoxShadow>[
                                                      BoxShadow(
                                                        color: Colors.black26,
                                                        blurRadius: 4.0,
                                                        offset: Offset(0.0, 1.0),
                                                      ),
                                                    ]),
                                                padding: EdgeInsets.all(
                                                    Sizes.mainPadding),
                                                child: resource.organizerImage !=
                                                    null &&
                                                    resource.organizerName !=
                                                        null
                                                    ? Column(
                                                  mainAxisSize:
                                                  MainAxisSize.min,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                          child:
                                                          Container(),
                                                        ),
                                                        _buildMenuButton(context, resource),
                                                      ],
                                                    ),
                                                    const SpaceH44(),
                                                    _buildHeader(),
                                                    const SpaceH30(),
                                                    const Divider(),
                                                    const SpaceH30(),
                                                    Flexible(
                                                        child:
                                                        _buildBody()),
                                                    const SpaceH30(),
                                                    _buildActionButtons(),
                                                  ],
                                                )
                                                    : const Center(
                                                    child:
                                                    CircularProgressIndicator()),
                                              ),
                                            ),
                                            resource.organizerImage == null ||
                                                resource
                                                    .organizerImage!.isEmpty
                                                ? Container()
                                                : Align(
                                              alignment:
                                              Alignment.topCenter,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        width: 1.0,
                                                        color: AppColors.greyLight),
                                                    borderRadius:
                                                    BorderRadius
                                                        .circular(
                                                      100,
                                                    ),
                                                    color: AppColors.greyLight),
                                                child: CircleAvatar(
                                                  radius: 50,
                                                  backgroundColor:
                                                  AppColors.white,
                                                  backgroundImage:
                                                  NetworkImage(resource
                                                      .organizerImage!),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  });
                            });
                      });
                });
          } else {
            return Container();
          }
        });
  }

  Widget _buildHeader() {
    TextTheme textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        Text(
          resource.title,
          textAlign: TextAlign.left,
          maxLines: 2,
          style: textTheme.bodyText1?.copyWith(
            letterSpacing: 1.2,
            fontSize: 32,
            color: AppColors.darkGray,
          ),
        ),
        const SpaceH24(),
        Text(
          resource.promotor != null
              ? resource.promotor!
              : resource.organizerName ?? '',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.penBlue,
          ),
        ),
      ],
    );
  }

  Widget _buildBody() {
    TextTheme textTheme = Theme.of(context).textTheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 6,
          child: SingleChildScrollView(
            controller: ScrollController(),
            child: Text(
              resource.description,
              style: textTheme.bodyText1,
            ),
          ),
        ),
        const SpaceW30(),
        Expanded(
          flex: 4,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              border: Border.all(
                color: AppColors.greyLight,
              ),
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 14.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SpaceH30(),
                  Text(
                    StringConst.RESOURCE_TYPE.toUpperCase(),
                    style: textTheme.bodyText1?.copyWith(
                        color: AppColors.penBlue, fontWeight: FontWeight.bold),
                  ),
                  const SpaceH8(),
                  Text('${resource.resourceTypeName}', style: textTheme.bodyText1,),
                  const SpaceH30(),
                  Text(
                    StringConst.LOCATION.toUpperCase(),
                    style: textTheme.bodyText1?.copyWith(
                        color: AppColors.penBlue, fontWeight: FontWeight.bold),
                  ),
                  const SpaceH8(),
                  Text(_getLocationText(resource), style: textTheme.bodyText1,),
                  const SpaceH30(),
                  Text(
                    StringConst.CAPACITY.toUpperCase(),
                    style: textTheme.bodyText1?.copyWith(
                        color: AppColors.penBlue, fontWeight: FontWeight.bold),
                  ),
                  const SpaceH8(),
                  Text('${resource.capacity}', style: textTheme.bodyText1,),
                  const SpaceH30(),
                  Text(
                    StringConst.DATE.toUpperCase(),
                    style: textTheme.bodyText1?.copyWith(
                        color: AppColors.penBlue, fontWeight: FontWeight.bold),
                  ),
                  const SpaceH8(),
                  DateFormat('dd/MM/yyyy').format(resource.start) ==
                      '31/12/2050'
                      ? Text(
                    StringConst.ALWAYS_AVAILABLE,
                    textAlign: TextAlign.center,
                    style: textTheme.bodyText1,
                  )
                      : Text(
                    '${DateFormat('dd/MM/yyyy').format(resource.start)} - ${DateFormat('dd/MM/yyyy').format(resource.end)}',
                    textAlign: TextAlign.center,
                    style: textTheme.bodyText1,
                  ),
                  const SpaceH30(),
                  Text(
                    StringConst.CONTRACT_TYPE.toUpperCase(),
                    style: textTheme.bodyText1?.copyWith(
                        color: AppColors.penBlue, fontWeight: FontWeight.bold),
                  ),
                  const SpaceH8(),
                  Text(
                    resource.contractType == null ||
                        resource.contractType!.isEmpty
                        ? 'Sin especificar'
                        : resource.contractType!,
                    textAlign: TextAlign.center,
                    style: textTheme.bodyText1,
                  ),
                  const SpaceH30(),
                  Text(
                    StringConst.SALARY.toUpperCase(),
                    style: textTheme.bodyText1?.copyWith(
                        color: AppColors.penBlue, fontWeight: FontWeight.bold),
                  ),
                  const SpaceH8(),
                  Text(
                    resource.salary == null || resource.salary!.isEmpty
                        ? 'Sin especificar'
                        : resource.salary!,
                    textAlign: TextAlign.center,
                    style: textTheme.bodyText1,
                  ),
                  const SpaceH30(),
                ],
              ),
            ),
          ),
        ),
      ],
    );
    /*
            if (resource.organizerName != null)
              Center(
                child: Text(
                  'Recomienda: ${resource.organizerName}',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15, color: Constants.textPrimary),
                ),
              ),
              */
  }

  Widget _buildActionButtons() {
    final auth = Provider.of<AuthBase>(context);
    final userId = auth.currentUser?.uid ?? '';
    final textTheme = Theme.of(context).textTheme;

    return Row(
      children: <Widget>[
        Expanded(
          flex: 6,
          child: Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () => {},
                  style: ButtonStyle(
                      backgroundColor:
                      MaterialStateProperty.all(resource.participants.contains(userId)
                          ? AppColors.chatDarkBlue : AppColors.turquoise),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ))),
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Text(
                      resource.participants.contains(userId)
                          ? StringConst.QUIT_RESOURCE
                          : StringConst.JOIN_RESOURCE,
                      style: textTheme.bodyText1?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                ),
              ),
              const SpaceW30(),
              InkWell(
                mouseCursor: MaterialStateMouseCursor.clickable,
                onTap: () {},
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 4,
                    top: 2,
                    right: 4,
                    bottom: 2,
                  ),
                  child: Column(
                    children: [
                      (resource.likes.contains(userId))
                          ? const Icon(
                        Icons.favorite,
                        color: AppColors.red,
                        size: 30,
                      )
                          : const Icon(Icons.favorite_outline_outlined,
                          color: AppColors.darkGray, size: 30),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 4,
          child: Container(),
        )
      ],
    );
  }

  Widget _buildMenuButton(BuildContext context, Resource resource) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    TextTheme textTheme = Theme.of(context).textTheme;
    return PopupMenuButton<int>(
      onSelected: (int value) {
        auth.currentUser == null
            ? _displayReportDialogVisitor(context, resource)
            : _displayReportDialog(context, resource);
      },
      itemBuilder: (context) {
        return List.generate(1, (index) {
          return PopupMenuItem(
            value: 1,
            child: Text('Denunciar el recurso',
              style: textTheme.button?.copyWith(
                height: 1.5,
                color: AppColors.red,
                fontWeight: FontWeight.w700,
              ),),
          );
        });
      },
      child: const Icon(
        Icons.more_vert,
        color: AppColors.greyAlt,
        size: 30.0,
      ),
    );
  }

  Future<void> _displayReportDialog(BuildContext context, Resource resource) async {
    final database = Provider.of<Database>(context, listen: false);
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
                ),
              ),
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
                style: TextButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                ),
                child: const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    'Cancelar',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          );
        });
  }

  String _getLocationText(Resource resource) {
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
        return StringConst.ONLINE_FOR_COUNTRY
            .replaceAll('país', resource.countryName!);

      case StringConst.ONLINE_FOR_PROVINCE:
        return StringConst.ONLINE_FOR_PROVINCE.replaceAll(
            'provincia', '${resource.provinceName!}, ${resource.countryName!}');

      case StringConst.ONLINE_FOR_CITY:
        return StringConst.ONLINE_FOR_CITY.replaceAll('ciudad',
            '${resource.cityName!}, ${resource.provinceName!}, ${resource.countryName!}');

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
                    onPressed: () => {},
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


}
