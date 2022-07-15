  // Token for solange
  // String token = "loading";

  // void printWrapped(String text) {
  //   final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
  //   pattern.allMatches(text).forEach((match) => print(match.group(0)));
  // }

  // void getToken() async {
  //   printWrapped('getting token');
  //   FirebaseAuth.instance.currentUser?.getIdToken(true).then((token) {
  //     printWrapped(token);
  //     setState(() {
  //       token = token;
  //     });
  //   });
  // }