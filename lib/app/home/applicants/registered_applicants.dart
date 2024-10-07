import 'package:enreda_empresas/app/common_widgets/custom_text.dart';
import 'package:enreda_empresas/app/common_widgets/rounded_container.dart';
import 'package:enreda_empresas/app/common_widgets/spaces.dart';
import 'package:enreda_empresas/app/home/resources/list_item_builder.dart';
import 'package:enreda_empresas/app/models/jobOffer.dart';
import 'package:enreda_empresas/app/models/jobOfferApplication.dart';
import 'package:enreda_empresas/app/models/resource.dart';
import 'package:enreda_empresas/app/models/userEnreda.dart';
import 'package:enreda_empresas/app/services/database.dart';
import 'package:enreda_empresas/app/utils/responsive.dart';
import 'package:enreda_empresas/app/values/strings.dart';
import 'package:enreda_empresas/app/values/values.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:enreda_empresas/app/home/resources/global.dart' as globals;

import '../../common_widgets/circle_widget.dart';
import '../../models/city.dart';
import '../../models/country.dart';
import '../../models/province.dart';
import 'applicants_list_page.dart';

class RegisteredApplicantsListPage extends StatefulWidget {
  const RegisteredApplicantsListPage({Key? key, this.status}) : super(key: key);
  final String? status;
  @override
  State<RegisteredApplicantsListPage> createState() => _RegisteredApplicantsListPageState();
}

class _RegisteredApplicantsListPageState extends State<RegisteredApplicantsListPage> {

  @override
  Widget build(BuildContext context) {
    return _buildParticipantPage(context, globals.currentResource!, globals.currentJobOffer!);
  }

  Widget _buildParticipantPage(BuildContext context, Resource resource, JobOffer jobOffer) {
    return Responsive.isMobile(context) ? _buildParticipantDetailMobile(context, resource, jobOffer) :
    _buildParticipantDetailWeb(context, resource, jobOffer);
  }

  Widget _buildParticipantDetailWeb(BuildContext context, Resource resource, JobOffer jobOffer) {
    return resource.resourceId == null || resource.resourceId!.isEmpty ? Container() :
    resource.organizer == globals.currentUserCompany?.companyId ? SingleChildScrollView(
        child: RoundedContainer(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Flex(
                  direction: Responsive.isMobile(context) ? Axis.vertical : Axis.horizontal,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                        width: 300,
                        child: CustomTextSmallBold(title: 'Nombres', color: AppColors.primary900,)),
                    const SpaceW20(),
                    SizedBox(
                        width: 100,
                        child:  CustomTextSmallBold(title: 'Inscrito', color: AppColors.primary900,)),
                    const SpaceW20(),
                    SizedBox(
                        width: 150, child: CustomTextSmallBold(title: 'Estado', color: AppColors.primary900,)),
                    const SpaceW20(),
                    SizedBox(
                        width: 200,
                        child: CustomTextSmallBold(title: 'Provincia', color: AppColors.primary900,)),
                    const SpaceW20(),
                    SizedBox(
                        width: 50, child:  CustomTextSmallBold(title: 'Match', color: AppColors.primary900,)),
                    const SpaceW20(),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 60.0),
                child: Divider(
                  indent: 0,
                  endIndent: 0,
                  color: AppColors.greyBorder,
                  thickness: 1,
                  height: 0,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 70.0),
                child: _buildParticipantsList(context, resource),
              ),
            ],
          ),
        )) : Container();
  }

  Widget _buildParticipantDetailMobile(BuildContext context, Resource resource, JobOffer jobOffer) {
    return Column(
      children: [
        SingleChildScrollView(
            child: Stack(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                        width: 250,
                        child: CustomTextSmall(text: 'Nombres')),
                    const SpaceW20(),
                    SizedBox(
                        width: 100, child: CustomTextSmall(text: 'Match')),
                    const SpaceW20(),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 30.0),
                  child: _buildParticipantsList(context, resource),
                ),
              ],
            )),
        SpaceH20(),
      ],
    );
  }

  Widget _buildParticipantsList(BuildContext context, Resource resource) {
    final database = Provider.of<Database>(context, listen: false);
    int _getStatusIndex(String status) {
      switch (status) {
        case 'seen':
          return 0;
        case 'not-seen':
          return 1;
        case 'pre-selected':
          return 2;
        case 'selected':
          return 3;
        case 'not-selected':
          return 4;
        case 'registered':
          return 5;
        default:
          return -1; // indicate an invalid type
      }
    }
    String _getDisplayText(String status) {
      List<String> textValues = [
        'Visto',
        'No visto',
        'Preseleccionado',
        'Seleccionado',
        'Descartado',
        'Registrado',
      ];

      int index = _getStatusIndex(status);

      if (index >= 0 && index < textValues.length) {
        return textValues[index];
      } else {
        return '';
      }
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          StreamBuilder<List<JobOfferApplication>>(
            stream: database.applicantsStreamByJobOffer(resource.jobOfferId!, widget.status),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }
              if(snapshot.hasData) {
                return ListItemBuilder(
                    snapshot: snapshot,
                    emptyTitle: 'Sin aplicaciones',
                    emptyMessage: 'Aún no se ha registrado ningún aplicante',
                    itemBuilder: (context, application) {
                      return StreamBuilder<UserEnreda>(
                        stream: database.userEnredaStreamByUserId(application.userId),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Container();
                          }
                          final user = snapshot.data!;
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Stack(
                              children: [
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      globals.currentParticipant = user;
                                      globals.currentApplication = application;
                                      ApplicantsListPage.selectedIndex.value = 3;
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: Sizes.kDefaultPaddingDouble),
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: 300,
                                          child: Row(
                                            children: [
                                              CustomTextSmall(text: ' ${user.firstName!} ${user.lastName!}'),
                                            ],
                                          ),
                                        ),
                                        const SpaceW20(),
                                        SizedBox(
                                            width: 100,
                                            child: CustomTextSmall(text: '${DateFormat('dd/MM/yyyy').format(application.createdate!)}')),
                                        const SpaceW20(),
                                        SizedBox(
                                            width: 150, child: CustomTextSmallBold(title: _getDisplayText(application.status!))),
                                        const SpaceW20(),
                                        SizedBox(
                                          width: 200,
                                          child: Row(
                                            children: [
                                              _buildMyLocation(context, user),
                                            ],
                                          ),
                                        ),
                                        const SpaceW20(),
                                        Container(
                                          width: 50,
                                          child:  GradientCircleWidget(
                                            text: '${application.match!}%',
                                            size: 50,
                                          ),
                                        ),
                                        const SpaceW20(),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 60.0),
                                  child: Divider(
                                    indent: 0,
                                    endIndent: 0,
                                    color: AppColors.greyBorder,
                                    thickness: 1,
                                    height: 0,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    }
                );
              }
              return Container();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMyLocation(BuildContext context, UserEnreda? user) {
    final database = Provider.of<Database>(context, listen: false);
    Country? myCountry;
    Province? myProvince;
    City? myCity;
    String? city;
    String? province;
    String? country;

    return StreamBuilder<Country>(
        stream: database.countryStream(user?.address?.country),
        builder: (context, snapshot) {
          myCountry = snapshot.data;
          return StreamBuilder<Province>(
              stream: database.provinceStream(user?.address?.province),
              builder: (context, snapshot) {
                myProvince = snapshot.data;
                return StreamBuilder<City>(
                    stream: database.cityStream(user?.address?.city),
                    builder: (context, snapshot) {
                      myCity = snapshot.data;
                      city = myCity?.name ?? '';
                      province = myProvince?.name ?? '';
                      country = myCountry?.name ?? '';
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomTextSmall(text: province ?? ''),
                        ],
                      );
                    });
              });
        });
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