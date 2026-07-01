import 'package:app/core/widgets/app_logo_widget.dart';
import 'package:app/shared/widgets/recent_bottomsheet.dart';
import 'package:bounce/bounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/widgets/split_action_button.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  void _showRecentSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const RecentBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        titleSpacing: 16,

        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "MENU INTELLIGENCE",
              style: TextStyle(
                fontSize: 12,
                letterSpacing: 1.8,
                color: Colors.grey.shade500,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "Tablemind",
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Colors.black,
                letterSpacing: 1,
                height: 1.0,
                fontFamily: 'Comfortaa',
              ),
            ),
          ],
        ),
        actions: [AppLogoWidget(width: 35, color: Colors.black)],
        actionsPadding: EdgeInsets.only(right: 15),
      ),

      body: Column(
        children: [
          const Spacer(),

          SplitActionButton(
            mainLabel: "Camera",
            subLabel: "& Upload",
            mainIcon: Icons.camera_alt_outlined,
            rightIcon: Icons.upload_file,
            onMainTap: () {},
            onRightTap: () {},
          ),

          // Button 2: Link (starts white)
          SplitActionButton(
            mainLabel: "Link",
            subLabel: "& Scanner",
            mainIcon: Icons.link,
            rightIcon: Icons.qr_code_scanner,
            onMainTap: () {},
            onRightTap: () {},
          ),

          // Button 3: Search Restaurant
          SplitActionButton(
            mainLabel: "Search Restaurant",
            mainIcon: Icons.search_rounded,
            rightIcon: Icons.arrow_forward_rounded,
            onMainTap: () {},
            onRightTap: () {},
          ),

          const Spacer(),

          // ── Recent bar ─────────────────────────────────────────────────────
          RecentBar(onTap: () => _showRecentSheet(context)),
        ],
      ),
    );
  }
}
