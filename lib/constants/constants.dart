final RegExp usernameRegex = RegExp(r'^[\w-_]+$');
final RegExp passwordRegex =
    RegExp(r'((?=.*\d)|(?=.*\W+))(?![.\n])(?=.*[A-Z])(?=.*[a-z]).*$');
const String viewModeStoreKey = 'discover_view_mode';
const String issueLastSelectedTabKey = 'issue_last_selected_tab';
const String dFreeLabel = 'dFree';
const String publicGroupLabel = 'public';
const double comicIssueAspectRatio = 690 / 1000;
const double comicAspectRatio = 1000 / 900;
const double creatorBannerAspectratio = 1920 / 900;
const double comicLogoAspectRatio = 800 / 450;

const String walkthroughAssetsPath = 'assets/images/walkthrough';
const String missingWalletAppText = 'Missing wallet application.';
const String powerSaveModeText = 'Cannot use wallet in the power save mode.';
const String successResult = 'OK';
const String usernameCriteriaText =
    'Must be 3 to 20 characters long. Numbers, dashes and underscores are allowed.';
const int splTokenHighestPriority = 1;
const int chainStatusTimeoutInSeconds = 25;
const int paginatedDataCacheInSeconds = 30;

const String localStoreName = 'local_store';
const String eReaderLocalStoreName = 'eReader_store';

const String eReaderListPositionKey = 'eReader_list_position';
const String eReaderPagePositionKey = 'eReader_page_position';
const String eReaderReadingModeKey = 'reading_mode';

const String failedToSignTransactionsMessage = 'Failed to sign transactions';

const String dAuthCouponName = 'dAuth';
const String solAddress = 'So11111111111111111111111111111111111111112';
