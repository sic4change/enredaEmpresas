import 'package:cached_network_image/cached_network_image.dart';
import 'package:enreda_empresas/app/common_widgets/build_share_button.dart';
import 'package:enreda_empresas/app/common_widgets/custom_text_title.dart';
import 'package:enreda_empresas/app/common_widgets/spaces.dart';
import 'package:enreda_empresas/app/home/resources/list_item_builder.dart';
import 'package:enreda_empresas/app/home/resources/list_item_builder_grid.dart';
import 'package:enreda_empresas/app/home/resources/resource_detail_dialog.dart';
import 'package:enreda_empresas/app/home/resources/resource_list_tile.dart';
import 'package:enreda_empresas/app/models/city.dart';
import 'package:enreda_empresas/app/models/country.dart';
import 'package:enreda_empresas/app/models/organization.dart';
import 'package:enreda_empresas/app/models/province.dart';
import 'package:enreda_empresas/app/models/resource.dart';
import 'package:enreda_empresas/app/models/resourcePicture.dart';
import 'package:enreda_empresas/app/models/userEnreda.dart';
import 'package:enreda_empresas/app/services/auth.dart';
import 'package:enreda_empresas/app/services/database.dart';
import 'package:enreda_empresas/app/utils/adaptative.dart';
import 'package:enreda_empresas/app/utils/responsive.dart';
import 'package:enreda_empresas/app/values/strings.dart';
import 'package:enreda_empresas/app/values/values.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../common_widgets/precached_avatar.dart';

class MyResourcesListPage extends StatefulWidget {
  const MyResourcesListPage({super.key});

  @override
  State<MyResourcesListPage> createState() => _MyResourcesListPageState();
}

class _MyResourcesListPageState extends State<MyResourcesListPage> {
  Widget? _currentPage;
  List<UserEnreda>? myParticipantsList = [];

  @override
  void initState() {
    _currentPage = _buildResourcesList(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      padding: EdgeInsets.all(Sizes.mainPadding),
      margin: EdgeInsets.all(Sizes.mainPadding),
      decoration: BoxDecoration(
        color: AppColors.altWhite,
        shape: BoxShape.rectangle,
        border: Border.all(color: AppColors.greyLight2.withOpacity(0.3), width: 1),
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Text(StringConst.RESOURCES_CREATED_BY,
              style: textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 30.0,
                  color: AppColors.greyDark2),),
          ),
          Container(
              margin: EdgeInsets.only(top: Sizes.mainPadding * 3),
              child: _currentPage),
        ],
      ),
    );
  }

  Widget _buildResourcesList(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    final database = Provider.of<Database>(context, listen: false);
    return StreamBuilder<UserEnreda>(
        stream: database.userEnredaStreamByUserId(auth.currentUser!.uid),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasData) {
            var user = snapshot.data!;
            return StreamBuilder<List<Resource>>(
                stream: database.myResourcesStream(user.organization!),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasData) {
                    return ListItemBuilderGrid<Resource>(
                      snapshot: snapshot,
                      fitSmallerLayout: false,
                      itemBuilder: (context, resource) {
                        return StreamBuilder<Organization>(
                          stream:
                              database.organizationStream(resource.organizer),
                          builder: (context, snapshot) {
                            final organization = snapshot.data;
                            resource.organizerName =
                                organization == null ? '' : organization.name;
                            resource.organizerImage =
                                organization == null ? '' : organization.photo;
                            resource.setResourceTypeName();
                            resource.setResourceCategoryName();
                            return StreamBuilder<Country>(
                                stream:
                                    database.countryStream(resource.country),
                                builder: (context, snapshot) {
                                  final country = snapshot.data;
                                  resource.countryName =
                                      country == null ? '' : country.name;
                                  return StreamBuilder<Province>(
                                    stream: database
                                        .provinceStream(resource.province),
                                    builder: (context, snapshot) {
                                      final province = snapshot.data;
                                      resource.provinceName =
                                          province == null ? '' : province.name;
                                      return StreamBuilder<City>(
                                          stream: database
                                              .cityStream(resource.city),
                                          builder: (context, snapshot) {
                                            final city = snapshot.data;
                                            resource.cityName =
                                                city == null ? '' : city.name;
                                            return StreamBuilder<
                                                    ResourcePicture>(
                                                stream: database
                                                    .resourcePictureStream(
                                                        resource
                                                            .resourcePictureId),
                                                builder: (context, snapshot) {
                                                  final resourcePicture =
                                                      snapshot.data;
                                                  resource.resourcePhoto =
                                                      resourcePicture
                                                          ?.resourcePic;
                                                  return Container(
                                                    key: Key(
                                                        'resource-${resource.resourceId}'),
                                                    child: ResourceListTile(
                                                      resource: resource,
                                                      onTap: () => setState(() {
                                                        _currentPage =
                                                            _myResourcesPage(
                                                                resource);
                                                      }),
                                                    ),
                                                  );
                                                });
                                          });
                                    },
                                  );
                                });
                          },
                        );
                      },
                      emptyTitle: 'Sin recursos',
                      emptyMessage: 'Aún no has creado ningún recurso',
                    );
                  }
                  return const Center(child: CircularProgressIndicator());
                });
          }
          return const Center(child: CircularProgressIndicator());
        });
  }

  Widget _myResourcesPage(Resource resource) {
    TextTheme textTheme = Theme.of(context).textTheme;
    double fontSizeTitle = responsiveSize(context, 14, 22, md: 18);
    double fontSizePromotor = responsiveSize(context, 12, 16, md: 14);
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.grey,
            ),
            onPressed: () => setState(() {
              _currentPage = _buildResourcesList(context);
            }),
          ),
          Flex(
            direction: Responsive.isMobile(context) ||
                    Responsive.isTablet(context) ||
                    Responsive.isDesktopS(context)
                ? Axis.vertical
                : Axis.horizontal,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                  flex: Responsive.isMobile(context) ||
                          Responsive.isTablet(context) ||
                          Responsive.isDesktopS(context)
                      ? 0
                      : 6,
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 40.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.rectangle,
                            border: Border.all(
                                color: AppColors.greyLight2.withOpacity(0.2),
                                width: 1),
                            borderRadius: BorderRadius.circular(Consts.padding),
                          ),
                          child: Column(
                            children: [
                              Responsive.isMobile(context)
                                  ? const SpaceH20()
                                  : const SpaceH60(),
                              Padding(
                                padding: const EdgeInsets.only(
                                    right: 30.0, left: 30.0),
                                child: Text(
                                  resource.title,
                                  textAlign: TextAlign.center,
                                  maxLines:
                                      Responsive.isMobile(context) ? 2 : 1,
                                  style: textTheme.bodyText1?.copyWith(
                                    letterSpacing: 1.2,
                                    color: AppColors.greyTxtAlt,
                                    height: 1.5,
                                    fontWeight: FontWeight.w300,
                                    fontSize: fontSizeTitle,
                                  ),
                                ),
                              ),
                              const SpaceH4(),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    resource.promotor != null
                                        ? resource.promotor!
                                        : resource.organizerName ?? '',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      letterSpacing: 1.2,
                                      fontSize: fontSizePromotor,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.penBlue,
                                    ),
                                  ),
                                ],
                              ),
                              const Padding(
                                padding: EdgeInsets.all(10.0),
                                child: Divider(
                                  color: AppColors.grey150,
                                  thickness: 1,
                                ),
                              ),
                              Flex(
                                direction: Responsive.isMobile(context) ||
                                        Responsive.isTablet(context) ||
                                        Responsive.isDesktopS(context)
                                    ? Axis.vertical
                                    : Axis.horizontal,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                      flex: Responsive.isMobile(context) ||
                                              Responsive.isTablet(context) ||
                                              Responsive.isDesktopS(context)
                                          ? 0
                                          : 4,
                                      child: _buildDetailResource(
                                          context, resource)),
                                  SizedBox(
                                    height: 600,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Expanded(
                                            flex:
                                                Responsive.isMobile(context) ||
                                                        Responsive.isTablet(
                                                            context) ||
                                                        Responsive.isDesktopS(
                                                            context)
                                                    ? 0
                                                    : 2,
                                            child: _buildDetailCard(
                                                context, resource)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      resource.organizerImage == null ||
                              resource.organizerImage!.isEmpty
                          ? Container()
                          : Align(
                              alignment: Alignment.topCenter,
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 1.0, color: AppColors.greyLight),
                                    borderRadius: BorderRadius.circular(
                                      100,
                                    ),
                                    color: AppColors.greyLight),
                                child: CircleAvatar(
                                  radius:
                                      Responsive.isMobile(context) ? 28 : 40,
                                  backgroundColor: AppColors.white,
                                  backgroundImage:
                                      NetworkImage(resource.organizerImage!),
                                ),
                              ),
                            ),
                    ],
                  )),
              Expanded(
                  flex: Responsive.isMobile(context) ||
                          Responsive.isTablet(context) ||
                          Responsive.isDesktopS(context)
                      ? 0
                      : 3,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                          color: AppColors.greyLight2.withOpacity(0.2),
                          width: 1),
                      borderRadius: BorderRadius.circular(Consts.padding),
                    ),
                    alignment: Alignment.center,
                    margin: const EdgeInsets.only(top: 40.0, left: 10),
                    padding: const EdgeInsets.all(20.0),
                    child: SingleChildScrollView(
                        child: _buildParticipantsList(context, resource.resourceId)),
                  ))
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailResource(BuildContext context, Resource resource) {
    double fontSize = responsiveSize(context, 12, 15, md: 14);
    TextTheme textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Text(
            resource.description,
            textAlign: TextAlign.left,
            style: textTheme.bodySmall?.copyWith(
              color: AppColors.greyTxtAlt,
              height: 1.5,
              fontSize: fontSize,
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          buildShareButton(context, resource, AppColors.darkGray),
          const SizedBox(
            height: 30,
          ),
        ],
      ),
    );
  }

  Widget _buildDetailCard(BuildContext context, Resource resource) {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.all(20),
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
          Row(
            children: [
              CustomTextBody(text: '${resource.countryName}'),
              const CustomTextBody(text: ', '),
              CustomTextBody(text: '${resource.provinceName}'),
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
          DateFormat('dd/MM/yyyy').format(resource.start) == '31/12/2050'
              ? const CustomTextBody(
                  text: StringConst.ALWAYS_AVAILABLE,
                )
              : Row(
                  children: [
                    CustomTextBody(
                        text: DateFormat('dd/MM/yyyy').format(resource.start)),
                    const SpaceW4(),
                    const CustomTextBody(text: '-'),
                    const SpaceW4(),
                    CustomTextBody(
                        text: DateFormat('dd/MM/yyyy').format(resource.end))
                  ],
                ),
          const SpaceH16(),
          (resource.contractType != null && resource.contractType != '')
              ? CustomTextTitle(title: StringConst.CONTRACT_TYPE.toUpperCase())
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
                    CustomTextTitle(title: StringConst.SALARY.toUpperCase()),
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
    );
  }

  Widget _buildParticipantsList(BuildContext context, String resourceId) {
    final database = Provider.of<Database>(context, listen: false);
    return StreamBuilder<List<UserEnreda>>(
      stream: database.participantsByResourceStream(resourceId),
      builder: (context, snapshot) {
        return ListItemBuilder(
            snapshot: snapshot,
            emptyTitle: 'Sin participantes',
            emptyMessage: 'Aún no se ha registrado ningún participante',
            itemBuilder: (context, user) {
              return  Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    _buildMyUserFoto(context, user.photo!),
                    const SpaceW20(),
                    Text('${user.firstName!} ${user.lastName!}'),
                  ],
                ),
              );
            }
        );
      },
    );
  }

  Widget _buildMyUserFoto(BuildContext context, String profilePic) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            !kIsWeb ?
            ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(60)),
              child:
              Center(
                child:
                profilePic == "" ?
                Container(
                  color:  Colors.transparent,
                  height: 40,
                  width: 40,
                  child: Image.asset(ImagePath.USER_DEFAULT),
                ):
                CachedNetworkImage(
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
                    alignment: Alignment.center,
                    imageUrl: profilePic),
              ),
            ):
            ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(60)),
              child:
              profilePic == "" ?
              Container(
                color:  Colors.transparent,
                height: 40,
                width: 40,
                child: Image.asset(ImagePath.USER_DEFAULT),
              ):
              PrecacheAvatarCard(
                imageUrl: profilePic,
              ),
            )
          ],
        ),
      ],
    );
  }
}
