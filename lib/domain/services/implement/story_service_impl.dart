import 'package:firebase_auth/firebase_auth.dart';
import 'package:h3_14_bookie/domain/model/category.dart';
import 'package:h3_14_bookie/domain/model/dto/category_dto.dart';
import 'package:h3_14_bookie/domain/model/dto/story_dto.dart';
import 'package:h3_14_bookie/domain/model/dto/story_response_dto.dart';
import 'package:h3_14_bookie/domain/model/story.dart';
import 'package:h3_14_bookie/domain/services/app_user_service.dart';
import 'package:h3_14_bookie/domain/services/category_service.dart';
import 'package:h3_14_bookie/domain/services/implement/app_user_service_impl.dart';
import 'package:h3_14_bookie/domain/services/implement/category_service_impl.dart';
import 'package:h3_14_bookie/domain/services/implement/label_service_impl.dart';
import 'package:h3_14_bookie/domain/services/label_service.dart';
import 'package:h3_14_bookie/domain/services/story_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

const String STORY_COLLECTION_REF = "stories";

class StoryServiceImpl implements IStoryService {
  final FirebaseFirestore db = FirebaseFirestore.instance;
  final ICategoryService categoryService = CategoryServiceImpl();
  final ILabelService labelService = LabelServiceImpl();
  final IAppUserService appUserService = AppUserServiceImpl();
  late final CollectionReference _storyRef;

  StoryServiceImpl() {
    _storyRef = db.collection(STORY_COLLECTION_REF).withConverter<Story>(
        fromFirestore: (snapshots, _) => Story.fromFirestore(snapshots, _),
        toFirestore: (story, _) => story.toFirestore());
  }

  @override
  Future<List<Story>> getStories() async {
    final docs = await _storyRef.get();
    return docs.docs.map((doc) => doc.data() as Story).toList();
  }

  @override
  Future<List<Story>> getStoriesWithFilter(
      String filter, CategoryDto? category) async {
    var stories = await getStories();
    if (category != null) {
      stories = stories
          .where(
              (story) => story.categories.any((c) => c.name == category.name))
          .toList();
    }

    return stories.where((story) {
      final containsInTitle =
          story.title?.toLowerCase().contains(filter.toLowerCase()) ?? false;
      final containsInLabels = story.labels?.any(
              (label) => label.toLowerCase().contains(filter.toLowerCase())) ??
          false;
      return containsInTitle || containsInLabels;
    }).toList();
  }

  @override
  Future<List<StoryResponseDto>> getStoriesResponseByStoryUid(
      List<String> storiesUid) async {
    final storiesResponseDtos =
        await Future.wait(storiesUid.map((storyUid) async {
      final story = await getStoryById(storyUid);
      if (story == null) {
        throw Exception('Story not found');
      }
      return convertToStoryResponseDto(storyUid, story);
    }).toList());
    return storiesResponseDtos;
  }

  Future<StoryResponseDto> convertToStoryResponseDto(
      String storyUid, Story story) async {
    List<String> categoriesUid = await Future.wait(story.categories.map(
        (category) =>
            categoryService.getCategoryUidByName(category.name ?? '')));

    StoryResponseDto storyResponseDto = StoryResponseDto(
        storyUid,
        story.title ?? '',
        (await appUserService.getAppUserById(story.authorUid ?? ''))?.name ??
            '',
        story.cover ?? '',
        story.synopsis ?? '',
        story.labels?.whereType<String>().toList() ?? [],
        categoriesUid,
        story.rate ?? 0,
        story.readings ?? 0,
        story.storyTimeInMin ?? 0,
        story.chaptersUid?.toList() ?? []);
    return storyResponseDto;
  }

  @override
  Future<String> createStory(StoryDto storyDto) async {
    final List<Category> categories = await Future.wait(storyDto.categoriesUid
        .map((uid) => categoryService.getCategoryByUid(uid)));

    Story story = Story(
        title: storyDto.title,
        authorUid: FirebaseAuth.instance.currentUser?.uid,
        cover: storyDto.cover,
        synopsis: storyDto.synopsis,
        categories: categories,
        labels: storyDto.labels,
        rate: 0,
        readings: 0);
    await _storyRef.add(story);

    final docRef = await _storyRef.add(story);
    final docSnap = await docRef.get();
    await appUserService.addNewWriting(story.authorUid!, docSnap.id, true);

    return docSnap.id;
  }

  @override
  Future<Story?> getStoryById(String storyUid) async {
    final docSnap = await _storyRef.doc(storyUid).get();
    if (!docSnap.exists) {
      throw Exception('Story not found');
    }
    return (docSnap as DocumentSnapshot<Story>).data();
  }

  /// Add a chapter to the story
  /// Return true if success
  /// Return false if failed
  @override
  Future<bool> addChapterToStory(String storyUid, String chapterUid) async {
    Story? story = await getStoryById(storyUid);
    if (story == null) {
      return false;
    }

    story.chaptersUid?.add(chapterUid);
    await _storyRef.doc(storyUid).update(story.toFirestore());
    return true;
  }

  @override
  Future<bool> deleteAllChaptersInStory(String storyUid) async {
    Story? story = await getStoryById(storyUid);
    if (story == null) {
      return false;
    }
    story.chaptersUid?.clear();
    await _storyRef.doc(storyUid).update(story.toFirestore());
    return true;
  }
}
