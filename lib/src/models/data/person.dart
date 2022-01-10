import 'package:async/async.dart';
import 'package:churchdata_core/churchdata_core.dart' hide GeoPoint, Timestamp;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

part 'person.g.dart';

@immutable
@CopyWith(copyWithNull: true)
class PersonBase extends DataObject implements PhotoObjectBase {
  final String? address;
  final GeoPoint? location;

  final String? mainPhone;
  final Json otherPhones;

  final DateTime? birthDate;

  final JsonRef? school;
  final JsonRef? college;
  final JsonRef? church;
  final JsonRef? cFather;

  final DateTime? lastKodas;
  final DateTime? lastTanawol;
  final DateTime? lastConfession;
  final DateTime? lastCall;

  final DateTime? lastVisit;
  final LastEdit? lastEdit;
  final String? notes;

  final bool isShammas;

  /// IsMale?
  final bool gender;
  final String? shammasLevel;
  final JsonRef? studyYear;

  @override
  final Color? color;

  @override
  final bool hasPhoto;

  PersonBase({
    required JsonRef ref,
    required String name,
    this.color,
    this.address,
    this.location,
    this.mainPhone,
    this.otherPhones = const {},
    this.birthDate,
    this.school,
    this.college,
    this.church,
    this.cFather,
    this.lastKodas,
    this.lastTanawol,
    this.lastConfession,
    this.lastCall,
    this.lastVisit,
    this.lastEdit,
    this.notes,
    this.isShammas = false,
    this.gender = true,
    this.shammasLevel,
    this.studyYear,
    this.hasPhoto = false,
  }) : super(ref, name);

  PersonBase.fromDoc(JsonDoc doc)
      : this(
          ref: doc.reference,
          hasPhoto: doc.data()!['HasPhoto'] ?? false,
          color:
              doc.data()!['Color'] == null ? null : Color(doc.data()!['Color']),
          name: doc.data()!['Name'],
          address: doc.data()!['Address'],
          location: doc.data()!['Location'],
          mainPhone: doc.data()!['MainPhone'],
          otherPhones: doc.data()!['OtherPhones'],
          birthDate: (doc.data()!['BirthDate'] as Timestamp?)?.toDate(),
          school: doc.data()!['School'],
          college: doc.data()!['College'],
          church: doc.data()!['Church'],
          cFather: doc.data()!['CFather'],
          lastKodas: (doc.data()!['LastKodas'] as Timestamp?)?.toDate(),
          lastTanawol: (doc.data()!['LastTanawol'] as Timestamp?)?.toDate(),
          lastConfession:
              (doc.data()!['LastConfession'] as Timestamp?)?.toDate(),
          lastCall: (doc.data()!['LastCall'] as Timestamp?)?.toDate(),
          lastVisit: (doc.data()!['LastVisit'] as Timestamp?)?.toDate(),
          lastEdit: doc.data()!['LastEdit'] == null
              ? null
              : LastEdit.fromJson(doc.data()!['LastEdit']),
          notes: doc.data()!['Notes'],
          isShammas: doc.data()!['IsShammas'] ?? false,
          gender: doc.data()!['Gender'] ?? true,
          shammasLevel: doc.data()!['ShammasLevel'],
          studyYear: doc.data()!['StudyYear'],
        );

  @override
  Reference? get photoRef =>
      hasPhoto ? GetIt.I<StorageRepository>().ref('PersonsPhotos/' + id) : null;

  @override
  IconData get defaultIcon => Icons.person;

  @override
  final AsyncCache<String> photoUrlCache =
      AsyncCache<String>(const Duration(days: 1));

  @override
  @mustCallSuper
  Json toJson() {
    return {
      'Name': name,
      'Address': address,
      'Location': location,
      'MainPhone': mainPhone,
      'OtherPhones': otherPhones,
      'BirthDate': birthDate,
      'BirthDay': birthDate == null
          ? null
          : DateTime(1970, birthDate!.month, birthDate!.day),
      'School': school,
      'College': college,
      'Church': church,
      'CFather': cFather,
      'LastKodas': lastKodas,
      'LastTanawol': lastTanawol,
      'LastConfession': lastConfession,
      'LastCall': lastCall,
      'LastVisit': lastVisit,
      'LastEdit': lastEdit?.toJson(),
      'Notes': notes,
      'IsShammas': isShammas,
      'Gender': gender,
      'ShammasLevel': shammasLevel,
      'StudyYear': studyYear,
      'Color': color?.value,
    };
  }

  // coverage:ignore-start
  static Map<String, PropertyMetadata> get propsMetadata => {
        'Name': const PropertyMetadata<String>(
          name: 'Name',
          label: 'الاسم',
          defaultValue: '',
        ),
        'MainPhone': const PropertyMetadata<String?>(
          name: 'MainPhone',
          label: 'موبايل',
          defaultValue: null,
        ),
        'OtherPhones': const PropertyMetadata<Json>(
          name: 'OtherPhones',
          label: 'الأرقام الأخرى',
          defaultValue: {},
        ),
        'BirthDate': const PropertyMetadata<DateTime>(
          name: 'BirthDate',
          label: 'تاريخ الميلاد',
          defaultValue: null,
        ),
        'BirthDay': const PropertyMetadata<DateTime>(
          name: 'BirthDay',
          label: 'يوم الميلاد',
          defaultValue: null,
        ),
        'StudyYear': PropertyMetadata<JsonRef>(
          name: 'StudyYear',
          label: 'سنة الدراسة',
          defaultValue: null,
          collection: GetIt.I<DatabaseRepository>()
              .collection('StudyYears')
              .orderBy('Grade'),
        ),
        'Gender': const PropertyMetadata<bool>(
          name: 'Gender',
          label: 'النوع',
          defaultValue: true,
        ),
        'IsShammas': const PropertyMetadata<bool>(
          name: 'IsShammas',
          label: 'شماس؟',
          defaultValue: false,
        ),
        'ShammasLevel': const PropertyMetadata<String>(
          name: 'ShammasLevel',
          label: 'رتبة الشموسية',
          defaultValue: '',
        ),
        'Address': const PropertyMetadata<String>(
          name: 'Address',
          label: 'العنوان',
          defaultValue: '',
        ),
        'Location': const PropertyMetadata<GeoPoint>(
          name: 'Location',
          label: 'الموقع الجغرافي',
          defaultValue: null,
        ),
        'School': PropertyMetadata<JsonRef>(
          name: 'School',
          label: 'المدرسة',
          defaultValue: null,
          collection: GetIt.I<DatabaseRepository>()
              .collection('Schools')
              .orderBy('Name'),
        ),
        'College': PropertyMetadata<JsonRef>(
          name: 'College',
          label: 'الكلية',
          defaultValue: null,
          collection: GetIt.I<DatabaseRepository>()
              .collection('Colleges')
              .orderBy('Name'),
        ),
        'Church': PropertyMetadata<JsonRef>(
          name: 'Church',
          label: 'الكنيسة',
          defaultValue: null,
          collection: GetIt.I<DatabaseRepository>()
              .collection('Churches')
              .orderBy('Name'),
        ),
        'CFather': PropertyMetadata<JsonRef>(
          name: 'CFather',
          label: 'أب الاعتراف',
          defaultValue: null,
          collection: GetIt.I<DatabaseRepository>()
              .collection('Fathers')
              .orderBy('Name'),
        ),
        'Notes': const PropertyMetadata<String>(
          name: 'Notes',
          label: 'ملاحظات',
          defaultValue: '',
        ),
        'LastKodas': const PropertyMetadata<DateTime>(
          name: 'LastKodas',
          label: 'تاريخ أخر حضور قداس',
          defaultValue: null,
        ),
        'LastTanawol': const PropertyMetadata<DateTime>(
          name: 'LastTanawol',
          label: 'تاريخ أخر تناول',
          defaultValue: null,
        ),
        'LastConfession': const PropertyMetadata<DateTime>(
          name: 'LastConfession',
          label: 'تاريخ أخر اعتراف',
          defaultValue: null,
        ),
        'LastVisit': const PropertyMetadata<DateTime>(
          name: 'LastVisit',
          label: 'تاريخ أخر افتقاد',
          defaultValue: null,
        ),
        'LastCall': const PropertyMetadata<DateTime>(
          name: 'LastCall',
          label: 'تاريخ أخر مكالمة',
          defaultValue: null,
        ),
        'LastEdit': PropertyMetadata<Json>(
          name: 'LastEdit',
          label: 'أخر تعديل',
          defaultValue: const {},
          collection:
              GetIt.I<DatabaseRepository>().collection('Users').orderBy('Name'),
        ),
        'HasPhoto': const PropertyMetadata<bool>(
          name: 'HasPhoto',
          label: 'لديه صورة',
          defaultValue: false,
        ),
        'Color': const PropertyMetadata<Color?>(
          name: 'Color',
          label: 'اللون',
          defaultValue: null,
        ),
      };
  // coverage:ignore-end
}
