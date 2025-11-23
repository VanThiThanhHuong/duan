import 'package:flutter/material.dart';
import '../../models/flashcard_set.dart';
import '../../models/vocabulary.dart';
import 'flashcard_set_detail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FlashcardPage extends StatefulWidget {
  const FlashcardPage({super.key});

  @override
  State<FlashcardPage> createState() => _FlashcardPageState();
}

class _FlashcardPageState extends State<FlashcardPage>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        onPressed: () => showAddFlashcardSheet(context),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Column(
        children: [
          // TAB BAR
          Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              labelColor: const Color(0xFFFF8F00),
              unselectedLabelColor: const Color(0xFFB0BEC5),
              indicatorColor: const Color(0xFFFF8F00),
              labelStyle: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
              unselectedLabelStyle: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
              tabs: const [
                Tab(text: "Cộng đồng"),
                Tab(text: "Cá nhân"),
              ],
            ),
          ),

          // TAB CONTENT
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Cộng đồng (Firestore)
                _buildCommunityFlashcards(),

                // Cá nhân (Firestore)
                _buildPersonalFlashcards(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ================== TAB CỘNG ĐỒNG ==================
  Widget _buildCommunityFlashcards() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('flashcard_sets')
          .where('isCommunity', isEqualTo: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text("Chưa có bộ cộng đồng nào"));
        }

        final communitySets = snapshot.data!.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return FlashcardSet(
            id: doc.id,
            title: data['title'] ?? '',
            description: data['description'] ?? '',
            vocabList: (data['vocabList'] as List<dynamic>? ?? [])
                .map((v) => Vocabulary(
                      word: v['word'] ?? '',
                      romaji: v['romaji'] ?? '',
                      meaning: v['meaning'] ?? '',
                    ))
                .toList(),
            participants: data['participants'] ?? 1,
          );
        }).toList();

        return _buildFlashcardList(communitySets);
      },
    );
  }

  // ================== TAB CÁ NHÂN ==================
  Widget _buildPersonalFlashcards() {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('flashcards')
          .doc(userId)
          .collection('userFlashcards')
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text("Chưa có bộ flashcard nào"));
        }

        final userSets = snapshot.data!.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return FlashcardSet(
            id: doc.id,
            title: data['title'] ?? 'Không có tiêu đề',
            description: data['description'] ?? '',
            vocabList: (data['vocabList'] as List<dynamic>? ?? [])
                .map(
                  (v) => Vocabulary(
                    word: v['word'] ?? '',
                    romaji: v['romaji'] ?? '',
                    meaning: v['meaning'] ?? '',
                  ),
                )
                .toList(),
            participants: data['participants'] ?? 1,
          );
        }).toList();

        return _buildFlashcardList(userSets);
      },
    );
  }

  // ================== HIỂN THỊ LIST ==================
  Widget _buildFlashcardList(List<FlashcardSet> sets) {
    if (sets.isEmpty) {
      return const Center(child: Text("Không có dữ liệu"));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: sets.length,
      itemBuilder: (context, index) {
        final set = sets[index];

        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.orange.shade200.withOpacity(0.4),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => FlashcardSetDetailPage(
                    set: set,
                    isPersonal: _tabController.index == 1,
                  ),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Icon
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade100,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.menu_book_rounded,
                      color: Colors.orange,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),

                  // Text
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          set.title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          set.description,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 8),

                        Row(
                          children: [
                            Icon(
                              Icons.list_alt,
                              size: 18,
                              color: Colors.orange.shade700,
                            ),
                            const SizedBox(width: 6),
                            Text("${set.vocabList.length} từ"),

                            const SizedBox(width: 16),

                            Icon(
                              Icons.group,
                              size: 18,
                              color: Colors.blue.shade600,
                            ),
                            const SizedBox(width: 6),
                            Text("${set.participants} người"),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 18,
                    color: Colors.orange,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // ================== TẠO FLASHCARD ==================
  void showAddFlashcardSheet(BuildContext context) {
    String title = '';
    String description = '';
    bool loading = false;

    final userId = FirebaseAuth.instance.currentUser?.uid ?? "anonymous";

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 20,
                right: 20,
                top: 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 50,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  const SizedBox(height: 12),

                  const Text(
                    "Tạo Flashcard mới",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Tiêu đề
                  TextField(
                    decoration: InputDecoration(
                      labelText: "Tiêu đề",
                      labelStyle: const TextStyle(fontWeight: FontWeight.w600),
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(
                          color: Colors.orange.shade200,
                          width: 2,
                        ),
                      ),
                    ),
                    onChanged: (value) => title = value,
                  ),

                  const SizedBox(height: 12),

                  // Mô tả
                  TextField(
                    decoration: InputDecoration(
                      labelText: "Mô tả",
                      labelStyle: const TextStyle(fontWeight: FontWeight.w600),
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(
                          color: Colors.orange.shade200,
                          width: 2,
                        ),
                      ),
                    ),
                    onChanged: (value) => description = value,
                  ),

                  const SizedBox(height: 20),

                  // LƯU
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: loading
                          ? null
                          : () async {
                              if (title.trim().isEmpty) return;

                              setState(() => loading = true);

                              try {
                                final ref = FirebaseFirestore.instance
                                    .collection('flashcards')
                                    .doc(userId)
                                    .collection('userFlashcards')
                                    .doc();

                                await ref.set({
                                  "title": title.trim(),
                                  "description": description.trim(),
                                  "vocabList": [],
                                  "participants": 1,
                                  "createdAt": FieldValue.serverTimestamp(),
                                });

                                Navigator.pop(context);

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: const Text(
                                      "Tạo flashcard thành công!",
                                      style: TextStyle(color: Colors.orange),
                                    ),
                                    backgroundColor: Colors.orange.shade100,
                                    behavior: SnackBarBehavior.floating,
                                    margin: const EdgeInsets.all(16),
                                  ),
                                );
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Lỗi: $e")),
                                );
                              } finally {
                                setState(() => loading = false);
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: loading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              "LƯU",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
