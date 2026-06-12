import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../controllers/appointment_controller.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/styles.dart';
import 'chat_screen.dart';

// ---------------------------------------------------------------------------
// ChatListScreen
// ---------------------------------------------------------------------------

/// Reusable chat-list screen that works for both the patient and the therapist.
/// Pass [isTherapist] to control whose perspective is shown.
///
/// Architecture:
///  • State lives in [AppointmentController] (GetX, already registered).
///  • Search is handled locally with an [RxString] – no extra controller class.
///  • [FocusNode] is lifecycle-managed by the State so the back button can
///    dismiss the keyboard instead of popping the route when search is active.
///  • Each list item is a standalone [_ChatTile] widget keeping rebuild scope minimal.
class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key, required this.isTherapist});

  final bool isTherapist;

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  final RxString _query = ''.obs;
  final TextEditingController _searchCtrl = TextEditingController();
  final FocusNode _searchFocus = FocusNode();

  @override
  void dispose() {
    _searchCtrl.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  void _dismissKeyboard() => _searchFocus.unfocus();

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<AppointmentController>()) {
      Get.put(AppointmentController());
    }
    final ctrl = Get.find<AppointmentController>();

    return PopScope(
      // When the search field is focused, intercept back to only dismiss keyboard
      canPop: !_searchFocus.hasFocus,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _dismissKeyboard();
      },
      child: Scaffold(
        backgroundColor: AppColors.backgroundLight,
        appBar: _buildAppBar(),
        body: Column(
          children: [
            // ── Search field pinned below the app bar ────────────────────
            _SearchBar(
              controller: _searchCtrl,
              focusNode: _searchFocus,
              query: _query,
              isTherapist: widget.isTherapist,
            ),
            // ── Chat list ─────────────────────────────────────────────────
            Expanded(
              child: Obx(() {
                final sessions = widget.isTherapist
                    ? [
                        ...ctrl.therapistPendingAppointments,
                        ...ctrl.therapistUpcomingAppointments,
                        ...ctrl.therapistActiveSessions,
                        ...ctrl.therapistCompletedAppointments,
                      ]
                    : ctrl.patientAppointments;

                final chats = sessions
                    .where(
                      (s) => s.chatRoomId != null && s.chatRoomId!.isNotEmpty,
                    )
                    .toList();

                final q = _query.value.trim().toLowerCase();
                final filtered = q.isEmpty
                    ? chats
                    : chats.where((s) {
                        final name = widget.isTherapist
                            ? (s.patientName ?? '')
                            : (s.therapistName ?? '');
                        return name.toLowerCase().contains(q);
                      }).toList();

                if (filtered.isEmpty) {
                  return _EmptyState(hasQuery: q.isNotEmpty);
                }

                return ListView.separated(
                  padding: const EdgeInsets.only(top: 8, bottom: 24),
                  itemCount: filtered.length,
                  separatorBuilder: (_, __) => const _ChatDivider(),
                  itemBuilder: (context, i) {
                    final session = filtered[i];
                    final partnerName = widget.isTherapist
                        ? (session.patientName ?? 'Unknown')
                        : (session.therapistName ?? 'Unknown');
                    return _ChatTile(
                      chatRoomId: session.chatRoomId!,
                      partnerName: partnerName,
                      status: session.status,
                      isTherapist: widget.isTherapist,
                      onTap: () => Get.to(
                        () => ChatScreen(
                          sessionId: session.id,
                          isTherapist: widget.isTherapist,
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      title: const Text(
        'Messages',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
          fontSize: 20,
          letterSpacing: 0.3,
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.more_vert_rounded, color: Colors.white),
          onPressed: () {},
          tooltip: 'Options',
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// _SearchBar
// ---------------------------------------------------------------------------

class _SearchBar extends StatelessWidget {
  const _SearchBar({
    required this.controller,
    required this.focusNode,
    required this.query,
    required this.isTherapist,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final RxString query;
  final bool isTherapist;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primary,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        onChanged: (v) => query.value = v,
        style: const TextStyle(color: Colors.white, fontSize: 14),
        cursorColor: Colors.white,
        decoration: InputDecoration(
          hintText: 'Search conversations…',
          hintStyle: TextStyle(
            color: Colors.white.withOpacity(0.65),
            fontSize: 14,
          ),
          prefixIcon: const Icon(
            Icons.search_rounded,
            color: Colors.white70,
            size: 20,
          ),
          suffixIcon: Obx(
            () => query.value.isNotEmpty
                ? GestureDetector(
                    onTap: () {
                      controller.clear();
                      query.value = '';
                    },
                    child: const Icon(
                      Icons.close_rounded,
                      color: Colors.white70,
                      size: 18,
                    ),
                  )
                : const SizedBox.shrink(),
          ),
          filled: true,
          fillColor: Colors.white.withOpacity(0.15),
          contentPadding: const EdgeInsets.symmetric(vertical: 10),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// _ChatTile
// ---------------------------------------------------------------------------

/// Lightweight tile: pulls only the last message from Firestore in real time.
class _ChatTile extends StatelessWidget {
  const _ChatTile({
    required this.chatRoomId,
    required this.partnerName,
    required this.status,
    required this.isTherapist,
    required this.onTap,
  });

  final String chatRoomId;
  final String partnerName;
  final String status;
  final bool isTherapist;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('chats')
          .doc(chatRoomId)
          .collection('messages')
          .orderBy('createdAt', descending: true)
          .limit(1)
          .snapshots(),
      builder: (context, snap) {
        String preview = 'Tap to start chatting';
        String timeLabel = '';
        bool hasUnread = false;

        if (snap.hasData && snap.data!.docs.isNotEmpty) {
          final data = snap.data!.docs.first.data();
          preview = (data['text'] as String?) ?? preview;
          hasUnread = (data['isRead'] as bool?) == false;
          final ts = data['createdAt'] as Timestamp?;
          if (ts != null) {
            final date = ts.toDate();
            final now = DateTime.now();
            if (now.difference(date).inDays == 0) {
              timeLabel = DateFormat('h:mm a').format(date);
            } else if (now.difference(date).inDays == 1) {
              timeLabel = 'Yesterday';
            } else {
              timeLabel = DateFormat('MMM d').format(date);
            }
          }
        }

        return InkWell(
          onTap: onTap,
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                // ── Avatar ────────────────────────────────────────────────
                _GradientAvatar(name: partnerName),
                const SizedBox(width: 14),
                // ── Name + Preview ────────────────────────────────────────
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    partnerName,
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: hasUnread
                                          ? FontWeight.w700
                                          : FontWeight.w600,
                                      color: AppColors.textPrimary,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                if (status.toLowerCase() == 'completed') ...[
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFE8F5E9),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Text(
                                      'Session Ended',
                                      style: TextStyle(
                                        color: AppColors.ended,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ),
                                ] else if (status.toLowerCase() == 'active' ||
                                    status.toLowerCase() == 'started') ...[
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.iconBookSession
                                          .withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Text(
                                      'Ongoing',
                                      style: TextStyle(
                                        color: AppColors.iconBookSession,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            timeLabel,
                            style: TextStyle(
                              fontSize: 11,
                              color: hasUnread
                                  ? (isTherapist
                                      ? AppColors.therapistPrimary
                                      : AppColors.primary)
                                  : AppColors.textSecondary,
                              fontWeight: hasUnread
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              preview,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 13,
                                color: hasUnread
                                    ? AppColors.textPrimary
                                    : AppColors.textSecondary,
                                fontWeight: hasUnread
                                    ? FontWeight.w500
                                    : FontWeight.normal,
                              ),
                            ),
                          ),
                          if (hasUnread)
                            Container(
                              margin: const EdgeInsets.only(left: 8),
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: isTherapist
                                    ? AppColors.therapistPrimary
                                    : AppColors.primary,
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// _GradientAvatar
// ---------------------------------------------------------------------------

/// Circular avatar showing the initials of [name] on a gradient background.
/// Generates a consistent color per person based on the first character.
class _GradientAvatar extends StatelessWidget {
  const _GradientAvatar({required this.name});

  final String name;

  List<Color> _gradientColors() {
    const palettes = [
      [AppColors.primary, AppColors.primaryDark], // Dark Red
      [AppColors.secondary, AppColors.secondaryDark], // Blue Grey
      [AppColors.primaryLight, AppColors.secondary], // Red → Grey
      [Color(0xFFB71C1C), Color(0xFF7F0000)], // Deep Burgundy
      [Color(0xFF455A64), Color(0xFF263238)], // Slate Grey
      [Color(0xFF37474F), Color(0xFF212121)], // Charcoal
      [AppColors.secondaryLight, AppColors.secondary], // Light Grey → Mid Grey
    ];
    if (name.isEmpty) return palettes[0];
    final idx = name.codeUnitAt(0) % palettes.length;
    return palettes[idx];
  }

  String get _initials {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return '?';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final colors = _gradientColors();
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: colors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: colors.first.withOpacity(0.35),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Text(
        _initials,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
          fontSize: 17,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// _ChatDivider
// ---------------------------------------------------------------------------

class _ChatDivider extends StatelessWidget {
  const _ChatDivider();

  @override
  Widget build(BuildContext context) {
    return const Divider(
      height: 1,
      thickness: 0.6,
      indent: 82, // aligned after the avatar
      endIndent: 0,
      color: Color(0xFFEEEEEE),
    );
  }
}

// ---------------------------------------------------------------------------
// _EmptyState
// ---------------------------------------------------------------------------

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.hasQuery});

  final bool hasQuery;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.spacingLarge),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: const BoxDecoration(
                color: AppColors.iconBgChat,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.chat_bubble_outline_rounded,
                size: 36,
                color: AppColors.iconChat,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              hasQuery ? 'No results found' : 'No conversations yet',
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              hasQuery
                  ? 'Try a different name or keyword.'
                  : 'Once a session is booked and confirmed,\nyour chats will appear here.',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyTextSecondary,
            ),
          ],
        ),
      ),
    );
  }
}
