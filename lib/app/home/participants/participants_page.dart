import 'package:enreda_empresas/app/common_widgets/build_share_button.dart';
import 'package:enreda_empresas/app/common_widgets/custom_text_title.dart';
import 'package:enreda_empresas/app/common_widgets/spaces.dart';
import 'package:enreda_empresas/app/home/participants/participants_tile.dart';
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

class ParticipantsListPage extends StatefulWidget {
  const ParticipantsListPage({super.key});

  @override
  State<ParticipantsListPage> createState() => _ParticipantsListPageState();
}

class _ParticipantsListPageState extends State<ParticipantsListPage> {
  Widget? _currentPage;

  @override
  void initState() {
    _currentPage = _buildResourcesList(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: _currentPage,
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
        var user = snapshot.data!;
        return StreamBuilder<List<Resource>>(
          stream: database.myResourcesStream(user.organization!),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            final resourceIdList = snapshot.data!.map((e) => e.resourceId).toList();
            return StreamBuilder<List<UserEnreda>>(
              stream: database.userParticipantsStream(resourceIdList),
              builder: (context, snapshot) {
                return ListItemBuilderGrid(
                  snapshot: snapshot,
                  fitSmallerLayout: false,
                  emptyTitle: 'Sin recursos',
                  emptyMessage: 'Aún no has creado ningún recurso',
                  itemBuilder: (context, user) {
                    return ParticipantsListTile(user: user);
                  }
                );
            });
        });
    });
  }

  Widget _participantsPage(Resource resource) {
    TextTheme textTheme = Theme.of(context).textTheme;
    double fontSizeTitle = responsiveSize(context, 14, 22, md: 18);
    double fontSizePromotor = responsiveSize(context, 12, 16, md: 14);
    final database = Provider.of<Database>(context, listen: false);
    final myDataOfInterest = resource.participants;
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
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30.0),
              color: Colors.transparent,
            ),
            child: myDataOfInterest.isNotEmpty
                ? Wrap(
              children: myDataOfInterest
                  .map((d) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SpaceH12(),
                  Container(
                    height: 40.0,
                    child: Row(
                      children: [
                        Expanded(child: CustomTextBody(text: d)),
                        SpaceW12(),
                        // EditButton(
                        //   onTap: () =>
                        //       _showDataOfInterestDialog(context, d),
                        // ),
                        // SpaceW12(),
                        // DeleteButton(
                        //   onTap: () {
                        //     user!.dataOfInterest.remove(d);
                        //     database.setUserEnreda(user!);
                        //   },
                        // ),
                      ],
                    ),
                  ),
                  Divider(),
                ],
              ))
                  .toList(),
            )
                : CustomTextBody(text: StringConst.NO_DATA_OF_INTEREST),
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
}
