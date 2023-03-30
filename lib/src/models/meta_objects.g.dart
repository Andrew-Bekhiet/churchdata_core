// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meta_objects.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ChurchCWProxy {
  Church ref(DocumentReference<Map<String, dynamic>> ref);

  Church name(String name);

  Church address(String? address);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Church(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Church(...).copyWith(id: 12, name: "My name")
  /// ````
  Church call({
    DocumentReference<Map<String, dynamic>>? ref,
    String? name,
    String? address,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfChurch.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfChurch.copyWith.fieldName(...)`
class _$ChurchCWProxyImpl implements _$ChurchCWProxy {
  const _$ChurchCWProxyImpl(this._value);

  final Church _value;

  @override
  Church ref(DocumentReference<Map<String, dynamic>> ref) => this(ref: ref);

  @override
  Church name(String name) => this(name: name);

  @override
  Church address(String? address) => this(address: address);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Church(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Church(...).copyWith(id: 12, name: "My name")
  /// ````
  Church call({
    Object? ref = const $CopyWithPlaceholder(),
    Object? name = const $CopyWithPlaceholder(),
    Object? address = const $CopyWithPlaceholder(),
  }) {
    return Church(
      ref: ref == const $CopyWithPlaceholder() || ref == null
          ? _value.ref
          // ignore: cast_nullable_to_non_nullable
          : ref as DocumentReference<Map<String, dynamic>>,
      name: name == const $CopyWithPlaceholder() || name == null
          ? _value.name
          // ignore: cast_nullable_to_non_nullable
          : name as String,
      address: address == const $CopyWithPlaceholder()
          ? _value.address
          // ignore: cast_nullable_to_non_nullable
          : address as String?,
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
      ref: ref,
      name: name,
      address: address == true ? null : this.address,
    );
  }
}

abstract class _$PersonStateCWProxy {
  PersonState ref(DocumentReference<Map<String, dynamic>> ref);

  PersonState name(String name);

  PersonState color(Color? color);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PersonState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PersonState(...).copyWith(id: 12, name: "My name")
  /// ````
  PersonState call({
    DocumentReference<Map<String, dynamic>>? ref,
    String? name,
    Color? color,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfPersonState.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfPersonState.copyWith.fieldName(...)`
class _$PersonStateCWProxyImpl implements _$PersonStateCWProxy {
  const _$PersonStateCWProxyImpl(this._value);

  final PersonState _value;

  @override
  PersonState ref(DocumentReference<Map<String, dynamic>> ref) =>
      this(ref: ref);

  @override
  PersonState name(String name) => this(name: name);

  @override
  PersonState color(Color? color) => this(color: color);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PersonState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PersonState(...).copyWith(id: 12, name: "My name")
  /// ````
  PersonState call({
    Object? ref = const $CopyWithPlaceholder(),
    Object? name = const $CopyWithPlaceholder(),
    Object? color = const $CopyWithPlaceholder(),
  }) {
    return PersonState(
      ref: ref == const $CopyWithPlaceholder() || ref == null
          ? _value.ref
          // ignore: cast_nullable_to_non_nullable
          : ref as DocumentReference<Map<String, dynamic>>,
      name: name == const $CopyWithPlaceholder() || name == null
          ? _value.name
          // ignore: cast_nullable_to_non_nullable
          : name as String,
      color: color == const $CopyWithPlaceholder()
          ? _value.color
          // ignore: cast_nullable_to_non_nullable
          : color as Color?,
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
      ref: ref,
      name: name,
      color: color == true ? null : this.color,
    );
  }
}

abstract class _$CollegeCWProxy {
  College ref(DocumentReference<Map<String, dynamic>> ref);

  College name(String name);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `College(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// College(...).copyWith(id: 12, name: "My name")
  /// ````
  College call({
    DocumentReference<Map<String, dynamic>>? ref,
    String? name,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfCollege.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfCollege.copyWith.fieldName(...)`
class _$CollegeCWProxyImpl implements _$CollegeCWProxy {
  const _$CollegeCWProxyImpl(this._value);

  final College _value;

  @override
  College ref(DocumentReference<Map<String, dynamic>> ref) => this(ref: ref);

  @override
  College name(String name) => this(name: name);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `College(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// College(...).copyWith(id: 12, name: "My name")
  /// ````
  College call({
    Object? ref = const $CopyWithPlaceholder(),
    Object? name = const $CopyWithPlaceholder(),
  }) {
    return College(
      ref: ref == const $CopyWithPlaceholder() || ref == null
          ? _value.ref
          // ignore: cast_nullable_to_non_nullable
          : ref as DocumentReference<Map<String, dynamic>>,
      name: name == const $CopyWithPlaceholder() || name == null
          ? _value.name
          // ignore: cast_nullable_to_non_nullable
          : name as String,
    );
  }
}

extension $CollegeCopyWith on College {
  /// Returns a callable class that can be used as follows: `instanceOfCollege.copyWith(...)` or like so:`instanceOfCollege.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$CollegeCWProxy get copyWith => _$CollegeCWProxyImpl(this);
}

abstract class _$FatherCWProxy {
  Father ref(DocumentReference<Map<String, dynamic>> ref);

  Father name(String name);

  Father churchId(DocumentReference<Map<String, dynamic>>? churchId);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Father(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Father(...).copyWith(id: 12, name: "My name")
  /// ````
  Father call({
    DocumentReference<Map<String, dynamic>>? ref,
    String? name,
    DocumentReference<Map<String, dynamic>>? churchId,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfFather.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfFather.copyWith.fieldName(...)`
class _$FatherCWProxyImpl implements _$FatherCWProxy {
  const _$FatherCWProxyImpl(this._value);

  final Father _value;

  @override
  Father ref(DocumentReference<Map<String, dynamic>> ref) => this(ref: ref);

  @override
  Father name(String name) => this(name: name);

  @override
  Father churchId(DocumentReference<Map<String, dynamic>>? churchId) =>
      this(churchId: churchId);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Father(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Father(...).copyWith(id: 12, name: "My name")
  /// ````
  Father call({
    Object? ref = const $CopyWithPlaceholder(),
    Object? name = const $CopyWithPlaceholder(),
    Object? churchId = const $CopyWithPlaceholder(),
  }) {
    return Father(
      ref: ref == const $CopyWithPlaceholder() || ref == null
          ? _value.ref
          // ignore: cast_nullable_to_non_nullable
          : ref as DocumentReference<Map<String, dynamic>>,
      name: name == const $CopyWithPlaceholder() || name == null
          ? _value.name
          // ignore: cast_nullable_to_non_nullable
          : name as String,
      churchId: churchId == const $CopyWithPlaceholder()
          ? _value.churchId
          // ignore: cast_nullable_to_non_nullable
          : churchId as DocumentReference<Map<String, dynamic>>?,
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
      ref: ref,
      name: name,
      churchId: churchId == true ? null : this.churchId,
    );
  }
}

abstract class _$JobCWProxy {
  Job ref(DocumentReference<Map<String, dynamic>> ref);

  Job name(String name);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Job(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Job(...).copyWith(id: 12, name: "My name")
  /// ````
  Job call({
    DocumentReference<Map<String, dynamic>>? ref,
    String? name,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfJob.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfJob.copyWith.fieldName(...)`
class _$JobCWProxyImpl implements _$JobCWProxy {
  const _$JobCWProxyImpl(this._value);

  final Job _value;

  @override
  Job ref(DocumentReference<Map<String, dynamic>> ref) => this(ref: ref);

  @override
  Job name(String name) => this(name: name);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Job(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Job(...).copyWith(id: 12, name: "My name")
  /// ````
  Job call({
    Object? ref = const $CopyWithPlaceholder(),
    Object? name = const $CopyWithPlaceholder(),
  }) {
    return Job(
      ref: ref == const $CopyWithPlaceholder() || ref == null
          ? _value.ref
          // ignore: cast_nullable_to_non_nullable
          : ref as DocumentReference<Map<String, dynamic>>,
      name: name == const $CopyWithPlaceholder() || name == null
          ? _value.name
          // ignore: cast_nullable_to_non_nullable
          : name as String,
    );
  }
}

extension $JobCopyWith on Job {
  /// Returns a callable class that can be used as follows: `instanceOfJob.copyWith(...)` or like so:`instanceOfJob.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$JobCWProxy get copyWith => _$JobCWProxyImpl(this);
}

abstract class _$PersonTypeCWProxy {
  PersonType ref(DocumentReference<Map<String, dynamic>> ref);

  PersonType name(String name);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PersonType(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PersonType(...).copyWith(id: 12, name: "My name")
  /// ````
  PersonType call({
    DocumentReference<Map<String, dynamic>>? ref,
    String? name,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfPersonType.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfPersonType.copyWith.fieldName(...)`
class _$PersonTypeCWProxyImpl implements _$PersonTypeCWProxy {
  const _$PersonTypeCWProxyImpl(this._value);

  final PersonType _value;

  @override
  PersonType ref(DocumentReference<Map<String, dynamic>> ref) => this(ref: ref);

  @override
  PersonType name(String name) => this(name: name);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PersonType(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PersonType(...).copyWith(id: 12, name: "My name")
  /// ````
  PersonType call({
    Object? ref = const $CopyWithPlaceholder(),
    Object? name = const $CopyWithPlaceholder(),
  }) {
    return PersonType(
      ref: ref == const $CopyWithPlaceholder() || ref == null
          ? _value.ref
          // ignore: cast_nullable_to_non_nullable
          : ref as DocumentReference<Map<String, dynamic>>,
      name: name == const $CopyWithPlaceholder() || name == null
          ? _value.name
          // ignore: cast_nullable_to_non_nullable
          : name as String,
    );
  }
}

extension $PersonTypeCopyWith on PersonType {
  /// Returns a callable class that can be used as follows: `instanceOfPersonType.copyWith(...)` or like so:`instanceOfPersonType.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$PersonTypeCWProxy get copyWith => _$PersonTypeCWProxyImpl(this);
}

abstract class _$ServingTypeCWProxy {
  ServingType ref(DocumentReference<Map<String, dynamic>> ref);

  ServingType name(String name);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ServingType(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ServingType(...).copyWith(id: 12, name: "My name")
  /// ````
  ServingType call({
    DocumentReference<Map<String, dynamic>>? ref,
    String? name,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfServingType.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfServingType.copyWith.fieldName(...)`
class _$ServingTypeCWProxyImpl implements _$ServingTypeCWProxy {
  const _$ServingTypeCWProxyImpl(this._value);

  final ServingType _value;

  @override
  ServingType ref(DocumentReference<Map<String, dynamic>> ref) =>
      this(ref: ref);

  @override
  ServingType name(String name) => this(name: name);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ServingType(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ServingType(...).copyWith(id: 12, name: "My name")
  /// ````
  ServingType call({
    Object? ref = const $CopyWithPlaceholder(),
    Object? name = const $CopyWithPlaceholder(),
  }) {
    return ServingType(
      ref: ref == const $CopyWithPlaceholder() || ref == null
          ? _value.ref
          // ignore: cast_nullable_to_non_nullable
          : ref as DocumentReference<Map<String, dynamic>>,
      name: name == const $CopyWithPlaceholder() || name == null
          ? _value.name
          // ignore: cast_nullable_to_non_nullable
          : name as String,
    );
  }
}

extension $ServingTypeCopyWith on ServingType {
  /// Returns a callable class that can be used as follows: `instanceOfServingType.copyWith(...)` or like so:`instanceOfServingType.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ServingTypeCWProxy get copyWith => _$ServingTypeCWProxyImpl(this);
}

abstract class _$StudyYearCWProxy {
  StudyYear ref(DocumentReference<Map<String, dynamic>> ref);

  StudyYear name(String name);

  StudyYear grade(int grade);

  StudyYear isCollegeYear(bool isCollegeYear);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `StudyYear(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// StudyYear(...).copyWith(id: 12, name: "My name")
  /// ````
  StudyYear call({
    DocumentReference<Map<String, dynamic>>? ref,
    String? name,
    int? grade,
    bool? isCollegeYear,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfStudyYear.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfStudyYear.copyWith.fieldName(...)`
class _$StudyYearCWProxyImpl implements _$StudyYearCWProxy {
  const _$StudyYearCWProxyImpl(this._value);

  final StudyYear _value;

  @override
  StudyYear ref(DocumentReference<Map<String, dynamic>> ref) => this(ref: ref);

  @override
  StudyYear name(String name) => this(name: name);

  @override
  StudyYear grade(int grade) => this(grade: grade);

  @override
  StudyYear isCollegeYear(bool isCollegeYear) =>
      this(isCollegeYear: isCollegeYear);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `StudyYear(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// StudyYear(...).copyWith(id: 12, name: "My name")
  /// ````
  StudyYear call({
    Object? ref = const $CopyWithPlaceholder(),
    Object? name = const $CopyWithPlaceholder(),
    Object? grade = const $CopyWithPlaceholder(),
    Object? isCollegeYear = const $CopyWithPlaceholder(),
  }) {
    return StudyYear(
      ref: ref == const $CopyWithPlaceholder() || ref == null
          ? _value.ref
          // ignore: cast_nullable_to_non_nullable
          : ref as DocumentReference<Map<String, dynamic>>,
      name: name == const $CopyWithPlaceholder() || name == null
          ? _value.name
          // ignore: cast_nullable_to_non_nullable
          : name as String,
      grade: grade == const $CopyWithPlaceholder() || grade == null
          ? _value.grade
          // ignore: cast_nullable_to_non_nullable
          : grade as int,
      isCollegeYear:
          isCollegeYear == const $CopyWithPlaceholder() || isCollegeYear == null
              ? _value.isCollegeYear
              // ignore: cast_nullable_to_non_nullable
              : isCollegeYear as bool,
    );
  }
}

extension $StudyYearCopyWith on StudyYear {
  /// Returns a callable class that can be used as follows: `instanceOfStudyYear.copyWith(...)` or like so:`instanceOfStudyYear.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$StudyYearCWProxy get copyWith => _$StudyYearCWProxyImpl(this);
}

abstract class _$SchoolCWProxy {
  School ref(DocumentReference<Map<String, dynamic>> ref);

  School name(String name);

  School address(String? address);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `School(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// School(...).copyWith(id: 12, name: "My name")
  /// ````
  School call({
    DocumentReference<Map<String, dynamic>>? ref,
    String? name,
    String? address,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfSchool.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfSchool.copyWith.fieldName(...)`
class _$SchoolCWProxyImpl implements _$SchoolCWProxy {
  const _$SchoolCWProxyImpl(this._value);

  final School _value;

  @override
  School ref(DocumentReference<Map<String, dynamic>> ref) => this(ref: ref);

  @override
  School name(String name) => this(name: name);

  @override
  School address(String? address) => this(address: address);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `School(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// School(...).copyWith(id: 12, name: "My name")
  /// ````
  School call({
    Object? ref = const $CopyWithPlaceholder(),
    Object? name = const $CopyWithPlaceholder(),
    Object? address = const $CopyWithPlaceholder(),
  }) {
    return School(
      ref: ref == const $CopyWithPlaceholder() || ref == null
          ? _value.ref
          // ignore: cast_nullable_to_non_nullable
          : ref as DocumentReference<Map<String, dynamic>>,
      name: name == const $CopyWithPlaceholder() || name == null
          ? _value.name
          // ignore: cast_nullable_to_non_nullable
          : name as String,
      address: address == const $CopyWithPlaceholder()
          ? _value.address
          // ignore: cast_nullable_to_non_nullable
          : address as String?,
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
      ref: ref,
      name: name,
      address: address == true ? null : this.address,
    );
  }
}
