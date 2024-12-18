import 'dart:async';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enreda_empresas/app/models/ability.dart';
import 'package:enreda_empresas/app/models/certificationRequest.dart';
import 'package:enreda_empresas/app/models/city.dart';
import 'package:enreda_empresas/app/models/closureReport.dart';
import 'package:enreda_empresas/app/models/competency.dart';
import 'package:enreda_empresas/app/models/competencyCategory.dart';
import 'package:enreda_empresas/app/models/competencySubCategory.dart';
import 'package:enreda_empresas/app/models/contact.dart';
import 'package:enreda_empresas/app/models/country.dart';
import 'package:enreda_empresas/app/models/dedication.dart';
import 'package:enreda_empresas/app/models/derivationReport.dart';
import 'package:enreda_empresas/app/models/education.dart';
import 'package:enreda_empresas/app/models/experience.dart';
import 'package:enreda_empresas/app/models/followReport.dart';
import 'package:enreda_empresas/app/models/gamificationFlags.dart';
import 'package:enreda_empresas/app/models/gender.dart';
import 'package:enreda_empresas/app/models/initialReport.dart';
import 'package:enreda_empresas/app/models/interest.dart';
import 'package:enreda_empresas/app/models/ipilConnectionTerritory.dart';
import 'package:enreda_empresas/app/models/ipilContextualization.dart';
import 'package:enreda_empresas/app/models/ipilEntry.dart';
import 'package:enreda_empresas/app/models/ipilInterviews.dart';
import 'package:enreda_empresas/app/models/ipilObjectives.dart';
import 'package:enreda_empresas/app/models/ipilPostWorkSupport.dart';
import 'package:enreda_empresas/app/models/ipilReinforcement.dart';
import 'package:enreda_empresas/app/models/ipilResults.dart';
import 'package:enreda_empresas/app/models/jobOfferCriteria.dart';
import 'package:enreda_empresas/app/models/keepLearningOption.dart';
import 'package:enreda_empresas/app/models/organization.dart';
import 'package:enreda_empresas/app/models/region.dart';
import 'package:enreda_empresas/app/models/documentationParticipant.dart';
import 'package:enreda_empresas/app/models/personalDocumentType.dart';
import 'package:enreda_empresas/app/models/socialEntitiesType.dart';
import 'package:enreda_empresas/app/models/company.dart';
import 'package:enreda_empresas/app/models/province.dart';
import 'package:enreda_empresas/app/models/resource.dart';
import 'package:enreda_empresas/app/models/resourceCategory.dart';
import 'package:enreda_empresas/app/models/resourceInvitation.dart';
import 'package:enreda_empresas/app/models/resourcetype.dart';
import 'package:enreda_empresas/app/models/scope.dart';
import 'package:enreda_empresas/app/models/size.dart';
import 'package:enreda_empresas/app/models/specificinterest.dart';
import 'package:enreda_empresas/app/models/timeSearching.dart';
import 'package:enreda_empresas/app/models/timeSpentWeekly.dart';
import 'package:enreda_empresas/app/models/unemployedUser.dart';
import 'package:enreda_empresas/app/models/userEnreda.dart';
import 'package:enreda_empresas/app/services/api_path.dart';
import 'package:enreda_empresas/app/services/firestore_service.dart';
import 'package:enreda_empresas/app/models/resourcePicture.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../models/documentCategory.dart';
import '../models/externalSocialEntity.dart';
import '../models/filterResource.dart';
import '../models/ipilCoordination.dart';
import '../models/ipilImprovementEmployment.dart';
import '../models/ipilObtainingEmployment.dart';
import '../models/jobOffer.dart';
import '../models/jobOfferApplication.dart';
import '../models/socialEntitiesCategories.dart';
import '../models/companyUser.dart';
import '../utils/functions.dart';

abstract class Database {
     Stream<List<Resource>> resourcesStream();
     Stream<List<Resource>> limitResourcesStream(int i);
     Stream<Resource> resourceStream(String? resourceId);
     Stream<List<Resource>> myResourcesStream(String companyId);
     Stream<List<Resource>> myDraftResourcesStream(String companyId);
     Stream<List<Resource>> myActiveResourcesStream(String companyId);
     Stream<List<Resource>> myFinishedResourcesStream(String companyId);
     Stream<List<Resource>> myAllResourcesStream(String companyId);
     Stream<JobOffer> jobOfferStreamById(String jobOfferId);
     Stream<List<Resource>> myLimitResourcesStream(String companyId, int i);
     Stream<List<Resource>> participantsResourcesStream(String? userId, String? organizerId);
     Stream<List<UserEnreda>> getParticipantsBySocialEntityStream(String companyId);
     Stream<List<Company>> socialEntitiesStream();
     Stream<List<ExternalSocialEntity>> filteredExternalSocialEntitiesStream(FilterResource filter, String companyId);
     Stream<List<Company>> companyByIdStream(String companyId);
     Stream<Company> companyStream(String? companyId);
     Stream<ExternalSocialEntity> externalSocialEntityByIdStream(String externalSocialEntityId);
     Stream<UserEnreda> mentorStream(String mentorId);
     Stream<UserEnreda?> userStreamByEmail(String? email);
     Stream<List<Country>> countriesStream();
     Stream<List<Region>> regionStreamByCountry(String countryId);
     Stream<List<Country>> countryFormatedStream();
     Stream<Country> countryStream(String? countryId);
     Stream<List<Province>> provincesStream();
     Stream<Province> provinceStream(String? provinceId);
     Stream<List<Province>> provincesCountryStream(String? countryId);
     Stream<List<City>> citiesStream();
     Stream<City> cityStream(String? cityId);
     Stream<ResourcePicture> resourcePictureStream(String? resourcePictureId);
     Stream<List<ResourcePicture>> resourcePicturesStream();
     Stream<List<City>> citiesProvinceStream(String? provinceId);
     Stream<List<UserEnreda>> userStream(String? email);
     Stream<List<UserEnreda>> userParticipantsStream(List<String?> resourceIdList);
     Stream<List<Resource>> resourcesParticipantsStream(List<String?> participantsIdList);
     Stream<List<Interest>> resourcesInterestsStream(List<String?> interestsIdList);
     Stream<List<Competency>> resourcesCompetenciesStream(List<String?> competenciesIdList);
     Stream<List<UserEnreda>> participantsByResourceStream(String resourceId);
     Stream<List<JobOfferApplication>> registeredApplicationsByJobOffer(String jobOfferId);
     Stream<List<JobOfferApplication>> preSelectedApplicationsByJobOffer(String jobOfferId);
     Stream<List<JobOfferApplication>> selectedApplicationsByJobOffer(String jobOfferId);
     Stream<List<JobOfferApplication>> applicantsStreamByJobOffer(String jobOfferId, String? status);
     Stream<JobOfferCriteria> jobOfferCriteriaById(String jobOfferCriteriaId);
     Stream<Company> companyStreamById(String? companyId);
     Stream<Organization> organizationStreamById(String organizationId);
     Stream<UserEnreda> userEnredaStreamByUserId(String? userId);
     Stream<ResourceType> resourceTypeStreamById(String? resourceTypeId);
     Stream<ResourceCategory> resourceCategoryStreamById(String? resourceCategoryId);
     Stream<List<Scope>> scopeStream();
     Stream<List<SizeOrg>> sizeStream();
     Stream<List<Ability>> abilityStream();
     Stream<List<ResourceCategory>> resourceCategoryStream();
     Stream<List<Education>> educationStream();
     Stream<List<ResourceType>> resourceTypeStream();
     Stream<List<Interest>> interestStream();
     Stream<List<Interest>> interestsStream(String? interestId);
     Stream<List<SpecificInterest>> specificInterestsStream();
     Stream<List<SpecificInterest>> specificInterestStream(String? interestId);
     Stream<List<CompetencySubCategory>> subCategoriesCompetenciesById(String? competencyId);
     Stream<List<Competency>> competenciesBySubCategoryId(String? competencySubCategoryId);
     Stream<List<UserEnreda>> checkIfUserEmailRegistered(String email);
     Stream<List<Experience>> myExperiencesStream(String userId);
     Stream<List<Competency>> competenciesStream();
     Stream<List<CompetencyCategory>> competenciesCategoriesStream();
     Stream<List<CompetencySubCategory>> competenciesSubCategoriesStream();
     Stream<List<CertificationRequest>> myCertificationRequestStream(String userId);
     Stream<List<SocialEntitiesType>> socialEntitiesTypeStream();
     Stream<List<SocialEntityCategory>> socialEntitiesCategoriesStream();
     Stream<List<DocumentCategory>> documentCategoriesStream();
     Stream<List<PersonalDocumentType>> personalDocumentTypeStream();
     Stream<List<PersonalDocumentType>> documentSubCategoriesByCategoryStream(String categoryId);
     Stream<List<DocumentationParticipant>> documentationParticipantBySubCategoryStream(PersonalDocumentType documentSubCategory, UserEnreda user);
     Stream<DocumentationParticipant> documentationParticipantStream(String documentId);

     Future<void> setUserEnreda(UserEnreda userEnreda);
     Future<void> deleteUser(UserEnreda userEnreda);
     Future<void> uploadUserAvatar(String userId, Uint8List data);
     Future<void> uploadCompanyLogo(String companyId, Uint8List data);
     Future<void> uploadLogoAvatar(String companyId, Uint8List data);
     Future<void> addContact(Contact contact);
     Future<void> setResource(Resource resource);
     Future<void> setJobOffer(JobOffer jobOffer);
     Future<void> setJobOfferApplication(JobOfferApplication jobOfferApplication);
     Future<void> setExternalSocialEntity(ExternalSocialEntity externalSocialEntity);
     Future<void> deleteResource(Resource resource);
     Future<void> deleteJobOffer(String jobOfferId);
     Future<void> deleteExternalSocialEntity(ExternalSocialEntity externalSocialEntity);
     Future<void> addCompanyUser(CompanyUser companyUser);
     Future<String> addCompany(Company company);
     Future<void> addExternalSocialEntity(ExternalSocialEntity externalSocialEntity);
     Future<String> addResource(Resource resource);
     Future<void> updateResource(String resourceId, String jobOfferId);
     Future<String> addJobOffer(JobOffer jobOffer);
     Future<void> updateJobOffer(String jobOfferId, String resourceId);
     Future<void> addResourceInvitation(ResourceInvitation resourceInvitation);
     Future<void> updateCertificationRequest(CertificationRequest certificationRequest, bool certified, bool referenced );
     Stream<List<GamificationFlag>> gamificationFlagsStream();
     Future<void> addUnemployedUser(UnemployedUser unemployedUser);
     Stream<List<Dedication>> dedicationStream();
     Stream<List<Gender>> genderStream();
     Stream<List<TimeSpentWeekly>> timeSpentWeeklyStream();
     Stream<List<TimeSearching>> timeSearchingStream();
     Stream<List<IpilEntry>> getIpilEntriesByUserStream(String userId);
     Future<void> addIpilEntry(IpilEntry ipilEntry);
     Future<void> updateIpilEntryContent(IpilEntry ipilEntry, String content);
     Future<void> updateIpilEntryDate(IpilEntry ipilEntry, DateTime date);
     Future<void> deleteIpilEntry(IpilEntry ipilEntry);
     Future<void> setIpilEntry(IpilEntry ipilEntry);
     Future<void> addDocumentationParticipant(String userId, String fileName, Uint8List data, DocumentationParticipant document);
     Future<void> addDocumentCompany(String companyId, String fileName, Uint8List data);
     Future<void> editFileDocumentationParticipant(String userId, String fileName, Uint8List data, DocumentationParticipant document);
     Future<void> updateDocumentationParticipant(DocumentationParticipant document);
     Stream<InitialReport> initialReportsStreamByUserId(String? userId);
     Future<void> setInitialReport(InitialReport initialReport);
     Future<void> addInitialReport(InitialReport initialReport);
     Stream<List<String>> languagesStream();
     Stream<List<String>> nationsSpanishStream();
     Stream<ClosureReport> closureReportsStreamByUserId(String? userId);
     Future<void> setClosureReport(ClosureReport closureReport);
     Future<void> addClosureReport(ClosureReport closureReport);
     Stream<List<KeepLearningOption>> keepLearningOptionsStream();
     Stream<FollowReport> followReportsStreamByUserId(String? userId);
     Future<void> setFollowReport(FollowReport followReport);
     Future<void> addFollowReport(FollowReport followReport);
     Stream<DerivationReport> derivationReportsStreamByUserId(String? userId);
     Future<void> setDerivationReport(DerivationReport derivationReport);
     Future<void> addDerivationReport(DerivationReport derivationReport);
     Stream<List<IpilReinforcement>> ipilReinforcementStream();
     Stream<List<IpilReinforcement>> ipilReinforcementStreamByUser(List<String> idList);
     Stream<List<IpilContextualization>> ipilContextualizationStream();
     Stream<List<IpilContextualization>> ipilContextualizationStreamByUser(List<String> idList);
     Stream<List<IpilConnectionTerritory>> ipilConnectionTerritoryStream();
     Stream<List<IpilConnectionTerritory>> ipilConnectionTerritoryStreamByUser(List<String> idList);
     Stream<List<IpilInterviews>> ipilInterviewsStream();
     Stream<List<IpilInterviews>> ipilInterviewsStreamByUser(List<String> idList);
     Stream<List<IpilObtainingEmployment>> ipilObtainingEmploymentStream();
     Stream<List<IpilImprovingEmployment>> ipilImprovingEmploymentStream();
     Stream<List<IpilPostWorkSupport>> ipilPostWorkSupportStream();
     Stream<List<IpilCoordination>> ipilCoordinationStream();
     Stream<IpilObtainingEmployment> ipilObtainingEmploymentStreamByUser(String obtainingEmploymentId);
     Stream<IpilImprovingEmployment> ipilImprovingEmploymentStreamByUser(String improvingEmploymentId);
     Stream<IpilCoordination> ipilCoordinationStreamByUser(String coordinationId);
     Stream<IpilPostWorkSupport> ipilPostWorkSupportStreamByUser(String postWorkSupportId);
     Stream<List<IpilResults>> ipilResultsStream();
     Stream<IpilObjectives> ipilObjectivesStreamByUserId(String userId);
     Future<void> setIpilObjectives(IpilObjectives ipilObjectives);
     Future<void> addIpilObjectives(IpilObjectives ipilObjectives);
     Future<void> deleteDocumentationParticipant(DocumentationParticipant document);
}

class FirestoreDatabase implements Database {
  FirestoreDatabase();

  final _service = FirestoreService.instance;

  @override
  Future<void> setResource(Resource resource) => _service.updateData(
      path: APIPath.resource(resource.resourceId!), data: resource.toMap());

  @override
  Future<void> setJobOffer(JobOffer jobOffer) => _service.updateData(
      path: APIPath.jobOffer(jobOffer.jobOfferId!), data: jobOffer.toMap());

  @override
  Future<void> setJobOfferApplication(JobOfferApplication jobOfferApplication) => _service.updateData(
      path: APIPath.jobOfferApplication(jobOfferApplication.jobOfferApplicationId), data: jobOfferApplication.toMap());

  @override
  Future<void> deleteResource(Resource resource) =>
      _service.deleteData(path: APIPath.resource(resource.resourceId!));

  @override
  Future<void> deleteJobOffer(String jobOfferId) =>
      _service.deleteData(path: APIPath.jobOffer(jobOfferId));


  @override
  Future<void> deleteExternalSocialEntity(ExternalSocialEntity company) =>
      _service.deleteData(path: APIPath.externalSocialEntity(company.externalSocialEntityId!));

  @override
  Future<void> setExternalSocialEntity(ExternalSocialEntity externalSocialEntity) => _service.updateData(
      path: APIPath.externalSocialEntity(externalSocialEntity.externalSocialEntityId!), data: externalSocialEntity.toMap());

  @override
    Stream<List<Resource>> myResourcesStream(String companyId) =>
        _service.collectionStream(
          path: APIPath.resources(),
          queryBuilder: (query) =>
              query.where('organizer', isEqualTo: companyId),
          builder: (data, documentId) => Resource.fromMap(data, documentId),
          sort: (rhs, lhs) => lhs.createdate.compareTo(rhs.createdate),
        );

  @override
  Stream<List<Resource>> myDraftResourcesStream(String companyId) =>
      _service.collectionStream(
        path: APIPath.resources(),
        queryBuilder: (query) => query
            .where('organizer', isEqualTo: companyId)
            .where('status', isEqualTo: 'edition'),
        builder: (data, documentId) => Resource.fromMap(data, documentId),
        sort: (rhs, lhs) => lhs.createdate.compareTo(rhs.createdate),
      );

  @override
  Stream<List<Resource>> myActiveResourcesStream(String companyId) =>
      _service.collectionStream(
        path: APIPath.resources(),
        queryBuilder: (query) => query
            .where('organizer', isEqualTo: companyId)
            .where('status', isEqualTo: 'Disponible'), // TODO: when add 'finished' status add isNotEqualTo to 'finished' and 'edition'
        builder: (data, documentId) => Resource.fromMap(data, documentId),
        sort: (rhs, lhs) => lhs.createdate.compareTo(rhs.createdate),
      );

  @override
  Stream<List<Resource>> myFinishedResourcesStream(String companyId) =>
      _service.collectionStream(
        path: APIPath.resources(),
        queryBuilder: (query) => query
            .where('organizer', isEqualTo: companyId)
            .where('status', isEqualTo: 'No disponible'), // TODO: cloud function to exclude 'finished' status in automatic updates
        builder: (data, documentId) => Resource.fromMap(data, documentId),
        sort: (rhs, lhs) => lhs.createdate.compareTo(rhs.createdate),
      );

  @override
  Stream<List<Resource>> myAllResourcesStream(String companyId) =>
      _service.collectionStream(
        path: APIPath.resources(),
        queryBuilder: (query) => query
            .where('organizer', isEqualTo: companyId),
        builder: (data, documentId) => Resource.fromMap(data, documentId),
        sort: (rhs, lhs) => lhs.createdate.compareTo(rhs.createdate),
      );

    @override
    Stream<List<Resource>> myLimitResourcesStream(String companyId, int limit) =>
      _service.collectionStream(
        path: APIPath.resources(),
        queryBuilder: (query) => query
            .where('organizer', isEqualTo: companyId)
            .limit(limit),
        builder: (data, documentId) => Resource.fromMap(data, documentId),
        sort: (rhs, lhs) => lhs.createdate.compareTo(rhs.createdate),
      );

    @override
    Stream<List<Resource>> participantsResourcesStream(String? userId, String? organizerId) =>
      _service.collectionStream(
        path: APIPath.resources(),
        queryBuilder: (query) {
              query = query.where('participants', arrayContains: userId).where('organizer', isEqualTo: organizerId);
              return query;
            },
        builder: (data, documentId) => Resource.fromMap(data, documentId),
        sort: (rhs, lhs) => lhs.createdate.compareTo(rhs.createdate),
      );

    @override
    Stream<Resource> resourceStream(String? resourceId) =>
        _service.documentStream<Resource>(
          path: APIPath.resource(resourceId!),
          builder: (data, documentId) => Resource.fromMap(data, documentId),
        );

    @override
    Stream<List<Resource>> resourcesStream() => _service.collectionStream(
      path: APIPath.resources(),
      queryBuilder: (query) => query.where('organizerType', isEqualTo: "Empresa"),
      builder: (data, documentId) => Resource.fromMap(data, documentId),
      sort: (lhs, rhs) => lhs.createdate.compareTo(rhs.createdate),
    );

  @override
  Stream<List<Resource>> limitResourcesStream(int limit) =>
      _service.collectionStream(
        path: APIPath.resources(),
        queryBuilder: (query) => query
            .where('organizerType', isEqualTo: "Empresa")
            .limit(limit),
        builder: (data, documentId) => Resource.fromMap(data, documentId),
        sort: (rhs, lhs) => lhs.createdate.compareTo(rhs.createdate),
      );

    @override
    Stream<List<Company>> socialEntitiesStream() => _service.collectionStream(
      path: APIPath.companies(),
      queryBuilder: (query) => query.where('trust', isEqualTo: true),
      builder: (data, documentId) => Company.fromMap(data, documentId),
      sort: (lhs, rhs) => lhs.name.compareTo(rhs.name),
    );

  @override
  Stream<List<ExternalSocialEntity>> filteredExternalSocialEntitiesStream(FilterResource filter, String companyId) {
    return _service.filteredCollectionStream(
      path: APIPath.externalSocialEntities(),
      queryBuilder: (query) {
        query = query.where('trust', isEqualTo: true).where('associatedSocialEntityId', isEqualTo: companyId);
        return query;
      },
      builder: (data, documentId) {
        final searchTextChallenge = removeDiacritics((data['searchText'] ?? '').toLowerCase());
        final searchListPost = searchTextChallenge.split(';');
        final searchTextFilter = removeDiacritics(filter.searchText.toLowerCase());
        final searchListFilter = searchTextFilter.split(' ');
        Set<dynamic> postCategoriesSet = filter.externalSocialEntityTypesIds.toSet();

        if (filter.searchText == '' && postCategoriesSet.isEmpty)
          return ExternalSocialEntity.fromMap(data, documentId);

        // The following code checks if an idea is selected by applying filters
        bool textFilterSelection = false; // Initialize textFilter result to false
        bool tagsFilterSelection = false; // Initialize tagsFilter result to false

        // If search text exists in filter, filter through the search list
        if (filter.searchText != '') {
          searchListFilter.forEach((filterElement) {
            // For each element in searchListFilter, check against each element in searchListIdea
            if (searchListPost.any(
                    (resourceElement) => resourceElement.contains(filterElement))) {
              textFilterSelection = textFilterSelection || true; // Set ideaSelected false if a match isn't found
            }
          });
        }
        // If the intersection of selected ecosystem tags (filter.ideaEcosystems)
        // with the ideas' ecosystems (data['ecosystemsIdList']) is empty,
        // then ideaSelected is false
        if (postCategoriesSet.isNotEmpty) {
          Set<dynamic> postsCategoriesIdSet = [...data['types']].toSet();
          tagsFilterSelection = postsCategoriesIdSet
              .intersection(postCategoriesSet)
              .isNotEmpty;
        }
        return textFilterSelection || tagsFilterSelection ? ExternalSocialEntity.fromMap(data, documentId) : null;
      },
      sort: (rhs, lhs) => lhs.createdAt.compareTo(rhs.createdAt),
    );
  }

    @override
    Stream<List<Company>> companyByIdStream(String companyId) =>
        _service.collectionStream(
          path: APIPath.companies(),
          builder: (data, documentId) => Company.fromMap(data, documentId),
          queryBuilder: (query) =>
              query.where('companyId', isEqualTo: companyId),
          sort: (lhs, rhs) => lhs.name.compareTo(rhs.name),
        );

    @override
    Stream<Company> companyStream(String? companyId) =>
        _service.documentStream<Company>(
          path: APIPath.company(companyId!),
          builder: (data, documentId) => Company.fromMap(data, documentId),
        );

  @override
  Stream<ExternalSocialEntity> externalSocialEntityByIdStream(String externalSocialEntityId) =>
      _service.documentStream<ExternalSocialEntity>(
        path: APIPath.externalSocialEntity(externalSocialEntityId),
        builder: (data, documentId) => ExternalSocialEntity.fromMap(data, documentId),
      );

    @override
    Stream<UserEnreda> mentorStream(String mentorId) =>
        _service.documentStream<UserEnreda>(
          path: APIPath.user(mentorId),
          builder: (data, documentId) => UserEnreda.fromMap(data, documentId),
        );

    Stream<UserEnreda?> userStreamByEmail(String? email) {
      return _service.nullableDocumentStreamByField(
        path: APIPath.users(),
        builder: (data, documentId) => UserEnreda.fromMap(data, documentId),
        queryBuilder: (query) => query.where('email', isEqualTo: email),
      );
    }

    @override
    Stream<List<Country>> countriesStream() => _service.collectionStream(
      path: APIPath.countries(),
      builder: (data, documentId) => Country.fromMap(data, documentId),
      sort: (lhs, rhs) => lhs.name.compareTo(rhs.name),
    );

    @override
    Stream<List<Country>> countryFormatedStream() => _service.collectionStream(
      path: APIPath.countries(),
      queryBuilder: (query) => query.where('name', isNotEqualTo: 'Online'),
      builder: (data, documentId) => Country.fromMap(data, documentId),
      sort: (lhs, rhs) => lhs.name.compareTo(rhs.name),
    );

    @override
    Stream<Country> countryStream(String? countryId) =>
          _service.documentStream<Country>(
            path: APIPath.country(countryId),
            builder: (data, documentId) => Country.fromMap(data, documentId),
          );

    @override
    Stream<List<Region>> regionStreamByCountry(String? countryId) {
      // int countryIdInt = 0;
      // if (countryId != '') {
      //   countryIdInt = int.parse(countryId!);
      // }
      // return _service.collectionStream<Region>(
      //   path: APIPath.regions(),
      //   builder: (data, documentId) => Region.fromMap(data, documentId),
      //   queryBuilder: (query) => query.where('country_id', isEqualTo:countryIdInt),
      //   sort: (lhs, rhs) => lhs.name.compareTo(rhs.name),
      // );
      int? countryIdInt; // Make it nullable since it can be null

      // This checks for both non-null and non-empty countryId before parsing
      if (countryId != null && countryId.isNotEmpty) {
        countryIdInt = int.tryParse(countryId);

        // Handle the case when parsing fails (e.g., if countryId is not a valid integer)
        if (countryIdInt == null) {
          throw FormatException('Invalid countryId: $countryId is not an integer');
        }
      }

      return _service.collectionStream<Region>(
        path: APIPath.regions(),
        builder: (data, documentId) => Region.fromMap(data, documentId),
        queryBuilder: (query) => query.where('country_id', isEqualTo: countryIdInt),
        sort: (lhs, rhs) => lhs.name.compareTo(rhs.name),
      );
    }

    @override
    Stream<List<Province>> provincesStream() => _service.collectionStream(
      path: APIPath.provinces(),
      builder: (data, documentId) => Province.fromMap(data, documentId),
      sort: (lhs, rhs) => lhs.name.compareTo(rhs.name),
    );

    @override
    Stream<Province> provinceStream(String? provinceId) =>
        _service.documentStream<Province>(
          path: APIPath.province(provinceId),
          builder: (data, documentId) => Province.fromMap(data, documentId),
        );

    // @override
    // Stream<List<Province>> provincesCountryStream(String? countryId) {
    //
    //   if (countryId == null) {
    //     return const Stream<List<Province>>.empty();
    //   }
    //
    //   return _service.collectionStream(
    //     path: APIPath.provinces(),
    //     builder: (data, documentId) => Province.fromMap(data, documentId),
    //     queryBuilder: (query) => query.where('id', isEqualTo: countryId),
    //     sort: (lhs, rhs) => lhs.name.compareTo(rhs.name),
    //   );
    // }

    @override
    Stream<List<Province>> provincesCountryStream(String? countryId) {

      if (countryId == null) {
        return const Stream<List<Province>>.empty();
      }

      return _service.collectionStream(
        path: APIPath.provinces(),
        builder: (data, documentId) => Province.fromMap(data, documentId),
        queryBuilder: (query) => query.where('countryId', isEqualTo: countryId).where('active', isEqualTo: true),
        sort: (lhs, rhs) => lhs.name.compareTo(rhs.name),
      );
    }

    @override
    Stream<List<City>> citiesStream() => _service.collectionStream(
      path: APIPath.cities(),
      queryBuilder: (query) => query.where('cityId', isNotEqualTo: null),
      builder: (data, documentId) => City.fromMap(data, documentId),
      sort: (lhs, rhs) => lhs.name.compareTo(rhs.name),
    );

    @override
    Stream<City> cityStream(String? cityId) => _service.documentStream<City>(
        path: APIPath.city(cityId),
        builder: (data, documentId) => City.fromMap(data, documentId),
      );

    @override
    Stream<List<City>> citiesProvinceStream(String? provinceId) =>
        _service.collectionStream(
          path: APIPath.cities(),
          builder: (data, documentId) => City.fromMap(data, documentId),
          queryBuilder: (query) =>
              query.where('provinceId', isEqualTo: provinceId),
          sort: (lhs, rhs) => lhs.name.compareTo(rhs.name),
        );

    @override
    Stream<ResourcePicture> resourcePictureStream(String? resourcePictureId) =>
        _service.documentStream<ResourcePicture>(
          path: APIPath.resourcePicture(resourcePictureId),
          builder: (data, documentId) =>
              ResourcePicture.fromMap(data, documentId),
        );

    @override
    Stream<List<ResourcePicture>> resourcePicturesStream() =>
      _service.collectionStream(
        path: APIPath.resourcePictures(),
        queryBuilder: (query) => query.where('role', isEqualTo: "Super Admin"),
        builder: (data, documentId) => ResourcePicture.fromMap(data, documentId),
        sort: (lhs, rhs) => lhs.name.compareTo(rhs.name),
      );

    @override
    Stream<List<UserEnreda>> userStream(String? email) {
      return _service.collectionStream<UserEnreda>(
        path: APIPath.users(),
        queryBuilder: (query) => query.where('email', isEqualTo: email),
        builder: (data, documentId) => UserEnreda.fromMap(data, documentId),
        sort: (lhs, rhs) => lhs.email.compareTo(rhs.email),
      );
    }

  @override
  Stream<List<UserEnreda>> userParticipantsStream(List<String?> resourceIdList) {
    return _service.collectionStream<UserEnreda>(
      path: APIPath.users(),
      queryBuilder: (query) {

        return query.where('resources', arrayContainsAny: resourceIdList);
      },
      builder: (data, documentId) => UserEnreda.fromMap(data, documentId),
      sort: (lhs, rhs) => lhs.email.compareTo(rhs.email),
      );
    }

  @override
  Stream<List<UserEnreda>> getParticipantsBySocialEntityStream(String companyId) {
    return _service.collectionStream<UserEnreda>(
      path: APIPath.users(),
      queryBuilder: (query) => query.where('assignedEntityId', isEqualTo: companyId),
      builder: (data, documentId) => UserEnreda.fromMap(data, documentId),
      sort: (lhs, rhs) => (lhs.firstName??"").compareTo(rhs.firstName??""),
    );
  }

  @override
  Stream<List<UserEnreda>> participantsByResourceStream(String? resourceId) {
    return _service.collectionStream<UserEnreda>(
      path: APIPath.users(),
      queryBuilder: (query) => query.where('resources', arrayContains: resourceId),
      builder: (data, documentId) => UserEnreda.fromMap(data, documentId),
      sort: (lhs, rhs) => lhs.email.compareTo(rhs.email),
    );
  }

  @override
  Stream<List<JobOfferApplication>> applicantsStreamByJobOffer(String? jobOfferId, String? status) {
    return _service.collectionStream<JobOfferApplication>(
      path: APIPath.jobOfferApplications(),
      queryBuilder: (query) {
        query = query.where('jobOfferId', isEqualTo: jobOfferId);
        if (status != null) {
          query = query.where('status', isEqualTo: status);
        }
        return query;
      },
      builder: (data, documentId) => JobOfferApplication.fromMap(data, documentId),
      sort: (lhs, rhs) => rhs.match!.compareTo(lhs.match!),
    );
  }

  @override
  Stream<List<JobOfferApplication>> registeredApplicationsByJobOffer(String? jobOfferId) {
    return _service.collectionStream<JobOfferApplication>(
      path: APIPath.jobOfferApplications(),
      queryBuilder: (query) => query.where('jobOfferId', isEqualTo: jobOfferId),
      builder: (data, documentId) => JobOfferApplication.fromMap(data, documentId),
      sort: (lhs, rhs) => rhs.match!.compareTo(lhs.match!),
    );
  }

  @override
  Stream<List<JobOfferApplication>> preSelectedApplicationsByJobOffer(String? jobOfferId) {
    return _service.collectionStream<JobOfferApplication>(
      path: APIPath.jobOfferApplications(),
      queryBuilder: (query) => query.where('jobOfferId', isEqualTo: jobOfferId)
          .where('status', isEqualTo: 'pre-selected'),
      builder: (data, documentId) => JobOfferApplication.fromMap(data, documentId),
      sort: (lhs, rhs) => rhs.match!.compareTo(lhs.match!),
    );
  }

  @override
  Stream<List<JobOfferApplication>> selectedApplicationsByJobOffer(String? jobOfferId) {
    return _service.collectionStream<JobOfferApplication>(
      path: APIPath.jobOfferApplications(),
      queryBuilder: (query) => query.where('jobOfferId', isEqualTo: jobOfferId)
          .where('status', isEqualTo: 'selected'),
      builder: (data, documentId) => JobOfferApplication.fromMap(data, documentId),
      sort: (lhs, rhs) => rhs.match!.compareTo(lhs.match!),
    );
  }

  @override
  Stream<JobOfferCriteria> jobOfferCriteriaById(String jobOfferCriteriaId) =>
      _service.documentStream<JobOfferCriteria>(
        path: APIPath.jobOfferCriteria(jobOfferCriteriaId),
        builder: (data, documentId) => JobOfferCriteria.fromMap(data, documentId),
      );

  @override
  Stream<List<Resource>> resourcesParticipantsStream(List<String?> participantsIdList) {
    return _service.collectionStream<Resource>(
      path: APIPath.resources(),
      queryBuilder: (query) => query.where('participants', arrayContainsAny: participantsIdList),
      builder: (data, documentId) => Resource.fromMap(data, documentId),
      sort: (lhs, rhs) => lhs.title.compareTo(rhs.title),
    );
  }

  @override
  Stream<List<Interest>> resourcesInterestsStream(List<String?> interestsIdList) async* {
    final collectionPath = FirebaseFirestore.instance.collection(APIPath.interests());
    final batches = <Future<List<Interest>>>[];

    for (var i = 0; i < interestsIdList.length; i += 10) {
      final batch = interestsIdList.sublist(i, i + 10 < interestsIdList.length ? i + 10 : interestsIdList.length);
      final futureBatch = collectionPath
          .where('interestId', whereIn: batch)
          .get()
          .then((results) => results.docs.map<Interest>((result) => Interest.fromMap(result.data(), result.id)).toList());
      batches.add(futureBatch);
    }
    final results = await Future.wait(batches);
    var combinedResults = results.expand((i) => i).toSet().toList();
    yield combinedResults;
  }

  @override
  Stream<List<Competency>> resourcesCompetenciesStream(List<String?> competenciesIdList) async* {
    final collectionPath = FirebaseFirestore.instance.collection(APIPath.competencies());
    final batches = <Future<List<Competency>>>[];

    for (var i = 0; i < competenciesIdList.length; i += 10) {
      final batch = competenciesIdList.sublist(i, i + 10 < competenciesIdList.length ? i + 10 : competenciesIdList.length);
      final futureBatch = collectionPath
          .where('id', whereIn: batch)
          .get()
          .then((results) => results.docs.map<Competency>((result) => Competency.fromMap(result.data(), result.id)).toList());
      batches.add(futureBatch);
    }
    final results = await Future.wait(batches);
    var combinedResults = results.expand((i) => i).toSet().toList();
    yield combinedResults;
  }

  @override
  Stream<Company> companyStreamById(String? companyId) =>
      _service.documentStream<Company>(
        path: APIPath.company(companyId!),
        builder: (data, documentId) =>
            Company.fromMap(data, documentId),
      );

  @override
  Stream<JobOffer> jobOfferStreamById(String? jobOfferId) =>
      _service.documentStream<JobOffer>(
        path: APIPath.jobOffer(jobOfferId!),
        builder: (data, documentId) =>
            JobOffer.fromMap(data, documentId),
      );

  @override
  Stream<Organization> organizationStreamById(String? organizationId) =>
      _service.documentStream<Organization>(
        path: APIPath.organization(organizationId!),
        builder: (data, documentId) =>
            Organization.fromMap(data, documentId),
      );

  @override
  Stream<ResourceType> resourceTypeStreamById(String? resourceTypeId) =>
      _service.documentStream<ResourceType>(
        path: APIPath.resourceType(resourceTypeId!),
        builder: (data, documentId) =>
            ResourceType.fromMap(data, documentId),
      );

  @override
  Stream<ResourceCategory> resourceCategoryStreamById(String? resourceCategoryId) =>
      _service.documentStream<ResourceCategory>(
        path: APIPath.resourceCategory(resourceCategoryId!),
        builder: (data, documentId) =>
            ResourceCategory.fromMap(data, documentId),
      );

  @override
  Stream<UserEnreda> userEnredaStreamByUserId(String? userId) {
    return _service.documentStreamByField(
      path: APIPath.users(),
      builder: (data, documentId) => UserEnreda.fromMap(data, documentId),
      queryBuilder: (query) => query.where('userId', isEqualTo: userId),
    );
  }

    @override
    Stream<List<CertificationRequest>> myCertificationRequestStream(String userId) =>
        _service.collectionStream(
          path: APIPath.certificationsRequests(),
          queryBuilder: (query) => query.where('unemployedRequesterId', isEqualTo: userId),
          builder: (data, documentId) => CertificationRequest.fromMap(data, documentId),
          sort: (lhs, rhs) => lhs.certifierName.compareTo(rhs.certifierName),
        );

    @override
    Stream<List<SocialEntitiesType>> socialEntitiesTypeStream() => _service.collectionStream(
      path: APIPath.socialEntitiesType(),
      queryBuilder: (query) => query.where('id', isNotEqualTo: null),
      builder: (data, documentId) => SocialEntitiesType.fromMap(data, documentId),
      sort: (lhs, rhs) => lhs.name.compareTo(rhs.name),
    );

    @override
    Stream<List<SocialEntityCategory>> socialEntitiesCategoriesStream() => _service.collectionStream(
      path: APIPath.socialEntitiesCategories(),
      queryBuilder: (query) => query.where('socialEntityCategoryId', isNotEqualTo: null),
      builder: (data, documentId) => SocialEntityCategory.fromMap(data, documentId),
      sort: (lhs, rhs) => lhs.order.compareTo(rhs.order),
    );

    @override
    Future<void> setUserEnreda(UserEnreda userEnreda) {
      return _service.updateData(
          path: APIPath.user(userEnreda.userId!), data: userEnreda.toMap());
    }

    @override
    Future<void> deleteUser(UserEnreda userEnreda) {
      return _service.deleteData(path: APIPath.user(userEnreda.userId!));
    }

  @override
  Future<void> updateCertificationRequest(CertificationRequest certificationRequest, bool certified, bool referenced) {
    return _service.updateData(
        path: APIPath.certificationRequest(certificationRequest.certificationRequestId!), data: {
      "certified": certified, 'referenced': referenced});
  }

    @override
    Stream<List<Interest>> interestStream() => _service.collectionStream(
      path: APIPath.interests(),
      queryBuilder: (query) => query.where('name', isNotEqualTo: null),
      builder: (data, documentId) => Interest.fromMap(data, documentId),
      sort: (lhs, rhs) => lhs.order!.compareTo(rhs.order!),
    );


  @override
  Stream<List<Interest>> interestsStream(String? interestId) =>
      _service.collectionStream(
        path: APIPath.interests(),
        queryBuilder: (query) =>
            query.where('interestId', isEqualTo: interestId),
        builder: (data, documentId) =>
            Interest.fromMap(data, documentId),
        sort: (lhs, rhs) => lhs.name.compareTo(rhs.name),
      );

  @override
  Stream<List<PersonalDocumentType>> documentSubCategoriesByCategoryStream(String? categoryId) =>
      _service.collectionStream(
        path: APIPath.personalDocumentType(),
        queryBuilder: (query) =>
            query.where('documentCategoryId', isEqualTo: categoryId),
        builder: (data, documentId) =>
            PersonalDocumentType.fromMap(data, documentId),
        sort: (lhs, rhs) => lhs.order.compareTo(rhs.order),
      );

  @override
  Stream<List<SpecificInterest>> specificInterestsStream() => _service.collectionStream(
    path: APIPath.specificInterests(),
    queryBuilder: (query) => query.where('name', isNotEqualTo: null),
    builder: (data, documentId) => SpecificInterest.fromMap(data, documentId),
    sort: (lhs, rhs) => lhs.name.compareTo(rhs.name),
  );

  @override
  Stream<List<SpecificInterest>> specificInterestStream(String? interestId) =>
      _service.collectionStream(
        path: APIPath.specificInterests(),
        queryBuilder: (query) =>
            query.where('interestId', isEqualTo: interestId),
        builder: (data, documentId) =>
            SpecificInterest.fromMap(data, documentId),
        sort: (lhs, rhs) => lhs.name.compareTo(rhs.name),
      );

  @override
  Stream<List<Ability>> abilityStream() => _service.collectionStream(
    path: APIPath.abilities(),
    queryBuilder: (query) => query.where('name', isNotEqualTo: null),
    builder: (data, documentId) => Ability.fromMap(data, documentId),
    sort: (lhs, rhs) => lhs.name.compareTo(rhs.name),
  );

    @override
    Stream<List<Scope>> scopeStream() => _service.collectionStream(
      path: APIPath.scopes(),
      queryBuilder: (query) => query.where('label', isNotEqualTo: null),
      builder: (data, documentId) => Scope.fromMap(data, documentId),
      sort: (lhs, rhs) => lhs.order.compareTo(rhs.order),
    );

    @override
    Stream<List<SizeOrg>> sizeStream() => _service.collectionStream(
      path: APIPath.sizes(),
      queryBuilder: (query) => query.where('label', isNotEqualTo: null),
      builder: (data, documentId) => SizeOrg.fromMap(data, documentId),
      sort: (lhs, rhs) => lhs.order.compareTo(rhs.order),
    );

    @override
    Stream<List<ResourceCategory>> resourceCategoryStream() => _service.collectionStream(
      path: APIPath.resourcesCategories(),
      queryBuilder: (query) => query.where('name', isNotEqualTo: null),
      builder: (data, documentId) => ResourceCategory.fromMap(data, documentId),
      sort: (lhs, rhs) => lhs.order.compareTo(rhs.order),
    );

      @override
      Stream<List<Education>> educationStream() => _service.collectionStream(
        path: APIPath.education(),
        queryBuilder: (query) => query.where('label', isNotEqualTo: null),
        builder: (data, documentId) => Education.fromMap(data, documentId),
        sort: (lhs, rhs) => lhs.order.compareTo(rhs.order),
      );

      @override
      Stream<List<ResourceType>> resourceTypeStream() => _service.collectionStream(
        path: APIPath.resourcesTypes(),
        queryBuilder: (query) => query.where('name', isNotEqualTo: null),
        builder: (data, documentId) => ResourceType.fromMap(data, documentId),
        sort: (lhs, rhs) => lhs.name.compareTo(rhs.name),
      );

    @override
      Future<void> uploadUserAvatar(String userId, Uint8List data) async {
        var firebaseStorageRef =
        FirebaseStorage.instance.ref().child('users/$userId/profilePic');
        UploadTask uploadTask = firebaseStorageRef.putData(data);
        TaskSnapshot taskSnapshot = await uploadTask;
        taskSnapshot.ref.getDownloadURL().then(
              (value) => {
            _service.updateData(path: APIPath.photoUser(userId), data: {
              "profilePic": {
                'src': '$value',
                'title': 'photo.jpg',
              }
            })
          },
        );
      }

  @override
  Future<void> uploadCompanyLogo(String companyId, Uint8List data) async {
    var firebaseStorageRef =
    FirebaseStorage.instance.ref().child('companies/$companyId/logo');
    UploadTask uploadTask = firebaseStorageRef.putData(data);
    TaskSnapshot taskSnapshot = await uploadTask;
    taskSnapshot.ref.getDownloadURL().then(
          (value) => {
        _service.updateData(path: APIPath.logoCompany(companyId), data: {
          "logo": {
            'src': '$value',
            'title': 'logo.jpg',
          }
        })
      },
    );
  }

  @override
  Future<void> uploadLogoAvatar(String companyId, Uint8List data) async {
    var firebaseStorageRef =
    FirebaseStorage.instance.ref().child('externalSocialEntities/$companyId/logoPic');
    UploadTask uploadTask = firebaseStorageRef.putData(data);
    TaskSnapshot taskSnapshot = await uploadTask;
    taskSnapshot.ref.getDownloadURL().then(
          (value) => {
        _service.updateData(path: APIPath.externalSocialEntity(companyId), data: {
          "logoPic": {
            'src': '$value',
            'title': 'photo.jpg',
          }
        })
      },
    );
  }

  @override
    Future<void> addContact(Contact contact) =>
        _service.addData(path: APIPath.contacts(), data: contact.toMap());

  @override
  Future<String> addCompany(Company company) => _service.addDataString(
      path: APIPath.companies(), data: company.toMap());

  @override
  Future<void> addExternalSocialEntity(ExternalSocialEntity externalSocialEntity) => _service.addData(
      path: APIPath.externalSocialEntities(), data: externalSocialEntity.toMap());

  @override
  Future<void> addCompanyUser(CompanyUser companyUser) =>
      _service.addData(path: APIPath.users(), data: companyUser.toMap());

  @override
  Future<void> addResourceInvitation(ResourceInvitation resourceInvitation) =>
      _service.addData(path: APIPath.resourcesInvitations(), data: resourceInvitation.toMap());

  @override
  Future<String> addResource(Resource resource) =>
      _service.addDataString(path: APIPath.resources(), data: resource.toMap());

  @override
  Future<String> addJobOffer(JobOffer jobOffer) =>
      _service.addDataString(path: APIPath.jobOffers(), data: jobOffer.toMap());


  @override
  Future<void> updateResource(String resourceId, String jobOfferId) {
    return _service.updateData(
        path: APIPath.resource(resourceId), data: {
      "jobOfferId": jobOfferId});
  }
  @override
  Future<void> updateJobOffer(String jobOfferId, String resourceId) {
    return _service.updateData(
        path: APIPath.jobOffer(jobOfferId), data: {
      "resourceId": resourceId});
  }

  @override
  Stream<List<UserEnreda>> checkIfUserEmailRegistered(String email) {
    return _service.collectionStream(
      path: APIPath.users(),
      builder: (data, documentId) => UserEnreda.fromMap(data, documentId),
      queryBuilder: (query) => query.where('email', isEqualTo: email),
      sort: (lhs, rhs) => lhs.email.compareTo(rhs.email),
    );
  }

  @override
  Stream<List<Experience>> myExperiencesStream(String userId) =>
      _service.collectionStream(
        path: APIPath.experiences(),
        queryBuilder: (query) =>
            query.where('userId', isEqualTo: userId),
        builder: (data, documentId) => Experience.fromMap(data, documentId),
        sort: (lhs, rhs) => (rhs.startDate?? Timestamp.fromMicrosecondsSinceEpoch(0))
            .compareTo(lhs.startDate?? Timestamp.fromMicrosecondsSinceEpoch(0)),
      );

  @override
  Stream<List<Competency>> competenciesStream() => _service.collectionStream(
    path: APIPath.competencies(),
    builder: (data, documentId) => Competency.fromMap(data, documentId),
    queryBuilder: (query) => query.where('name', isNotEqualTo: null),
    sort: (lhs, rhs) => lhs.name.compareTo(rhs.name),
  );

  @override
  Stream<List<CompetencyCategory>> competenciesCategoriesStream() => _service.collectionStream(
    path: APIPath.competenciesCategories(),
    builder: (data, documentId) => CompetencyCategory.fromMap(data, documentId),
    queryBuilder: (query) => query,
    sort: (lhs, rhs) => lhs.name.compareTo(rhs.name),
  );

  @override
  Stream<List<CompetencySubCategory>> competenciesSubCategoriesStream() => _service.collectionStream(
    path: APIPath.competenciesSubCategories(),
    builder: (data, documentId) => CompetencySubCategory.fromMap(data, documentId),
    queryBuilder: (query) => query,
    sort: (lhs, rhs) => lhs.name.compareTo(rhs.name),
  );

  @override
  Stream<List<CompetencySubCategory>> subCategoriesCompetenciesById(String? competencyCategoryId) =>
      _service.collectionStream(
        path: APIPath.competenciesSubCategories(),
        queryBuilder: (query) =>
            query.where('competencyCategoryId', isEqualTo: competencyCategoryId),
        builder: (data, documentId) =>
            CompetencySubCategory.fromMap(data, documentId),
        sort: (lhs, rhs) => lhs.name.compareTo(rhs.name),
      );

  @override
  Stream<List<Competency>> competenciesBySubCategoryId(String? competencySubCategoryId) =>
      _service.collectionStream(
        path: APIPath.competencies(),
        queryBuilder: (query) =>
            query.where('competencySubCategoryId', isEqualTo: competencySubCategoryId),
        builder: (data, documentId) =>
            Competency.fromMap(data, documentId),
        sort: (lhs, rhs) => lhs.name.compareTo(rhs.name),
      );

  @override
  Stream<List<GamificationFlag>> gamificationFlagsStream() => _service.collectionStream(
    path: APIPath.gamificationFlags(),
    queryBuilder: (query) => query.where('id', isNotEqualTo: null),
    builder: (data, documentId) => GamificationFlag.fromMap(data, documentId),
    sort: (lhs, rhs) => lhs.order.compareTo(rhs.order),
  );

  @override
  Future<void> addUnemployedUser(UnemployedUser unemployedUser) =>
      _service.addData(path: APIPath.users(), data: unemployedUser.toMap());

  @override
  Stream<List<Dedication>> dedicationStream() => _service.collectionStream(
    path: APIPath.dedications(),
    queryBuilder: (query) => query.where('label', isNotEqualTo: null),
    builder: (data, documentId) => Dedication.fromMap(data, documentId),
    sort: (lhs, rhs) => lhs.value.compareTo(rhs.value),
  );

  @override
  Stream<List<Gender>> genderStream() => _service.collectionStream(
    path: APIPath.genders(),
    queryBuilder: (query) => query.where('name', isNotEqualTo: null),
    builder: (data, documentId) => Gender.fromMap(data, documentId),
    sort: (lhs, rhs) => lhs.name.compareTo(rhs.name),
  );

  @override
  Stream<List<TimeSpentWeekly>> timeSpentWeeklyStream() =>
      _service.collectionStream(
        path: APIPath.timeSpentWeekly(),
        queryBuilder: (query) => query.where('label', isNotEqualTo: null),
        builder: (data, documentId) =>
            TimeSpentWeekly.fromMap(data, documentId),
        sort: (lhs, rhs) => lhs.value.compareTo(rhs.value),
      );

  @override
  Stream<List<TimeSearching>> timeSearchingStream() =>
      _service.collectionStream(
        path: APIPath.timeSearching(),
        queryBuilder: (query) => query.where('label', isNotEqualTo: null),
        builder: (data, documentId) => TimeSearching.fromMap(data, documentId),
        sort: (lhs, rhs) => lhs.value.compareTo(rhs.value),
      );

  @override
  Stream<List<IpilEntry>> getIpilEntriesByUserStream(String userId) {
    return _service.collectionStream<IpilEntry>(
      path: APIPath.ipilEntry(),
      queryBuilder: (query) => query.where('userId', isEqualTo: userId),
      builder: (data, documentId) => IpilEntry.fromMap(data, documentId),
      sort: (lhs, rhs) => (rhs.date).compareTo(lhs.date),
    );
  }

  @override
  Future<void> addIpilEntry(IpilEntry ipilEntry) =>
      _service.addData(path: APIPath.ipilEntry(), data: ipilEntry.toMap());

  @override
  Future<void> updateIpilEntryContent(IpilEntry ipilEntry, String content) {
    return _service.updateData(
        path: APIPath.ipilEntryById(ipilEntry.ipilId!), data: {
      "content": content});
  }

  @override
  Future<void> updateIpilEntryDate(IpilEntry ipilEntry, DateTime date) {
    return _service.updateData(
        path: APIPath.ipilEntryById(ipilEntry.ipilId!), data: {
      'date': date});
  }

  @override
  Future<void> deleteIpilEntry(IpilEntry ipilEntry) =>
      _service.deleteData(path: APIPath.ipilEntryById(ipilEntry.ipilId!));

  @override
  Future<void> setIpilEntry(IpilEntry ipilEntry) {
    return _service.updateData(
        path: APIPath.ipilEntryById(ipilEntry.ipilId!), data: ipilEntry.toMap());
  }

  @override
  Stream<List<PersonalDocumentType>> personalDocumentTypeStream() => _service.collectionStream(
    path: APIPath.personalDocumentType(),
    queryBuilder: (query) => query.where('personalDocId', isNotEqualTo: null),
    builder: (data, documentId) => PersonalDocumentType.fromMap(data, documentId),
    sort: (lhs, rhs) => lhs.order.compareTo(rhs.order),
  );

  @override
  Stream<List<DocumentCategory>> documentCategoriesStream() => _service.collectionStream(
    path: APIPath.documentCategories(),
    queryBuilder: (query) => query.where('name', isNotEqualTo: null),
    builder: (data, documentId) => DocumentCategory.fromMap(data, documentId),
    sort: (lhs, rhs) => lhs.order.compareTo(rhs.order),
  );

  @override
  Stream<List<DocumentationParticipant>> documentationParticipantBySubCategoryStream(PersonalDocumentType documentSubCategory, UserEnreda user) => _service.collectionStream(
    path: APIPath.documentationParticipants(),
    queryBuilder: (query) => query.where('userId', isEqualTo: user.userId)
        .where('documentSubCategoryId', isEqualTo: documentSubCategory.personalDocId),
    builder: (data, documentId) => DocumentationParticipant.fromMap(data, documentId),
    sort: (lhs, rhs) => lhs.name.compareTo(rhs.name),
  );

  @override
  Stream<DocumentationParticipant> documentationParticipantStream(String documentId) =>
      _service.documentStream<DocumentationParticipant>(
        path: APIPath.oneDocumentationParticipant(documentId),
        builder: (data, documentId) => DocumentationParticipant.fromMap(data, documentId),
      );

  @override
  Future<void> addDocumentCompany(String companyId, String fileName, Uint8List data) async {
    var firebaseStorageRef =
    FirebaseStorage.instance.ref().child('companies/$companyId/files/$fileName');
    UploadTask uploadTask = firebaseStorageRef.putData(data);
    TaskSnapshot taskSnapshot = await uploadTask;
    try {
      await taskSnapshot.ref.getDownloadURL().then(
            (value) {
          _service.updateData(path: APIPath.company(companyId), data: {
            "file": {
              'src': '$value',
              'title': '$fileName',
            },
          },);
        },
      );
    } catch (e) {
      print('Error updating document: $e');
    }
  }

  @override
  Future<void> addDocumentationParticipant(String userId, String fileName, Uint8List data, DocumentationParticipant document) async {
    var firebaseStorageRef =
    FirebaseStorage.instance.ref().child('users/$userId/files/$fileName');
    UploadTask uploadTask = firebaseStorageRef.putData(data);
    TaskSnapshot taskSnapshot = await uploadTask;
    await taskSnapshot.ref.getDownloadURL().then(
       (value) {
        _service.addDataFile(path: APIPath.documentationParticipants(), data: {
          "file": {
            'src': '$value',
            'title': '$fileName',
          },
          "userId": userId,
          "name": document.name,
          "createDate": document.createDate,
          "renovationDate": document.renovationDate,
          "documentCategoryId": document.documentCategoryId,
          "documentSubCategoryId": document.documentSubCategoryId,
          "createdBy": document.createdBy
        },).then((value) => _service.updateData(
            path: APIPath.oneDocumentationParticipant(value),
            data: {
              "documentationParticipantId": value,
            })
        );
      },
    );
  }

  @override
  Future<void> editFileDocumentationParticipant(String userId, String fileName, Uint8List data, DocumentationParticipant document) async {
    try {
      var firebaseStorageRef = FirebaseStorage.instance.ref().child('users/$userId/files/$fileName');
      UploadTask uploadTask = firebaseStorageRef.putData(data);

      TaskSnapshot taskSnapshot = await uploadTask;
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();

      await _service.updateData(
        path: APIPath.oneDocumentationParticipant(document.documentationParticipantId!),
        data: {
          "file": {
            'src': '$downloadUrl',
            'title': '$fileName',
          },
          "name": document.name,
          "createDate": document.createDate,
          "renovationDate": document.renovationDate,
        }
      );    
    } catch (e) {
      print('An error occurred: $e');
    }
  }

  @override
  Future<void> updateDocumentationParticipant(DocumentationParticipant document) => _service.updateData(
      path: APIPath.oneDocumentationParticipant(document.documentationParticipantId!), data: document.toMap());

  @override
  Future<void> deleteDocumentationParticipant(DocumentationParticipant document) =>
      _service.deleteData(path: APIPath.oneDocumentationParticipant(document.documentationParticipantId!));

  @override
  Stream<InitialReport> initialReportsStreamByUserId(String? userId) {
    return _service.documentStreamByField(
      path: APIPath.initialReports(),
      builder: (data, documentId) => InitialReport.fromMap(data, documentId),
      queryBuilder: (query) => query.where('userId', isEqualTo: userId),
    );
  }

  @override
  Future<void> setInitialReport(InitialReport initialReport) {
    return _service.updateData(
        path: APIPath.initialReport(initialReport.initialReportId!), data: initialReport.toMap());
  }

  @override
  Future<void> addInitialReport(InitialReport initialReport) =>
      _service.addData(path: APIPath.initialReports(), data: initialReport.toMap());

  @override
  Stream<List<String>> languagesStream() => _service.collectionStream(
    path: APIPath.languages(),
    queryBuilder: (query) => query.where('name', isNotEqualTo: null),
    builder: (data, documentId) => data['name'].toString(),
    sort: (lhs, rhs) => lhs.compareTo(rhs),
  );

  @override
  Stream<List<String>> nationsSpanishStream() => _service.collectionStream(
    path: APIPath.nations(),
    queryBuilder: (query) => query.where('name', isNotEqualTo: null),
    builder: (data, documentId) => data['translations']['es'].toString(),
    sort: (lhs, rhs) => lhs.compareTo(rhs),
  );

  @override
  Stream<ClosureReport> closureReportsStreamByUserId(String? userId) {
    return _service.documentStreamByField(
      path: APIPath.closureReports(),
      builder: (data, documentId) => ClosureReport.fromMap(data, documentId),
      queryBuilder: (query) => query.where('userId', isEqualTo: userId),
    );
  }

  @override
  Future<void> setClosureReport(ClosureReport closureReport) {
    return _service.updateData(
        path: APIPath.closureReport(closureReport.closureReportId!), data: closureReport.toMap());
  }

  @override
  Future<void> addClosureReport(ClosureReport closureReport) =>
      _service.addData(path: APIPath.closureReports(), data: closureReport.toMap());

  @override
  Stream<List<KeepLearningOption>> keepLearningOptionsStream() => _service.collectionStream(
    path: APIPath.keepLearningOptions(),
    queryBuilder: (query) => query.where('title', isNotEqualTo: null),
    builder: (data, documentId) => KeepLearningOption.fromMap(data, documentId),
    sort: (lhs, rhs) => lhs.order.compareTo(rhs.order),
  );

  @override
  Stream<FollowReport> followReportsStreamByUserId(String? userId) {
    return _service.documentStreamByField(
      path: APIPath.followReports(),
      builder: (data, documentId) => FollowReport.fromMap(data, documentId),
      queryBuilder: (query) => query.where('userId', isEqualTo: userId),
    );
  }

  @override
  Future<void> setFollowReport(FollowReport followReport) {
    return _service.updateData(
        path: APIPath.followReport(followReport.followReportId!), data: followReport.toMap());
  }

  @override
  Future<void> addFollowReport(FollowReport followReport) =>
      _service.addData(path: APIPath.followReports(), data: followReport.toMap());

  @override
  Stream<DerivationReport> derivationReportsStreamByUserId(String? userId) {
    return _service.documentStreamByField(
      path: APIPath.derivationReports(),
      builder: (data, documentId) => DerivationReport.fromMap(data, documentId),
      queryBuilder: (query) => query.where('userId', isEqualTo: userId),
    );
  }

  @override
  Future<void> setDerivationReport(DerivationReport derivationReport) {
    return _service.updateData(
        path: APIPath.derivationReport(derivationReport.derivationReportId!), data: derivationReport.toMap());
  }

  @override
  Future<void> addDerivationReport(DerivationReport derivationReport) =>
      _service.addData(path: APIPath.derivationReports(), data: derivationReport.toMap());


  @override
  Stream<List<IpilReinforcement>> ipilReinforcementStreamByUser(List<String?> reinforcementIdList) async* {
    final collectionPath = FirebaseFirestore.instance.collection(APIPath.ipilReinforcement());
    final batches = <Future<List<IpilReinforcement>>>[];

    for (var i = 0; i < reinforcementIdList.length; i += 10) {
      final batch = reinforcementIdList.sublist(i, i + 10 < reinforcementIdList.length ? i + 10 : reinforcementIdList.length);
      final futureBatch = collectionPath
          .where('ipilReinforcementId', whereIn: batch)
          .get()
          .then((results) => results.docs.map<IpilReinforcement>((result) => IpilReinforcement.fromMap(result.data(), result.id)).toList());
      batches.add(futureBatch);
    }
    final results = await Future.wait(batches);
    var combinedResults = results.expand((i) => i).toSet().toList();
    yield combinedResults;
  }

  @override
  Stream<List<IpilContextualization>> ipilContextualizationStreamByUser(List<String?> contextualizationIdList) async* {
    final collectionPath = FirebaseFirestore.instance.collection(APIPath.ipilContextualization());
    final batches = <Future<List<IpilContextualization>>>[];

    for (var i = 0; i < contextualizationIdList.length; i += 10) {
      final batch = contextualizationIdList.sublist(i, i + 10 < contextualizationIdList.length ? i + 10 : contextualizationIdList.length);
      final futureBatch = collectionPath
          .where('ipilContextualizationId', whereIn: batch)
          .get()
          .then((results) => results.docs.map<IpilContextualization>((result) => IpilContextualization.fromMap(result.data(), result.id)).toList());
      batches.add(futureBatch);
    }
    final results = await Future.wait(batches);
    var combinedResults = results.expand((i) => i).toSet().toList();
    yield combinedResults;
  }

  @override
  Stream<List<IpilConnectionTerritory>> ipilConnectionTerritoryStreamByUser(List<String?> connectionTerritoryIdList) async* {
    final collectionPath = FirebaseFirestore.instance.collection(APIPath.ipilConnectionTerritory());
    final batches = <Future<List<IpilConnectionTerritory>>>[];

    for (var i = 0; i < connectionTerritoryIdList.length; i += 10) {
      final batch = connectionTerritoryIdList.sublist(i, i + 10 < connectionTerritoryIdList.length ? i + 10 : connectionTerritoryIdList.length);
      final futureBatch = collectionPath
          .where('ipilConnectionTerritoryId', whereIn: batch)
          .get()
          .then((results) => results.docs.map<IpilConnectionTerritory>((result) => IpilConnectionTerritory.fromMap(result.data(), result.id)).toList());
      batches.add(futureBatch);
    }
    final results = await Future.wait(batches);
    var combinedResults = results.expand((i) => i).toSet().toList();
    yield combinedResults;
  }

  @override
  Stream<List<IpilInterviews>> ipilInterviewsStreamByUser(List<String?> interviewsIdList) async* {
    final collectionPath = FirebaseFirestore.instance.collection(APIPath.ipilInterviews());
    final batches = <Future<List<IpilInterviews>>>[];

    for (var i = 0; i < interviewsIdList.length; i += 10) {
      final batch = interviewsIdList.sublist(i, i + 10 < interviewsIdList.length ? i + 10 : interviewsIdList.length);
      final futureBatch = collectionPath
          .where('ipilInterviewsId', whereIn: batch)
          .get()
          .then((results) => results.docs.map<IpilInterviews>((result) => IpilInterviews.fromMap(result.data(), result.id)).toList());
      batches.add(futureBatch);
    }
    final results = await Future.wait(batches);
    var combinedResults = results.expand((i) => i).toSet().toList();
    yield combinedResults;
  }

  @override
  Stream<List<IpilReinforcement>> ipilReinforcementStream() => _service.collectionStream(
    path: APIPath.ipilReinforcement(),
    queryBuilder: (query) => query.where('ipilReinforcementId', isNotEqualTo: null),
    builder: (data, documentId) => IpilReinforcement.fromMap(data, documentId),
    sort: (lhs, rhs) => lhs.order.compareTo(rhs.order),
  );

  @override
  Stream<List<IpilContextualization>> ipilContextualizationStream() => _service.collectionStream(
    path: APIPath.ipilContextualization(),
    queryBuilder: (query) => query.where('ipilContextualizationId', isNotEqualTo: null),
    builder: (data, documentId) => IpilContextualization.fromMap(data, documentId),
    sort: (lhs, rhs) => lhs.order.compareTo(rhs.order),
  );

  @override
  Stream<List<IpilConnectionTerritory>> ipilConnectionTerritoryStream() => _service.collectionStream(
    path: APIPath.ipilConnectionTerritory(),
    queryBuilder: (query) => query.where('ipilConnectionTerritoryId', isNotEqualTo: null),
    builder: (data, documentId) => IpilConnectionTerritory.fromMap(data, documentId),
    sort: (lhs, rhs) => lhs.order.compareTo(rhs.order),
  );

  @override
  Stream<List<IpilInterviews>> ipilInterviewsStream() => _service.collectionStream(
    path: APIPath.ipilInterviews(),
    queryBuilder: (query) => query.where('ipilInterviewsId', isNotEqualTo: null),
    builder: (data, documentId) => IpilInterviews.fromMap(data, documentId),
    sort: (lhs, rhs) => lhs.order.compareTo(rhs.order),
  );

  @override
  Stream<List<IpilObtainingEmployment>> ipilObtainingEmploymentStream() => _service.collectionStream(
    path: APIPath.ipilObtainingEmployment(),
    queryBuilder: (query) => query.where('ipilObtainingEmploymentId', isNotEqualTo: null),
    builder: (data, documentId) => IpilObtainingEmployment.fromMap(data, documentId),
    sort: (lhs, rhs) => lhs.order.compareTo(rhs.order),
  );

  @override
  Stream<IpilObtainingEmployment> ipilObtainingEmploymentStreamByUser(String? obtainingEmploymentId) {
    return _service.documentStreamByField(
      path: APIPath.ipilObtainingEmployment(),
      builder: (data, documentId) => IpilObtainingEmployment.fromMap(data, documentId),
      queryBuilder: (query) => query.where('ipilObtainingEmploymentId', isEqualTo: obtainingEmploymentId),
    );
  }

  @override
  Stream<List<IpilImprovingEmployment>> ipilImprovingEmploymentStream() => _service.collectionStream(
    path: APIPath.ipilImprovingEmployment(),
    queryBuilder: (query) => query.where('ipilImprovingEmploymentId', isNotEqualTo: null),
    builder: (data, documentId) => IpilImprovingEmployment.fromMap(data, documentId),
    sort: (lhs, rhs) => lhs.order.compareTo(rhs.order),
  );

  @override
  Stream<IpilImprovingEmployment> ipilImprovingEmploymentStreamByUser(String? improvingEmploymentId) {
    return _service.documentStreamByField(
      path: APIPath.ipilImprovingEmployment(),
      builder: (data, documentId) => IpilImprovingEmployment.fromMap(data, documentId),
      queryBuilder: (query) => query.where('ipilImprovingEmploymentId', isEqualTo: improvingEmploymentId),
    );
  }

  @override
  Stream<List<IpilPostWorkSupport>> ipilPostWorkSupportStream() => _service.collectionStream(
    path: APIPath.ipilPostWorkSupport(),
    queryBuilder: (query) => query.where('ipilPostWorkSupportId', isNotEqualTo: null),
    builder: (data, documentId) => IpilPostWorkSupport.fromMap(data, documentId),
    sort: (lhs, rhs) => lhs.order.compareTo(rhs.order),
  );

  @override
  Stream<IpilPostWorkSupport> ipilPostWorkSupportStreamByUser(String? postWorkSupportId) {
    return _service.documentStreamByField(
      path: APIPath.ipilPostWorkSupport(),
      builder: (data, documentId) => IpilPostWorkSupport.fromMap(data, documentId),
      queryBuilder: (query) => query.where('ipilPostWorkSupportId', isEqualTo: postWorkSupportId),
    );
  }

  @override
  Stream<List<IpilCoordination>> ipilCoordinationStream() => _service.collectionStream(
    path: APIPath.ipilCoordination(),
    queryBuilder: (query) => query.where('ipilCoordinationId', isNotEqualTo: null),
    builder: (data, documentId) => IpilCoordination.fromMap(data, documentId),
    sort: (lhs, rhs) => lhs.order.compareTo(rhs.order),
  );

  @override
  Stream<IpilCoordination> ipilCoordinationStreamByUser(String? coordinationId) {
    return _service.documentStreamByField(
      path: APIPath.ipilCoordination(),
      builder: (data, documentId) => IpilCoordination.fromMap(data, documentId),
      queryBuilder: (query) => query.where('ipilCoordinationId', isEqualTo: coordinationId),
    );
  }

  @override
  Stream<List<IpilResults>> ipilResultsStream() => _service.collectionStream(
    path: APIPath.ipilResults(),
    queryBuilder: (query) => query.where('ipilResultsId', isNotEqualTo: null),
    builder: (data, documentId) => IpilResults.fromMap(data, documentId),
    sort: (lhs, rhs) => lhs.order.compareTo(rhs.order),
  );

  @override
  Stream<IpilObjectives> ipilObjectivesStreamByUserId(String userId) {
    return _service.documentStreamByField(
      path: APIPath.ipilObjectives(),
      builder: (data, documentId) => IpilObjectives.fromMap(data, documentId),
      queryBuilder: (query) => query.where('userId', isEqualTo: userId),
    );
  }

  @override
  Future<void> setIpilObjectives(IpilObjectives ipilObjectives) {
    return _service.updateData(
        path: APIPath.ipilObjective(ipilObjectives.ipilObjectivesId!), data: ipilObjectives.toMap());
  }

  @override
  Future<void> addIpilObjectives(IpilObjectives ipilObjectives) async {
      await _service.addData(path: APIPath.ipilObjectives(), data: ipilObjectives.toMap());
  }

}


