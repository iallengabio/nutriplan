import 'package:freezed_annotation/freezed_annotation.dart';
import 'user.dart';

part 'auth_result.freezed.dart';
part 'auth_result.g.dart';

@freezed
class AuthResult with _$AuthResult {
  const factory AuthResult.success({
    required User user,
    String? message,
  }) = AuthSuccess;

  const factory AuthResult.failure({
    required String message,
    String? code,
  }) = AuthFailure;

  factory AuthResult.fromJson(Map<String, dynamic> json) => _$AuthResultFromJson(json);
}

@freezed
class LoginRequest with _$LoginRequest {
  const factory LoginRequest({
    required String email,
    required String password,
  }) = _LoginRequest;

  factory LoginRequest.fromJson(Map<String, dynamic> json) => _$LoginRequestFromJson(json);
}

@freezed
class RegisterRequest with _$RegisterRequest {
  const factory RegisterRequest({
    required String email,
    required String password,
    String? displayName,
  }) = _RegisterRequest;

  factory RegisterRequest.fromJson(Map<String, dynamic> json) => _$RegisterRequestFromJson(json);
}