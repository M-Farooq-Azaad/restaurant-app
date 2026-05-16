import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/theme/app_theme_extension.dart';
import 'transfer_flow_screen.dart';

class AppContact {
  final String name;
  final String phone;
  final String? username;
  final bool isOnApp;
  final String? tier;
  final Color avatarColor;

  const AppContact({
    required this.name,
    required this.phone,
    this.username,
    required this.isOnApp,
    this.tier,
    required this.avatarColor,
  });

  String get initials {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return name[0].toUpperCase();
  }

  bool matchesQuery(String q) {
    final lower = q.toLowerCase();
    return name.toLowerCase().contains(lower) ||
        (username?.toLowerCase().contains(lower) ?? false) ||
        phone.contains(lower);
  }
}

enum _PermissionState { notAsked, requesting, granted }

class SendPointsScreen extends StatefulWidget {
  const SendPointsScreen({super.key});

  @override
  State<SendPointsScreen> createState() => _SendPointsScreenState();
}

class _SendPointsScreenState extends State<SendPointsScreen> {
  _PermissionState _permState = _PermissionState.notAsked;
  final _searchCtrl = TextEditingController();
  String _query = '';

  static const _contacts = [
    AppContact(
      name: 'Sarah Kim',
      phone: '+1-555-0101',
      username: 'sarahkim',
      isOnApp: true,
      tier: 'Gold',
      avatarColor: Color(0xFFEC4899),
    ),
    AppContact(
      name: 'Alex Chen',
      phone: '+1-555-0102',
      username: 'alexchen_dev',
      isOnApp: true,
      tier: 'Silver',
      avatarColor: Color(0xFF3B82F6),
    ),
    AppContact(
      name: 'Marco Rossi',
      phone: '+1-555-0103',
      username: 'marco.r',
      isOnApp: true,
      tier: 'Platinum',
      avatarColor: Color(0xFF8B5CF6),
    ),
    AppContact(
      name: 'Tom Wright',
      phone: '+1-555-0105',
      username: 'tomwright',
      isOnApp: true,
      tier: 'Bronze',
      avatarColor: Color(0xFF10B981),
    ),
    AppContact(
      name: 'James Liu',
      phone: '+1-555-0107',
      username: 'jamesliu99',
      isOnApp: true,
      tier: 'Silver',
      avatarColor: Color(0xFFF59E0B),
    ),
    AppContact(
      name: 'Emma Wilson',
      phone: '+1-555-0104',
      isOnApp: false,
      avatarColor: Color(0xFF6B7280),
    ),
    AppContact(
      name: 'Priya Patel',
      phone: '+1-555-0106',
      isOnApp: false,
      avatarColor: Color(0xFF6B7280),
    ),
    AppContact(
      name: 'Nina Torres',
      phone: '+1-555-0108',
      isOnApp: false,
      avatarColor: Color(0xFF6B7280),
    ),
  ];

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _requestPermission() async {
    HapticFeedback.mediumImpact();
    setState(() => _permState = _PermissionState.requesting);
    await Future.delayed(const Duration(milliseconds: 1200));
    if (!mounted) return;
    setState(() => _permState = _PermissionState.granted);
  }

  List<AppContact> get _filtered {
    final q = _query.trim();
    if (q.isEmpty) return _contacts;
    return _contacts.where((c) => c.matchesQuery(q)).toList();
  }

  List<AppContact> get _onApp => _filtered.where((c) => c.isOnApp).toList();
  List<AppContact> get _notOnApp => _filtered.where((c) => !c.isOnApp).toList();

  void _selectContact(AppContact contact) {
    HapticFeedback.selectionClick();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => TransferFlowScreen(
          contact: contact,
          onComplete: () => Navigator.of(context).pop(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Scaffold(
      backgroundColor: colors.bgPrimary,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            toolbarHeight: 64,
            backgroundColor: const Color(0xFF1C1400),
            surfaceTintColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
            title: Text(
              'Send Points',
              style: AppTextStyles.cardTitle.copyWith(color: Colors.white),
            ),
            centerTitle: true,
          ),
          if (_permState == _PermissionState.granted)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(Sp.base),
                child: _ContactList(
                  key: const ValueKey('list'),
                  searchCtrl: _searchCtrl,
                  onSearch: (q) => setState(() => _query = q),
                  onApp: _onApp,
                  notOnApp: _notOnApp,
                  onSelect: _selectContact,
                ),
              ),
            )
          else
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: const EdgeInsets.all(Sp.base),
                child: Center(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 320),
                    switchInCurve: Curves.easeOut,
                    transitionBuilder: (child, anim) => FadeTransition(
                      opacity: anim,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0, 0.05),
                          end: Offset.zero,
                        ).animate(anim),
                        child: child,
                      ),
                    ),
                    child: switch (_permState) {
                      _PermissionState.notAsked => _PermissionCard(
                          key: const ValueKey('perm'),
                          onRequest: _requestPermission,
                        ),
                      _PermissionState.requesting => const _LoadingContacts(
                          key: ValueKey('loading'),
                        ),
                      _ => const SizedBox.shrink(),
                    },
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ── Permission card ───────────────────────────────────────────────────────────

class _PermissionCard extends StatelessWidget {
  final VoidCallback onRequest;

  const _PermissionCard({super.key, required this.onRequest});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(Sp.xl),
          decoration: BoxDecoration(
            color: colors.bgSecondary,
            borderRadius: BorderRadius.circular(Rd.xxl),
            border: Border.all(color: colors.divider),
          ),
          child: Column(
            children: [
              Container(
                width: 76,
                height: 76,
                decoration: BoxDecoration(
                  color: AppColors.accentSoft,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.accent.withValues(alpha: 0.25),
                  ),
                ),
                child: const Icon(
                  Icons.contacts_rounded,
                  color: AppColors.accentDeep,
                  size: 36,
                ),
              ),
              const SizedBox(height: Sp.lg),
              Text(
                'Find Your Friends',
                style: AppTextStyles.cardTitle.copyWith(
                  color: colors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: Sp.sm),
              Text(
                'Allow access to your contacts so we can show you which friends are already on the app.',
                style: AppTextStyles.bodySm.copyWith(
                  color: colors.textTertiary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: Sp.xl),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: onRequest,
                  icon: const Icon(Icons.contacts_rounded, size: 18),
                  label: const Text('Allow Contacts Access'),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: Sp.md),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(Rd.xl),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: Sp.md),
        Text(
          'Your contacts are never stored on our servers.',
          style: AppTextStyles.labelSm.copyWith(
            color: colors.textTertiary,
            fontSize: 11,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _LoadingContacts extends StatelessWidget {
  const _LoadingContacts({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const CircularProgressIndicator(
            color: AppColors.accent, strokeWidth: 2.5),
        const SizedBox(height: Sp.lg),
        Text(
          'Checking your contacts...',
          style: AppTextStyles.bodySm.copyWith(color: colors.textTertiary),
        ),
      ],
    );
  }
}

// ── Contact list ──────────────────────────────────────────────────────────────

class _ContactList extends StatelessWidget {
  final TextEditingController searchCtrl;
  final ValueChanged<String> onSearch;
  final List<AppContact> onApp;
  final List<AppContact> notOnApp;
  final ValueChanged<AppContact> onSelect;

  const _ContactList({
    super.key,
    required this.searchCtrl,
    required this.onSearch,
    required this.onApp,
    required this.notOnApp,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Search bar
        Container(
          height: 48,
          decoration: BoxDecoration(
            color: colors.bgSecondary,
            borderRadius: BorderRadius.circular(Rd.xl),
            border: Border.all(color: colors.divider),
          ),
          child: TextField(
            controller: searchCtrl,
            onChanged: onSearch,
            style: AppTextStyles.bodyMd.copyWith(color: colors.textPrimary),
            decoration: InputDecoration(
              hintText: 'Search by name, @username or phone',
              hintStyle: AppTextStyles.bodySm.copyWith(
                color: colors.textTertiary,
              ),
              prefixIcon: Icon(
                Icons.search_rounded,
                color: colors.textTertiary,
                size: 20,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
        ),
        const SizedBox(height: Sp.xl),
        if (onApp.isNotEmpty) ...[
          _SectionLabel(label: 'ON THIS APP — ${onApp.length} found'),
          const SizedBox(height: Sp.sm),
          _ContactGroup(contacts: onApp, onSelect: onSelect, selectable: true),
          const SizedBox(height: Sp.xl),
        ],
        if (notOnApp.isNotEmpty) ...[
          const _SectionLabel(label: 'NOT ON APP YET'),
          const SizedBox(height: Sp.sm),
          _ContactGroup(
            contacts: notOnApp,
            onSelect: onSelect,
            selectable: false,
          ),
        ],
        if (onApp.isEmpty && notOnApp.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: Sp.xxxl),
            child: Center(
              child: Text(
                'No contacts match "${searchCtrl.text}"',
                style: AppTextStyles.bodySm.copyWith(
                  color: colors.textTertiary,
                ),
              ),
            ),
          ),
        SizedBox(height: MediaQuery.of(context).padding.bottom + Sp.xl),
      ],
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;

  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: AppTextStyles.labelSm.copyWith(
        color: context.colors.textTertiary,
        fontSize: 10,
        letterSpacing: 0.8,
      ),
    );
  }
}

class _ContactGroup extends StatelessWidget {
  final List<AppContact> contacts;
  final ValueChanged<AppContact> onSelect;
  final bool selectable;

  const _ContactGroup({
    required this.contacts,
    required this.onSelect,
    required this.selectable,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      decoration: BoxDecoration(
        color: colors.bgSecondary,
        borderRadius: BorderRadius.circular(Rd.xl),
        border: Border.all(color: colors.divider),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: contacts.asMap().entries.map((e) {
          final isLast = e.key == contacts.length - 1;
          return _ContactTile(
            contact: e.value,
            isLast: isLast,
            selectable: selectable,
            onTap: selectable ? () => onSelect(e.value) : null,
          );
        }).toList(),
      ),
    );
  }
}

class _ContactTile extends StatelessWidget {
  final AppContact contact;
  final bool isLast;
  final bool selectable;
  final VoidCallback? onTap;

  const _ContactTile({
    required this.contact,
    required this.isLast,
    required this.selectable,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.vertical(
            top: const Radius.circular(0),
            bottom: isLast ? const Radius.circular(Rd.xl) : Radius.zero,
          ),
          child: Opacity(
            opacity: selectable ? 1.0 : 0.45,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: Sp.base,
                vertical: Sp.md,
              ),
              child: Row(
                children: [
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      color: contact.avatarColor.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: contact.avatarColor.withValues(alpha: 0.30),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        contact.initials,
                        style: AppTextStyles.labelMd.copyWith(
                          color: contact.avatarColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: Sp.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                contact.name,
                                style: AppTextStyles.bodyLg.copyWith(
                                  color: colors.textPrimary,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (contact.tier != null) ...[
                              const SizedBox(width: Sp.xs),
                              _TierChip(tier: contact.tier!),
                            ],
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          contact.username != null
                              ? '@${contact.username}'
                              : contact.phone,
                          style: AppTextStyles.bodySm.copyWith(
                            color: colors.textTertiary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (selectable)
                    Icon(
                      Icons.chevron_right_rounded,
                      color: colors.textTertiary,
                      size: 20,
                    )
                  else
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: Sp.sm,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: colors.bgTertiary,
                        borderRadius: BorderRadius.circular(Rd.pill),
                        border: Border.all(color: colors.divider),
                      ),
                      child: Text(
                        'Invite',
                        style: AppTextStyles.labelSm.copyWith(
                          color: colors.textTertiary,
                          fontSize: 10,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
        if (!isLast)
          Padding(
            padding: const EdgeInsets.only(
              left: Sp.base + 46 + Sp.md,
            ),
            child: Divider(height: 1, color: colors.divider),
          ),
      ],
    );
  }
}

class _TierChip extends StatelessWidget {
  final String tier;

  const _TierChip({required this.tier});

  Color get _color => switch (tier) {
        'Platinum' => const Color(0xFF818CF8),
        'Gold' => AppColors.accent,
        'Silver' => const Color(0xFF9CA3AF),
        _ => const Color(0xFFA16207),
      };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
      decoration: BoxDecoration(
        color: _color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(Rd.pill),
        border: Border.all(color: _color.withValues(alpha: 0.30)),
      ),
      child: Text(
        tier,
        style: AppTextStyles.labelSm.copyWith(color: _color, fontSize: 9),
      ),
    );
  }
}
