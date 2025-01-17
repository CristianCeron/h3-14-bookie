import 'package:h3_14_bookie/domain/model/Location.dart';
import 'package:h3_14_bookie/domain/model/chapter.dart';
import 'package:h3_14_bookie/domain/model/dto/chapter_dto.dart';
import 'package:h3_14_bookie/domain/model/story.dart';
import 'package:h3_14_bookie/domain/services/chapter_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:h3_14_bookie/domain/services/implement/story_service_impl.dart';
import 'package:h3_14_bookie/domain/services/story_service.dart';

const String CHAPTER_COLLECTION_REF = "chapter";

class ChapterServiceImpl implements IChapterService {
  final db = FirebaseFirestore.instance;
  final IStoryService _storyService = StoryServiceImpl();

  late final CollectionReference _chapterRef;

  ChapterServiceImpl() {
    _chapterRef = db.collection(CHAPTER_COLLECTION_REF).withConverter<Chapter>(
        fromFirestore: (snapshots, _) => Chapter.fromFirestore(snapshots, _),
        toFirestore: (chapter, _) => chapter.toFirestore());
  }

  @override
  Future<List<Chapter>> getChapters() async {
    final docs = await _chapterRef.get();
    return docs.docs.map((doc) {
      final chapter = (doc as DocumentSnapshot<Chapter>).data();
      if (chapter == null) throw Exception('Chapter data is null');
      return chapter;
    }).toList();
  }

  @override
  Future<Chapter> getChapterById(String chapterUid) async {
    final doc = await _chapterRef.doc(chapterUid).get();
    return doc.data() as Chapter;
  }

  @override
  Future<List<Chapter>> getChaptersByStoryUid(String storyUid) async {
    List<Chapter> chapters = await getChapters();
    return chapters.where((chapter) => chapter.storyUid == storyUid).toList();
  }

  @override
  Future<ChapterDto> convertToChapterDto(Chapter chapter) async {
    return ChapterDto(
      storyUid: chapter.storyUid,
      title: chapter.title ?? '',
      pages: chapter.pages ?? [],
      placeName: chapter.location?.place ?? '',
      lat: chapter.location?.lat ?? 0.0,
      long: chapter.location?.long ?? 0.0,
    );
  }

  /// Create a chapter and add it to the story
  /// Return the chapter uid if success
  /// Return error message if failed
  @override
  Future<String> createChapter(ChapterDto chapterDto) async {
    Location location = Location(
      place: chapterDto.placeName,
      lat: chapterDto.lat,
      long: chapterDto.long,
    );
    Chapter chapter = Chapter(
      storyUid: chapterDto.storyUid,
      title: chapterDto.title,
      pages: chapterDto.pages,
      isCompleted: false,
      location: location,
      number: await asignChapterNumber(chapterDto.storyUid),
    );

    final docRef = await _chapterRef.add(chapter);
    final docSnap = await docRef.get() as DocumentSnapshot<Chapter>;

    bool success =
        await _storyService.addChapterToStory(chapterDto.storyUid, docSnap.id);

    if (!success) {
      return 'Failed to add chapter to story';
    }

    return docSnap.id;
  }

  Future<int> asignChapterNumber(String storyUid) async {
    Story? story = await _storyService.getStoryById(storyUid);
    if (story == null) {
      return 0;
    }
    if (story.chaptersUid == null) {
      return 1;
    }
    return story.chaptersUid!.length + 1;
  }

  @override
  Future<bool> deleteChaptersByStoryUid(String storyUid) async {
    QuerySnapshot querySnapshot =
        await _chapterRef.where('storyUid', isEqualTo: storyUid).get();
    for (QueryDocumentSnapshot doc in querySnapshot.docs) {
      await _chapterRef.doc(doc.id).delete();
    }
    return true;
  }
}
