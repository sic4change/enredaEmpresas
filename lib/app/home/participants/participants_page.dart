import 'package:cached_network_image/cached_network_image.dart';
import 'package:enreda_empresas/app/common_widgets/custom_text.dart';
import 'package:enreda_empresas/app/common_widgets/spaces.dart';
import 'package:enreda_empresas/app/home/participants/participants_tile.dart';
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
              style: textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 30.0,
                  color: AppColors.greyDark2),),
          ),
          Container(
              margin: EdgeInsets.only(top: Sizes.mainPadding * 3),
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
                  emptyTitle: 'Sin participantes',
                  emptyMessage: 'Aún no se ha registrado ningún participante',
                  itemBuilder: (context, user) {
                    return ParticipantsListTile(user: user,
                        onTap: () => setState(() {
                      _currentPage = _buildMyProfile(user);
                    })
                    );
                  }
                );
            });
        });
    });
  }

  Widget _buildMyProfile(UserEnreda? user) {
    final textTheme = Theme.of(context).textTheme;
    double? textSize = responsiveSize(
      context,
      Sizes.TEXT_SIZE_14,
      Sizes.TEXT_SIZE_18,
      md: Sizes.TEXT_SIZE_15,
    );
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.grey,
              ),
              onPressed: () => setState(() {
                _currentPage = _buildResourcesList(context);
              }),
            ),
          ),
          Container(
            height: 250,
            padding: EdgeInsets.symmetric(vertical: Sizes.mainPadding),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.greyLight, width: 1),
              borderRadius: const BorderRadius.only(topRight: Radius.circular(15.0), topLeft: Radius.circular(15.0),),
              color: AppColors.white,
            ),
            child: Flex(
              direction:  Responsive.isMobile(context) ? Axis.vertical : Axis.horizontal,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      mouseCursor: MaterialStateMouseCursor.clickable,
                      // onTap: () => !kIsWeb
                      //     ? _displayPickImageDialog()
                      //     : _onImageButtonPressed(ImageSource.gallery),
                      child: Container(
                        width: Responsive.isMobile(context) ? 70 : 120,
                        height: Responsive.isMobile(context) ? 70 : 120,
                        color: Colors.white,
                        margin: Responsive.isMobile(context) ?  const EdgeInsets.all(10.0) :  const EdgeInsets.all(30.0),
                        child: Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(120),
                              ),
                              child:
                              !kIsWeb ?
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
                            Positioned(
                              left: Responsive.isMobile(context) ? 0 : 6,
                              top: Responsive.isMobile(context) ? 0 : 6,
                              child: Container(
                                padding: const EdgeInsets.all(2.0),
                                decoration: BoxDecoration(
                                  color: AppColors.white,
                                  shape: BoxShape.circle,
                                  border:
                                  Border.all(color: AppColors.penBlue, width: 1.0),
                                ),
                                child: const Icon(
                                  Icons.mode_edit_outlined,
                                  size: 22,
                                  color: AppColors.penBlue,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${user!.firstName} ${user.lastName}',
                          style: textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.bold, color: AppColors.chatDarkGray),
                        ),
                        const SizedBox(height: 8,),
                        Text(
                          '${user.educationName}'.toUpperCase(),
                          style: textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.bold, color: AppColors.penBlue),
                        ),

                      ],
                    ),
                  ],
                ),
                const Spacer(),
                const SpaceH20(),
                ElevatedButton(
                  onPressed: () => {},
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(StringConst.INVITE_RESOURCE.toUpperCase(),
                          style: textTheme.bodyLarge?.copyWith(
                            color: AppColors.penBlue,
                            fontSize: textSize,
                            letterSpacing: 1.1,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 5,),
                        IconButton(
                            icon: const Icon(
                              Icons.add,
                              color: AppColors.penBlue,
                            ),
                            onPressed: () => {}
                        ),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
                const SpaceH20(),
                const Divider(),
              ],
            ),
          ),
          _buildPersonalData(context, user)
        ],
      ),
    );
  }

  Widget _buildPersonalData(BuildContext context, UserEnreda user) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: 250,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.greyTxtAlt, width: 1),
        borderRadius: const BorderRadius.all(Radius.circular(15.0)),
        color: AppColors.white,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            StringConst.PERSONAL_DATA.toUpperCase(),
            style: textTheme.bodyText1?.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: Responsive.isDesktop(context) ? 18 : 14.0,
              color: AppColors.darkLilac,
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
                          SpaceW4(),
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
  
}
