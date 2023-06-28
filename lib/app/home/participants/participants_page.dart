import 'package:cached_network_image/cached_network_image.dart';
import 'package:enreda_empresas/app/common_widgets/custom_text.dart';
import 'package:enreda_empresas/app/common_widgets/spaces.dart';
import 'package:enreda_empresas/app/home/participants/my_cv_page.dart';
import 'package:enreda_empresas/app/home/participants/participants_tile.dart';
import 'package:enreda_empresas/app/home/participants/resources_participants.dart';
import 'package:enreda_empresas/app/home/participants/show_invitation_diaglog.dart';
import 'package:enreda_empresas/app/home/resources/list_item_builder_grid.dart';
import 'package:enreda_empresas/app/models/city.dart';
import 'package:enreda_empresas/app/models/country.dart';
import 'package:enreda_empresas/app/models/province.dart';
import 'package:enreda_empresas/app/models/resource.dart';
import 'package:enreda_empresas/app/models/userEnreda.dart';
import 'package:enreda_empresas/app/services/auth.dart';
import 'package:enreda_empresas/app/services/database.dart';
import 'package:enreda_empresas/app/utils/adaptative.dart';
import 'package:enreda_empresas/app/utils/responsive.dart';
import 'package:enreda_empresas/app/values/strings.dart';
import 'package:enreda_empresas/app/values/values.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ParticipantsListPage extends StatefulWidget {
  const ParticipantsListPage({super.key});

  @override
  State<ParticipantsListPage> createState() => _ParticipantsListPageState();
}

class _ParticipantsListPageState extends State<ParticipantsListPage> {
  Widget? _currentPage;
  late UserEnreda organizationUser;

  @override
  void initState() {
    _currentPage = _buildResourcesList(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      padding: EdgeInsets.all(Sizes.mainPadding),
      margin: EdgeInsets.all(Sizes.mainPadding),
      decoration: BoxDecoration(
        color: AppColors.altWhite,
        shape: BoxShape.rectangle,
        border: Border.all(color: AppColors.greyLight2.withOpacity(0.3), width: 1),
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Text(StringConst.PARTICIPANTS_BY,
              style: textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.greyDark2),),
          ),
          Container(
              margin: EdgeInsets.only(top: Sizes.mainPadding * 2),
              child: _currentPage),
        ],
      ),
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
        organizationUser = snapshot.data!;
        return StreamBuilder<List<Resource>>(
          stream: database.myResourcesStream(organizationUser.organization!),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            final resourceIdList = snapshot.data!.map((e) => e.resourceId).toList();
            return StreamBuilder<List<UserEnreda>>(
              stream: database.getParticipantsByOrganizationStream(resourceIdList),
              builder: (context, snapshot) {
                if(snapshot.hasData) {
                  return ListItemBuilderGrid(
                      snapshot: snapshot,
                      fitSmallerLayout: false,
                      itemBuilder: (context, user) {
                        return ParticipantsListTile(user: user,
                            onTap: () => setState(() {
                              _currentPage = Responsive.isMobile(context) || Responsive.isTablet(context)  ? _buildParticipantProfileMobile(user) : _buildParticipantProfileWeb(user);
                            })
                        );
                      }
                  );
                }
                return const Center(child: CircularProgressIndicator());
            });
        });
    });
  }

  Widget _buildParticipantProfileWeb(UserEnreda? user) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 250,
          child: Flex(
            direction:  Responsive.isMobile(context) || Responsive.isTablet(context)  ? Axis.vertical : Axis.horizontal,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_back,
                        color: AppColors.greyDark,
                      ),
                      onPressed: () => setState(() {
                        _currentPage = _buildResourcesList(context);
                      }),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(120),
                          ),
                          child:
                          !kIsWeb ? ClipRRect(
                            borderRadius: const BorderRadius.all(Radius.circular(60)),
                            child:
                            Center(
                              child:
                              user?.photo == "" ?
                              Container(
                                color:  Colors.transparent,
                                height: Responsive.isMobile(context) ? 90 : 120,
                                width: Responsive.isMobile(context) ? 90 : 120,
                                child: Image.asset(ImagePath.USER_DEFAULT),
                              ):
                              CachedNetworkImage(
                                  width: Responsive.isMobile(context) ? 90 : 120,
                                  height: Responsive.isMobile(context) ? 90 : 120,
                                  fit: BoxFit.cover,
                                  alignment: Alignment.center,
                                  imageUrl: user?.photo ?? ""),
                            ),
                          ):
                          ClipRRect(
                            borderRadius: const BorderRadius.all(Radius.circular(60)),
                            child:
                            Center(
                              child:
                              user?.photo == "" ?
                              Container(
                                color:  Colors.transparent,
                                height: Responsive.isMobile(context) ? 90 : 120,
                                width: Responsive.isMobile(context) ? 90 : 120,
                                child: Image.asset(ImagePath.USER_DEFAULT),
                              ):
                              FadeInImage.assetNetwork(
                                placeholder: ImagePath.USER_DEFAULT,
                                width: Responsive.isMobile(context) ? 90 : 120,
                                height: Responsive.isMobile(context) ? 90 : 120,
                                fit: BoxFit.cover,
                                image: user?.photo ?? "",
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${user!.firstName} ${user.lastName}',
                            style: textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold, color: AppColors.chatDarkGray),
                          ),
                          const SizedBox(height: 8,),
                          Text(
                            '${user.educationName}'.toUpperCase(),
                            style: textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.bold, color: AppColors.penBlue),
                          ),
                          const SizedBox(height: 30,),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ElevatedButton(
                      onPressed: () => showDialog(
                          context: context,
                          builder: (BuildContext context) => ShowInvitationDialog(user: user, organizerId: organizationUser.organization!,)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.violet, // Background color
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(StringConst.INVITE_RESOURCE.toUpperCase(),
                              style: textTheme.titleLarge?.copyWith(
                                color: AppColors.penBlue,
                                letterSpacing: 1.1,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(width: Responsive.isMobile(context) ? 5 : 20),
                            SizedBox(height: 40, width: 40, child: Image.asset(ImagePath.CREATE_RESOURCE),)
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: Responsive.isMobile(context) || Responsive.isTablet(context) ? 500 : 250,
          child: Flex(
            direction:  Responsive.isMobile(context) || Responsive.isTablet(context) ? Axis.vertical : Axis.horizontal,
            children: [
              Expanded(
                flex: Responsive.isMobile(context) || Responsive.isTablet(context) ? 1 : 1,
                child: _buildPersonalData(context, user)
              ),
              Expanded(
                flex: Responsive.isMobile(context) || Responsive.isTablet(context) ? 1 : 3,
                child: _buildResourcesParticipant(context, user)),
              Expanded(
                  flex: Responsive.isMobile(context) || Responsive.isTablet(context) ? 1 : 1,
                  child: _buildCvParticipant(context, user)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildParticipantProfileMobile(UserEnreda? user) {
    final textTheme = Theme.of(context).textTheme;
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  color: AppColors.greyDark,
                ),
                onPressed: () => setState(() {
                  _currentPage = _buildResourcesList(context);
                }),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(120),
                    ),
                    child:
                    !kIsWeb ? ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(60)),
                      child:
                      Center(
                        child:
                        user?.photo == "" ?
                        Container(
                          color:  Colors.transparent,
                          height: Responsive.isMobile(context) ? 90 : 120,
                          width: Responsive.isMobile(context) ? 90 : 120,
                          child: Image.asset(ImagePath.USER_DEFAULT),
                        ):
                        CachedNetworkImage(
                            width: Responsive.isMobile(context) ? 90 : 120,
                            height: Responsive.isMobile(context) ? 90 : 120,
                            fit: BoxFit.cover,
                            alignment: Alignment.center,
                            imageUrl: user?.photo ?? ""),
                      ),
                    ):
                    ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(60)),
                      child:
                      Center(
                        child:
                        user?.photo == "" ?
                        Container(
                          color:  Colors.transparent,
                          height: Responsive.isMobile(context) ? 90 : 120,
                          width: Responsive.isMobile(context) ? 90 : 120,
                          child: Image.asset(ImagePath.USER_DEFAULT),
                        ):
                        FadeInImage.assetNetwork(
                          placeholder: ImagePath.USER_DEFAULT,
                          width: Responsive.isMobile(context) ? 90 : 120,
                          height: Responsive.isMobile(context) ? 90 : 120,
                          fit: BoxFit.cover,
                          image: user?.photo ?? "",
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0, top: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${user!.firstName} ${user.lastName}',
                      maxLines: 2,
                      style: textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold, color: AppColors.chatDarkGray),
                    ),
                    const SizedBox(height: 8,),
                    Text(
                      '${user.educationName}'.toUpperCase(),
                      maxLines: 2,
                      style: textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.bold, color: AppColors.penBlue),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20,),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ElevatedButton(
                onPressed: () => showDialog(
                    context: context,
                    builder: (BuildContext context) => ShowInvitationDialog(user: user, organizerId: organizationUser.organization!,)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.violet, // Background color
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(StringConst.INVITE_RESOURCE.toUpperCase(),
                        style: textTheme.bodySmall?.copyWith(
                          color: AppColors.penBlue,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(width: Responsive.isMobile(context) ? 5 : 20),
                      SizedBox(height: 40, width: 40, child: Image.asset(ImagePath.CREATE_RESOURCE),)
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20,),
          Column(
            children: [
              _buildPersonalData(context, user),
              _buildResourcesParticipant(context, user),
              _buildCvParticipant(context, user),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalData(BuildContext context, UserEnreda user) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.greyLight2.withOpacity(0.3), width: 1),
        borderRadius: const BorderRadius.all(Radius.circular(15.0)),
        color: AppColors.white,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            StringConst.PERSONAL_DATA,
            style: textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: Responsive.isDesktop(context) ? 18 : 14.0,
              color: AppColors.penBlue,
            ),
          ),
          const SpaceH20(),
          Row(
            children: [
              const Icon(
                Icons.mail,
                color: AppColors.darkGray,
                size: 12.0,
              ),
              const SpaceW4(),
              Flexible(
                child: CustomTextSmall(text: user.email,)
              ),
            ],
          ),
          const SpaceH8(),
          Row(
            children: [
              const Icon(
                Icons.phone,
                color: AppColors.darkGray,
                size: 12.0,
              ),
              const SpaceW4(),
              CustomTextSmall(text: user.phone ?? '',)
            ],
          ),
          const SpaceH8(),
          _buildMyLocation(context, user),
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
                          Icon(
                            Icons.location_on,
                            color: Colors.black.withOpacity(0.7),
                            size: 16,
                          ),
                          const SpaceW4(),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomTextSmall(text: city ?? ''),
                              CustomTextSmall(text: province ?? ''),
                              CustomTextSmall(text: country ?? ''),
                            ],
                          ),
                        ],
                      );
                    });
              });
        });
  }

  Widget _buildResourcesParticipant(BuildContext context, UserEnreda user) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      height: Responsive.isMobile(context) || Responsive.isTablet(context) ? null : 250,
      margin: Responsive.isMobile(context) || Responsive.isTablet(context) ? const EdgeInsets.symmetric(vertical: 20.0) : const EdgeInsets.only(left: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.greyLight2.withOpacity(0.3), width: 1),
        borderRadius: const BorderRadius.all(Radius.circular(15.0)),
        color: AppColors.white,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            StringConst.RESOURCES_PARTICIPANT,
            style: textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: Responsive.isDesktop(context) ? 18 : 14.0,
              color: AppColors.penBlue,
            ),
          ),
          const SizedBox(height: 10,),
          ParticipantResourcesList(participantId: user.userId!, organizerId: organizationUser.organization!,),
        ],
      ),
    );
  }

  Widget _buildCvParticipant(BuildContext context, UserEnreda user) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      margin: Responsive.isMobile(context) || Responsive.isTablet(context) ? const EdgeInsets.only(top: 20) : const EdgeInsets.only(left: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.greyLight2.withOpacity(0.3), width: 1),
        borderRadius: const BorderRadius.all(Radius.circular(15.0)),
        color: AppColors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            StringConst.MY_CV,
            style: textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: Responsive.isDesktop(context) ? 18 : 14.0,
              color: AppColors.penBlue,
            ),
          ),
          const SizedBox(height: 10,),
          IconButton(
            iconSize: 40,
            icon: const Icon(
              Icons.pages,
              color: AppColors.penBlue,
            ),
            onPressed: () => {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  fullscreenDialog: true,
                  builder: ((context) => MyCurriculumPage(user: user)),
                ),
              )
            },
          ),
        ],
      ),
    );
  }
}
