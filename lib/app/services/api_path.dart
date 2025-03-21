class APIPath {
  static String resource(String resourceId) => 'resources/$resourceId';
  static String resources() => 'resources';
  static String resourcesCategories() => 'resourcesCategories';
  static String organization(String organizationId) => 'organizations/$organizationId';
  static String organizations() => 'organizations';
  static String country(String? countryId) => 'countries/$countryId';
  static String countries() => 'countries';
  static String province(String? provinceId) => 'provinces/$provinceId';
  static String provinces() => 'provinces';
  static String city(String? cityId) => 'cities/$cityId';
  static String cities() => 'cities';
  static String resourcePicture(String? resourcePictureId) => 'resourcesPictures/$resourcePictureId';
  static String users() => 'users';
  static String user(String userId) => 'users/$userId';
  static String interests() => 'interests';
  static String photoUser(String userId) => 'users/$userId';
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

  static String chatQuestion(String id) => 'chatQuestions/$id';
  static String chatQuestions() => 'chatQuestions';
  static String question(String id) => 'questions/$id';
  static String questions() => 'questions';
  static String experienceType(String id) => 'experienceTypes/$id';
  static String experience(String id) => 'experiences/$id';
  static String experiences() => 'experiences';
  static String competency(String id) => 'competencies/$id';
  static String competencies() => 'competencies';
  static String activity(String id) => 'activities/$id';
  static String activities() => 'activities';
  static String experienceTypes() => 'experienceTypes';
  static String experienceSubtypes() => 'experienceSubtypes';
  static String profession(String id) => 'professions/$id';
  static String professions() => 'professions';
  static String activityChoices() => 'activityChoices';
  static String activityRoleChoices() => 'activityRoleChoices';
  static String activityLevelChoices() => 'activityLevelChoices';

  static String tests() => 'tests';
  static String test(String testId) => 'tests/$testId';
}