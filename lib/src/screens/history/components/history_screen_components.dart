import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:greenio/src/models/item/item_model.dart';

class HistoryScreenComponents {
  static Center showEmptyHistory() {
    return const Center(
      child: ListTile(
        leading: Icon(Icons.info_outline_rounded),
        subtitle:
            Text("Currently, you haven't posted anything for donation.\nGo to donation and submit your donation."),
      ),
    );
  }

  static ListView showHistoryLists(
      List<QueryDocumentSnapshot<Object?>> items, onImageTapped, showDeleteConfirmationDialog) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (BuildContext context, int index) {
        final item = DonationItemModel.fromMap(items[index].data() as Map<String, dynamic>);
        return _historyListCard(item, onImageTapped, showDeleteConfirmationDialog);
      },
    );
  }

  static Card _historyListCard(DonationItemModel item, onImageTapped, showDeleteConfirmationDialog) {
    return Card(
      color: item.isCollected ? Colors.green[400] : Colors.yellow,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
        child: ListTile(
          leading: GestureDetector(
            onTap: () => onImageTapped(item.imageUrl),
            child: CircleAvatar(
              radius: 25,
              backgroundColor: Colors.green,
              backgroundImage: NetworkImage(item.imageUrl),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
              ),
            ),
          ),
          title: Text(
            'Item Category: ${item.category}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: item.isCollected ? Colors.white : Colors.black,
              fontSize: 20,
            ),
          ),
          subtitle: Text(
            item.isCollected ? 'Item Status: Collected' : 'Item Status: Not collected',
            style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
          ),
          trailing: !item.isCollected
              ? IconButton(
                  onPressed: () => showDeleteConfirmationDialog(item),
                  icon: const Icon(Icons.delete_forever_outlined, color: Colors.red, size: 33),
                )
              : null,
        ),
      ),
    );
  }
}
