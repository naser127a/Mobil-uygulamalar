// ignore_for_file: file_names, unused_import

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

class FireStoreServices {
  // get collection of books from the database

  final CollectionReference books =
      FirebaseFirestore.instance.collection("books");

  get kitapAdi => null;

  // CREATE : add a new book to the collection
  Future<void> addBook(String kitapAdi, String yayinEvi, String yazar,
      String sayfaSayisi, String basimYili, String kategori, bool checkbox) {
    return books.add({
      "Kitab adi": kitapAdi,
      "Yayin Evi": yayinEvi,
      "Yazarlar": yazar,
      "Sayfa sayisi": sayfaSayisi,
      "Basim yili": basimYili,
      "timestamp": Timestamp.now(),
      "Kategori": kategori,
      "checkbox": checkbox
    });
  }

  // get books from the database
  Stream<QuerySnapshot> getBooksStream() {
    final booksStream =
        books.orderBy("timestamp", descending: false).snapshots();
    return booksStream;
  }

  // update books from the database
  Future<void> updateBook(
      String? docID,
      String newBook,
      String newyayinEvi,
      String newyazarlar,
      String newSayfaSayisi,
      String newBasimYili,
      String categori,
      bool? checkbox) {
    return books.doc(docID).update({
      "Kitab adi": newBook,
      "Yayin Evi": newyayinEvi,
      "Yazarlar": newyazarlar,
      "Sayfa sayisi": newSayfaSayisi,
      "Basim yili": newBasimYili,
      "Kategori": categori,
      "checkbox": checkbox,
      "timestamp": Timestamp.now()
    });
  }

  // delete books from the database
  Future<void> deleteBook(String docID) {
    return books.doc(docID).delete();
  }
}
