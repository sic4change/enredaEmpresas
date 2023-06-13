import 'package:cached_network_image/cached_network_image.dart';
import 'package:enreda_empresas/app/common_widgets/custom_text.dart';
import 'package:enreda_empresas/app/common_widgets/enreda_button.dart';
import 'package:enreda_empresas/app/common_widgets/precached_avatar.dart';
import 'package:enreda_empresas/app/common_widgets/spaces.dart';
import 'package:enreda_empresas/app/home/participants/pdf_generator/pdf_preview.dart';
import 'package:enreda_empresas/app/models/certificationRequest.dart';
import 'package:enreda_empresas/app/models/experience.dart';
import 'package:enreda_empresas/app/models/userEnreda.dart';
import 'package:enreda_empresas/app/utils/adaptative.dart';
import 'package:enreda_empresas/app/utils/responsive.dart';
import 'package:enreda_empresas/app/values/strings.dart';
import 'package:enreda_empresas/app/values/values.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MyCvModelsPage extends StatelessWidget {
  MyCvModelsPage({
    Key? key,
    required this.user,
    required this.city,
    required this.province,
    required this.country,
    required this.myCustomAboutMe,
    required this.myCustomEmail,
    required this.myCustomPhone,
    required this.myExperiences,
    required this.myCustomExperiences,
    required this.mySelectedExperiences,
    required this.myEducation,
    required this.myCustomEducation,
    required this.mySelectedEducation,
    required this.competenciesNames,
    required this.myCustomCompetencies,
    required this.mySelectedCompetencies,
    required this.myCustomDataOfInterest,
    required this.mySelectedDataOfInterest,
    required this.myCustomLanguages,
    required this.mySelectedLanguages,
    required this.myCustomCity,
    required this.myCustomProvince,
    required this.myCustomCountry,
    required this.myReferences,
    required this.myCustomReferences,
    required this.mySelectedReferences,

  }) : super(key: key);

  final UserEnreda? user;
  final String? city;
  final String? province;
  final String? country;
  String myCustomCity;
  String myCustomProvince;
  String myCustomCountry;
  String myCustomAboutMe;
  String myCustomEmail;
  String myCustomPhone;
  final List<Experience>? myExperiences;
  List<Experience> myCustomExperiences;
  List<int> mySelectedExperiences;
  final List<Experience>? myEducation;
  List<Experience> myCustomEducation;
  List<int> mySelectedEducation;
  final List<String> competenciesNames;
  List<String> myCustomCompetencies;
  List<int> mySelectedCompetencies;
  List<String> myCustomDataOfInterest;
  List<int> mySelectedDataOfInterest;
  List<String> myCustomLanguages;
  List<int> mySelectedLanguages;
  final List<CertificationRequest>? myReferences;
  List<CertificationRequest> myCustomReferences;
  List<int> mySelectedReferences;

  int? _selectedEducationIndex;

  int? _selectedExperienceIndex;

  int? _selectedReferenceIndex;

  int? _selectedCompetenciesIndex;

  int? _selectedLanguagesIndex;

  int? _selectedDataOfInterestIndex;

  final bool _isSelectedPhoto = true;

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    double fontSize = responsiveSize(context, 20, 22, md: 22);

    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Curriculum Vitae',
            textAlign: TextAlign.left,
            style: textTheme.bodySmall?.copyWith(
              color: AppColors.white,
              height: 1.5,
              letterSpacing: 0.3,
              fontWeight: FontWeight.w800,
              fontSize: fontSize,
            ),
          ),
          backgroundColor: AppColors.primaryColor,
          elevation: 0.0,
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
        ),
        body: _buildContent(context)
    );
  }

  Widget _buildContent(BuildContext context) {
    return SafeArea(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Responsive.isDesktop(context) ?
          _myCurriculumWeb(context) :
          _myCurriculumMobile(context),
        ],
      ),
    );
  }

  Widget _myCurriculumWeb(BuildContext context){
    var profilePic = user?.profilePic?.src ?? "";
    return Container(
      margin: const EdgeInsets.all(20.0),
      height: MediaQuery.of(context).size.height * 0.90,
      width: MediaQuery.of(context).size.width * 0.80,
      padding: const EdgeInsets.all(30.0),
      decoration: BoxDecoration(
        color: AppColors.lightLilac,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Colors.black26,
            blurRadius: 4.0,
            offset: Offset(0.0, 1.0),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              padding: const EdgeInsets.only(
                  top: 20.0, bottom: 20, right: 5, left: 20),
              width: Responsive.isDesktop(context) ? 330 : Responsive.isDesktopS(context) ? 290.0 : 290,
              height: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.white,
                shape: BoxShape.rectangle,
                border: Border.all(color: AppColors.lilac, width: 1),
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: SingleChildScrollView(
                controller: ScrollController(),
                child: Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          Padding(
                            padding: Responsive.isMobile(context)
                                ? const EdgeInsets.all(8.0)
                                : const EdgeInsets.all(20.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                !kIsWeb ?
                                ClipRRect(
                                  borderRadius: const BorderRadius.all(Radius.circular(60)),
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
                                  borderRadius: const BorderRadius.all(Radius.circular(60)),
                                  child:
                                  user?.profilePic?.src == "" ?
                                  Container(
                                    color:  Colors.transparent,
                                    height: 120,
                                    width: 120,
                                    child: Image.asset(ImagePath.USER_DEFAULT),
                                  ):
                                  PrecacheAvatarCard(
                                    imageUrl: profilePic,
                                    width: 120,
                                    height: 120,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SpaceH20(),
                      _buildPersonalData(context),
                      const SpaceH20(),
                      _buildAboutMe(context),
                      const SpaceH20(),
                      _buildMyDataOfInterest(context),
                      const SpaceH20(),
                      _buildMyLanguages(context),
                      const SpaceH20(),
                      _buildMyReferences(context),
                      const SpaceH20(),
                    ],
                  ),
                ),
              )),
          const SpaceW20(),
          Expanded(
              child: SingleChildScrollView(
                controller: ScrollController(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildCVHeader(context),
                    const SpaceH40(),
                    _buildMyEducation(context),
                    const SpaceH40(),
                    _buildMyExperiences(context),
                    const SpaceH40(),
                    _buildMyCompetencies(context),
                  ],
                ),
              ))
        ],
      ),
    );
  }

  Widget _myCurriculumMobile(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    var profilePic = user?.profilePic?.src ?? "";
    return SingleChildScrollView(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.95,
        margin: EdgeInsets.only(top: Sizes.mainPadding, bottom: Sizes.mainPadding),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.greyLight, width: 1),
          borderRadius: const BorderRadius.all(Radius.circular(40.0)),
          color: AppColors.lightLilac,
        ),
        child: Padding(
          padding: EdgeInsets.all(Sizes.mainPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                      flex: 5,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: CustomTextBody(text: StringConst.MY_CV.toUpperCase()),
                      )),
                  Expanded(
                    flex: Responsive.isMobile(context) ? 4 : 2,
                    child: EnredaButton(
                      buttonTitle: "Vista previa",
                      width: 80,
                      onPressed: () async {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  MyCv(
                                    user: user!,
                                    myPhoto: _isSelectedPhoto,
                                    city: myCustomCity,
                                    province: myCustomProvince,
                                    country: myCustomCountry,
                                    myExperiences: myCustomExperiences,
                                    myEducation: myCustomEducation,
                                    competenciesNames: myCustomCompetencies,
                                    aboutMe: myCustomAboutMe,
                                    languagesNames: myCustomLanguages,
                                    myDataOfInterest: myCustomDataOfInterest,
                                    myCustomEmail: myCustomEmail,
                                    myCustomPhone: myCustomPhone,
                                    myCustomReferences: myCustomReferences,
                                  )
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              const SpaceH20(),
              Padding(
                padding: Responsive.isMobile(context)
                    ? const EdgeInsets.all(8.0)
                    : const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    !kIsWeb ?
                    ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(60)),
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
                      borderRadius: const BorderRadius.all(Radius.circular(60)),
                      child:
                      user?.profilePic?.src == "" ?
                      Container(
                        color:  Colors.transparent,
                        height: 120,
                        width: 120,
                        child: Image.asset(ImagePath.USER_DEFAULT),
                      ):
                      PrecacheAvatarCard(
                        imageUrl: profilePic,
                        width: 120,
                        height: 120,
                      ),
                    ),
                  ],
                ),
              ),
              Responsive.isMobile(context) ? const SpaceH12() : const SpaceH24(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '${user?.firstName} ${user?.lastName}',
                    style: textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.penBlue),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              const SpaceH24(),
              Center(child:  Text(
                user?.educationName?.toUpperCase() ?? '',
                style: textTheme.bodyMedium?.copyWith(
                    color: AppColors.darkGray),
              )),
              const SpaceH24(),
              _buildPersonalData(context),
              const SpaceH24(),
              _buildMyEducation(context),
              const SpaceH24(),
              _buildMyExperiences(context),
              const SpaceH24(),
              _buildMyCompetencies(context),
              const SpaceH24(),
              _buildAboutMe(context),
              const SpaceH24(),
              _buildMyDataOfInterest(context),
              const SpaceH24(),
              _buildMyLanguages(context),
              const SpaceH24(),
              _buildMyReferences(context),
              const SpaceH24(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCVHeader(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CustomTextBody(text: StringConst.MY_CV.toUpperCase()),
            const Spacer(),
            EnredaButton(
              buttonTitle: "Vista previa",
              width: 100,
              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          MyCv(
                            user: user!,
                            myPhoto: _isSelectedPhoto,
                            city: myCustomCity,
                            province: myCustomProvince,
                            country: myCustomCountry,
                            myExperiences: myCustomExperiences,
                            myEducation: myCustomEducation,
                            competenciesNames: myCustomCompetencies,
                            aboutMe: myCustomAboutMe,
                            languagesNames: myCustomLanguages,
                            myDataOfInterest: myCustomDataOfInterest,
                            myCustomEmail: myCustomEmail,
                            myCustomPhone: myCustomPhone,
                            myCustomReferences: myCustomReferences,
                          )
                  ),
                );
              },
            ),
            const SpaceW8(),
          ],
        ),
        const SpaceH20(),
        Text(
          '${user?.firstName} ${user?.lastName}',
          style: textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.penBlue),
        ),
        const SpaceH20(),
        Text(
          user?.educationName?.toUpperCase() ?? '',
          style: textTheme.bodyMedium?.copyWith(
              color: AppColors.darkGray),
        ),
        const SpaceH20(),
      ],
    );
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
                CustomTextTitle(title: StringConst.ABOUT_ME.toUpperCase()),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30.0),
              color: AppColors.white,
            ),
            child: Expanded(
              child: CustomTextBody(
                  text: user?.aboutMe != null && user!.aboutMe!.isNotEmpty
                      ? user!.aboutMe!
                      : 'Aún no ha añadido información adicional'),
            ),
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
        CustomTextTitle(title: StringConst.PERSONAL_DATA.toUpperCase()),
        const SpaceH4(),
        Container(
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30.0),
            color: AppColors.white,
          ),
          child: Column(
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.mail,
                    color: AppColors.darkGray,
                    size: 12.0,
                  ),
                  const SpaceW4(),
                  Expanded(
                    child: Text(
                      user?.email ?? '',
                      style: textTheme.bodySmall?.copyWith(
                          fontSize: Responsive.isDesktop(context) ? 14 : 14.0,
                          color: AppColors.darkGray),
                    ),
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
                  Expanded(
                    child: Text(
                      user?.phone ?? '',
                      style: textTheme.bodySmall?.copyWith(
                          fontSize: Responsive.isDesktop(context) ? 14 : 14.0,
                          color: AppColors.darkGray),
                    ),
                  ),
                ],
              ),
              const SpaceH8(),
              _buildMyLocation(context),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMyLocation(BuildContext context) {
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

  }

  Widget _buildMyCompetencies(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextTitle(title: StringConst.COMPETENCIES.toUpperCase()),
        const SpaceH4(),
        Container(
          padding: const EdgeInsets.all(20.0),
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30.0),
            color: AppColors.white,
          ),
          child: competenciesNames.isNotEmpty ?
          ListView.builder(
            shrinkWrap: true,
            itemCount: competenciesNames.length,
            itemBuilder: (context, index) {
              return Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(vertical: 0),
                  child: ListTile(
                    selected: index == _selectedCompetenciesIndex,
                    title: Row(
                      children: [
                        Expanded(
                          child: Text(
                              competenciesNames[index],
                              style: textTheme.bodySmall
                                  ?.copyWith(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.darkGray)
                          ),
                        ),
                      ],
                    ),
                  )
              );
            },
          ) :
          const Padding(
            padding: EdgeInsets.all(20.0),
            child: Center(
                child: Text(
                  'Aquí aparecerán las competencias evaluadas y certificadas'
                )),
          ),
        ),

      ],
    );
  }

  Widget _buildMyEducation(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextTitle(title: StringConst.EDUCATION.toUpperCase()),
        const SpaceH4(),
        Container(
          padding: const EdgeInsets.all(20.0),
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30.0),
            color: AppColors.white,
          ),
          child: myEducation!.isNotEmpty
              ?
          ListView.builder(
            shrinkWrap: true,
            itemCount: myEducation!.length,
            itemBuilder: (context, index) {
              return Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.symmetric(vertical: 0),
                child: ListTile(
                  selected: index == _selectedEducationIndex,
                  title: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            if (myEducation![index].activity != null && myEducation![index].activityRole != null)
                              RichText(
                                text: TextSpan(
                                    text: '${myEducation![index].activityRole!.toUpperCase()} -',
                                    style: textTheme.bodySmall?.copyWith(
                                      fontSize: 14.0,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: ' ${myEducation![index].activity!.toUpperCase()}',
                                        style: textTheme.bodySmall?.copyWith(
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )
                                    ]),
                              ),
                            if (myEducation![index].activity != null && myEducation![index].activityRole == null)
                              Text(myEducation![index].activity!,
                                  style: textTheme.bodySmall
                                      ?.copyWith(fontSize: 14.0, fontWeight: FontWeight.bold)),
                            if (myEducation![index].activity != null) const SpaceH8(),
                            if (myEducation![index].organization != null && myEducation![index].organization != "") Column(
                              children: [
                                Text(
                                  myEducation![index].organization!,
                                  style: textTheme.bodySmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14.0,
                                  ),
                                ),
                                const SpaceH8()
                              ],
                            ),
                            Text(
                              '${formatter.format(myEducation![index].startDate.toDate())} / ${myEducation![index].endDate != null
                                  ? formatter.format(myEducation![index].endDate!.toDate())
                                  : 'Actualmente'}',
                              style: textTheme.bodySmall?.copyWith(
                                fontSize: 14.0,
                              ),
                            ),
                            const SpaceH8(),
                            Text(
                              myEducation![index].location,
                              style: textTheme.bodySmall?.copyWith(
                                fontSize: 14.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          )
              : const CustomTextBody(text: 'Aquí aparecerá la educación'),
        ),
      ],
    );
  }

  Widget _buildMyExperiences(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextTitle(title: StringConst.MY_EXPERIENCES.toUpperCase()),
        const SpaceH4(),
        Container(
          padding: const EdgeInsets.all(20.0),
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30.0),
            color: AppColors.white,
          ),
          child: myExperiences!.isNotEmpty
              ?
          ListView.builder(
            shrinkWrap: true,
            itemCount: myExperiences!.length,
            itemBuilder: (context, index) {
              return Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.symmetric(vertical: 0),
                child: ListTile(
                  selected: index == _selectedExperienceIndex,
                  title: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            if (myExperiences![index].activity != null && myExperiences![index].activityRole != null)
                              RichText(
                                text: TextSpan(
                                    text: '${myExperiences![index].activityRole!.toUpperCase()} -',
                                    style: textTheme.bodySmall?.copyWith(
                                      fontSize: 14.0,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: ' ${myExperiences![index].activity!.toUpperCase()}',
                                        style: textTheme.bodySmall?.copyWith(
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )
                                    ]),
                              ),
                            if (myExperiences![index].activity != null && myExperiences![index].activityRole == null)
                              Text( myExperiences![index].position == null || myExperiences![index].position == "" ? '${myExperiences![index].activity!}' : '${myExperiences![index].position}',
                                  style: textTheme.bodySmall
                                      ?.copyWith(fontSize: 14.0, fontWeight: FontWeight.bold)),
                            if (myExperiences![index].position != null || myExperiences![index].activity != null) const SpaceH8(),
                            if (myExperiences![index].organization != null && myExperiences![index].organization != "") Column(
                              children: [
                                Text(
                                  myExperiences![index].organization!,
                                  style: textTheme.bodySmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14.0,
                                  ),
                                ),
                                const SpaceH8()
                              ],
                            ),
                            Text(
                              '${formatter.format(myExperiences![index].startDate.toDate())} / ${myExperiences![index].endDate != null
                                  ? formatter.format(myExperiences![index].endDate!.toDate())
                                  : 'Actualmente'}',
                              style: textTheme.bodySmall?.copyWith(
                                fontSize: 14.0,
                              ),
                            ),
                            const SpaceH8(),
                            Text(
                              myExperiences![index].location,
                              style: textTheme.bodySmall?.copyWith(
                                fontSize: 14.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          )
              : const CustomTextBody(text: 'Aquí aparecerá las experiencias'),
        ),
      ],
    );
  }

  Widget _buildMyDataOfInterest(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final myDataOfInterest = user?.dataOfInterest ?? [];
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextTitle(title: StringConst.DATA_OF_INTEREST.toUpperCase()),
        Container(
          padding: const EdgeInsets.all(10.0),
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30.0),
            color: AppColors.white,
          ),
          child: myDataOfInterest.isNotEmpty ?
          ListView.builder(
            shrinkWrap: true,
            itemCount: myDataOfInterest.length,
            itemBuilder: (context, index) {
              return ListTile(
                selected: index == _selectedDataOfInterestIndex,
                title: Row(
                  children: [
                    Expanded(
                      child: Text(
                          myDataOfInterest[index],
                          style: textTheme.bodySmall
                              ?.copyWith(
                              fontSize: 14.0,
                              fontWeight: FontWeight.w500,
                              color: AppColors.darkGray)
                      ),
                    ),
                  ],
                ),
              );
            },
          ) :
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Center(
                child: Text(
                  'Aquí aparecerá la información de interés',
                  style: textTheme.bodySmall,
                )),
          ),
        ),

      ],
    );
  }

  Widget _buildMyLanguages(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final myLanguages = user?.languages ?? [];
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextTitle(title: StringConst.LANGUAGES.toUpperCase()),
        Container(
          padding: const EdgeInsets.all(10.0),
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30.0),
            color: AppColors.white,
          ),
          child: myLanguages.isNotEmpty ?
          ListView.builder(
            shrinkWrap: true,
            itemCount: myLanguages.length,
            itemBuilder: (context, index) {
              return ListTile(
                selected: index == _selectedLanguagesIndex,
                title: Row(
                  children: [
                    Expanded(
                      child: Text(
                          myLanguages[index],
                          style: textTheme.bodySmall
                              ?.copyWith(
                              fontSize: 14.0,
                              fontWeight: FontWeight.w500,
                              color: AppColors.darkGray)
                      ),
                    ),
                  ],
                ),
              );
            },
          ) :
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Center(
                child: Text(
                  'Aquí aparecerán los idiomas',
                  style: textTheme.bodySmall,
                )),
          ),
        ),

      ],
    );
  }

  Widget _buildMyReferences(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextTitle(title: StringConst.PERSONAL_REFERENCES.toUpperCase()),
        const SpaceH4(),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30.0),
            color: AppColors.white,
          ),
          child: myReferences!.isNotEmpty ?
          ListView.builder(
            shrinkWrap: true,
            itemCount: myReferences!.length,
            itemBuilder: (context, index) {
              return Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.symmetric(vertical: 0),
                child: ListTile(
                  selected: index == _selectedReferenceIndex,
                  title: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            CustomTextBold(title: '${myReferences![index].certifierName}'),
                            const SpaceH4(),
                            RichText(
                              text: TextSpan(
                                  text: '${myReferences![index].certifierPosition.toUpperCase()} -',
                                  style: textTheme.bodySmall?.copyWith(
                                    fontSize: 14.0,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: ' ${myReferences![index].certifierCompany.toUpperCase()}',
                                      style: textTheme.bodySmall?.copyWith(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  ]),
                            ),
                            CustomTextSmall(text: '${myReferences![index].email}'),
                            myReferences![index].phone != "" ? CustomTextSmall(text: '${myReferences![index].phone}') : Container(),
                            const SizedBox(height: 10,),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          )
              : const Padding(
                padding: EdgeInsets.all(10.0),
                child: CustomTextBody(text: 'Aquí aparecerán las referencias personales'),
              ),
        ),
      ],
    );
  }
}


