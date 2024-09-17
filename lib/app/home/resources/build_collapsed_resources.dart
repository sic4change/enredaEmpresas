import 'package:enreda_empresas/app/home/resources/list_item_builder_grid.dart';
import 'package:enreda_empresas/app/home/resources/my_resources_list_page.dart';
import 'package:enreda_empresas/app/home/resources/resource_detail/resource_detail_page.dart';
import 'package:enreda_empresas/app/home/resources/resource_list_tile.dart';
import 'package:enreda_empresas/app/home/resources/resources_page.dart';
import 'package:enreda_empresas/app/home/web_home.dart';
import 'package:enreda_empresas/app/models/city.dart';
import 'package:enreda_empresas/app/models/country.dart';
import 'package:enreda_empresas/app/models/province.dart';
import 'package:enreda_empresas/app/models/resource.dart';
import 'package:enreda_empresas/app/models/company.dart';
import 'package:enreda_empresas/app/models/userEnreda.dart';
import 'package:enreda_empresas/app/services/auth.dart';
import 'package:enreda_empresas/app/services/database.dart';
import 'package:enreda_empresas/app/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'global.dart' as globals;

class CollapsedResourcesList extends StatefulWidget {
  const CollapsedResourcesList({Key? key, required this.itemsNumber}) : super(key: key);
  final int itemsNumber;

  @override
  State<CollapsedResourcesList> createState() => _CollapsedResourcesListState();
}

class _CollapsedResourcesListState extends State<CollapsedResourcesList> {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    final database = Provider.of<Database>(context, listen: false);

    return Container(
      height: MediaQuery.of(context).size.height * 0.28,
      child: StreamBuilder<UserEnreda>(
          stream: database.userEnredaStreamByUserId(auth.currentUser!.uid),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasData) {
              var user = snapshot.data!;
              return StreamBuilder<List<Resource>>(
                  stream: database.myLimitResourcesStream(user.socialEntityId!, widget.itemsNumber),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                          child: CircularProgressIndicator());
                    }
                    if (snapshot.hasData) {
                      return ListItemBuilderGrid<Resource>(
                        snapshot: snapshot,
                        fitSmallerLayout: false,
                        mainAxisExtentValue : Responsive.isMobile(context)? 180.0 : 248,
                        itemBuilder: (context, resource) {
                          if (!snapshot.hasData) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                          if (snapshot.hasData) {
                            return StreamBuilder<Company>(
                              stream: database.companyStreamById(user.socialEntityId!),
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
                                                  return Container(
                                                    key: Key('resource-${resource.resourceId}'),
                                                    child: ResourceListTile(
                                                      resource: resource,
                                                      onTap: () =>
                                                          setState(() {
                                                            globals.currentResource = resource;
                                                            WebHome.goResources();
                                                            MyResourcesListPage.selectedIndex.value = 2;
                                                          }),
                                                    ),
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
                      );
                    }
                    return const Center(child: CircularProgressIndicator());
                  });
            }
            return const Center(child: CircularProgressIndicator());
          }),
    );
  }
}

