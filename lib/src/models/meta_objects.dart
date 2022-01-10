// coverage:ignore-file
import 'dart:async';

import 'package:churchdata_core/churchdata_core.dart' hide JsonRef;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

part 'meta_objects.g.dart';

@immutable
class MetaObject extends DataObject {
  const MetaObject(DocumentReference<Json> ref, String name) : super(ref, name);

  @override
  Json toJson() {
    return {'Name': name};
  }
}

@CopyWith(copyWithNull: true)
class Church extends MetaObject {
  final String? address;

  const Church(
      {required DocumentReference<Json> ref,
      required String name,
      this.address})
      : super(ref, name);

  Church.createNew()
      : this(
          ref: GetIt.I<DatabaseRepository>().collection('Churches').doc(),
          name: '',
          address: '',
        );

  @override
  Json toJson() {
    return {...super.toJson(), 'Address': address};
  }

  Stream<List<Church>> getAll() {
    return GetIt.I<DatabaseRepository>()
        .collection('Fathers')
        .where('ChurchId', isEqualTo: ref)
        .snapshots()
        .map((s) => s.docs.map(Church.fromDoc).toList());
  }

  Church.fromDoc(JsonDoc data)
      : this(
          ref: data.reference,
          name: data.data()!['Name'],
          address: data.data()!['Address'],
        );

  Stream<List<Father>> getChildren(
      [String orderBy = 'Name', bool tranucate = false]) {
    return (GetIt.I<DatabaseRepository>()
            .collection('Fathers')
            .where('ChurchId', isEqualTo: ref)
            .snapshots())
        .map((s) => s.docs.map(Father.fromDoc).toList());
  }
}

@CopyWith(copyWithNull: true)
class PersonState extends MetaObject {
  @override
  final Color? color;

  const PersonState(
      {required DocumentReference<Json> ref, required String name, this.color})
      : super(ref, name);

  PersonState.createNew()
      : this(
          ref: GetIt.I<DatabaseRepository>().collection('States').doc(),
          name: '',
        );

  @override
  Json toJson() {
    return {...super.toJson(), 'Color': color};
  }

  PersonState.fromDoc(JsonDoc data)
      : this(
          ref: data.reference,
          name: data.data()!['Name'],
          color: data.data()!['Color'],
        );
}

@CopyWith(copyWithNull: true)
class College extends MetaObject {
  const College({required DocumentReference<Json> ref, required String name})
      : super(ref, name);

  College.createNew()
      : this(
          ref: GetIt.I<DatabaseRepository>().collection('States').doc(),
          name: '',
        );

  College.fromDoc(JsonDoc data)
      : this(
          ref: data.reference,
          name: data.data()!['Name'],
        );
}

@CopyWith(copyWithNull: true)
class Father extends MetaObject {
  final DocumentReference<Json>? churchId;

  const Father({
    required DocumentReference<Json> ref,
    required String name,
    this.churchId,
  }) : super(ref, name);

  Father.createNew()
      : this(
          ref: GetIt.I<DatabaseRepository>().collection('Fathers').doc(),
          name: '',
        );

  Future<String?> getChurchName() async {
    if (churchId == null) return null;
    return Church.fromDoc(
      await churchId!.get(),
    ).name;
  }

  @override
  Json toJson() {
    return {...super.toJson(), 'ChurchId': churchId};
  }

  Father.fromDoc(JsonDoc data)
      : this(
          ref: data.reference,
          name: data.data()!['Name'],
          churchId: data.data()!['ChurchId'],
        );
}

@CopyWith(copyWithNull: true)
class Job extends MetaObject {
  const Job({required DocumentReference<Json> ref, required String name})
      : super(ref, name);

  Job.createNew()
      : this(
          ref: GetIt.I<DatabaseRepository>().collection('Jobs').doc(),
          name: '',
        );

  Job.fromDoc(JsonDoc data)
      : this(
          ref: data.reference,
          name: data.data()!['Name'],
        );
}

@CopyWith(copyWithNull: true)
class PersonType extends MetaObject {
  const PersonType({required DocumentReference<Json> ref, required String name})
      : super(ref, name);

  PersonType.createNew()
      : this(
          ref: GetIt.I<DatabaseRepository>().collection('Types').doc(),
          name: '',
        );

  PersonType.fromDoc(JsonDoc data)
      : this(
          ref: data.reference,
          name: data.data()!['Name'],
        );
}

@CopyWith(copyWithNull: true)
class ServingType extends MetaObject {
  const ServingType(
      {required DocumentReference<Json> ref, required String name})
      : super(ref, name);

  ServingType.createNew()
      : this(
          ref: GetIt.I<DatabaseRepository>().collection('ServingTypes').doc(),
          name: '',
        );

  ServingType.fromDoc(JsonDoc data)
      : this(
          ref: data.reference,
          name: data.data()!['Name'],
        );
}

@CopyWith(copyWithNull: true)
class StudyYear extends MetaObject {
  final bool isCollegeYear;
  final int grade;

  const StudyYear({
    required DocumentReference<Json> ref,
    required String name,
    required this.grade,
    this.isCollegeYear = false,
  }) : super(ref, name);

  StudyYear.createNew()
      : this(
          ref: GetIt.I<DatabaseRepository>().collection('States').doc(),
          name: '',
          grade: 0,
        );

  @override
  Json toJson() {
    return {
      ...super.toJson(),
      'IsCollegeYear': isCollegeYear,
      'Grade': grade,
    };
  }

  StudyYear.fromDoc(JsonDoc data)
      : this(
          ref: data.reference,
          name: data.data()!['Name'],
          grade: data.data()!['Grade'],
          isCollegeYear: data.data()!['IsCollegeYear'],
        );
}

@CopyWith(copyWithNull: true)
class School extends MetaObject {
  final String? address;

  const School(
      {required DocumentReference<Json> ref,
      required String name,
      this.address})
      : super(ref, name);

  School.createNew()
      : this(
          ref: GetIt.I<DatabaseRepository>().collection('States').doc(),
          name: '',
        );

  @override
  Json toJson() {
    return {
      ...super.toJson(),
      'Address': address,
    };
  }

  Stream<List<School>> getAll() {
    return GetIt.I<DatabaseRepository>()
        .collection('Persons')
        .where('School', isEqualTo: ref)
        .snapshots()
        .map((s) => s.docs.map(School.fromDoc).toList());
  }

  School.fromDoc(JsonDoc data)
      : this(
          ref: data.reference,
          name: data.data()!['Name'],
          address: data.data()!['Address'],
        );
}

class PreferredStudyYear extends StudyYear {
  final double? preferredGroup;

  PreferredStudyYear.fromStudyYear(StudyYear sy, [this.preferredGroup])
      : super(
          ref: sy.ref,
          name: sy.name,
          grade: sy.grade,
          isCollegeYear: sy.isCollegeYear,
        );

  @override
  List<Object?> get props => [...super.props, preferredGroup];
}
