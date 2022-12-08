import 'package:flutter/cupertino.dart';

@immutable
class CloudStorageException implements Exception{
  const CloudStorageException();
}

//C
class CouldNotCreateNoteException extends CloudStorageException{}
//R
class CouldNotGetAllNoteException extends CloudStorageException{}
//U
class CouldNotUpdateNoteException extends CloudStorageException{}
//D
class CouldNotDeleteNoteException extends CloudStorageException{}
