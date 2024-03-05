// import'package:d_reader_flutter/features/comic_issue/domain/models/comic_issue.dart';
// import 'package:d_reader_flutter/core/models/owned_comic_issue.dart';
// import 'package:d_reader_flutter/core/models/page_model.dart';
// import 'package:d_reader_flutter/core/repositories/comic_issues/comic_issue_repository.dart';
// import 'package:dio/dio.dart';

// class ComicIssueRepositoryImpl implements ComicIssueRepository {
//   final Dio client;

//   ComicIssueRepositoryImpl({
//     required this.client,
//   });

//   @override
//   Future<List<ComicIssueModel>> getComicIssues({String? queryString}) async {
//     final response = await client
//         .get<List<dynamic>?>('/comic-issue/get?$queryString')
//         .then((value) => value.data);

//     return response != null
//         ? List<ComicIssueModel>.from(
//             response.map(
//               (item) => ComicIssueModel.fromJson(
//                 item,
//               ),
//             ),
//           )
//         : [];
//   }

//   @override
//   Future<ComicIssueModel?> getComicIssue(int id) async {
//     final response =
//         await client.get('/comic-issue/get/$id').then((value) => value.data);

//     return response != null ? ComicIssueModel.fromJson(response) : null;
//   }

//   @override
//   Future<List<PageModel>> getComicIssuePages(int id) async {
//     final response = await client
//         .get('/comic-issue/get/$id/pages')
//         .then((value) => value.data);

//     return response != null
//         ? List<PageModel>.from(
//             response.map(
//               (item) => PageModel.fromJson(
//                 item,
//               ),
//             ),
//           )
//         : [];
//   }

//   @override
//   Future<void> favouritiseIssue(int id) {
//     return client
//         .patch('/comic-issue/favouritise/$id')
//         .then((value) => value.data);
//   }

//   @override
//   Future<dynamic> rateIssue({
//     required int id,
//     required int rating,
//   }) async {
//     await client
//         .patch(
//           '/comic-issue/rate/$id',
//           data: {
//             'rating': rating,
//           },
//         )
//         .then((value) => value.data)
//         .onError((error, stackTrace) {
//           return error.toString();
//         });
//   }

//   @override
//   Future<List<OwnedComicIssue>> getOwnedIssues(
//       {required int id, required String query}) async {
//     final response = await client
//         .get('/comic-issue/get/by-owner/$id?$query')
//         .then((value) => value.data);

//     return response != null
//         ? List<OwnedComicIssue>.from(
//             response.map(
//               (item) => OwnedComicIssue.fromJson(
//                 item,
//               ),
//             ),
//           )
//         : [];
//   }
// }
