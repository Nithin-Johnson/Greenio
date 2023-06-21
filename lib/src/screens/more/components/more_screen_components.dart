import 'package:flutter/material.dart';
import 'package:greenio/src/models/user/user_model.dart';

class MoreScreenComponents {
  static displayName(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
    );
  }

  static displayProfilePicture(UserModel user) {
    return CircleAvatar(
      radius: 50,
      backgroundColor: Colors.green,
      backgroundImage: user.picture != null ? NetworkImage(user.picture!) : null,
      child: user.picture == null ? const Icon(Icons.person, size: 50) : null,
    );
  }

  static showButton({required onTap, required IconData prefixIcon, required String title, required Color color}) {
    return InkWell(
      splashColor: Colors.green,
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Colors.green[200]!),
        ),
        elevation: 2,
        color: color,
        child: ListTile(
          leading: Icon(prefixIcon),
          title: Text(title),
          textColor: Colors.white,
          iconColor: Colors.white,
        ),
      ),
    );
  }
}
