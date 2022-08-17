// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meta_objects.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ChurchCWProxy {
  Church address(String? address);

  Church name(String name);

  Church ref(DocumentReference<Map<String, dynamic>> ref);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Church(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Church(...).copyWith(id: 12, name: "My name")
  /// ````
  Church call({
    String? address,
    String? name,
    DocumentReference<Map<String, dynamic>>? ref,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfChurch.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfChurch.copyWith.fieldName(...)`
class _$ChurchCWProxyImpl implements _$ChurchCWProxy {
  final Church _value;

  const _$ChurchCWProxyImpl(this._value);

  @override
  Church address(String? address) => this(address: address);

  @override
  Church name(String name) => this(name: name);

  @override
  Church ref(DocumentReference<Map<String, dynamic>> ref) => this(ref: ref);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Church(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Church(...).copyWith(id: 12, name: "My name")
  /// ````
  Church call({
    Object? address = const $CopyWithPlaceholder(),
    Object? name = const $CopyWithPlaceholder(),
    Object? ref = const $CopyWithPlaceholder(),
  }) {
    return Church(
      address: address == const $CopyWithPlaceholder()
          ? _value.address
          // ignore: cast_nullable_to_non_nullable
          : address as String?,
      name: name == const $CopyWithPlaceholder() || name == null
          ? _value.name
          // ignore: cast_nullable_to_non_nullable
          : name as String,
      ref: ref == const $CopyWithPlaceholder() || ref == null
          ? _value.ref
          // ignore: cast_nullable_to_non_nullable
          : ref as DocumentReference<Map<String, dynamic>>,
    );
  }
}

extension $ChurchCopyWith on Church {
  /// Returns a callable class that can be used as follows: `instanceOfChurch.copyWith(...)` or like so:`instanceOfChurch.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ChurchCWProxy get copyWith => _$ChurchCWProxyImpl(this);

  /// Copies the object with the specific fields set to `null`. If you pass `false` as a parameter, nothing will be done and it will be ignored. Don't do it. Prefer `copyWith(field: null)` or `Church(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Church(...).copyWithNull(firstField: true, secondField: true)
  /// ````
  Church copyWithNull({
    bool address = false,
  }) {
    return Church(
      address: address == true ? null : this.address,
      name: name,
      ref: ref,
    );
  }
}

abstract class _$PersonStateCWProxy {
  PersonState color(Color? color);

  PersonState name(String name);

  PersonState ref(DocumentReference<Map<String, dynamic>> ref);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PersonState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PersonState(...).copyWith(id: 12, name: "My name")
  /// ````
  PersonState call({
    Color? color,
    String? name,
    DocumentReference<Map<String, dynamic>>? ref,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfPersonState.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfPersonState.copyWith.fieldName(...)`
class _$PersonStateCWProxyImpl implements _$PersonStateCWProxy {
  final PersonState _value;

  const _$PersonStateCWProxyImpl(this._value);

  @override
  PersonState color(Color? color) => this(color: color);

  @override
  PersonState name(String name) => this(name: name);

  @override
  PersonState ref(DocumentReference<Map<String, dynamic>> ref) =>
      this(ref: ref);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PersonState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PersonState(...).copyWith(id: 12, name: "My name")
  /// ````
  PersonState call({
    Object? color = const $CopyWithPlaceholder(),
    Object? name = const $CopyWithPlaceholder(),
    Object? ref = const $CopyWithPlaceholder(),
  }) {
    return PersonState(
      color: color == const $CopyWithPlaceholder()
          ? _value.color
          // ignore: cast_nullable_to_non_nullable
          : color as Color?,
      name: name == const $CopyWithPlaceholder() || name == null
          ? _value.name
          // ignore: cast_nullable_to_non_nullable
          : name as String,
      ref: ref == const $CopyWithPlaceholder() || ref == null
          ? _value.ref
          // ignore: cast_nullable_to_non_nullable
          : ref as DocumentReference<Map<String, dynamic>>,
    );
  }
}

extension $PersonStateCopyWith on PersonState {
  /// Returns a callable class that can be used as follows: `instanceOfPersonState.copyWith(...)` or like so:`instanceOfPersonState.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$PersonStateCWProxy get copyWith => _$PersonStateCWProxyImpl(this);

  /// Copies the object with the specific fields set to `null`. If you pass `false` as a parameter, nothing will be done and it will be ignored. Don't do it. Prefer `copyWith(field: null)` or `PersonState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PersonState(...).copyWithNull(firstField: true, secondField: true)
  /// ````
  PersonState copyWithNull({
    bool color = false,
  }) {
    return PersonState(
      color: color == true ? null : this.color,
      name: name,
      ref: ref,
    );
  }
}

abstract class _$CollegeCWProxy {
  College name(String name);

  College ref(DocumentReference<Map<String, dynamic>> ref);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `College(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// College(...).copyWith(id: 12, name: "My name")
  /// ````
  College call({
    String? name,
    DocumentReference<Map<String, dynamic>>? ref,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfCollege.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfCollege.copyWith.fieldName(...)`
class _$CollegeCWProxyImpl implements _$CollegeCWProxy {
  final College _value;

  const _$CollegeCWProxyImpl(this._value);

  @override
  College name(String name) => this(name: name);

  @override
  College ref(DocumentReference<Map<String, dynamic>> ref) => this(ref: ref);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `College(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// College(...).copyWith(id: 12, name: "My name")
  /// ````
  College call({
    Object? name = const $CopyWithPlaceholder(),
    Object? ref = const $CopyWithPlaceholder(),
  }) {
    return College(
      name: name == const $CopyWithPlaceholder() || name == null
          ? _value.name
          // ignore: cast_nullable_to_non_nullable
          : name as String,
      ref: ref == const $CopyWithPlaceholder() || ref == null
          ? _value.ref
          // ignore: cast_nullable_to_non_nullable
          : ref as DocumentReference<Map<String, dynamic>>,
    );
  }
}

extension $CollegeCopyWith on College {
  /// Returns a callable class that can be used as follows: `instanceOfCollege.copyWith(...)` or like so:`instanceOfCollege.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$CollegeCWProxy get copyWith => _$CollegeCWProxyImpl(this);
}

abstract class _$FatherCWProxy {
  Father churchId(DocumentReference<Map<String, dynamic>>? churchId);

  Father name(String name);

  Father ref(DocumentReference<Map<String, dynamic>> ref);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Father(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Father(...).copyWith(id: 12, name: "My name")
  /// ````
  Father call({
    DocumentReference<Map<String, dynamic>>? churchId,
    String? name,
    DocumentReference<Map<String, dynamic>>? ref,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfFather.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfFather.copyWith.fieldName(...)`
class _$FatherCWProxyImpl implements _$FatherCWProxy {
  final Father _value;

  const _$FatherCWProxyImpl(this._value);

  @override
  Father churchId(DocumentReference<Map<String, dynamic>>? churchId) =>
      this(churchId: churchId);

  @override
  Father name(String name) => this(name: name);

  @override
  Father ref(DocumentReference<Map<String, dynamic>> ref) => this(ref: ref);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Father(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Father(...).copyWith(id: 12, name: "My name")
  /// ````
  Father call({
    Object? churchId = const $CopyWithPlaceholder(),
    Object? name = const $CopyWithPlaceholder(),
    Object? ref = const $CopyWithPlaceholder(),
  }) {
    return Father(
      churchId: churchId == const $CopyWithPlaceholder()
          ? _value.churchId
          // ignore: cast_nullable_to_non_nullable
          : churchId as DocumentReference<Map<String, dynamic>>?,
      name: name == const $CopyWithPlaceholder() || name == null
          ? _value.name
          // ignore: cast_nullable_to_non_nullable
          : name as String,
      ref: ref == const $CopyWithPlaceholder() || ref == null
          ? _value.ref
          // ignore: cast_nullable_to_non_nullable
          : ref as DocumentReference<Map<String, dynamic>>,
    );
  }
}

extension $FatherCopyWith on Father {
  /// Returns a callable class that can be used as follows: `instanceOfFather.copyWith(...)` or like so:`instanceOfFather.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$FatherCWProxy get copyWith => _$FatherCWProxyImpl(this);

  /// Copies the object with the specific fields set to `null`. If you pass `false` as a parameter, nothing will be done and it will be ignored. Don't do it. Prefer `copyWith(field: null)` or `Father(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Father(...).copyWithNull(firstField: true, secondField: true)
  /// ````
  Father copyWithNull({
    bool churchId = false,
  }) {
    return Father(
      churchId: churchId == true ? null : this.churchId,
      name: name,
      ref: ref,
    );
  }
}

abstract class _$JobCWProxy {
  Job name(String name);

  Job ref(DocumentReference<Map<String, dynamic>> ref);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Job(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Job(...).copyWith(id: 12, name: "My name")
  /// ````
  Job call({
    String? name,
    DocumentReference<Map<String, dynamic>>? ref,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfJob.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfJob.copyWith.fieldName(...)`
class _$JobCWProxyImpl implements _$JobCWProxy {
  final Job _value;

  const _$JobCWProxyImpl(this._value);

  @override
  Job name(String name) => this(name: name);

  @override
  Job ref(DocumentReference<Map<String, dynamic>> ref) => this(ref: ref);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Job(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Job(...).copyWith(id: 12, name: "My name")
  /// ````
  Job call({
    Object? name = const $CopyWithPlaceholder(),
    Object? ref = const $CopyWithPlaceholder(),
  }) {
    return Job(
      name: name == const $CopyWithPlaceholder() || name == null
          ? _value.name
          // ignore: cast_nullable_to_non_nullable
          : name as String,
      ref: ref == const $CopyWithPlaceholder() || ref == null
          ? _value.ref
          // ignore: cast_nullable_to_non_nullable
          : ref as DocumentReference<Map<String, dynamic>>,
    );
  }
}

extension $JobCopyWith on Job {
  /// Returns a callable class that can be used as follows: `instanceOfJob.copyWith(...)` or like so:`instanceOfJob.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$JobCWProxy get copyWith => _$JobCWProxyImpl(this);
}

abstract class _$PersonTypeCWProxy {
  PersonType name(String name);

  PersonType ref(DocumentReference<Map<String, dynamic>> ref);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PersonType(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PersonType(...).copyWith(id: 12, name: "My name")
  /// ````
  PersonType call({
    String? name,
    DocumentReference<Map<String, dynamic>>? ref,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfPersonType.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfPersonType.copyWith.fieldName(...)`
class _$PersonTypeCWProxyImpl implements _$PersonTypeCWProxy {
  final PersonType _value;

  const _$PersonTypeCWProxyImpl(this._value);

  @override
  PersonType name(String name) => this(name: name);

  @override
  PersonType ref(DocumentReference<Map<String, dynamic>> ref) => this(ref: ref);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PersonType(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PersonType(...).copyWith(id: 12, name: "My name")
  /// ````
  PersonType call({
    Object? name = const $CopyWithPlaceholder(),
    Object? ref = const $CopyWithPlaceholder(),
  }) {
    return PersonType(
      name: name == const $CopyWithPlaceholder() || name == null
          ? _value.name
          // ignore: cast_nullable_to_non_nullable
          : name as String,
      ref: ref == const $CopyWithPlaceholder() || ref == null
          ? _value.ref
          // ignore: cast_nullable_to_non_nullable
          : ref as DocumentReference<Map<String, dynamic>>,
    );
  }
}

extension $PersonTypeCopyWith on PersonType {
  /// Returns a callable class that can be used as follows: `instanceOfPersonType.copyWith(...)` or like so:`instanceOfPersonType.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$PersonTypeCWProxy get copyWith => _$PersonTypeCWProxyImpl(this);
}

abstract class _$ServingTypeCWProxy {
  ServingType name(String name);

  ServingType ref(DocumentReference<Map<String, dynamic>> ref);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ServingType(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ServingType(...).copyWith(id: 12, name: "My name")
  /// ````
  ServingType call({
    String? name,
    DocumentReference<Map<String, dynamic>>? ref,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfServingType.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfServingType.copyWith.fieldName(...)`
class _$ServingTypeCWProxyImpl implements _$ServingTypeCWProxy {
  final ServingType _value;

  const _$ServingTypeCWProxyImpl(this._value);

  @override
  ServingType name(String name) => this(name: name);

  @override
  ServingType ref(DocumentReference<Map<String, dynamic>> ref) =>
      this(ref: ref);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ServingType(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ServingType(...).copyWith(id: 12, name: "My name")
  /// ````
  ServingType call({
    Object? name = const $CopyWithPlaceholder(),
    Object? ref = const $CopyWithPlaceholder(),
  }) {
    return ServingType(
      name: name == const $CopyWithPlaceholder() || name == null
          ? _value.name
          // ignore: cast_nullable_to_non_nullable
          : name as String,
      ref: ref == const $CopyWithPlaceholder() || ref == null
          ? _value.ref
          // ignore: cast_nullable_to_non_nullable
          : ref as DocumentReference<Map<String, dynamic>>,
    );
  }
}

extension $ServingTypeCopyWith on ServingType {
  /// Returns a callable class that can be used as follows: `instanceOfServingType.copyWith(...)` or like so:`instanceOfServingType.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ServingTypeCWProxy get copyWith => _$ServingTypeCWProxyImpl(this);
}

abstract class _$StudyYearCWProxy {
  StudyYear grade(int grade);

  StudyYear isCollegeYear(bool isCollegeYear);

  StudyYear name(String name);

  StudyYear ref(DocumentReference<Map<String, dynamic>> ref);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `StudyYear(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// StudyYear(...).copyWith(id: 12, name: "My name")
  /// ````
  StudyYear call({
    int? grade,
    bool? isCollegeYear,
    String? name,
    DocumentReference<Map<String, dynamic>>? ref,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfStudyYear.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfStudyYear.copyWith.fieldName(...)`
class _$StudyYearCWProxyImpl implements _$StudyYearCWProxy {
  final StudyYear _value;

  const _$StudyYearCWProxyImpl(this._value);

  @override
  StudyYear grade(int grade) => this(grade: grade);

  @override
  StudyYear isCollegeYear(bool isCollegeYear) =>
      this(isCollegeYear: isCollegeYear);

  @override
  StudyYear name(String name) => this(name: name);

  @override
  StudyYear ref(DocumentReference<Map<String, dynamic>> ref) => this(ref: ref);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `StudyYear(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// StudyYear(...).copyWith(id: 12, name: "My name")
  /// ````
  StudyYear call({
    Object? grade = const $CopyWithPlaceholder(),
    Object? isCollegeYear = const $CopyWithPlaceholder(),
    Object? name = const $CopyWithPlaceholder(),
    Object? ref = const $CopyWithPlaceholder(),
  }) {
    return StudyYear(
      grade: grade == const $CopyWithPlaceholder() || grade == null
          ? _value.grade
          // ignore: cast_nullable_to_non_nullable
          : grade as int,
      isCollegeYear:
          isCollegeYear == const $CopyWithPlaceholder() || isCollegeYear == null
              ? _value.isCollegeYear
              // ignore: cast_nullable_to_non_nullable
              : isCollegeYear as bool,
      name: name == const $CopyWithPlaceholder() || name == null
          ? _value.name
          // ignore: cast_nullable_to_non_nullable
          : name as String,
      ref: ref == const $CopyWithPlaceholder() || ref == null
          ? _value.ref
          // ignore: cast_nullable_to_non_nullable
          : ref as DocumentReference<Map<String, dynamic>>,
    );
  }
}

extension $StudyYearCopyWith on StudyYear {
  /// Returns a callable class that can be used as follows: `instanceOfStudyYear.copyWith(...)` or like so:`instanceOfStudyYear.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$StudyYearCWProxy get copyWith => _$StudyYearCWProxyImpl(this);
}

abstract class _$SchoolCWProxy {
  School address(String? address);

  School name(String name);

  School ref(DocumentReference<Map<String, dynamic>> ref);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `School(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// School(...).copyWith(id: 12, name: "My name")
  /// ````
  School call({
    String? address,
    String? name,
    DocumentReference<Map<String, dynamic>>? ref,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfSchool.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfSchool.copyWith.fieldName(...)`
class _$SchoolCWProxyImpl implements _$SchoolCWProxy {
  final School _value;

  const _$SchoolCWProxyImpl(this._value);

  @override
  School address(String? address) => this(address: address);

  @override
  School name(String name) => this(name: name);

  @override
  School ref(DocumentReference<Map<String, dynamic>> ref) => this(ref: ref);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `School(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// School(...).copyWith(id: 12, name: "My name")
  /// ````
  School call({
    Object? address = const $CopyWithPlaceholder(),
    Object? name = const $CopyWithPlaceholder(),
    Object? ref = const $CopyWithPlaceholder(),
  }) {
    return School(
      address: address == const $CopyWithPlaceholder()
          ? _value.address
          // ignore: cast_nullable_to_non_nullable
          : address as String?,
      name: name == const $CopyWithPlaceholder() || name == null
          ? _value.name
          // ignore: cast_nullable_to_non_nullable
          : name as String,
      ref: ref == const $CopyWithPlaceholder() || ref == null
          ? _value.ref
          // ignore: cast_nullable_to_non_nullable
          : ref as DocumentReference<Map<String, dynamic>>,
    );
  }
}

extension $SchoolCopyWith on School {
  /// Returns a callable class that can be used as follows: `instanceOfSchool.copyWith(...)` or like so:`instanceOfSchool.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$SchoolCWProxy get copyWith => _$SchoolCWProxyImpl(this);

  /// Copies the object with the specific fields set to `null`. If you pass `false` as a parameter, nothing will be done and it will be ignored. Don't do it. Prefer `copyWith(field: null)` or `School(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// School(...).copyWithNull(firstField: true, secondField: true)
  /// ````
  School copyWithNull({
    bool address = false,
  }) {
    return School(
      address: address == true ? null : this.address,
      name: name,
      ref: ref,
    );
  }
}
