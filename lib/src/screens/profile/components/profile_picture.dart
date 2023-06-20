import 'package:flutter/material.dart';

showProfilePicture({
  required onTap,
  required localPictureUrl,
  required networkPictureUrl,
}) {

  return GestureDetector(
    onTap: onTap,
    child: CircleAvatar(
      radius: 50,
      backgroundColor: Colors.green,
      backgroundImage: localPictureUrl != null
          ? FileImage(localPictureUrl)
          : (networkPictureUrl != null ? NetworkImage(networkPictureUrl) as ImageProvider : null),    
      child: ((localPictureUrl==null) && (networkPictureUrl==null)) ? const Icon(Icons.person,size: 50,) : null,  
    ),
  );
}
