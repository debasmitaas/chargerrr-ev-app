import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/app_constants.dart';
import '../../routes/app_routes.dart';
import '../../services/supabase_service.dart';

class SidebarController extends GetxController {
  void logout() async {
    await SupabaseService.instance.signOut();
    Get.offAllNamed(AppRoutes.login);
  }
  
  void closeDrawer() {
    Get.back();
  }
}

class CustomSidebarDrawer extends StatelessWidget {
  const CustomSidebarDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SidebarController>(
      init: SidebarController(),
      builder: (controller) => Drawer(
        child: Column(
          children: [
            _buildHeader(context, controller),
            Expanded(child: _buildMenuItems(controller)),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, SidebarController controller) {
    final user = SupabaseService.instance.getCurrentAppUser();
    
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        16,
        MediaQuery.of(context).padding.top + 16, // Dynamic top padding
        16,
        16,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppConstants.primaryGreen, AppConstants.accentGreen],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min, // FIXED: Use minimum space needed
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Flexible( // FIXED: Make text flexible
                child: Text(
                  'Chargerrr',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              IconButton(
                onPressed: controller.closeDrawer,
                icon: const Icon(Icons.close, color: Colors.white),
                constraints: const BoxConstraints(), // FIXED: Remove default constraints
                padding: const EdgeInsets.all(8),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const CircleAvatar(
            radius: 25, // FIXED: Smaller avatar
            backgroundColor: Colors.white24,
            child: Icon(Icons.person, color: Colors.white, size: 25),
          ),
          const SizedBox(height: 8),
          Flexible( // FIXED: Make name flexible
            child: Text(
              user?.name ?? 'Guest User',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16, // FIXED: Smaller font
                fontWeight: FontWeight.w600,
              ),
              maxLines: 2, // FIXED: Allow 2 lines for long names
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 4),
          Flexible( // FIXED: Make email flexible
            child: Text(
              user?.email ?? 'guest@chargerrr.com',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 12, // FIXED: Smaller font
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItems(SidebarController controller) {
    // final user = SupabaseService.instance.getCurrentAppUser();
    // final favoriteCount = user?.favoriteStations?.length ?? 0;
    
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        _buildMenuItem(
          icon: Icons.logout,
          title: 'Logout',
          iconColor: AppConstants.errorRed,
          textColor: AppConstants.errorRed,
          onTap: controller.logout,
        ),
      ],
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
    Color? iconColor,
    Color? textColor,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4), // FIXED: Better padding
      leading: Icon(
        icon,
        color: iconColor ?? AppConstants.primaryGreen,
        size: 22, // FIXED: Consistent icon size
      ),
      title: Text(
        title,
        style: TextStyle(
          color: textColor ?? Colors.black87,
          fontWeight: FontWeight.w600,
          fontSize: 14, // FIXED: Consistent font size
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: subtitle != null 
          ? Text(
              subtitle,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ) 
          : null,
      onTap: onTap,
    );
  }
}