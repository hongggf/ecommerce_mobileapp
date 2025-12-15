import 'dart:io';
import 'package:flutter/material.dart';

class ProfileTileWidget extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? avatarPath;
  final Widget? trailing;
  final VoidCallback? onTap;

  const ProfileTileWidget({
    super.key,
    required this.title,
    this.subtitle,
    this.avatarPath,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.primary,
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              _buildAvatar(),
              const SizedBox(width: 14),
              _buildText(context),
              if (trailing != null) ...[
                const SizedBox(width: 8),
                trailing!,
              ],
            ],
          ),
        ),
      ),
    );
  }

  // ---------------- AVATAR ----------------

  Widget _buildAvatar() {
    return CircleAvatar(
      radius: 24,
      backgroundColor: const Color(0xFFB0BEC5),
      child: ClipOval(
        child: _buildImage(),
      ),
    );
  }

  Widget _buildImage() {
    if (avatarPath == null || avatarPath!.isEmpty) {
      return _fallbackIcon();
    }

    print(avatarPath);

    // Check if it is network URL
    if (avatarPath!.startsWith('http://') || avatarPath!.startsWith('https://')) {
      return Image.network(
        avatarPath!,
        width: 48,
        height: 48,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _fallbackIcon(),
      );
    }

    // Check if file exists
    final file = File(avatarPath!);
    if (file.existsSync()) {
      return Image.file(
        file,
        width: 48,
        height: 48,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _fallbackIcon(),
      );
    }

    // Otherwise, try asset image
    return Image.asset(
      avatarPath!,
      width: 48,
      height: 48,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => _fallbackIcon(),
    );
  }

  Widget _fallbackIcon() {
    return const Icon(
      Icons.person,
      size: 24,
      color: Colors.white,
    );
  }

  // ---------------- TEXT ----------------

  Widget _buildText(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.white
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          if (subtitle != null) ...[
            Text(
              subtitle!,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.white
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }
}