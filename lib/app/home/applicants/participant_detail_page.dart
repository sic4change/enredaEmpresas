import 'package:enreda_empresas/app/common_widgets/add_yellow_button.dart';
import 'package:enreda_empresas/app/common_widgets/custom_dialog.dart';
import 'package:enreda_empresas/app/common_widgets/custom_text.dart';
import 'package:enreda_empresas/app/common_widgets/rounded_container.dart';
import 'package:enreda_empresas/app/common_widgets/spaces.dart';
import 'package:enreda_empresas/app/home/resources/list_item_builder.dart';
import 'package:enreda_empresas/app/home/resources/resource_detail/invite_users_page.dart';
import 'package:enreda_empresas/app/home/resources/resource_detail_dialog.dart';
import 'package:enreda_empresas/app/models/jobOffer.dart';
import 'package:enreda_empresas/app/models/jobOfferApplication.dart';
import 'package:enreda_empresas/app/models/resource.dart';
import 'package:enreda_empresas/app/models/userEnreda.dart';
import 'package:enreda_empresas/app/services/database.dart';
import 'package:enreda_empresas/app/utils/adaptative.dart';
import 'package:enreda_empresas/app/utils/responsive.dart';
import 'package:enreda_empresas/app/values/strings.dart';
import 'package:enreda_empresas/app/values/values.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:enreda_empresas/app/home/resources/global.dart' as globals;

import '../../common_widgets/circle_widget.dart';
import '../../common_widgets/user_avatar.dart';
import '../../models/city.dart';
import '../../models/country.dart';
import '../../models/province.dart';

class ParticipantDetailPage extends StatefulWidget {
  const ParticipantDetailPage({Key? key}) : super(key: key);

  @override
  State<ParticipantDetailPage> createState() => _ParticipantDetailPageState();
}

class _ParticipantDetailPageState extends State<ParticipantDetailPage> {

  @override
  Widget build(BuildContext context) {
    return _buildResourcePage(context, globals.currentResource!, globals.currentJobOffer!);
  }

  Widget _buildResourcePage(BuildContext context, Resource resource, JobOffer jobOffer) {
    return _buildParticipantDetail(context, resource, jobOffer);
  }

  Widget _buildParticipantDetail(BuildContext context, Resource resource, JobOffer jobOffer) {
    return resource.resourceId == null || resource.resourceId!.isEmpty ? Container() :
    resource.organizer == globals.currentUserCompany?.companyId ? SingleChildScrollView(
        child: Stack(
          children: [
            Text('Participant detail page'),
          ],
        )) : Container();
  }


}