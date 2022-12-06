import 'package:flutter/cupertino.dart';
import 'package:mynote/views/utilities/generic_dialog.dart';

Future<bool> showDeleteDialog(BuildContext context) {
  return showGenericDialog<bool>(
          context: context,
          title: 'Deletion',
          content: 'Are you sure you want to delete?',
          optionsBuilder: () => {'Cancel': false, 'Delete': true})
      .then((value) => value ?? false);
}
