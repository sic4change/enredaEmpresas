import 'package:email_validator/email_validator.dart';
import 'package:enreda_empresas/app/common_widgets/custom_text_title.dart';
import 'package:enreda_empresas/app/common_widgets/enreda_button.dart';
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
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
                                        child:
                                        Stack(
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
                                                    ),
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
                                                    Expanded(
                                                        child:
                                                        Responsive.isMobile(context) || Responsive.isTablet(context)
                                                            ? _buildDetailsListViewMobile(context, resource)
                                                            : _buildDetailsListViewWeb(context, resource)),
                                                    const SpaceH30(),
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

  Widget _buildDetailsListViewWeb(BuildContext context, Resource resource) {
    double fontSize = responsiveSize(context, 12, 15, md: 14);
    TextTheme textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 80.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: Responsive.isMobile(context) ? 2 : 4,
            child: Padding(
              padding: const EdgeInsets.only(top: 30, right: 30.0),
              child: SingleChildScrollView(
                child: Text(
                  resource.description,
                  textAlign: TextAlign.left,
                  style: textTheme.bodySmall?.copyWith(
                    color: AppColors.greyTxtAlt,
                    height: 1.5,
                    fontSize: fontSize,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: Responsive.isMobile(context) ? 2 : 2,
            child: Container(
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.only(top: 30),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.greyDark, width: 1),
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextTitle(
                        title: StringConst.RESOURCE_TYPE.toUpperCase()),
                    CustomTextBody(text: '${resource.resourceTypeName}'),
                    const SpaceH16(),
                    CustomTextTitle(title: StringConst.LOCATION.toUpperCase()),
                    Row(
                      children: [
                        CustomTextBody(text: '${resource.countryName}'),
                        const CustomTextBody(text: ', '),
                        CustomTextBody(
                            text: '${resource.provinceName}'),
                      ],
                    ),
                    const SpaceH16(),
                    CustomTextTitle(title: StringConst.MODALITY.toUpperCase()),
                    CustomTextBody(text: resource.modality),
                    const SpaceH16(),
                    CustomTextTitle(title: StringConst.CAPACITY.toUpperCase()),
                    CustomTextBody(text: '${resource.capacity}'),
                    const SpaceH16(),
                    CustomTextTitle(title: StringConst.DATE.toUpperCase()),
                    DateFormat('dd/MM/yyyy').format(resource.start) ==
                        '31/12/2050'
                        ? const CustomTextBody(
                      text: StringConst.ALWAYS_AVAILABLE,
                    )
                        : Row(
                      children: [
                        CustomTextBody(
                            text: DateFormat('dd/MM/yyyy')
                                .format(resource.start)),
                        const SpaceW4(),
                        const CustomTextBody(text: '-'),
                        const SpaceW4(),
                        CustomTextBody(
                            text: DateFormat('dd/MM/yyyy')
                                .format(resource.end))
                      ],
                    ),
                    const SpaceH16(),
                    (resource.contractType != null && resource.contractType != '')
                        ? CustomTextTitle(
                        title: StringConst.CONTRACT_TYPE.toUpperCase())
                        : Container(),
                    (resource.contractType != null && resource.contractType != '')
                        ? CustomTextBody(text: '${resource.contractType}')
                        : Container(),
                    const SpaceH4(),
                    (resource.contractType != null && resource.contractType != '')
                        ? const SpaceH16()
                        : Container(),
                    CustomTextTitle(title: StringConst.DURATION.toUpperCase()),
                    CustomTextBody(text: resource.duration),
                    (resource.salary != null && resource.salary != '')
                        ? Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomTextTitle(
                            title: StringConst.SALARY.toUpperCase()),
                        CustomTextBody(text: '${resource.salary}')
                      ],
                    )
                        : Container(),
                    const SpaceH4(),
                    (resource.salary != null && resource.salary != '')
                        ? const SpaceH16()
                        : Container(),
                    resource.temporality == null
                        ? const SizedBox(
                      height: 0,
                    )
                        : CustomTextBody(text: '${resource.temporality}')
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsListViewMobile(BuildContext context, Resource resource) {
    double fontSize = responsiveSize(context, 12, 15, md: 14);
    TextTheme textTheme = Theme.of(context).textTheme;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 30, right: 30.0),
            child: Text(
              resource.description,
              textAlign: TextAlign.left,
              style: textTheme.bodyText1?.copyWith(
                color: AppColors.greyTxtAlt,
                height: 1.5,
                fontWeight: FontWeight.w400,
                fontSize: fontSize,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            margin: const EdgeInsets.only(top: 30),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.greyDark, width: 1),
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTextTitle(title: StringConst.RESOURCE_TYPE.toUpperCase()),
                CustomTextBody(text: '${resource.resourceTypeName}'),
                const SpaceH16(),
                CustomTextTitle(title: StringConst.LOCATION.toUpperCase()),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextBody(text: resource.modality),
                    resource.modality == StringConst.ONLINE
                        ? Container()
                        : Row(
                      children: [
                        CustomTextBody(text: '${resource.countryName}'),
                        const CustomTextBody(text: ', '),
                        CustomTextBody(text: '${resource.provinceName}'),
                      ],
                    ),
                  ],
                ),
                const SpaceH16(),
                CustomTextTitle(title: StringConst.CAPACITY.toUpperCase()),
                CustomTextBody(text: '${resource.capacity}'),
                const SpaceH16(),
                CustomTextTitle(title: StringConst.DURATION.toUpperCase()),
                CustomTextBody(text: resource.duration),
                const SpaceH16(),
                (resource.contractType != null && resource.contractType != '')
                    ? CustomTextTitle(
                    title: StringConst.CONTRACT_TYPE.toUpperCase())
                    : Container(),
                (resource.contractType != null && resource.contractType != '')
                    ? CustomTextBody(text: '${resource.contractType}')
                    : Container(),
                const SpaceH4(),
                (resource.contractType != null && resource.contractType != '')
                    ? const SpaceH16()
                    : Container(),
                (resource.salary != null && resource.salary != '')
                    ? Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextTitle(
                        title: StringConst.SALARY.toUpperCase()),
                    CustomTextBody(text: '${resource.salary}')
                  ],
                )
                    : Container(),
                const SpaceH4(),
                (resource.salary != null && resource.salary != '')
                    ? const SpaceH16()
                    : Container(),
                CustomTextTitle(title: StringConst.DATE.toUpperCase()),
                DateFormat('dd/MM/yyyy').format(resource.start) == '31/12/2050'
                    ? const CustomTextBody(
                  text: StringConst.ALWAYS_AVAILABLE,
                )
                    : Row(
                  children: [
                    CustomTextBody(
                        text: DateFormat('dd/MM/yyyy')
                            .format(resource.start)),
                    const SpaceW4(),
                    const CustomTextBody(text: '-'),
                    const SpaceW4(),
                    CustomTextBody(
                        text: DateFormat('dd/MM/yyyy').format(resource.end))
                  ],
                ),
                resource.temporality == null
                    ? const SizedBox(
                  height: 0,
                )
                    : CustomTextBody(text: '${resource.temporality}')
              ],
            ),
          ),
          const SpaceH20(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              EnredaButton(
                buttonTitle: StringConst.JOIN_RESOURCE,
                onPressed: () => {},
              ),
            ],
          ),
          const SpaceH20(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              //buildShareButton(context, resource, AppColors.darkBlue),
              IconButton(
                icon: const FaIcon(FontAwesomeIcons.heart),
                tooltip: 'Me gusta',
                color: AppColors.penBlue,
                iconSize: 24,
                onPressed: () => {},
              ),
            ],
          ),
        ],
      ),
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
