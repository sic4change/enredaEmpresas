import 'package:chips_choice/chips_choice.dart';
import 'package:enreda_empresas/app/common_widgets/custom_chip.dart';
import 'package:enreda_empresas/app/models/filterResource.dart';
import 'package:enreda_empresas/app/models/socialEntitiesType.dart';
import 'package:enreda_empresas/app/models/company.dart';
import 'package:enreda_empresas/app/services/database.dart';
import 'package:enreda_empresas/app/utils/responsive.dart';
import 'package:enreda_empresas/app/values/values.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:enreda_empresas/app/home/resources/global.dart' as globals;
import '../../models/externalSocialEntity.dart';
import 'entity_directory_page.dart';
import 'entity_list_tile.dart';
import 'filter_text_field_row.dart';

class EntitiesListPage extends StatefulWidget {
  const EntitiesListPage({Key? key, required this.socialEntityId}) : super(key: key);
  final String? socialEntityId;

  @override
  State<EntitiesListPage> createState() => _EntitiesListPageState();
}

class _EntitiesListPageState extends State<EntitiesListPage> {

  List<SocialEntitiesType> socialEntityTypes = [];
  final _searchTextController = TextEditingController();
  FilterResource filterResource = FilterResource("", []);
  List<Company> finalSocialEntities = [];
  bool create = false;  //Choose between show list of social entities or create form


  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _searchTextController.dispose();
    super.dispose();
  }

  void setStateIfMounted(f) {
    if (mounted) setState(f);
  }


  @override
  Widget build(BuildContext context) {
    return _buildEntitiesList();
  }

  Widget _buildEntitiesList(){
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: Sizes.mainPadding,),
          Padding(
            padding: Responsive.isMobile(context) ? EdgeInsets.all(Sizes.mainPadding) : const EdgeInsets.all(8.0),
            child: FilterTextFieldRow(
              searchTextController: _searchTextController,
              onPressed: () async {
                filterResource.searchText = _searchTextController.text;
              },
              onFieldSubmitted: (value) => setState(() {
                filterResource.searchText = _searchTextController.text;
              }),
              clearFilter: () => _clearFilter(),
              hintText: 'Nombre del contacto ...',
            ),
          ),
          Padding(
            padding: Responsive.isMobile(context) ? EdgeInsets.all(Sizes.mainPadding) : const EdgeInsets.all(8.0),
            child: chipFilter(),
          ),
          Container(
              margin: EdgeInsets.only(top: Sizes.mainPadding * 3),
              child: _buildEntitiesStream(context)),
        ],
      ),);
  }

  Widget chipFilter(){
    final database = Provider.of<Database>(context, listen: false);
    List<SocialEntitiesType> socialEntityTypes = [];
    return StreamBuilder<List<SocialEntitiesType>>(
        stream: database.socialEntitiesTypeStream(),
        builder: (context, snapshot) {
          if(!snapshot.hasData) return Container();
          socialEntityTypes.clear();
          snapshot.data!.toList().forEach((element) {
            socialEntityTypes.add(element);
          });
          return ChipsChoice<String>.multiple(
            padding: EdgeInsets.all(5),
            wrapped: true,
            value: filterResource.externalSocialEntityTypesIds,
            onChanged: (val){
              setState(() => filterResource.externalSocialEntityTypesIds = val);
            },
            choiceItems: C2Choice.listFrom<String, SocialEntitiesType>(
              source: socialEntityTypes,
              value: (i, v) => v.id,
              label: (i, v) => v.name,
            ),
            choiceBuilder: (item, i) => CustomChip(
              label: item.label,
              borderRadius: 17.0,
              backgroundColor: AppColors.greyChip,
              selectedBackgroundColor: AppColors.bluePetrol,
              textColor: AppColors.greyLetter,
              selected: item.selected,
              onSelect: item.select!,
            ),
          );
        }
    );
  }

  Widget _buildEntitiesStream(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);
    return StreamBuilder<List<ExternalSocialEntity>>(
        stream: database.filteredExternalSocialEntitiesStream(filterResource, widget.socialEntityId!),
        builder: (context, snapshot) {
          if(snapshot.hasData) {
            final List<ExternalSocialEntity> socialEntities = snapshot.data!.toList();
            return SingleChildScrollView(
              controller: ScrollController(),
              child: Wrap(
                alignment: WrapAlignment.center,
                children: [
                  for(ExternalSocialEntity currentExternalSocialEntity in socialEntities)
                    Padding(
                      padding: EdgeInsets.all(15),
                      child: EntityListTile(
                          socialEntity: currentExternalSocialEntity,
                          onTap: () {
                            setState(() {
                              globals.currentExternalSocialEntity = currentExternalSocialEntity;
                              EntityDirectoryPage.selectedIndex.value = 2;
                            });
                          }
                      ),
                    ),
                ],
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        });
  }

  void _clearFilter() {
    setStateIfMounted(() {
      _searchTextController.clear();
      _searchTextController.text = '';
      filterResource.searchText = '';
      filterResource.externalSocialEntityTypesIds = [];
    });
  }

}
