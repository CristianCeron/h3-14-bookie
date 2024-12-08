import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:h3_14_bookie/domain/model/dto/story_dto.dart';
import 'package:h3_14_bookie/domain/model/story.dart';

interface class IStoryService {
  Stream<QuerySnapshot> getStories() {
    return Stream.empty();
  }

  Future<String> createStory(StoryDto storyDto) async {
    return '';
  }

  Future<Story?> getStoryById(String storyUid) {
    return Future(() => null);
  }

  Future<bool> addChapterToStory(String storyUid, String chapterUid) async {
    return false;
  }
}