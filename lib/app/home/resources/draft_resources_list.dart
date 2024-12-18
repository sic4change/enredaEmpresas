import 'package:enreda_empresas/app/home/applicants/applicants_list_page.dart';
import 'package:enreda_empresas/app/home/resources/resource_list_tile.dart';
import 'package:enreda_empresas/app/home/resources/manage_offers_page.dart';
import 'package:enreda_empresas/app/models/city.dart';
import 'package:enreda_empresas/app/models/company.dart';
import 'package:enreda_empresas/app/models/country.dart';
import 'package:enreda_empresas/app/models/jobOffer.dart';
import 'package:enreda_empresas/app/models/province.dart';
import 'package:enreda_empresas/app/models/resource.dart';
import 'package:enreda_empresas/app/models/userEnreda.dart';
import 'package:enreda_empresas/app/services/auth.dart';
import 'package:enreda_empresas/app/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:enreda_empresas/app/home/resources/global.dart' as globals;

import '../../common_widgets/no_resources_illustration.dart';
import '../../utils/responsive.dart';
import '../../values/strings.dart';
import '../../values/values.dart';
import 'builders/list_item_builder_grid.dart';


class DraftResourcesPage extends StatefulWidget {
  @override
  State<DraftResourcesPage> createState() => _DraftResourcesPageState();
}

class _DraftResourcesPageState extends State<DraftResourcesPage> {
  @override
  Widget build(BuildContext context) {
    return _buildContents(context);
  }

  Widget _buildContents(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    final database = Provider.of<Database>(context, listen: false);
    return Container(
      height: MediaQuery.of(context).size.height,
      padding: EdgeInsets.symmetric(horizontal: Sizes.mainPadding * 2),
      child: StreamBuilder<UserEnreda>(
          stream: database.userEnredaStreamByUserId(auth.currentUser!.uid),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasData) {
              var user = snapshot.data!;
              return StreamBuilder<List<Resource>>(
                  stream: database.myDraftResourcesStream(user.companyId!),
                  builder: (context, snapshot) {
                    return snapshot.hasData && snapshot.data!.isNotEmpty
                        ?  ListItemBuilderGrid<Resource>(
                      snapshot: snapshot,
                      fitSmallerLayout: false,
                      mainAxisExtentValue : Responsive.isMobile(context)? 191.0 : 248,
                      itemBuilder: (context, resource) {
                        if (!snapshot.hasData) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        if (snapshot.hasData) {
                          return StreamBuilder<Company>(
                            stream: database.companyStreamById(user.companyId!),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              }
                              final Company? socialEntity = snapshot.data;
                              resource.organizerName = socialEntity == null ? '' : socialEntity.name;
                              resource.organizerImage = socialEntity == null ? '' : socialEntity.photo;
                              resource.setResourceTypeName();
                              resource.setResourceCategoryName();
                              return StreamBuilder<Country>(
                                  stream: database.countryStream(resource.country),
                                  builder: (context, snapshot) {
                                    final country = snapshot.data;
                                    resource.countryName = country == null ? '' : country.name;
                                    return StreamBuilder<Province>(
                                        stream: database.provinceStream(resource.province),
                                        builder: (context, snapshot) {
                                          final province = snapshot.data;
                                          resource.provinceName = province == null ? '' : province.name;
                                          return StreamBuilder<City>(
                                              stream: database.cityStream(resource.city),
                                              builder: (context, snapshot) {
                                                final city = snapshot.data;
                                                resource.cityName = city == null ? '' : city.name;
                                                return StreamBuilder<JobOffer>(
                                                  stream: database.jobOfferStreamById(resource.jobOfferId!),
                                                  builder: (context, snapshot) {
                                                    if (!snapshot.hasData) return Container();
                                                    if (snapshot.hasData && snapshot.data != null) {
                                                      final jobOffer = snapshot.data!;
                                                      return Container(
                                                        key: Key('resource-${resource.resourceId}'),
                                                        child: ResourceListTile(
                                                          resource: resource,
                                                          onTap: () async {
                                                              await setGlobalParameters(context, resource);
                                                              ApplicantsListPage.selectedIndex.value = 0;
                                                              setState(() {
                                                                globals.currentResource = resource;

                                                                globals.currentJobOffer = jobOffer;
                                                                ManageOffersPage.selectedIndex.value = 2;
                                                              });
                                                          }
                                                        ),
                                                      );
                                                    }
                                                    return Container();
                                                  },
                                                );
                                              });
                                        });
                                  });
                            },
                          );
                        }
                        return const Center(child: CircularProgressIndicator());
                      },
                      emptyTitle: 'Sin recursos',
                      emptyMessage: 'Aún no has creado ningún recurso',
                      scrollController: ScrollController(),
                    ) :
                    snapshot.connectionState == ConnectionState.waiting ?
                    Padding(
                      padding: EdgeInsets.all(Sizes.kDefaultPaddingDouble),
                      child: Center(child: CircularProgressIndicator(),),
                    ) :
                    NoResourcesIllustration(
                      title: StringConst.NO_RESOURCES_TITLE_DRAFT,
                      subtitle: StringConst.NO_RESOURCES_DESCRIPTION_DRAFT,
                      imagePath: ImagePath.FAVORITES_ILLUSTRATION,
                    );
                  });
            }
            return const Center(child: CircularProgressIndicator());
          }),
    );
  }

  Future<void> setGlobalParameters(BuildContext context, Resource resource) async {
    final database = Provider.of<Database>(context, listen: false);

    // Set initial resource values
    resource.setResourceTypeName();
    resource.setResourceCategoryName();
    globals.interestsCurrentResource = resource.interests ?? [];
    globals.selectedInterestsCurrentResource = {};
    globals.interestsNamesCurrentResource = '';
    globals.selectedCompetenciesCurrentResource = {};
    globals.competenciesNamesCurrentResource = '';

    // Organizer
    if (resource.organizer != null) {
      await database.companyStream(resource.organizer).first.then((organization) {
        globals.organizerCurrentResource = organization;
        resource.organizerName = organization?.name ?? '';
        resource.organizerImage = organization?.photo ?? '';
      }).catchError((error) {
        globals.organizerCurrentResource = null;
        resource.organizerName = '';
        resource.organizerImage = '';
      });
    }

    // Address details
    if (resource.address != null) {
      if (resource.address!.country != null) {
        await database.countryStream(resource.address!.country).first.then((country) {
          resource.countryName = country?.name ?? '';
        }).catchError((error) {
          resource.countryName = '';
        });
      }

      if (resource.address!.province != null) {
        await database.provinceStream(resource.address!.province).first.then((province) {
          resource.provinceName = province?.name ?? '';
        }).catchError((error) {
          resource.provinceName = '';
        });
      }

      if (resource.address!.city != null) {
        await database.cityStream(resource.address!.city).first.then((city) {
          resource.cityName = city?.name ?? '';
        }).catchError((error) {
          resource.cityName = '';
        });
      }
    }

    // Interests
    final interestsLocal = resource.interests ?? [];
    if (interestsLocal.isNotEmpty) {
      await database.resourcesInterestsStream(interestsLocal).first.then((interests) {
        globals.selectedInterestsCurrentResource = interests.toSet();
        globals.interestsNamesCurrentResource = interests.map((item) => item.name).join(' / ');
      }).catchError((error) {
        globals.selectedInterestsCurrentResource = {};
        globals.interestsNamesCurrentResource = '';
      });
    }

    // Competencies
    final competenciesLocal = resource.competencies ?? [];
    if (competenciesLocal.isNotEmpty) {
      await database.resourcesCompetenciesStream(competenciesLocal).first.then((competencies) {
        globals.selectedCompetenciesCurrentResource = competencies.toSet();
        globals.competenciesNamesCurrentResource = competencies.map((item) => item.name).join(' / ');
      }).catchError((error) {
        globals.selectedCompetenciesCurrentResource = {};
        globals.competenciesNamesCurrentResource = '';
      });
    }
  }

}
