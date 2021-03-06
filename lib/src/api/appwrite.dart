import 'package:appwrite/appwrite.dart';
import 'package:flutter_appwrite/src/utils/config.dart';

Account initAppWrite() {
  Client client = Client();
  Account account = Account(client);

  client.setEndpoint(appWriteApiUrl).setProject(appwriteProjectId);

  return account;
}
