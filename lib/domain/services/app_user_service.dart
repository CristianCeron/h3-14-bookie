import 'package:h3_14_bookie/domain/model/app_user.dart';
import 'package:h3_14_bookie/domain/model/dto/user_dto.dart';
import 'package:h3_14_bookie/domain/model/writing.dart';

interface class IAppUserService {
  Future<List<AppUser>> getAppUsers() async {
    return [];
  }

  Future<AppUser?> getAppUserById(String uid) async {
    return null;
  }

  Future<AppUser?> getAppUserByAuthUserUid(String authUserUid) async {
    return null;
  }

  Future<void> createAppUser(UserDto newUser) async {}

  Future<void> updateUser(String uid, String name, String email) async {}

  Future<void> updateUserWriting(Writing writing) async {}

  Future<bool> addNewReading(String storyId, bool inLibrary) async {
    throw UnimplementedError();
  }

  Future<void> addNewWriting(
      String authUserUid, String storyId, bool isDraft) async {}

  Future<List<Writing>> getAuthorWritings(String authorUid) async {
    return [];
  }

  Future<void> completeNewChapterInStory(
      String stroyId, String completedChapterUid) async {}
}
