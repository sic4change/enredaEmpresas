// import 'package:algolia/algolia.dart';
// import 'package:enreda_empresas/app/models/company.dart';
//
// class AlgoliaSearch {
//   static final Algolia algolia = Algolia.init(
//       applicationId: 'BHQG81KUSV',
//       apiKey: 'bd1a42613c3da346253dc30f36e820dd'
//   );
//
//   Future<List<SocialEntity>> fetchUsers(String searchQuery) async{
//     const index = 'socialEntities_index';
//     final query = algolia.instance.index('socialEntities_index').query(searchQuery);
//     final snap = await query.getObjects();
//     final values = snap.hits;
//     List<SocialEntity> results = [];
//     for(var item in values){
//       results.add(SocialEntity.fromMap(item.data, item.data['socialEntityId']));
//     }
//     return results;
//   }
// }
// /*
// class SearchEngineAlgolia {
//
//   SearchEngineAlgolia({required Algolia algolia}) : _algolia = algolia;
//
//   final Algolia _algolia;
//
//   AlgoliaIndexReference _index(String indexName) => _algolia.index(indexName);
//   AlgoliaQuery query(String indexName, String searchQuery) => _index(indexName).query(searchQuery);
//   Future<List<T>> getObjects<T>({
//     required AlgoliaQuery query,
//     required T Function(Map<String, dynamic> data) builder }) => query.getObjects().then(
//           (snapshot) => snapshot.hits.map((e) => builder(e.data)).toList());
//
//   Future<List<SocialEntity>> fetchUsers(String searchQuery) async{
//     const index = 'socialEntities_index';
//     final query = _algolia.instance.index('socialEntities_index').query(searchQuery);
//     final snap = await query.getObjects();
//     final values = snap.hits;
//     List<SocialEntity> results = [];
//     for(var item in values){
//       results.add(SocialEntity.fromMap(item.data, item.data['socialEntityId']));
//     }
//     return results;
//   }
// }
// */
