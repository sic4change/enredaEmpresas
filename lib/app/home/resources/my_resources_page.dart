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
import 'package:enreda_empresas/app/values/strings.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';


class MyResourcesPage extends StatelessWidget {
  const MyResourcesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildContents(context);
  }

  Widget _buildContents(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    final database = Provider.of<Database>(context, listen: false);
    return StreamBuilder<UserEnreda>(
        stream: database.userEnredaStreamByUserId(auth.currentUser!.uid),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          if (snapshot.hasData){
            var user = snapshot.data!;
            return StreamBuilder<List<Resource>>(
                stream: database.myResourcesStream(user.organization!),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                  if (snapshot.hasData) {
                    return ListItemBuilderGrid<Resource>(
                      snapshot: snapshot,
                      fitSmallerLayout: false,
                      itemBuilder: (context, resource) {
                        return StreamBuilder<Organization>(
                          stream: database.organizationStream(resource.organizer),
                          builder: (context, snapshot) {
                            final organization = snapshot.data;
                            resource.organizerName =
                            organization == null ? '' : organization.name;
                            resource.organizerImage =
                            organization == null ? '' : organization.photo;
                            resource.setResourceTypeName();
                            resource.setResourceCategoryName();
                            return StreamBuilder<Country>(
                                stream: database.countryStream(resource.country),
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
                                          stream: database.cityStream(resource.city),
                                          builder: (context, snapshot) {
                                            final city = snapshot.data;
                                            resource.cityName =
                                            city == null ? '' : city.name;
                                            return StreamBuilder<ResourcePicture>(
                                                stream: database.resourcePictureStream(resource.resourcePictureId),
                                                builder: (context, snapshot) {
                                                  final resourcePicture = snapshot.data;
                                                  resource.resourcePhoto = resourcePicture?.resourcePic;
                                                  return Container(
                                                    key: Key(
                                                        'resource-${resource.resourceId}'),
                                                    child:
                                                    /*ResourceListTile(
                                                      resource: resource,
                                                      onTap: () => context.go(
                                                          '${StringConst.PATH_RESOURCES}/${resource.resourceId}'),
                                                    ),*/
                                                    ResourceListTile(
                                                      resource: resource,
                                                      onTap: () => showDialog(
                                                        context: context,
                                                        builder: (BuildContext context) => ShowResourceDetailDialog(
                                                          resource: resource,
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                }
                                            );
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
        }
    );
  }


}
