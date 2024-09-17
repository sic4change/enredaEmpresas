// import 'dart:async';
//
// import 'package:algolia/algolia.dart';
// import 'package:enreda_empresas/app/models/company.dart';
// import 'package:enreda_empresas/app/services/algolia_search.dart';
// import 'package:flutter/material.dart';
//
// class SearchBarAlgolia extends StatefulWidget {
//   const SearchBarAlgolia({super.key});
//
//   @override
//   State<SearchBarAlgolia> createState() => _SearchBarAlgoliaState();
//
// }
// Algolia algolia = AlgoliaSearch.algolia;
//
// class _SearchBarAlgoliaState extends State<SearchBarAlgolia> {
//   final _queryController = TextEditingController();
//   String get searchQuery => _queryController.text;
//   List<SocialEntity> finalSocialEntities = [];
//
//   late Algolia _algolia;
//   final List<AlgoliaObjectSnapshot> _results = [];
//
//
//   @override
//   void initState() {
//     super.initState();
//     _algolia = AlgoliaSearch.algolia;
//   }
//
//   Future<void> _fetchUsers() async{
//     final query = _algolia.instance.index('socialEntities_index').query(searchQuery);
//     final snap = await query.getObjects();
//     final results = snap.hits;
//     _results.addAll(results);
//     SocialEntity prueba = SocialEntity.fromMap(_results[0].data, _results[0].data['socialEntityId']);
//     finalSocialEntities.add(prueba);
//     print(_results[0].data);
//     print('Prueba: ${prueba.name}');
//     setState(() {
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         Expanded(
//           child: TextFormField(
//             controller: _queryController,
//           ),
//         ),
//         IconButton(
//             onPressed: _fetchUsers,
//             icon: Icon(
//               Icons.search,
//               color: Colors.black,
//             )
//         )
//       ],
//     );
//   }
//
//
// }
