library globals;

import 'package:enreda_empresas/app/models/closureReport.dart';
import 'package:enreda_empresas/app/models/competency.dart';
import 'package:enreda_empresas/app/models/competencyCategory.dart';
import 'package:enreda_empresas/app/models/derivationReport.dart';
import 'package:enreda_empresas/app/models/followReport.dart';
import 'package:enreda_empresas/app/models/initialReport.dart';
import 'package:enreda_empresas/app/models/jobOffer.dart';
import 'package:enreda_empresas/app/models/jobOfferApplication.dart';
import 'package:enreda_empresas/app/models/resource.dart';
import 'package:enreda_empresas/app/models/company.dart';
import 'package:enreda_empresas/app/models/userEnreda.dart';

import '../../models/externalSocialEntity.dart';
import '../../models/interest.dart';

Resource? currentResource;
JobOffer? currentJobOffer;
Company? organizerCurrentResource;
String? interestsNamesCurrentResource;
String? competenciesNamesCurrentResource;
Set<Interest> selectedInterestsCurrentResource = {};
Set<CompetencyCategory> selectedCompetenciesCategoriesCurrentResource = {};
Set<Competency> selectedCompetenciesCurrentResource = {};
List<String> interestsCurrentResource = [];
UserEnreda? currentParticipant;
JobOfferApplication? currentApplication;
UserEnreda? currentSocialEntityUser; // this is the user that is logged
Company? currentUserCompany; // this is the social entity that the user is belonging
ExternalSocialEntity? currentExternalSocialEntity; // this is the social entity that is selected in "Agenda de entidades sociales externas"
InitialReport currentInitialReportUser = InitialReport();
FollowReport currentFollowReportUser = FollowReport();
DerivationReport currentDerivationReportUser = DerivationReport();
ClosureReport currentClosureReportUser = ClosureReport();