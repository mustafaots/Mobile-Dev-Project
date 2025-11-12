import 'base_repository.dart';

/// Repository for managing verification codes
class VerificationCodeRepository extends BaseRepository {
  /// Insert a new verification code
  Future<int> insertVerificationCode({
    required String code,
    required int owner,
  }) async {
    return await db.insert('verification_codes', {
      'code': code,
      'owner': owner,
    });
  }

  /// Get verification code by code string
  Future<Map<String, dynamic>?> getVerificationCodeByCode(String code) async {
    final result = await db.query(
      'verification_codes',
      where: 'code = ?',
      whereArgs: [code],
    );
    return result.isNotEmpty ? result.first : null;
  }

  /// Get all verification codes for a user
  Future<List<Map<String, dynamic>>> getVerificationCodesByOwner(
    int owner,
  ) async {
    return await db.query(
      'verification_codes',
      where: 'owner = ?',
      whereArgs: [owner],
    );
  }

  /// Delete verification code
  Future<int> deleteVerificationCode(String code) async {
    return await db.delete(
      'verification_codes',
      where: 'code = ?',
      whereArgs: [code],
    );
  }
}
