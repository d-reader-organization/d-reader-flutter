final RegExp usernameRegex = RegExp(r'^[\w-]+$');
final RegExp passwordRegex =
    RegExp(r'((?=.*\d)|(?=.*\W+))(?![.\n])(?=.*[A-Z])(?=.*[a-z]).*$');
const String viewModeStoreKey = 'discover_view_mode';
