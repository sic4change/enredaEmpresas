import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FirestoreService {
  FirestoreService._();
  static final instance = FirestoreService._();

  Future<void> addData(
      {required String path, required Map<String, dynamic> data}) async {
    final reference = FirebaseFirestore.instance.collection(path);
    await reference.add(data);
  }

  Future<String> addDataString(
      {required String path, Map<String, dynamic>? data}) async {
    final CollectionReference<Map<String, dynamic>?> reference = FirebaseFirestore.instance.collection(path);
    return await reference.add(data).then((value) => value.id);
  }

  Future<String> addDataFile(
      {required String path, Map<String, dynamic>? data}) async {
    final CollectionReference<Map<String, dynamic>?> reference = FirebaseFirestore.instance.collection(path);
    return await reference.add(data).then((value) => value.id);
  }

  Future<void> updateData(
      {required String path, required Map<String, dynamic> data}) async {
    final reference = FirebaseFirestore.instance.doc(path);
    await reference.set(data, SetOptions(merge: true));
  }

  Future<void> deleteData({required String path}) async {
    final reference = FirebaseFirestore.instance.doc(path);
    await reference.delete();
  }

  Stream<List<T>> collectionStream<T>({
    required String path,
    required T Function(Map<String, dynamic> data, String documentId) builder,
    Query Function(Query query)? queryBuilder,
    int Function(T lhs, T rhs)? sort,
  }) {
    Query query = FirebaseFirestore.instance.collection(path);
    if (queryBuilder != null) {
      query = queryBuilder(query);
    }
    final snapshots = query.snapshots();
    return snapshots.map((snapshot) {
      final List<T> result = snapshot.docs
          .map((snapshot) => builder(snapshot.data() as Map<String, dynamic>, snapshot.id))
          .toList();
      if (sort != null) {
        result.sort(sort);
      }
      return result;
    });
  }

  Stream<T> documentStreamByField<T>({
    required String path,
    required T Function(Map<String, dynamic> data, String documentId) builder,
    Query Function(Query query)? queryBuilder,
  }) {
    Query query = FirebaseFirestore.instance.collection(path);

    if (queryBuilder != null) {
      query = queryBuilder(query);
    }
    final snapshots = query.snapshots();
    return snapshots.map((snapshot) {
      final result = snapshot.docs
          .map((snapshot) => builder(snapshot.data() as Map<String, dynamic>, snapshot.id))
          .where((value) => value != null)
          .toList();

      return result.first;
    });
  }

  Stream<List<T>> filteredCollectionStream<T>({
    required String path,
    required T? Function(Map<String, dynamic> data, String documentId) builder,
    Query<Map<String, dynamic>> Function(Query<Map<String, dynamic>> query)? queryBuilder,
    int Function(T lhs, T rhs)? sort,
  }) {
    Query<Map<String, dynamic>> query = FirebaseFirestore.instance.collection(path);
    if (queryBuilder != null) {
      query = queryBuilder(query);
    }
    final snapshots = query.snapshots();
    return snapshots.map((snapshot) {
      final map = snapshot.docs
          .map((snapshot) => builder(snapshot.data(), snapshot.id));
      final List<T> result = [];
      map.toList();
      map.forEach((element) {
        if (element != null) result.add(element);
      });

      if (sort != null) {
        result.sort(sort);
      }
      return result;
    });
  }

  Stream<T> documentStream<T>({
    required String path,
    required T builder(Map<String, dynamic> data, String documentID),
  }) {
    final reference = FirebaseFirestore.instance.doc(path);
    final snapshots = reference.snapshots();
    return snapshots.map((snapshot) => builder(snapshot.data()!, snapshot.id));
  }

  Stream<T?> nullableDocumentStreamByField<T>({
    required String path,
    required T Function(Map<String, dynamic> data, String documentId) builder,
    Query Function(Query query)? queryBuilder,
  }) {
    Query query = FirebaseFirestore.instance.collection(path);

    if (queryBuilder != null) {
      query = queryBuilder(query);
    }
    final snapshots = query.snapshots();
    return snapshots.map((snapshot) {
      final List<T?> result = snapshot.docs
          .map((snapshot) => builder(snapshot.data() as Map<String, dynamic>, snapshot.id))
          .toList();

      return result.isNotEmpty? result.first: null;
    });
  }
}
