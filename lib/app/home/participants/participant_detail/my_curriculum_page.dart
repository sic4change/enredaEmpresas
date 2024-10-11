import 'package:cached_network_image/cached_network_image.dart';
import 'package:enreda_empresas/app/models/certificationRequest.dart';
import 'package:enreda_empresas/app/models/competency.dart';
import 'package:enreda_empresas/app/models/country.dart';
import 'package:enreda_empresas/app/models/education.dart';
import 'package:enreda_empresas/app/models/experience.dart';
import 'package:enreda_empresas/app/models/language.dart';
import 'package:enreda_empresas/app/models/province.dart';
import 'package:enreda_empresas/app/models/userEnreda.dart';
import 'package:enreda_empresas/app/services/database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smooth_star_rating_null_safety/smooth_star_rating_null_safety.dart';
import '../../../common_widgets/alert_dialog.dart';
import '../../../common_widgets/custom_text.dart';
import '../../../common_widgets/main_container.dart';
import '../../../common_widgets/my_custom_behavior.dart';
import '../../../common_widgets/precached_avatar.dart';
import '../../../common_widgets/show_custom_dialog.dart';
import '../../../common_widgets/spaces.dart';
import '../../../models/city.dart';
import '../../../utils/adaptative.dart';
import '../../../utils/functions.dart';
import '../../../utils/responsive.dart';
import '../../../values/strings.dart';
import '../../../values/values.dart';
import '../experience_tile.dart';
import '../pdf_generator/cv_print/my_cv_multiple_pages.dart';
import '../reference_tile.dart';
import 'competencies/competency_tile.dart';
import 'package:enreda_empresas/app/home/resources/global.dart' as globals;

class MyCurriculumPage extends StatefulWidget {
  const MyCurriculumPage({super.key, this.mini = false});

  final bool mini;

  @override
  State<MyCurriculumPage> createState() => _MyCurriculumPageState();
}

class _MyCurriculumPageState extends State<MyCurriculumPage> {
  UserEnreda? user;
  String? myLocation;
  String? city;
  String? province;
  String? country;
  String myCustomCity = "";
  String myCustomProvince = "";
  String myCustomCountry = "";
  String myCustomAboutMe = "";
  String myCustomEmail = "";
  String myCustomPhone = "";
  Education? myMaxEducation;
  List<Competency>? myCompetencies = [];
  List<Experience>? myExperiences = [];
  List<Experience> myCustomExperiences = [];
  List<int> mySelectedExperiences = [];
  List<Experience>? myPersonalExperiences = [];
  List<Experience> myPersonalCustomExperiences = [];
  List<int> myPersonalSelectedExperiences = [];
  List<Experience>? myEducation = [];
  List<Experience> myCustomEducation = [];
  List<int> mySelectedEducation = [];
  List<Experience>? mySecondaryEducation = [];
  List<Experience> mySecondaryCustomEducation = [];
  List<int> mySecondarySelectedEducation = [];
  List<CertificationRequest>? myReferences = [];
  List<CertificationRequest> myCustomReferences = [];
  List<int> mySelectedReferences = [];
  List<String> competenciesNames = [];
  List<String> myCustomCompetencies = [];
  List<int> mySelectedCompetencies = [];
  List<String> myCustomDataOfInterest = [];
  List<int> mySelectedDataOfInterest = [];
  List<Language> myCustomLanguages = [];
  List<int> mySelectedLanguages = [];
  double speakingLevel = 1.0;
  double writingLevel = 1.0;
  BuildContext? myContext;
  String _userId = '';
  String _photo = '';

  void setStateIfMounted(f) {
    if (mounted) setState(f);
  }

  @override
  void initState() {
    user = globals.currentParticipant!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);
    return StreamBuilder<List<UserEnreda>>(
        stream: database.userStream(user?.email ?? ''),
        builder: (context, snapshot) {
          if (snapshot.hasData &&
              snapshot.connectionState == ConnectionState.active) {
            user = snapshot.data!.isNotEmpty ? snapshot.data!.first : null;
            var profilePic = user?.profilePic?.src ?? "";
            return StreamBuilder<List<Competency>>(
                stream: database.competenciesStream(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return Container();
                  if (snapshot.hasError)
                    return Center(child: Text('Ocurrió un error'));
                  List<Competency> competencies = snapshot.data!;
                  final competenciesIds = user!.competencies.keys.toList();
                  competencies = competencies
                      .where((competency) => competenciesIds.any((id) => competency.id == id))
                      .toList();
                  competencies.forEach((competency) {
                    final status =
                        user?.competencies[competency.id] ?? StringConst.BADGE_EMPTY;
                    if (competency.name !="" && status != StringConst.BADGE_EMPTY && status != StringConst.BADGE_IDENTIFIED ) {
                      final index1 = competenciesNames.indexWhere((element) => element == competency.name);
                      if (index1 == -1) competenciesNames.add(competency.name);
                    }
                  });

                  final myAboutMe = user?.aboutMe ?? "";
                  myCustomAboutMe = myAboutMe;

                  final myEmail = user?.email ?? "";
                  myCustomEmail = myEmail;

                  final myPhone = user?.phone ?? "";
                  myCustomPhone = myPhone;

                  myCustomCompetencies = competenciesNames.map((element) => element).toList();
                  mySelectedCompetencies = List.generate(myCustomCompetencies.length, (i) => i);

                  final myDataOfInterest = user?.dataOfInterest ?? [];
                  myCustomDataOfInterest = myDataOfInterest.map((element) => element).toList();
                  mySelectedDataOfInterest = List.generate(myCustomDataOfInterest.length, (i) => i);

                  final myLanguages = user?.languagesLevels ?? [];
                  myCustomLanguages = myLanguages.map((element) => element).toList();
                  mySelectedLanguages = List.generate(myCustomLanguages.length, (i) => i);

                  _photo = profilePic;
                  if (widget.mini)
                    return _myCurriculumMini(context, user, profilePic, competenciesNames );
                  else {
                    return Responsive.isDesktop(context)
                        ? _myCurriculumWeb(context, user, profilePic, competenciesNames )
                        : _myCurriculumMobile(context, user, profilePic, competenciesNames);
                  }
                });
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }

  Widget _myCurriculumMini(BuildContext context, UserEnreda? user, String profilePic, List<String> competenciesNames){
    final textTheme = Theme.of(context).textTheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: Responsive.isDesktop(context) ? 400 : Responsive.isDesktopS(context) ? 400.0 : 400,
          padding: EdgeInsets.only(
            left: Sizes.mainPadding * 2,
            top: Sizes.mainPadding * 2,
            right: Sizes.mainPadding * 2,
          ),
          decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  AppColors.primary400.withOpacity(0.15),
                  AppColors.primary020.withOpacity(0.13)
                ],
              )
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    !kIsWeb ?
                    ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(60)),
                      child:
                      Center(
                        child:
                        profilePic == "" ?
                        Container(
                          color:  Colors.transparent,
                          height: 120,
                          width: 120,
                          child: Image.asset(ImagePath.USER_DEFAULT),
                        ):
                        CachedNetworkImage(
                            width: 120,
                            height: 120,
                            fit: BoxFit.cover,
                            alignment: Alignment.center,
                            imageUrl: profilePic),
                      ),
                    ):
                    ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(60)),
                      child:
                      profilePic == "" ?
                      Container(
                        color:  Colors.transparent,
                        height: 120,
                        width: 120,
                        child: Image.asset(ImagePath.USER_DEFAULT),
                      ):
                      PrecacheAvatarCard(
                        imageUrl: profilePic,
                        height: 120,
                        width: 120,
                      ),
                    )
                  ],
                ),
              ),
              SpaceH20(),
              _buildPersonalData(context),
              SpaceH20(),
              _buildAboutMe(context),
              SpaceH20(),
              _buildMyDataOfInterest(context),
              SpaceH20(),
              _buildMyLanguages(context),
              SpaceH20(),
              _buildMyReferences(context, user),
            ],
          ),
        ),
        SpaceW20(),
        Container(
          width: 600,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SpaceH50(),
              Text(
                '${user?.firstName} ${user?.lastName}',
                style: textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: Responsive.isDesktop(context) ? 45.0 : 32.0,
                    color: AppColors.primary900),
              ),
              SpaceH30(),
              _buildMyEducation(context, user),
              SpaceH30(),
              _buildMySecondaryEducation(context, user),
              SpaceH30(),
              _buildMyExperiences(context, user),
              SpaceH30(),
              _buildMyCompetencies(context, user),
              SpaceH30(),
              _buildFinalCheck(context, user),
              SpaceH30(),
            ],
          ),
        )
      ],
    );
  }


  Widget _myCurriculumWeb(BuildContext context, UserEnreda? user, String profilePic, List<String> competenciesNames){
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              width: Responsive.isDesktopS(context) ? MediaQuery.of(context).size.width * 0.25 :
              MediaQuery.of(context).size.width * 0.2,
              height: double.infinity,
              padding: EdgeInsets.only(
                left: Sizes.mainPadding * 1.3,
                top: Sizes.mainPadding,
              ),
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      AppColors.primary400.withOpacity(0.15),
                      AppColors.primary020.withOpacity(0.13)
                    ],
                  )
              ),
              child: Padding(
                padding: EdgeInsets.only(right: 50.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildMyProfilePhoto(user),
                    SpaceH20(),
                    _buildPersonalData(context),
                    SpaceH20(),
                    _buildAboutMe(context),
                    SpaceH20(),
                    _buildMyDataOfInterest(context),
                    SpaceH20(),
                    _buildMyLanguages(context),
                    SpaceH20(),
                    _buildMyReferences(context, user),
                  ],
                ),
              )),
          SpaceW40(),
          Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  right: Sizes.mainPadding * 2,
                  top: Sizes.mainPadding * 2,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildCVHeader(context, user, profilePic, competenciesNames),
                    SpaceH30(),
                    _buildMyEducation(context, user),
                    SpaceH30(),
                    _buildMySecondaryEducation(context, user),
                    SpaceH30(),
                    _buildMyExperiences(context, user),
                    SpaceH30(),
                    _buildMyCompetencies(context, user),
                    SpaceH30(),
                    _buildFinalCheck(context, user),
                    SpaceH30(),
                  ],
                ),
              ))
        ],
      ),
    );
  }

  Widget _myCurriculumMobile(BuildContext context, UserEnreda? user, String profilePic, List<String> competenciesNames) {
    final textTheme = Theme.of(context).textTheme;
    return SingleChildScrollView(
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Responsive.isMobile(context) ? Container() : SpaceH12(),
                _buildMyProfilePhoto(user),
                Text(
                  '${user?.firstName} ${user?.lastName}',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: AppColors.primary900),
                  textAlign: TextAlign.left,
                ),
                SpaceH24(),
                _buildMyEducation(context, user),
                SpaceH24(),
                _buildMySecondaryEducation(context, user),
                SpaceH24(),
                _buildMyExperiences(context, user),
                SpaceH24(),
                _buildMyCompetencies(context, user),
              ],
            ),
            Container(
              padding: EdgeInsets.all(Sizes.mainPadding),
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      AppColors.primary400.withOpacity(0.15),
                      AppColors.primary020.withOpacity(0.13)
                    ],
                  )
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SpaceH24(),
                  CustomTextTitle(title: StringConst.PERSONAL_DATA.toUpperCase(), color: AppColors.primary900),
                  Row(
                    children: [
                      Icon(
                        Icons.mail,
                        color: Colors.black.withOpacity(0.7),
                        size: 16,
                      ),
                      SpaceW4(),
                      CustomTextSmall(text: user?.email ?? ''),
                    ],
                  ),
                  SpaceH8(),
                  Row(
                    children: [
                      Icon(
                        Icons.phone,
                        color: AppColors.darkGray,
                        size: 12.0,
                      ),
                      SpaceW4(),
                      Text(
                        user?.phone ?? '',
                        style: textTheme.bodySmall?.copyWith(
                            fontSize: Responsive.isDesktop(context) ? 16 : 14.0,
                            color: AppColors.darkGray),
                      ),
                    ],
                  ),
                  SpaceH8(),
                  _buildMyLocation(context, user),
                  SpaceH24(),
                  _buildAboutMe(context),
                  SpaceH24(),
                  _buildMyDataOfInterest(context),
                  SpaceH24(),
                  _buildMyLanguages(context),
                  SpaceH24(),
                  _buildMyReferences(context, user),
                  SpaceH24(),
                  _buildFinalCheck(context, user),
                  SpaceH24(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCVHeader(BuildContext context, UserEnreda? user, String profilePic, List<String> competenciesNames) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: Responsive.isDesktopS(context) ? 200.0 : 300.0,
              child: Text(
                '${user?.firstName} ${user?.lastName}',
                style: textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: Responsive.isDesktopS(context) ? 30.0 : 40.0,
                    color: AppColors.primary900),
              ),
            ),
            Spacer(),
            _buildDownloadCV(),
            SpaceW8(),
          ],
        ),
      ],
    );
  }

  Widget _buildDownloadCV() {
    return InkWell(
      onTap: () async {
        final checkAgreeDownload = user?.checkAgreeCV ?? false;
        if(!checkAgreeDownload){
          showAlertDialog(context,
              title: 'Aviso importante',
              content: 'El participante debe autorizar el uso y tratamiento de datos personales antes de continuar',
              defaultActionText: 'Aceptar'
          );
          return;
        }
        await _hasEnoughExperiences(context);
        Navigator.push(
          context,
          MaterialPageRoute( builder: (context) {
            return MyCvMultiplePages(
              user: user!,
              myPhoto: true,
              city: city!,
              province: province!,
              country: country!,
              myExperiences: myCustomExperiences,
              myPersonalExperiences: myPersonalCustomExperiences,
              myEducation: myCustomEducation,
              mySecondaryEducation: mySecondaryCustomEducation,
              competenciesNames: myCustomCompetencies,
              aboutMe: myCustomAboutMe,
              languagesNames: myCustomLanguages,
              myDataOfInterest: myCustomDataOfInterest,
              myCustomEmail: myCustomEmail,
              myCustomPhone: myCustomPhone,
              myCustomReferences: myCustomReferences,
              myMaxEducation: myMaxEducation?.label ?? '',
            );

          }),
        );
      },
      child: Image.asset(
        ImagePath.DOWNLOAD,
        height:
        Responsive.isTablet(context) || Responsive.isMobile(context)
            ? Sizes.ICON_SIZE_40
            : Sizes.ICON_SIZE_50,
      ),
    );
  }

  Widget _buildMyProfilePhoto(UserEnreda? userEnreda) {
    return Container(
      padding: Responsive.isMobile(context) ? EdgeInsets.symmetric(vertical: 25, horizontal: 0) :
        EdgeInsets.symmetric(vertical: 10, horizontal: Sizes.mainPadding),
      width: double.infinity,
      child: Stack(
        children: [
          Theme(
            data: ThemeData(
              iconTheme: IconThemeData(color: AppColors.white),
            ),
            child: Container(
              width: Responsive.isMobile(context) ? 80 : 120,
              height:  Responsive.isMobile(context) ? 80 : 120,
              color: Colors.transparent,
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(120),
                    ),
                    child:
                    ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(60)),
                      child:
                      Center(
                        child:
                        _photo == "" ?
                        Container(
                          color:  Colors.transparent,
                          height: Responsive.isMobile(context) ? 80 :  120,
                          width:  Responsive.isMobile(context) ? 80 : 120,
                          child: Image.asset(ImagePath.USER_DEFAULT),
                        ):
                        FadeInImage.assetNetwork(
                          placeholder: ImagePath.USER_DEFAULT,
                          width:  Responsive.isMobile(context) ? 80 : 120,
                          height:  Responsive.isMobile(context) ? 80 : 120,
                          fit: BoxFit.cover,
                          image: _photo,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            right: 10,
            top: 0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Responsive.isDesktop(context) ? Container() : _buildDownloadCV(),
                Responsive.isDesktop(context) ? Container() : SpaceH50(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMyCareer(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);

    return StreamBuilder(
        stream: database.educationStream(),
        builder: (context, snapshotEducations) {
          if (snapshotEducations.hasData) {
            final educations = snapshotEducations.data!;

            if (user!.educationId!.isNotEmpty) {
              myMaxEducation = educations.firstWhere((e) => e.educationId == user!.educationId, orElse: () => Education(label: "", value: "", order: 0));
              return CustomTextBody(text: myMaxEducation?.label??"");
            } else {
              return StreamBuilder(
                  stream: database.myExperiencesStream(user?.userId ?? ''),
                  builder: (context, snapshotExperiences) {
                    if (snapshotEducations.hasData && snapshotExperiences.hasData) {
                      final myEducationalExperiencies = snapshotExperiences.data!
                          .where((experience) => experience.type == 'Formativa')
                          .toList();
                      if (myEducationalExperiencies.isNotEmpty) {
                        final areEduactions = myEducationalExperiencies.any((exp) => exp.education != null && exp.education!.isNotEmpty);
                        if (areEduactions) {
                          final myEducations = educations.where((edu) => myEducationalExperiencies.any((exp) => exp.education == edu.label)).toList();
                          myEducations.sort((a, b) => a.order.compareTo(b.order));
                          if(myEducations.isNotEmpty){
                            myMaxEducation = myEducations.first;
                          } else {
                            myMaxEducation = Education(label: "", value: "", order: 0);
                          }
                        } else {
                          myMaxEducation = Education(label: "", value: "", order: 0);
                        }
                        return CustomTextBody(text: myMaxEducation?.label??"");
                      } else {
                        return Container();
                      }
                    } else {
                      return Container();
                    }
                  });
            }
          } else {
            return Container();
          }
        });
  }

  Widget _buildAboutMe(BuildContext context) {
    return StatefulBuilder(builder: (context, setState) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child:
                CustomTextTitle(title: StringConst.ABOUT_ME.toUpperCase(), color: AppColors.primary900,),
              ),
            ],
          ),
        ],
      );
    });
  }

  Widget _buildPersonalData(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextTitle(title: StringConst.PERSONAL_DATA.toUpperCase(), color: AppColors.primary900,),
        Row(
          children: [
            Icon(
              Icons.mail,
              color: AppColors.darkGray,
              size: 12.0,
            ),
            SpaceW4(),
            Flexible(
              child: Text(
                user?.email ?? '',
                style: textTheme.bodyMedium?.copyWith(),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Icon(
              Icons.phone,
              color: AppColors.darkGray,
              size: 12.0,
            ),
            SpaceW4(),
            Text(
              user?.phone ?? '',
              style: textTheme.bodyMedium?.copyWith(),
            ),
          ],
        ),
        SpaceH8(),
        _buildMyLocation(context, user),
      ],
    );
  }

  Widget _buildMyLocation(BuildContext context, UserEnreda? user) {
    final database = Provider.of<Database>(context, listen: false);
    final textTheme = Theme.of(context).textTheme;
    Country? myCountry;
    Province? myProvince;
    City? myCity;

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

                      myLocation =
                      '${myCity?.name ?? ''}, ${myProvince?.name ?? ''}, ${myCountry?.name ?? ''}';
                      city = '${myCity?.name ?? ''}';
                      province = '${myProvince?.name ?? ''}';
                      country = '${myCountry?.name ?? ''}';

                      myCustomCity = city!;
                      myCustomProvince = province!;
                      myCustomCountry = country!;

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
                          Responsive.isMobile(context) ? CustomTextSmall(text: myLocation ?? '') :
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                city ?? '',
                                style: textTheme.bodyMedium?.copyWith(),
                              ),
                              Text(
                                province ?? '',
                                style: textTheme.bodyMedium?.copyWith(),
                              ),
                              Text(
                                country ?? '',
                                style: textTheme.bodyMedium?.copyWith(),
                              ),
                            ],
                          ),
                        ],
                      );
                    });
              });
        });
  }

  Widget _buildMyCompetencies(BuildContext context, UserEnreda? user) {
    final database = Provider.of<Database>(context, listen: false);
    final textTheme = Theme.of(context).textTheme;
    final controller = ScrollController();
    var scrollJump = 137.5;
    return StreamBuilder<List<Competency>>(
      stream: database.competenciesStream(),
      builder: (context, snapshot) {
        if (snapshot.hasData &&
            snapshot.connectionState == ConnectionState.active) {
          final competenciesIds = user!.competencies.keys.toList();
          myCompetencies = snapshot.data!
              .where((competency) => competenciesIds.any((id) => competency.id == id &&
              (user.competencies[id] == StringConst.BADGE_VALIDATED ||
                  user.competencies[id] == StringConst.BADGE_CERTIFIED) ))
              .toList();
          return Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.rectangle,
                border: Border.all(color: AppColors.primary900, width: 1),
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: Container(
                      height: 34,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomTextTitle(title: StringConst.COMPETENCIES.toUpperCase(), color: AppColors.primary900,),
                        ],
                      ),
                    ),
                  ),
                  myCompetencies!.isNotEmpty
                      ? Container(
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: InkWell(
                            onTap: () {
                              if (controller.position.pixels >=
                                  controller.position.minScrollExtent)
                                controller.animateTo(
                                    controller.position.pixels - scrollJump,
                                    duration: Duration(milliseconds: 500),
                                    curve: Curves.ease);
                            },
                            child: Icon(
                              Icons.arrow_back_ios_new,
                              color: AppColors.primary900,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            height: 185.0,
                            child: ScrollConfiguration(
                              behavior: MyCustomScrollBehavior(),
                              child: ListView(
                                controller: controller,
                                scrollDirection: Axis.horizontal,
                                children: myCompetencies!.map((competency) {
                                  final status =
                                      user.competencies[competency.id] ??
                                          StringConst.BADGE_EMPTY;
                                  return Column(
                                    children: [
                                      CompetencyTile(
                                        competency: competency,
                                        status: status,
                                        mini: true,
                                        height: 40,
                                      ),
                                      Text(
                                          status == StringConst.BADGE_VALIDATED
                                              ? 'EVALUADA'
                                              : 'CERTIFICADA',
                                          style: textTheme.bodySmall
                                              ?.copyWith(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 10,
                                              color: AppColors.primaryColor)),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding:
                          const EdgeInsets.symmetric(horizontal: 10.0),
                          child: InkWell(
                            onTap: () {
                              if (controller.position.pixels <=
                                  controller.position.maxScrollExtent)
                                controller.animateTo(
                                    controller.position.pixels + scrollJump,
                                    duration: Duration(milliseconds: 500),
                                    curve: Curves.ease);
                            },
                            child: Icon(
                              Icons.arrow_forward_ios,
                              color: AppColors.primary900,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                      : Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Center(
                        child: Text(
                          'Aquí aparecerán las competencias evaluadas a través de los microtests',
                          style: textTheme.bodySmall,
                        )),
                  ),
                ],
              )
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _buildFinalCheck(BuildContext context, UserEnreda? user){
    final bool checkFinal = user?.checkAgreeCV ?? false;
    TextTheme textTheme = Theme.of(context).textTheme;
    double fontSize = responsiveSize(context, 12, 14, md: 13);
    return  Row(
      children: [
        IconButton(
          icon: Icon(checkFinal ? Icons.check_box : Icons.crop_square),
          color: AppColors.primary900,
          iconSize: 20.0,
          onPressed: () {}, // Empty function can be a const
        ),
        Flexible(
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: StringConst.PERSONAL_DATA_LAW,
                  style: textTheme.titleMedium?.copyWith(
                    color: AppColors.primary900,
                    height: 1.5,
                    fontSize: fontSize,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      launchURL(StringConst.PERSONAL_DATA_LAW_PDF);
                    },
                ),
                TextSpan(
                  text: StringConst.PERSONAL_DATA_LAW_TEXT,
                  style: textTheme.bodySmall?.copyWith(
                    color: AppColors.primary900,
                    height: 1.5,
                    fontSize: fontSize,
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget _buildMyEducation(BuildContext context, UserEnreda? user) {
    final database = Provider.of<Database>(context, listen: false);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomTextTitle(title: StringConst.EDUCATIONAL_LEVEL.toUpperCase(), color: AppColors.primary900,),
          ],
        ),
        _buildMyCareer(context),
        SpaceH20(),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomTextTitle(title: StringConst.EDUCATION.toUpperCase(), color: AppColors.primary900,),
          ],
        ),
        SpaceH4(),
        StreamBuilder<List<Experience>>(
            stream: database.myExperiencesStream(user?.userId ?? ''),
            builder: (context, snapshot) {
              if (snapshot.hasData &&
                  snapshot.connectionState == ConnectionState.active) {
                myEducation = snapshot.data!
                    .where((experience) => experience.type == 'Formativa')
                    .toList();
                myCustomEducation = myEducation!.map((element) => element).toList();
                mySelectedEducation = List.generate(myCustomEducation.length, (i) => i);
                return Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30.0),
                    color: Colors.white,
                  ),
                  child: myEducation!.isNotEmpty
                      ? Wrap(
                    children: myEducation!
                        .map((e) => Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        SpaceH12(),
                        Container(
                          width: double.infinity,
                          child: ExperienceTile(experience: e, type: e.type),
                        ),
                        Divider(color: AppColors.greyBorder,),
                      ],
                    ))
                        .toList(),
                  )
                      : CustomTextBody(text: StringConst.NO_EDUCATION),
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            }),
      ],
    );
  }

  Widget _buildMySecondaryEducation(BuildContext context, UserEnreda? user) {
    final database = Provider.of<Database>(context, listen: false);
    return Column(
      children: [
        Row(
          children: [
            CustomTextTitle(title: StringConst.SECONDARY_EDUCATION.toUpperCase(), color: AppColors.primary900,),
          ],
        ),
        SpaceH4(),
        StreamBuilder<List<Experience>>(
            stream: database.myExperiencesStream(user?.userId ?? ''),
            builder: (context, snapshot) {
              if (snapshot.hasData &&
                  snapshot.connectionState == ConnectionState.active) {
                mySecondaryEducation = snapshot.data!
                    .where((experience) => experience.type == 'Complementaria')
                    .toList();
                mySecondaryCustomEducation = mySecondaryEducation!.map((element) => element).toList();
                mySecondarySelectedEducation = List.generate(mySecondaryCustomEducation.length, (i) => i);
                return Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30.0),
                    color: Colors.white,
                  ),
                  child: mySecondaryEducation!.isNotEmpty
                      ? Wrap(
                    children: mySecondaryEducation!
                        .map((e) => Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        SpaceH12(),
                        Container(
                          width: double.infinity,
                          child: ExperienceTile(experience: e, type: e.type),
                        ),
                        Divider(color: AppColors.greyBorder,),
                      ],
                    ))
                        .toList(),
                  )
                      : CustomTextBody(text: StringConst.NO_EDUCATION),
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            }),
      ],
    );
  }

  Widget _buildProfesionalExperience(BuildContext context, UserEnreda? user) {
    final database = Provider.of<Database>(context, listen: false);
    return Column(
      children: [
        Row(
          children: [
            CustomTextTitle(title: StringConst.MY_PROFESIONAL_EXPERIENCES.toUpperCase(), color: AppColors.primary900,),
          ],
        ),
        SpaceH4(),
        StreamBuilder<List<Experience>>(
            stream: database.myExperiencesStream(user?.userId ?? ''),
            builder: (context, snapshot) {
              if (snapshot.hasData &&
                  snapshot.connectionState == ConnectionState.active) {
                myExperiences = snapshot.data!
                    .where((experience) => experience.type == 'Profesional')
                    .toList();
                myCustomExperiences = myExperiences!.map((element) => element).toList();
                mySelectedExperiences = List.generate(myCustomExperiences.length, (i) => i);
                return Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30.0),
                    color: Colors.white,
                  ),
                  child: myExperiences!.isNotEmpty
                      ? Wrap(
                    children: myExperiences!
                        .map((e) => Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        SpaceH4(),
                        Container(
                          width: double.infinity,
                          child: ExperienceTile(experience: e, type: e.type),
                        ),
                        Divider(color: AppColors.greyBorder,),
                      ],
                    ))
                        .toList(),
                  )
                      : CustomTextBody(text: StringConst.NO_EXPERIENCE),
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            }),
      ],
    );
  }

  Widget _buildPersonalExperience(BuildContext context, UserEnreda? user) {
    final database = Provider.of<Database>(context, listen: false);
    return Column(
      children: [
        Row(
          children: [
            CustomTextTitle(title: StringConst.MY_PERSONAL_EXPERIENCES.toUpperCase(), color: AppColors.primary900,),
          ],
        ),
        SpaceH4(),
        StreamBuilder<List<Experience>>(
            stream: database.myExperiencesStream(user?.userId ?? ''),
            builder: (context, snapshot) {
              if (snapshot.hasData &&
                  snapshot.connectionState == ConnectionState.active) {
                myPersonalExperiences = snapshot.data!
                    .where((experience) => experience.type == 'Personal')
                    .toList();
                myPersonalCustomExperiences = myPersonalExperiences!.map((element) => element).toList();
                myPersonalSelectedExperiences = List.generate(myPersonalCustomExperiences.length, (i) => i);
                return Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30.0),
                    color: Colors.white,
                  ),
                  child: myPersonalExperiences!.isNotEmpty
                      ? Wrap(
                    children: myPersonalExperiences!
                        .map((e) => Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        SpaceH12(),
                        Container(
                          width: double.infinity,
                          child: ExperienceTile(experience: e, type: e.type,),
                        ),
                        Divider(color: AppColors.greyBorder,),
                      ],
                    ))
                        .toList(),
                  )
                      : CustomTextBody(text: StringConst.NO_EXPERIENCE),
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            }),
      ],
    );
  }

  Widget _buildMyExperiences(BuildContext context, UserEnreda? user) {
    return Column(
      children: [
        Row(
          children: [
            CustomTextTitle(title: StringConst.MY_EXPERIENCES.toUpperCase(), color: AppColors.primary900,),
          ],
        ),
        SpaceH4(),
        _buildProfesionalExperience(context, user),
        SpaceH4(),
        _buildPersonalExperience(context, user),
      ],
    );
  }

  Widget _buildMyDataOfInterest(BuildContext context) {
    final myDataOfInterest = user?.dataOfInterest ?? [];
    return Column(
      children: [
        Row(
          children: [
            CustomTextTitle(title: StringConst.DATA_OF_INTEREST.toUpperCase(), color: AppColors.primary900,),
          ],
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
                  height: 20.0,
                  child: Row(
                    children: [
                      Expanded(child: CustomTextBody(text: d)),
                    ],
                  ),
                ),
              ],
            ))
                .toList(),
          )
              : CustomTextBody(text: StringConst.NO_DATA_OF_INTEREST),
        ),
      ],
    );
  }

  Widget _buildMyLanguages(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final myLanguages = user?.languagesLevels ?? [];
    return Column(
      children: [
        Row(
          children: [
            CustomTextTitle(title: StringConst.LANGUAGES.toUpperCase(), color: AppColors.primary900,),
          ],
        ),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30.0),
            color: Colors.transparent,
          ),
          child: myLanguages.isNotEmpty
              ? Wrap(
            children: myLanguages
                .map((l) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SpaceH12(),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        l.name,
                        style: textTheme.bodySmall?.copyWith(),
                      ),
                    ),
                  ],
                ),
                SpaceH12(),
                _buildSpeakingLevelRow(
                  value: l.speakingLevel.toDouble(),
                  textTheme: textTheme,
                  iconSize: 15.0,
                  onValueChanged: null,),
                SpaceH12(),
                _buildWritingLevelRow(
                  value: l.writingLevel.toDouble(),
                  textTheme: textTheme,
                  iconSize: 15.0,
                  onValueChanged: null,),
                Divider(color: AppColors.greyBorder,),
              ],
            ))
                .toList(),
          )
              : Padding(
            padding: EdgeInsets.symmetric(vertical: 20.0),
            child: Center(child: CustomTextSmall(text: StringConst.NO_LANGUAGES)),
          ),
        ),
      ],
    );
  }

  Widget _buildMyReferences(BuildContext context, UserEnreda? user) {
    final database = Provider.of<Database>(context, listen: false);
    return Column(
      children: [
        Row(
          children: [
            CustomTextTitle(title: StringConst.PERSONAL_REFERENCES.toUpperCase(), color: AppColors.primary900,),
            SpaceW12(),
          ],
        ),
        SpaceH4(),
        StreamBuilder<List<CertificationRequest>>(
            stream: database.myCertificationRequestStream(user?.userId ?? ''),
            builder: (context, snapshot) {
              if (snapshot.hasData &&
                  snapshot.connectionState == ConnectionState.active) {
                myReferences = snapshot.data!
                    .where((certificationRequest) => certificationRequest.referenced == true)
                    .toList();
                myCustomReferences = myReferences!.map((element) => element).toList();
                mySelectedReferences = List.generate(myCustomReferences.length, (i) => i);
                return Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  child: myReferences!.isNotEmpty
                      ? Wrap(
                    children: myReferences!
                        .map((e) => Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        SpaceH12(),
                        Container(
                          width: double.infinity,
                          child: Row(
                            children: [
                              ReferenceTile(certificationRequest: e),
                            ],
                          ),
                        ),
                        Divider(color: AppColors.greyBorder,),
                      ],
                    )).toList(),
                  )
                      : Padding(
                    padding: EdgeInsets.symmetric(vertical: 20.0),
                    child: Center(child: CustomTextSmall(text: StringConst.NO_REFERENCES)),
                  ),
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            }),
      ],
    );
  }

  Widget _buildWritingLevelRow({
    required TextTheme textTheme,
    required double value,
    double iconSize = 20.0,
    dynamic Function(double)? onValueChanged
  }) {
    return Row(
      children: [
        Expanded(
          child: Text(
            'Expresión escrita',
            style: textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
        SmoothStarRating(
            allowHalfRating: false,
            onRatingChanged: onValueChanged,
            starCount: 3,
            rating: value,
            size: iconSize,
            filledIconData: Icons.circle,
            defaultIconData: Icons.circle_outlined,
            color: AppColors.primary900,
            borderColor: AppColors.primary900,
            spacing: 5.0
        )
      ],
    );
  }

  Widget _buildSpeakingLevelRow({
    required TextTheme textTheme,
    required double value,
    double iconSize = 20.0,
    dynamic Function(double)? onValueChanged
  }) {
    return Row(
      children: [
        Expanded(
          child: Text(
            'Expresión oral',
            style: textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
        SmoothStarRating(
            allowHalfRating: false,
            onRatingChanged: onValueChanged,
            starCount: 3,
            rating: value,
            size: iconSize,
            filledIconData: Icons.circle,
            defaultIconData: Icons.circle_outlined,
            color: AppColors.primary900,
            borderColor: AppColors.primary900,
            spacing: 5.0
        )
      ],
    );
  }

  Future<void> _hasEnoughExperiences(BuildContext context) async {
    if (myCompetencies!.length < 3 || myExperiences!.length < 2) {
      await showCustomDialog(context,
          content: CustomTextBody(text: StringConst.ADD_MORE_EXPERIENCES_SUGGESTION),
          defaultActionText: StringConst.FORM_ACCEPT,
          onDefaultActionPressed: (dialogContext) => Navigator.of(dialogContext).pop(true));
    }
  }

}
