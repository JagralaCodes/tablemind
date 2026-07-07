import 'package:app/core/widgets/app_logo_widget.dart';
import 'package:app/shared/widgets/link_menu_bottom_sheet.dart';
import '../domain/home_view_model.dart';
import 'package:app/shared/widgets/recent_bottomsheet.dart';
import 'package:app/app/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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

      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.black12, width: 1),
                ),
              ),
              child: Row(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
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
                      const SizedBox(height: 10),
                      Text(
                        "Tablemind",
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                          letterSpacing: 3,
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                  AppLogoWidget(width: 40, color: Colors.black),
                ],
              ),
            ),

            const Spacer(),

            SplitActionButton(
              mainLabel: "Camera",
              subLabel: "& Upload",
              mainIcon: Icons.camera_alt_outlined,
              rightIcon: Icons.upload_file,
              onMainTap: () {
                ref.read(homeViewModelProvider.notifier).onCameraTap();
              },
              onRightTap: () {
                ref.read(homeViewModelProvider.notifier).onFilePickerTap();
              },
            ),

            // Button 2: Link (starts white)
            SplitActionButton(
              mainLabel: "Link",
              subLabel: "& Scanner",
              mainIcon: Icons.link_rounded,
              rightIcon: Icons.qr_code_scanner,
              onMainTap: () {
                // Open Dialog
                showDialog(
                  context: context,
                  builder: (context) => const LinkMenuBottomSheet(),
                );
              },
              onRightTap: () {
                context.push(AppRoutes.scanner);
              },
            ),

            // Button 3: Search Restaurant
            SplitActionButton(
              mainLabel: "Search Restaurant",
              mainIcon: Icons.search_rounded,
              rightIcon: Icons.arrow_forward_rounded,
              onMainTap: () {
                context.push(AppRoutes.search);
              },
              onRightTap: () {
                context.push(AppRoutes.search);
              },
            ),

            const Spacer(),

            // ── Recent bar ─────────────────────────────────────────────────────
            RecentBar(onTap: () => _showRecentSheet(context)),
          ],
        ),
      ),
    );
  }
}
