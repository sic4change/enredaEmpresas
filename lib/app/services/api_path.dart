class APIPath {
  static String resource(String resourceId) => 'resources/$resourceId';
  static String resources() => 'resources';
  static String jobOffer(String jobOfferId) => 'jobOffers/$jobOfferId';
  static String jobOffers() => 'jobOffers';
  static String jobOfferApplications() => 'jobOfferApplications';
  static String resourcesCategories() => 'resourcesCategories';
  static String resourcesTypes() => 'resourcesTypes';
  static String documentCategories() => 'documentCategories';
  static String resourceType(String resourceType) => 'resourcesTypes/$resourceType';
  static String resourceCategory(String resourceCategory) => 'resourcesCategories/$resourceCategory';
  static String company(String companyId) => 'companies/$companyId';
  static String organization(String organizationId) => 'organizations/$organizationId';
  static String companies() => 'companies';
  static String externalSocialEntities() => 'externalSocialEntities';
  static String externalSocialEntity(String externalSocialEntityId) => 'externalSocialEntities/$externalSocialEntityId';
  static String country(String? countryId) => 'countries/$countryId';
  static String countries() => 'countries';
  static String region(String? regionId) => 'states/$regionId';
  static String regions() => 'states';
  static String province(String? provinceId) => 'provinces/$provinceId';
  static String provinces() => 'provinces';
  static String city(String? cityId) => 'cities/$cityId';
  static String cities() => 'cities';
  static String resourcePictures() => 'resourcesPictures';
  static String resourcePicture(String? resourcePictureId) => 'resourcesPictures/$resourcePictureId';
  static String users() => 'users';
  static String user(String userId) => 'users/$userId';
  static String interests() => 'interests';
  static String photoUser(String userId) => 'users/$userId';
  static String logoSocialEntity(String companyId) => 'socialEntities/$companyId';
  static String contacts() => 'contact';
  static String certificates() => 'certificates';
  static String certificate(String certificateId) => 'certificates/$certificateId';
  static String natures() => 'natures';
  static String scopes() => 'scopes';
  static String sizes() => 'sizes';
  static String abilities() => 'abilities';
  static String dedications() => 'dedications';
  static String timeSearching() => 'timeSearchings';
  static String timeSpentWeekly() => 'timeSpentWeeklys';
  static String education() => 'educations';
  static String genders() => 'genders';
  static String specificInterests() => 'specificInterests';
  static String certificationsRequests() => 'certificationsRequests';
  static String certificationRequest(String? certificationRequestId) => 'certificationsRequests/$certificationRequestId';
  static String resourcesInvitations() => 'resourcesInvitations';

  static String experienceType(String id) => 'experienceTypes/$id';
  static String experience(String id) => 'experiences/$id';
  static String experiences() => 'experiences';
  static String competency(String id) => 'competencies/$id';
  static String competencies() => 'competencies';
  static String competenciesCategories() => 'competenciesCategories';
  static String competenciesSubCategories() => 'competenciesSubCategories';
  static String activity(String id) => 'activities/$id';
  static String activities() => 'activities';
  static String experienceTypes() => 'experienceTypes';
  static String experienceSubtypes() => 'experienceSubtypes';
  static String profession(String id) => 'professions/$id';
  static String professions() => 'professions';
  static String activityChoices() => 'activityChoices';
  static String activityRoleChoices() => 'activityRoleChoices';
  static String activityLevelChoices() => 'activityLevelChoices';
  static String socialEntitiesType() => 'socialEntitiesType';
  static String socialEntitiesCategories() => 'socialEntitiesCategories';
  static String tests() => 'tests';
  static String test(String testId) => 'tests/$testId';
  static String gamificationFlags() => 'gamificationFlags';
  static String ipilEntry() => 'ipilEntry';
  static String ipilEntryById(String? ipilId) => 'ipilEntry/$ipilId';
  static String personalDocumentType() => 'personalDocumentType';
  static String documentationParticipants() => 'documentationParticipants';
  static String oneDocumentationParticipant(String fileId) => 'documentationParticipants/$fileId';
  static String personalDocumentUser(String userId) => 'users/$userId';
  static String initialReports() => 'initialReports';
  static String initialReport(String initialReportId) => 'initialReports/$initialReportId';
  static String languages() => 'languages';
  static String nations() => 'nations';
  static String closureReports() => 'closureReports';
  static String closureReport(String closureReportId) => 'closureReports/$closureReportId';
  static String keepLearningOptions() => 'keepLearningOptions';
  static String followReports() => 'followReports';
  static String followReport(String followReportId) => 'followReports/$followReportId';
  static String derivationReports() => 'derivationReports';
  static String derivationReport(String derivationReportId) => 'derivationReports/$derivationReportId';
  static String ipilReinforcement() => 'ipilReinforcement';
  static String ipilContextualization() => 'ipilContextualization';
  static String ipilConnectionTerritory() => 'ipilConnectionTerritory';
  static String ipilInterviews() => 'ipilInterviews';
  static String ipilObtainingEmployment() => 'ipilObtainingEmployment';
  static String ipilImprovingEmployment() => 'ipilImprovingEmployment';
  static String ipilPostWorkSupport() => 'ipilPostWorkSupport';
  static String ipilCoordination() => 'ipilCoordination';
  static String ipilResults() => 'ipilResults';
  static String ipilObjectives() => 'ipilObjectives';
  static String ipilObjective(String ipilObjectivesId) => 'ipilObjectives/$ipilObjectivesId';
}