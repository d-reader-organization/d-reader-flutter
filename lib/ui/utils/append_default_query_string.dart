String appendDefaultQuery(String? query) => query != null && query.isNotEmpty
    ? 'skip=0&take=20&$query'
    : 'skip=0&take=20';
