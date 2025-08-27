// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AuthSuccessImpl _$$AuthSuccessImplFromJson(Map<String, dynamic> json) =>
    _$AuthSuccessImpl(
      user: User.fromJson(json['user'] as Map<String, dynamic>),
      message: json['message'] as String?,
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$AuthSuccessImplToJson(_$AuthSuccessImpl instance) =>
    <String, dynamic>{
      'user': instance.user,
      'message': instance.message,
      'runtimeType': instance.$type,
    };

_$AuthFailureImpl _$$AuthFailureImplFromJson(Map<String, dynamic> json) =>
    _$AuthFailureImpl(
      message: json['message'] as String,
      code: json['code'] as String?,
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$AuthFailureImplToJson(_$AuthFailureImpl instance) =>
    <String, dynamic>{
      'message': instance.message,
      'code': instance.code,
      'runtimeType': instance.$type,
    };

_$LoginRequestImpl _$$LoginRequestImplFromJson(Map<String, dynamic> json) =>
    _$LoginRequestImpl(
      email: json['email'] as String,
      password: json['password'] as String,
    );

Map<String, dynamic> _$$LoginRequestImplToJson(_$LoginRequestImpl instance) =>
    <String, dynamic>{'email': instance.email, 'password': instance.password};

_$RegisterRequestImpl _$$RegisterRequestImplFromJson(
  Map<String, dynamic> json,
) => _$RegisterRequestImpl(
  email: json['email'] as String,
  password: json['password'] as String,
  displayName: json['displayName'] as String?,
);

Map<String, dynamic> _$$RegisterRequestImplToJson(
  _$RegisterRequestImpl instance,
) => <String, dynamic>{
  'email': instance.email,
  'password': instance.password,
  'displayName': instance.displayName,
};
