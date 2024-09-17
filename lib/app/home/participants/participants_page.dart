import 'package:enreda_empresas/app/common_widgets/custom_text.dart';
import 'package:enreda_empresas/app/common_widgets/rounded_container.dart';
import 'package:enreda_empresas/app/common_widgets/spaces.dart';
import 'package:enreda_empresas/app/home/participants/participant_detail/participant_detail_page.dart';
import 'package:enreda_empresas/app/home/participants/participants_item_builder.dart';
import 'package:enreda_empresas/app/home/participants/participants_tile.dart';
import 'package:enreda_empresas/app/models/userEnreda.dart';
import 'package:enreda_empresas/app/services/auth.dart';
import 'package:enreda_empresas/app/services/database.dart';
import 'package:enreda_empresas/app/utils/responsive.dart';
import 'package:enreda_empresas/app/values/strings.dart';
import 'package:enreda_empresas/app/values/values.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:enreda_empresas/app/home/resources/global.dart' as globals;

class ParticipantsListPage extends StatefulWidget {
  const ParticipantsListPage({super.key});

  static ValueNotifier<int> selectedIndex = ValueNotifier(0);

  @override
  State<ParticipantsListPage> createState() => _ParticipantsListPageState();
}

class _ParticipantsListPageState extends State<ParticipantsListPage> {
  var _bodyWidget = [];
  late UserEnreda companyUser;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_bodyWidget.isEmpty) {
      _bodyWidget = [
        _buildParticipantsList(),
        ParticipantDetailPage()
      ];
    }

    return ValueListenableBuilder<int>(
        valueListenable: ParticipantsListPage.selectedIndex,
        builder: (context, selectedIndex, child) {
          return RoundedContainer(
            color: AppColors.grey80,
            borderColor: Responsive.isMobile(context) ? Colors.transparent : AppColors.greyLight,
            margin: Responsive.isMobile(context) ? EdgeInsets.all(20) : EdgeInsets.all(Sizes.kDefaultPaddingDouble),
            child: Stack(
              alignment: Alignment.topLeft,
              children: [
                Container(
                  height: 80,
                  padding:  Responsive.isDesktopS(context) ? EdgeInsets.symmetric(horizontal: 20, vertical: 10) :
                    Responsive.isMobile(context) ? EdgeInsets.symmetric(horizontal: 0, vertical: 10) :
                      EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                  child: Row(
                    children: [
                      InkWell(
                          onTap: () => {
                            setState(() {
                              ParticipantsListPage.selectedIndex.value = 0;
                            })
                          },
                          child: selectedIndex != 0 ? CustomTextMedium(text: 'Participantes ') :
                          CustomTextMediumBold(text: 'Participantes ') ),
                      selectedIndex == 1 ? CustomTextMediumBold(text:'> ${globals.currentParticipant!.firstName} ${globals.currentParticipant!.lastName}') : Container()
                    ],
                  ),
                ),
                Container(
                  height: double.infinity,
                  margin: Responsive.isDesktopS(context) ? EdgeInsets.symmetric(horizontal: 20, vertical: 60) : EdgeInsets.only(top: 60),
                  child: _bodyWidget[selectedIndex]),
              ],
                    ),
          );
      }
    );
  }

  Widget _buildParticipantsList() {
    final auth = Provider.of<AuthBase>(context, listen: false);
    final database = Provider.of<Database>(context, listen: false);

    return StreamBuilder<UserEnreda>(
      stream: database.userEnredaStreamByUserId(auth.currentUser!.uid),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        globals.currentSocialEntityUser = snapshot.data!;
        companyUser = snapshot.data!;
        return StreamBuilder<List<UserEnreda>>(
          stream: database.getParticipantsBySocialEntityStream(companyUser.companyId!),
          builder: (context, userSnapshot) {
            if(userSnapshot.hasData) {
              return StreamBuilder(
                stream: database.companyStreamById(companyUser.companyId!),
                builder: (context, socialEntitySnapshot) {
                  if (socialEntitySnapshot.hasData) {
                    final textTheme = Theme.of(context).textTheme;
                    final users = userSnapshot.data!;
                    final myParticipants = users.where((u) =>
                    u.assignedEntityId == companyUser.companyId!
                        && u.assignedById == companyUser.userId).toList();
                    final allOtherParticipants = users.where((u) =>
                    u.assignedEntityId == companyUser.companyId!
                        && u.assignedById != companyUser.userId).toList();

                    return SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SpaceH12(),
                            Text(StringConst.MY_PARTICIPANTS,
                              style: textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.turquoiseBlue),),
                            SpaceH20(),
                            ParticipantsItemBuilder(
                                usersList: myParticipants,
                                emptyMessage: 'No hay participantes gestionados por ti',
                                itemBuilder: (context, user) {
                                  return ParticipantsListTile(
                                      user: user,
                                      socialEntityUserId: companyUser.companyId!,
                                      onTap: () => setState(() {
                                        globals.currentParticipant = user;
                                        ParticipantsListPage.selectedIndex.value = 1;
                                      })
                                  );
                                }
                                ),
                            SpaceH40(),
                            Text(StringConst.allParticipants(socialEntitySnapshot.data!.name),
                              style: textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.turquoiseBlue,),),
                            SpaceH20(),
                            ParticipantsItemBuilder(
                                usersList: allOtherParticipants,
                                emptyMessage: 'No hay participantes gestionados por tu empresa',
                                itemBuilder: (context, user) {
                                  return ParticipantsListTile(
                                      user: user,
                                      socialEntityUserId: companyUser.companyId!,
                                      onTap: () => setState(() {
                                        globals.currentParticipant = user;
                                        ParticipantsListPage.selectedIndex.value = 1;
                                      })
                                  );
                                }
                                ),
                          ],
                        ),
                      ),
                    );
                  }
                  return const Center(child: CircularProgressIndicator());
                }
              );
            }
            return const Center(child: CircularProgressIndicator());
        });
    });
  }

}
