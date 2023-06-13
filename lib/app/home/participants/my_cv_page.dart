import 'package:enreda_empresas/app/common_widgets/custom_text.dart';
import 'package:enreda_empresas/app/common_widgets/spaces.dart';
import 'package:enreda_empresas/app/home/participants/my_cv_model_page.dart';
import 'package:enreda_empresas/app/models/certificationRequest.dart';
import 'package:enreda_empresas/app/models/city.dart';
import 'package:enreda_empresas/app/models/competency.dart';
import 'package:enreda_empresas/app/models/country.dart';
import 'package:enreda_empresas/app/models/experience.dart';
import 'package:enreda_empresas/app/models/province.dart';
import 'package:enreda_empresas/app/models/userEnreda.dart';
import 'package:enreda_empresas/app/services/auth.dart';
import 'package:enreda_empresas/app/services/database.dart';
import 'package:enreda_empresas/app/utils/responsive.dart';
import 'package:enreda_empresas/app/values/strings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyCurriculumPage extends StatefulWidget {

  const MyCurriculumPage({super.key, required this.user});
  final UserEnreda user;

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
  List<Competency>? myCompetencies = [];
  List<Experience>? myExperiences = [];
  List<Experience> myCustomExperiences = [];
  List<int> mySelectedExperiences = [];
  List<Experience>? myEducation = [];
  List<Experience> myCustomEducation = [];
  List<int> mySelectedEducation = [];
  List<CertificationRequest>? myReferences = [];
  List<CertificationRequest> myCustomReferences = [];
  List<int> mySelectedReferences = [];
  List<String> competenciesNames = [];
  List<String> myCustomCompetencies = [];
  List<int> mySelectedCompetencies = [];
  List<String> myCustomDataOfInterest = [];
  List<int> mySelectedDataOfInterest = [];
  List<String> myCustomLanguages = [];
  List<int> mySelectedLanguages = [];

  Country? myCountry;
  Province? myProvince;
  City? myCity;

  @override
  Widget build(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);

    return Stack(
      children: [
        StreamBuilder<UserEnreda>(
            stream: database.userEnredaStreamByUserId(widget.user.userId),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                user = snapshot.data!;
                var profilePic = user?.profilePic?.src ?? "";
                return StreamBuilder<List<Competency>>(
                    stream: database.competenciesStream(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) return Container();
                      if (snapshot.hasError) {
                        return const Center(child: Text('Ocurrió un error'));
                      }
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

                      final myLanguages = user?.languages ?? [];
                      myCustomLanguages = myLanguages.map((element) => element).toList();
                      mySelectedLanguages = List.generate(myCustomLanguages.length, (i) => i);

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
                                        city = myCity?.name ?? '';
                                        province = myProvince?.name ?? '';
                                        country = myCountry?.name ?? '';

                                        myCustomCity = city!;
                                        myCustomProvince = province!;
                                        myCustomCountry = country!;

                                        return StreamBuilder<List<Experience>>(
                                            stream: database.myExperiencesStream(user?.userId ?? ''),
                                            builder: (context, snapshot) {
                                              if (snapshot.hasData &&
                                                  snapshot.connectionState == ConnectionState.active) {
                                                myEducation = snapshot.data!
                                                    .where((experience) => experience.type == 'Formativa')
                                                    .toList();
                                                myCustomEducation = myEducation!.map((element) => element).toList();
                                                mySelectedEducation = List.generate(myCustomEducation.length, (i) => i);
                                                return StreamBuilder<List<Experience>>(
                                                    stream: database.myExperiencesStream(user?.userId ?? ''),
                                                    builder: (context, snapshot) {
                                                      if (snapshot.hasData &&
                                                          snapshot.connectionState == ConnectionState.active) {
                                                        myExperiences = snapshot.data!
                                                            .where((experience) => experience.type != 'Formativa')
                                                            .toList();
                                                        myCustomExperiences = myExperiences!.map((element) => element).toList();
                                                        mySelectedExperiences = List.generate(myCustomExperiences.length, (i) => i);
                                                        return StreamBuilder<List<CertificationRequest>>(
                                                            stream: database.myCertificationRequestStream(user?.userId ?? ''),
                                                            builder: (context, snapshot) {
                                                              if (snapshot.hasData) {
                                                                myReferences = snapshot.data!
                                                                    .where((certificationRequest) => certificationRequest.referenced == true)
                                                                    .toList();
                                                                myCustomReferences = myReferences!.map((element) => element).toList();
                                                                mySelectedReferences = List.generate(myCustomReferences.length, (i) => i);
                                                                return MyCvModelsPage(
                                                                  user: user!,
                                                                  city: city!,
                                                                  province: province!,
                                                                  country: country!,
                                                                  myCustomAboutMe: myCustomAboutMe,
                                                                  myCustomEmail: myCustomEmail,
                                                                  myCustomPhone: myCustomPhone,
                                                                  myExperiences: myExperiences!,
                                                                  myCustomExperiences: myCustomExperiences,
                                                                  mySelectedExperiences: mySelectedExperiences,
                                                                  myEducation: myEducation!,
                                                                  myCustomEducation: myCustomEducation,
                                                                  mySelectedEducation: mySelectedEducation,
                                                                  competenciesNames: competenciesNames,
                                                                  myCustomCompetencies: myCustomCompetencies,
                                                                  mySelectedCompetencies: mySelectedCompetencies,
                                                                  myCustomDataOfInterest: myCustomDataOfInterest,
                                                                  mySelectedDataOfInterest: mySelectedDataOfInterest,
                                                                  myCustomLanguages: myCustomLanguages,
                                                                  mySelectedLanguages: mySelectedLanguages,
                                                                  myCustomCity: myCustomCity,
                                                                  myCustomProvince: myCustomProvince,
                                                                  myCustomCountry: myCustomCountry,
                                                                  myReferences: myReferences!,
                                                                  myCustomReferences: myCustomReferences,
                                                                  mySelectedReferences: mySelectedReferences,
                                                                );
                                                              } else {
                                                                return const Center(child: CircularProgressIndicator());
                                                              }
                                                            });
                                                      } else {
                                                        return const Center(child: CircularProgressIndicator());
                                                      }
                                                    });
                                              } else {
                                                return const Center(child: CircularProgressIndicator());
                                              }
                                            });
                                      });
                                });
                          });
                    });
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            }),
      ],
    );
  }
}
