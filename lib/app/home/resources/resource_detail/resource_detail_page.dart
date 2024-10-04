import 'package:enreda_empresas/app/common_widgets/add_yellow_button.dart';
import 'package:enreda_empresas/app/common_widgets/alert_dialog.dart';
import 'package:enreda_empresas/app/common_widgets/build_share_button.dart';
import 'package:enreda_empresas/app/common_widgets/custom_dialog.dart';
import 'package:enreda_empresas/app/common_widgets/custom_text.dart';
import 'package:enreda_empresas/app/common_widgets/enreda_button.dart';
import 'package:enreda_empresas/app/common_widgets/spaces.dart';
import 'package:enreda_empresas/app/common_widgets/user_avatar.dart';
import 'package:enreda_empresas/app/home/resources/list_item_builder.dart';
import 'package:enreda_empresas/app/home/resources/resource_competencies_stream.dart';
import 'package:enreda_empresas/app/home/resources/resource_detail/box_item_data.dart';
import 'package:enreda_empresas/app/home/resources/resource_detail/invite_users_page.dart';
import 'package:enreda_empresas/app/home/resources/resource_detail_dialog.dart';
import 'package:enreda_empresas/app/home/resources/resource_interests_stream.dart';
import 'package:enreda_empresas/app/models/city.dart';
import 'package:enreda_empresas/app/models/competency.dart';
import 'package:enreda_empresas/app/models/country.dart';
import 'package:enreda_empresas/app/models/interest.dart';
import 'package:enreda_empresas/app/models/jobOffer.dart';
import 'package:enreda_empresas/app/models/province.dart';
import 'package:enreda_empresas/app/models/resource.dart';
import 'package:enreda_empresas/app/models/company.dart';
import 'package:enreda_empresas/app/models/userEnreda.dart';
import 'package:enreda_empresas/app/services/database.dart';
import 'package:enreda_empresas/app/utils/adaptative.dart';
import 'package:enreda_empresas/app/utils/responsive.dart';
import 'package:enreda_empresas/app/values/strings.dart';
import 'package:enreda_empresas/app/values/values.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:enreda_empresas/app/home/resources/global.dart' as globals;
import '../manage_offers_page.dart';

class ResourceDetailPage extends StatefulWidget {
  const ResourceDetailPage({Key? key}) : super(key: key);

  @override
  State<ResourceDetailPage> createState() => _ResourceDetailPageState();
}

class _ResourceDetailPageState extends State<ResourceDetailPage> {

  @override
  Widget build(BuildContext context) {
    return _buildResourcePage(context, globals.currentResource!, globals.currentJobOffer!);
  }

  Widget _buildResourcePage(BuildContext context, Resource resource, JobOffer jobOffer) {
    List<String> interestsLocal = [];
    List<String> competenciesLocal = [];
    Set<Interest> selectedInterests = {};
    Set<Competency> selectedCompetencies = {};
    final database = Provider.of<Database>(context, listen: false);
    return StreamBuilder<Resource>(
        stream: resource.resourceId != null && resource.resourceId!.isNotEmpty
            ? database.resourceStream(resource.resourceId)
            : Stream.value(globals.currentResource!),  // Stream to create a new resource
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
                child: CircularProgressIndicator());
          }
          if (snapshot.hasData) {
            Resource resource = snapshot.data!;
            resource.setResourceTypeName();
            resource.setResourceCategoryName();
            if (resource.resourceId == null) {
              return const Center(
                  child: CircularProgressIndicator());
            }
            return StreamBuilder<Company>(
              stream: database.companyStream(resource.organizer),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                      child: CircularProgressIndicator());
                }
                final organization = snapshot.data;
                globals.organizerCurrentResource = organization;
                resource.organizerName =
                organization == null ? '' : organization.name;
                resource.organizerImage =
                organization == null ? '' : organization.photo;
                interestsLocal = resource.interests ?? [];
                competenciesLocal = resource.competencies ?? [];
                globals.interestsCurrentResource = resource.interests ?? [];
                resource.setResourceTypeName();
                resource.setResourceCategoryName();
                return StreamBuilder<Country>(
                    stream: database.countryStream(resource.address?.country),
                    builder: (context, snapshot) {
                      final country = snapshot.data;
                      resource.countryName = country == null ? '' : country.name;
                      resource.province ?? "";
                      resource.city ?? "";
                      return StreamBuilder<Province>(
                        stream: database.provinceStream(resource.address?.province),
                        builder: (context, snapshot) {
                          final province = snapshot.data;
                          resource.provinceName = province == null ? '' : province.name;
                          return StreamBuilder<City>(
                              stream: database
                                  .cityStream(resource.address?.city),
                              builder: (context, snapshot) {
                                final city = snapshot.data;
                                resource.cityName = city == null ? '' : city.name;
                                return StreamBuilder<List<Interest>>(
                                    stream: database.resourcesInterestsStream(interestsLocal),
                                    builder: (context, snapshotInterest) {
                                      if (snapshotInterest.hasData) {
                                        selectedInterests = snapshotInterest.data!.toSet();
                                        globals.selectedInterestsCurrentResource = snapshotInterest.data!.toSet();
                                        globals.interestsNamesCurrentResource = 
                                            selectedInterests.map((item) => item.name).join(' / ');
                                        return StreamBuilder<List<Competency>>(
                                            stream: database.resourcesCompetenciesStream(competenciesLocal),
                                            builder: (context, snapshotCompetencies) {
                                              if(!snapshotCompetencies.hasData) {
                                                selectedCompetencies = {};
                                                globals.selectedCompetenciesCurrentResource = {};
                                                globals.competenciesNamesCurrentResource = '';
                                                return Responsive.isMobile(context) ? _buildResourceDetailMobile(context, resource, jobOffer) :
                                                  _buildResourceDetailWeb(context, resource, jobOffer);
                                              }
                                              if (snapshotCompetencies.hasData) {
                                                selectedCompetencies = snapshotCompetencies.data!.toSet();
                                                globals.selectedCompetenciesCurrentResource = snapshotCompetencies.data!.toSet();
                                                globals.competenciesNamesCurrentResource = 
                                                    selectedCompetencies.map((item) => item.name).join(' / ');
                                                return Responsive.isMobile(context) ? _buildResourceDetailMobile(context, resource, jobOffer) :
                                                  _buildResourceDetailWeb(context, resource, jobOffer);
                                              }
                                              return Container();
                                            }
                                        );
                                      }
                                      return Container();
                                    });
                              });
                        },
                      );
                    });
              },
            );
          }
          return const Center(child: CircularProgressIndicator());
        });
  }

  Widget _buildResourceDetailWeb(BuildContext context, Resource resource, JobOffer jobOffer) {
    TextTheme textTheme = Theme.of(context).textTheme;
    double fontSizeTitle = responsiveSize(context, 14, 22, md: 18);
    double fontSizePromotor = responsiveSize(context, 12, 16, md: 14);
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                      Container(
                        constraints: BoxConstraints(
                          maxWidth: resource.organizer == globals.currentUserCompany?.companyId
                              ? MediaQuery.of(context).size.width
                              : MediaQuery.of(context).size.width * 0.5,
                        ),
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          border: Border.all(
                              color: Responsive.isMobile(context) ? Colors.transparent : AppColors.greyLight2.withOpacity(0.2),
                              width: 1),
                          borderRadius: BorderRadius.circular(Consts.padding),
                        ),
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(ImagePath.RECTANGLE_RESOURCE),
                                  fit: BoxFit.cover,
                                ),
                                borderRadius: BorderRadius.only(
                                    bottomRight: Radius.circular(Consts.padding),
                                    bottomLeft: Radius.circular(Consts.padding)),
                              ),
                              margin: const EdgeInsets.symmetric(horizontal: 20.0),
                              child: Column(
                                  children: [
                                    Responsive.isMobile(context)
                                        ? const SpaceH8()
                                        : const SpaceH20(),
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
                                    Padding(
                                      padding: const EdgeInsets.only(top: 10, right: 30.0, left: 30.0),
                                      child: Text(
                                        resource.title,
                                        textAlign: TextAlign.center,
                                        maxLines:
                                        Responsive.isMobile(context) ? 2 : 1,
                                        style: textTheme.bodySmall?.copyWith(
                                          letterSpacing: 1.2,
                                          color: AppColors.white,
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
                                              ? resource.promotor != ""
                                              ? resource.promotor!
                                              : resource.organizerName!
                                              : resource.organizerName!,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            letterSpacing: 1.2,
                                            fontSize: fontSizePromotor,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                    resource.resourceId == null || resource.resourceId!.isEmpty ? SpaceH20() :
                                    resource.organizer == globals.currentUserCompany?.companyId ? Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                                          child: EnredaButtonIcon(
                                            onPressed: () => {
                                              setState(() {
                                                ManageOffersPage.selectedIndex.value = 2;
                                              })
                                            },
                                            buttonColor: Colors.white,
                                            padding: const EdgeInsets.all(0),
                                            width: 80,
                                            height: 10,
                                            widget: Icon(
                                              Icons.edit_outlined,
                                              color: AppColors.greyTxtAlt,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                                          child: EnredaButtonIcon(
                                            onPressed: () => _confirmDeleteResource(context, resource),
                                            buttonColor: Colors.white,
                                            padding: const EdgeInsets.all(0),
                                            width: 80,
                                            height: 10,
                                            widget: Icon(
                                              Icons.delete_outline,
                                              color: AppColors.greyTxtAlt,
                                            ),

                                          ),
                                        ),
                                        buildShare(context, resource, AppColors.darkGray, AppColors.darkGray, Colors.white),
                                        SizedBox(width: 10),
                                      ],
                                    ) : Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        buildShare(context, resource, AppColors.darkGray, AppColors.darkGray, Colors.white),
                                        SizedBox(width: 10),
                                      ],
                                    ),
                                  ]
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                              child: _buildBoxes(resource),
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
                                        context, resource, jobOffer)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  )),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildResourceDetailMobile(BuildContext context, Resource resource, JobOffer jobOffer) {
    TextTheme textTheme = Theme.of(context).textTheme;
    double fontSizeTitle = responsiveSize(context, 14, 22, md: 18);
    double fontSizePromotor = responsiveSize(context, 12, 16, md: 14);
    return SingleChildScrollView(
      child: Container(
        margin: MediaQuery.of(context).size.width >= 1200 ?
        EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.1) : EdgeInsets.zero,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.rectangle,
          border: Border.all(
              color: Responsive.isMobile(context) ? Colors.transparent :AppColors.greyLight2.withOpacity(0.2),
              width: Responsive.isMobile(context) ? 0 : 1),
          borderRadius: BorderRadius.circular(Sizes.MARGIN_16),
        ),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(ImagePath.RECTANGLE_RESOURCE),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                  children: [
                    resource.resourceId == null || resource.resourceId!.isEmpty ? Container() :
                    Row(
                      children: [
                        Spacer(),
                        Container(
                            height: 50,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                                  child: InkWell(
                                    onTap: () => {
                                      setState(() {
                                        ManageOffersPage.selectedIndex.value = 2;
                                      })
                                    },
                                    child: Icon(
                                      Icons.edit_outlined,
                                      color: AppColors.white,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                                  child: InkWell(
                                    onTap: () => _confirmDeleteResource(context, resource),
                                    child: Icon(
                                      Icons.delete_outline,
                                      color: AppColors.white,
                                    ),
                                  ),
                                ),
                                buildShare(context, resource, AppColors.darkGray, AppColors.white, Colors.transparent),
                                SpaceW8(),
                              ],
                            ))
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Spacer(),
                        Align(
                          alignment: Alignment.topCenter,
                          child: resource.organizerImage == null || resource.organizerImage!.isEmpty ? Container() :
                          Container(
                            decoration: BoxDecoration(
                                border: Border.all(width: 1.0, color: AppColors.greyLight),
                                borderRadius: BorderRadius.circular(100,),
                                color: AppColors.greyLight),
                            child: CircleAvatar(
                              radius: Responsive.isMobile(context) ? 28 : 40,
                              backgroundColor: AppColors.white,
                              backgroundImage: NetworkImage(resource.organizerImage!),
                            ),
                          ),
                        ),
                        Spacer(),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10, right: 30.0, left: 30.0),
                      child: Text(
                        resource.title.toUpperCase(),
                        textAlign: TextAlign.center,
                        maxLines:
                        Responsive.isMobile(context) ? 2 : 1,
                        style: textTheme.bodySmall?.copyWith(
                          letterSpacing: 1.2,
                          color: AppColors.white,
                          height: 1.5,
                          fontWeight: FontWeight.w300,
                          fontSize: fontSizeTitle,
                        ),
                      ),
                    ),
                    SpaceH4(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            resource.promotor != null
                                ? resource.promotor != ""
                                ? resource.promotor!
                                : resource.organizerName!
                                : resource.organizerName!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              letterSpacing: 1.2,
                              fontSize: fontSizePromotor,
                              fontWeight: FontWeight.bold,
                              color: AppColors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SpaceH20(),
                    _buildBoxes(resource),
                    SpaceH20(),
                  ]
              ),
            ),
            _buildDetailResource(context, resource, jobOffer),
            SpaceH20(),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailResource(BuildContext context, Resource resource, JobOffer jobOffer) {
    TextTheme textTheme = Theme.of(context).textTheme;
    int _getTypeIndex(String type) {
      switch (type) {
        case 'academic':
          return 0;
        case 'experience':
          return 1;
        case 'languages':
          return 2;
        case 'competencies':
          return 3;
        default:
          return -1; // indicate an invalid type
      }
    }
    String _getDisplayText(String type) {
      List<String> textValues = [
        'Formación académica',
        'Nivel de experiencia',
        'Idiomas',
        'Competencias',
      ];

      int index = _getTypeIndex(type);

      if (index >= 0 && index < textValues.length) {
        return textValues[index];
      } else {
        return '';
      }
    }
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTextSmallBold(
            title: StringConst.FORM_DESCRIPTION.toUpperCase(), color: AppColors.primary900,
          ),
          const SizedBox(height: 10,),
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: Text(
              resource.description,
              textAlign: TextAlign.left,
              style: textTheme.bodyMedium?.copyWith(
                color: AppColors.greyTxtAlt,
                height: 1.5,
              ),
            ),
          ),
          jobOffer.responsibilities != null ? Text(
            StringConst.RESPONSIBILITIES,
          ) : Container(),
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: Text(
              jobOffer.responsibilities ?? '',
              textAlign: TextAlign.left,
              style: textTheme.bodyMedium?.copyWith(
                color: AppColors.greyTxtAlt,
                height: 1.5,
              ),
            ),
          ),
          jobOffer.functions != null ? Text(
            StringConst.FUNCTIONS,
          ) : Container(),
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: Text(
              jobOffer.functions ?? '',
              textAlign: TextAlign.left,
              style: textTheme.bodyMedium?.copyWith(
                color: AppColors.greyTxtAlt,
                height: 1.5,
              ),
            ),
          ),
          jobOffer.otherRequirements != null ? Text(
            StringConst.OTHER_REQUIREMENTS,
          ) : Container(),
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: Text(
              jobOffer.otherRequirements ?? '',
              textAlign: TextAlign.left,
              style: textTheme.bodyMedium?.copyWith(
                color: AppColors.greyTxtAlt,
                height: 1.5,
              ),
            ),
          ),
          CustomTextSmallBold(title: StringConst.CRITERIA_JOB_OFFER.toUpperCase(), color: AppColors.primary900),
          SizedBox(height: 10),
          ListView.builder(
            shrinkWrap: true,
            itemCount: jobOffer.criteria?.length,
            itemBuilder: (context, index) {
              final item = jobOffer.criteria?[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CustomTextSmallBold(title: _getDisplayText(item?.type ?? ''), color: AppColors.primary900),
                        CustomTextSmallBold(title: ' - Peso: ${item?.weight} %', color: AppColors.primary900,),
                      ],
                    ),
                    item?.requirementText != null ? CustomTextSmall(text: item!.requirementText!, maxLines: 30,) : Container(),
                    item?.competencies != null ?
                    Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: CompetenciesByResource(competenciesIdList: item!.competencies!)) : Container(),
                    SizedBox(height: 10),
                  ],
                ),
              );
            },
          ),
          SizedBox(height: 10),
          _buildInformationResource(context, resource),
        ],
      ),
    );
  }

  Widget _buildInformationResource(BuildContext context, Resource resource) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextSmallBold(
          title: StringConst.FORM_SECTOR.toUpperCase(), color: AppColors.primary900,
        ),
        const SizedBox(height: 10,),
        Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: InterestsByResource(interestsIdList: resource.interests!,),
        ),
        const SizedBox(height: 10,),
        CustomTextSmallBold(
          title: StringConst.AVAILABLE.toUpperCase(), color: AppColors.primary900,
        ),
        Container(
            width: 130,
            decoration: BoxDecoration(
              border: Border.all(
                  color: AppColors.greyLight2.withOpacity(0.2),
                  width: 1),
              borderRadius: BorderRadius.circular(Consts.padding),
            ),
            alignment: Alignment.center,
            padding: const EdgeInsets.all(4.0),
            margin: const EdgeInsets.only(top: 10.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 8,
                  width: 8,
                  decoration: BoxDecoration(
                    color: resource.status == "No disponible" ? Colors.green : resource.status == "edition" ? Colors.orange : Colors.lightGreenAccent,
                    borderRadius: BorderRadius.circular(Consts.padding),
                  ),
                ),
                const SizedBox(width: 15),
                CustomTextBody(text:
                resource.status == 'edition' ? 'Borrador' : '${resource.status}',),
              ],
            )),
        const SizedBox(height: 30,),
      ],
    );
  }

  Widget _buildBoxes(Resource resource) {
    List<BoxItemData> boxItemData = [
      BoxItemData(
          icon: Image.asset(Responsive.isMobile(context) ? ImagePath.ICON_MODALITY_YELLOW
              : ImagePath.ICON_MODALITY),
          title: StringConst.RESOURCE_TYPE,
          contact: '${resource.resourceCategoryName}'
      ),
      BoxItemData(
        icon: Image.asset(Responsive.isMobile(context) ? ImagePath.ICON_PLACE_YELLOW
            : ImagePath.ICON_PLACE),
        title: StringConst.LOCATION,
        contact: getLocationText(resource)!,
      ),
      BoxItemData(
        icon: Image.asset(Responsive.isMobile(context) ? ImagePath.ICON_MODALITY_YELLOW
            : ImagePath.ICON_MODALITY),
        title: StringConst.MODALITY,
        contact: '${resource.modality}',
      ),
      BoxItemData(
        icon: Image.asset(Responsive.isMobile(context) ? ImagePath.ICON_SEATS_YELLOW
            : ImagePath.ICON_SEATS),
        title: StringConst.CAPACITY,
        contact: '${resource.capacity}',
      ),
      BoxItemData(
        icon: Image.asset(Responsive.isMobile(context) ? ImagePath.ICON_DATE_YELLOW
            : ImagePath.ICON_DATE),
        title: StringConst.DATE,
        contact: '${DateFormat('dd/MM/yyyy').format(resource.start!)} - ${DateFormat('dd/MM/yyyy').format(resource.end!)}',
      ),
      if (resource.contractType != null && resource.contractType != '') BoxItemData(
        icon: Image.asset(Responsive.isMobile(context) ? ImagePath.ICON_CONTRACT_YELLOW
            : ImagePath.ICON_CONTRACT),
        title: StringConst.CONTRACT_TYPE,
        contact: resource.contractType != null && resource.contractType != ''  ? '${resource.contractType}' : 'Sin especificar',
      ),
      if (resource.temporality != null && resource.temporality != '') BoxItemData(
        icon: Image.asset(Responsive.isMobile(context) ? ImagePath.ICON_CONTRACT_YELLOW
            : ImagePath.ICON_CONTRACT),
        title: StringConst.FORM_SCHEDULE,
        contact: resource.temporality != null && resource.temporality != ''  ? '${resource.temporality}' :  'Sin especificar',
      ),
      if (resource.salary != null && resource.salary != '') BoxItemData(
        icon: Image.asset(Responsive.isMobile(context) ? ImagePath.ICON_CURRENCY_YELLOW
            : ImagePath.ICON_CURRENCY),
        title: StringConst.SALARY,
        contact: resource.salary != null && resource.salary != ''  ? '${resource.salary}' :  'Sin especificar',
      ),
    ];
    const int crossAxisCount = 2; // The number of columns in the grid
    const double maxCrossAxisExtent = 250;
    const double mainAxisExtent = 70;
    const double childAspectRatio = 6 / 2;
    const double crossAxisSpacing = 10;
    const double mainAxisSpacing = 10;
    int rowCount = (boxItemData.length / crossAxisCount).ceil();
    double gridHeight = rowCount * mainAxisExtent + (rowCount - 1) * mainAxisSpacing;
    double gridHeightD = rowCount * mainAxisExtent + (rowCount - 17) * mainAxisSpacing;
    return Responsive.isMobile(context) ?
    SizedBox(
      height: gridHeight * 0.85,
      child: ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          scrollDirection: Axis.vertical,
          itemCount: boxItemData.length,
          itemBuilder: (BuildContext context, index) {
            return BoxItem(
              icon: boxItemData[index].icon,
              title: boxItemData[index].title,
              contact: boxItemData[index].contact,
            );
          }),
    ) :
    Container(
      height: Responsive.isDesktop(context) ? gridHeightD : gridHeight,
      child: GridView.builder(
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: maxCrossAxisExtent,
              mainAxisExtent: mainAxisExtent,
              childAspectRatio: childAspectRatio,
              crossAxisSpacing: crossAxisSpacing,
              mainAxisSpacing: mainAxisSpacing),
          itemCount: boxItemData.length,
          itemBuilder: (BuildContext context, index) {
            return BoxItem(
              icon: boxItemData[index].icon,
              title: boxItemData[index].title,
              contact: boxItemData[index].contact,
            );
          }),
    );
  }
  
  Widget _buildParticipantsList(BuildContext context, Resource resource) {
    final database = Provider.of<Database>(context, listen: false);
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          StreamBuilder<List<UserEnreda>>(
            stream: database.participantsByResourceStream(resource.resourceId!),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }
              return ListItemBuilder(
                  snapshot: snapshot,
                  emptyTitle: 'Sin participantes',
                  emptyMessage: 'Aún no se ha registrado ningún aplicante',
                  itemBuilder: (context, user) {
                    return  Container(
                      margin: const EdgeInsets.symmetric(vertical: 10.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                            color: AppColors.greyLight2.withOpacity(0.2),
                            width: 1),
                        borderRadius: BorderRadius.circular(Consts.padding * 2),
                      ),
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            userAvatar(context, user.photo!),
                            const SpaceW20(),
                            Text('${user.firstName!} ${user.lastName!}'),
                          ],
                        ),
                      ),
                    );
                  }
              );
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(15),
                child: AddYellowButton(
                  text: 'Invitar esta oferta',
                  onPressed: () => showDialog(context: context, builder: (_) {
                    return CustomDialog(
                        width: Responsive.isMobile(context)? widthOfScreen(context) : widthOfScreen(context)/2,
                        child: InviteUsersToResourcePage(resource: resource,)
                    );
                  }),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _deleteResource(BuildContext context, Resource resource) async {
    try {
      final database = Provider.of<Database>(context, listen: false);
      await database.deleteResource(resource);
      await database.deleteJobOffer(resource.jobOfferId!);
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _confirmDeleteResource(BuildContext context, Resource resource) async {
    final didRequestSignOut = await showAlertDialog(context,
        title: 'Eliminar oferta de empleo: ${resource.title} ',
        content: 'Si pulsa en Aceptar se procederá a la eliminación completa '
            'de la oferta de empleo, esta acción no se podrá deshacer, '
            '¿Está seguro que quiere continuar?',
        cancelActionText: 'Cancelar',
        defaultActionText: 'Aceptar');
    if (didRequestSignOut == true) {
      _deleteResource(context, resource);
      setState(() {
        ManageOffersPage.selectedIndex.value = 0;
      });
    }
  }

  String? getLocationText(Resource resource) {
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

}
