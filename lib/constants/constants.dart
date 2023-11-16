final RegExp usernameRegex = RegExp(r'^[\w-]+$');
final RegExp passwordRegex =
    RegExp(r'((?=.*\d)|(?=.*\W+))(?![.\n])(?=.*[A-Z])(?=.*[a-z]).*$');
const String viewModeStoreKey = 'discover_view_mode';
const String issueLastSelectedTabKey = 'issue_last_selected_tab';
const String dFreeLabel = 'dFree';
const double comicIssueAspectRatio = 690 / 1000;
const double comicAspectRatio = 1000 / 900;
const double creatorBannerAspectratio = 1920 / 900;

const String walkthroughAssetsPath = 'assets/images/walkthrough';
const String missingWalletAppText = 'Missing wallet application.';
const String powerSaveModeText = 'Cannot use wallet in the power save mode.';
