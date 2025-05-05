class FirebaseErrorHandler {
  static String getError(String code){
    return code.replaceAll("-", " ");
  }
}