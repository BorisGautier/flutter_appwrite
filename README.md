# flutter_appwrite

A new Flutter project.

Before starting you must have a server with [AppWrite](https://appwrite.io/) installed on it

## Installation of the Flutter application

```sh
$ git clone https://github.com/BorisGautier/flutter_appwrite.git
$ cd flutter_appwrite
$ flutter pub get
```

- Create the config.dart file in /lib/src/utils/ and insert this content by replacing the values with the parameters of your appWrite server.

```sh
const appWriteApiUrl = "https://localhost/v1";
const appwriteProjectId = "PROJECTID";
```

- Modify the AndroidManifest.xml file (/android/app/src/main/AndroidManifest.xml) by replacing PROJECTID with the id of your AppWrite project

- Generate the apk

```sh
$ flutter build apk
```
