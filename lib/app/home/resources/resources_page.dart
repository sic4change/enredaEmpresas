import 'package:enreda_empresas/app/common_widgets/custom_text.dart';
import 'package:enreda_empresas/app/common_widgets/empty-list.dart';
import 'package:enreda_empresas/app/common_widgets/enreda_button.dart';
import 'package:enreda_empresas/app/home/resources/list_item_builder_grid.dart';
import 'package:enreda_empresas/app/home/resources/my_resources_list_page.dart';
import 'package:enreda_empresas/app/home/resources/resource_list_tile.dart';
import 'package:enreda_empresas/app/models/city.dart';
import 'package:enreda_empresas/app/models/country.dart';
import 'package:enreda_empresas/app/models/province.dart';
import 'package:enreda_empresas/app/models/resource.dart';
import 'package:enreda_empresas/app/models/company.dart';
import 'package:enreda_empresas/app/models/userEnreda.dart';
import 'package:enreda_empresas/app/services/auth.dart';
import 'package:enreda_empresas/app/services/database.dart';
import 'package:enreda_empresas/app/utils/responsive.dart';
import 'package:enreda_empresas/app/values/values.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../values/strings.dart';
import 'global.dart' as globals;

class ResourcesListPage extends StatefulWidget {
  const ResourcesListPage({Key? key}) : super(key: key);

  @override
  State<ResourcesListPage> createState() => _ResourcesListPageState();
}

class _ResourcesListPageState extends State<ResourcesListPage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _buildResourcesList(context);
  }

  Widget _buildResourcesList(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildMyResources(context),
          _buildAllResources(context),
        ],
      ),
    );
  }

  Widget _buildMyResources(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    final database = Provider.of<Database>(context, listen: false);
    int totalResources = 0;
    buildTitle() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          StreamBuilder<UserEnreda>(
              stream: database.userEnredaStreamByUserId(auth.currentUser!.uid),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasData) {
                  var user = snapshot.data!;
                  return StreamBuilder<List<Resource>>(
                      stream: database.myResourcesStream(user.companyId!),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        if (snapshot.hasData) {
                          List<Resource> resources = snapshot.data!;
                          totalResources = resources.length;
                          return CustomTextBoldTitle(title: resources.length == 1 ? '${resources.length.toString()} recurso creado por ${user.firstName}'
                              : '${resources.length.toString()} recursos creados por ${user.firstName}');
                        }
                        return const Center(child: CircularProgressIndicator());
                      });
                }
                return const Center(child: CircularProgressIndicator());
              }),
        ],
      );
    }

    buildCollapsedResourcesList() {
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
                    stream: database.myLimitResourcesStream(user.companyId!, 3),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(
                            child: CircularProgressIndicator());
                      }
                      if (snapshot.hasData) {
                        return ListItemBuilderGrid<Resource>(
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
                                                    return Container(
                                                      key: Key('resource-${resource.resourceId}'),
                                                      child: ResourceListTile(
                                                        resource: resource,
                                                        onTap: () =>
                                                            setState(() {
                                                              globals.currentResource = resource;
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

    buildExpandedResourcesList() {
      return Container(
        height: MediaQuery.of(context).size.height * 0.55,
        child: StreamBuilder<UserEnreda>(
            stream: database.userEnredaStreamByUserId(auth.currentUser!.uid),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasData) {
                var user = snapshot.data!;
                return StreamBuilder<List<Resource>>(
                    stream: database.myResourcesStream(user.companyId!),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(
                            child: CircularProgressIndicator());
                      }
                      if (snapshot.hasData) {
                        return ListItemBuilderGrid<Resource>(
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
                                                    return Container(
                                                      key: Key('resource-${resource.resourceId}'),
                                                      child: ResourceListTile(
                                                        resource: resource,
                                                        onTap: () =>
                                                            setState(() {
                                                              globals.currentResource = resource;
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

    return ExpandableNotifier(
        child: Padding(
          padding: const EdgeInsets.only(left: 0, right: 10, bottom: 10),
          child: ScrollOnExpand(
            child: Card(
              elevation: 0,
              color: Colors.transparent,
              clipBehavior: Clip.antiAlias,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expandable(
                    collapsed: buildTitle(),
                    expanded: buildTitle(),
                  ),
                  Expandable(
                    collapsed: buildCollapsedResourcesList(),
                    expanded: buildExpandedResourcesList(),
                  ),
                  Divider(
                    color: AppColors.greyLight,
                    height: 1,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Builder(
                        builder: (context) {
                          var controller =
                          ExpandableController.of(context, required: true)!;
                          return totalResources > 3 ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: EnredaButton(
                              buttonTitle: controller.expanded ? "Ver menos recursos" : "Ver más recursos",
                              onPressed: () {
                                controller.toggle();
                              },
                            ),
                          ) : Container();
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  Widget _buildAllResources(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);
    buildCollapsed1() {
      return CustomTextBoldTitle(title: 'Todos los recursos');
    }

    buildCollapsed2() {
      return Container(
        height: MediaQuery.of(context).size.height * 0.28,
        child: StreamBuilder<List<Resource>>(
            stream: database.limitResourcesStream(3),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListItemBuilderGrid<Resource>(
                  snapshot: snapshot,
                  fitSmallerLayout: false,
                  mainAxisExtentValue : Responsive.isMobile(context)? 191.0 : 248,
                  itemBuilder: (context, resource) {
                    if (snapshot.hasData) {
                      return StreamBuilder<Company>(
                        stream: database.companyStreamById(resource.organizer),
                        builder: (context, snapshot) {
                          final Company? socialEntity = snapshot.data;
                          resource.organizerName = socialEntity == null ? '' : socialEntity.name;
                          resource.organizerImage = socialEntity == null ? '' : socialEntity.photo;
                          resource.setResourceTypeName();
                          resource.setResourceCategoryName();
                          return Stack(
                            children: [
                              Container(
                                key: Key('resource-${resource.resourceId}'),
                                child: ResourceListTile(
                                  resource: resource,
                                  onTap: () =>
                                      setState(() {
                                        globals.currentResource = resource;
                                        MyResourcesListPage.selectedIndex.value = 2;
                                      }),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    }
                    return Container();
                  },
                  emptyTitle: 'Sin recursos',
                  emptyMessage: 'Aún no has creado ningún recurso',
                );
              }
              return Container();
            }),
      );
    }

    buildExpanded1() {
      return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                CustomTextBoldTitle(title: 'Recursos creados'),
              ],
            ),
          ]);
    }

    buildExpanded2() {
      return Container(
        height: MediaQuery.of(context).size.height * 0.55,
        child: StreamBuilder<List<Resource>>(
            stream: database.resourcesStream(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListItemBuilderGrid<Resource>(
                  snapshot: snapshot,
                  fitSmallerLayout: false,
                  mainAxisExtentValue : Responsive.isMobile(context)? 191.0 : 248,
                  itemBuilder: (context, resource) {
                    if (snapshot.hasData) {
                      return StreamBuilder<Company>(
                        stream: database.companyStreamById(resource.organizer),
                        builder: (context, snapshot) {
                          final Company? socialEntity = snapshot.data;
                          resource.organizerName = socialEntity == null ? '' : socialEntity.name;
                          resource.organizerImage = socialEntity == null ? '' : socialEntity.photo;
                          resource.setResourceTypeName();
                          resource.setResourceCategoryName();
                          return Stack(
                            children: [
                              Container(
                                key: Key('resource-${resource.resourceId}'),
                                child: ResourceListTile(
                                  resource: resource,
                                  onTap: () =>
                                      setState(() {
                                        globals.currentResource = resource;
                                        MyResourcesListPage.selectedIndex.value = 2;
                                      }),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    }
                    return Container();
                  },
                  emptyTitle: 'Sin recursos',
                  emptyMessage: 'Aún no has creado ningún recurso',
                );
              }
              return Container();
            }),
      );
    }

    return ExpandableNotifier(
        child: Padding(
          padding: const EdgeInsets.only(left: 0, right: 10, bottom: 10),
          child: ScrollOnExpand(
            child: Card(
              elevation: 0,
              color: Colors.transparent,
              clipBehavior: Clip.antiAlias,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expandable(
                    collapsed: buildCollapsed1(),
                    expanded: buildExpanded1(),
                  ),
                  Expandable(
                    collapsed: buildCollapsed2(),
                    expanded: buildExpanded2(),
                  ),
                  Divider(
                    color: AppColors.greyLight,
                    height: 1,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Builder(
                        builder: (context) {
                          var controller =
                          ExpandableController.of(context, required: true)!;
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: EnredaButton(
                              buttonTitle: controller.expanded ? "Ver menos recursos" : "Ver más recursos",
                              onPressed: () {
                                controller.toggle();
                              },
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ));
  }

}
