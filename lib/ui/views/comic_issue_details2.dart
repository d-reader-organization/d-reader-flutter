import 'package:cached_network_image/cached_network_image.dart';
import 'package:d_reader_flutter/core/models/collaborator.dart';
import 'package:d_reader_flutter/core/models/stateless_cover.dart';
import 'package:d_reader_flutter/core/providers/comic_issue_provider.dart';
import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/shared/enums.dart';
import 'package:d_reader_flutter/ui/utils/format_date.dart';
import 'package:d_reader_flutter/ui/utils/screen_navigation.dart';
import 'package:d_reader_flutter/ui/views/creators/creator_details.dart';
import 'package:d_reader_flutter/ui/widgets/comic_issues/details/scaffold.dart';
import 'package:d_reader_flutter/ui/widgets/common/cached_image_bg_placeholder.dart';
import 'package:d_reader_flutter/ui/widgets/common/figures/mature_audience.dart';
import 'package:d_reader_flutter/ui/widgets/common/icons/favourite_icon_count.dart';
import 'package:d_reader_flutter/ui/widgets/common/icons/rating_icon.dart';
import 'package:d_reader_flutter/ui/widgets/common/rarity.dart';
import 'package:d_reader_flutter/ui/widgets/creators/avatar.dart';
import 'package:d_reader_flutter/ui/widgets/genre/genre_tags_default.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class ComicIssueDetails2 extends ConsumerStatefulWidget {
  final int id;
  const ComicIssueDetails2({
    super.key,
    required this.id,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ComicIssueDetailsState();
}

class _ComicIssueDetailsState extends ConsumerState<ComicIssueDetails2>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _animation = ColorTween(
      begin: Colors.transparent,
      end: ColorPalette.appBackgroundColor,
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(comicIssueDetailsProvider(widget.id));

    return provider.when(
      data: (issue) {
        if (issue == null) {
          return const SizedBox();
        }
        return DefaultTabController(
          length: 2,
          child: Scaffold(
            backgroundColor: ColorPalette.appBackgroundColor,
            extendBodyBehindAppBar: true,
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: BottomNavigation(
                issue: issue,
              ),
            ),
            body: NestedScrollView(
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return [
                  AnimatedBuilder(
                    animation: _animation,
                    builder: (BuildContext context, Widget? child) {
                      return SliverAppBar(
                        pinned: true,
                        backgroundColor: ColorPalette.appBackgroundColor,
                        title: Text(
                          '${issue.comic?.title}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        actions: [
                          Padding(
                            padding: const EdgeInsets.only(
                              right: 16,
                              top: 4,
                            ),
                            child: SvgPicture.asset('assets/icons/more.svg'),
                          ),
                        ],
                      );
                    },
                  ),
                  SliverToBoxAdapter(
                    child: Stack(
                      children: [
                        CachedImageBgPlaceholder(
                          height: 381,
                          imageUrl: issue.cover,
                          overrideBorderRadius: BorderRadius.circular(0),
                          foregroundDecoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                ColorPalette.appBackgroundColor,
                                const Color(0xff181a20).withOpacity(.8),
                                ColorPalette.appBackgroundColor,
                              ],
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              stops: const [0.0, .6406, 1],
                            ),
                          ),
                        ),
                        Positioned.fill(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const SizedBox(),
                              Container(
                                height: 309,
                                width: 214,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                    8,
                                  ),
                                  image: DecorationImage(
                                    fit: BoxFit.fill,
                                    image: CachedNetworkImageProvider(
                                      issue.cover,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.all(16),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'EPISODE  ',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: ColorPalette.greyscale100,
                                ),
                              ),
                              Text(
                                '${issue.number}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                ' / ${issue.stats?.totalIssuesCount}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: ColorPalette.greyscale100,
                                ),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          Text(
                            issue.title,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              RatingIcon(
                                initialRating: issue.stats?.averageRating ?? 0,
                                isRatedByMe: issue.myStats?.rating != null,
                                issueId: issue.id,
                                isContainerWidget: true,
                              ),
                              FavouriteIconCount(
                                favouritesCount:
                                    issue.stats?.favouritesCount ?? 0,
                                isFavourite:
                                    issue.myStats?.isFavourite ?? false,
                                issueId: issue.id,
                                isContainerWidget: true,
                              ),
                              Row(
                                children: [
                                  Text(
                                    '${issue.stats?.totalPagesCount} ',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const Text(
                                    'pages',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: ColorPalette.greyscale100,
                                    ),
                                  ),
                                ],
                              ),
                              MatureAudience(
                                audienceType: issue.comic?.audienceType ?? '',
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          const Divider(
                            thickness: 1,
                            color: ColorPalette.boxBackground300,
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: GestureDetector(
                                  onTap: () => nextScreenPush(
                                    context,
                                    CreatorDetailsView(
                                      slug: issue.creator.slug,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      CreatorAvatar(
                                        avatar: issue.creator.avatar,
                                        radius: 24,
                                        height: 32,
                                        width: 32,
                                        slug: issue.creator.slug,
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          issue.creator.name,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  formatDateFull(issue.releaseDate),
                                  textAlign: TextAlign.end,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: ColorPalette.greyscale100,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Container(
                      padding: const EdgeInsets.only(
                        bottom: 4,
                        left: 16,
                        right: 16,
                      ),
                      child: Stack(
                        fit: StackFit.passthrough,
                        alignment: Alignment.bottomCenter,
                        children: <Widget>[
                          Container(
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: ColorPalette.boxBackground300,
                                  width: 2.0,
                                ),
                              ),
                            ),
                          ),
                          const TabBar(
                            dividerColor: ColorPalette.dReaderGrey,
                            indicatorWeight: 4,
                            indicatorColor: ColorPalette.dReaderYellow100,
                            labelColor: ColorPalette.dReaderYellow100,
                            unselectedLabelColor: ColorPalette.dReaderGrey,
                            tabs: [
                              Tab(
                                text: 'About',
                              ),
                              Tab(
                                text: 'Listings',
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ];
              },
              body: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 4,
                ),
                child: TabBarView(
                  children: [
                    ListView(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      children: [
                        const Text(
                          'Genres',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        GenreTagsDefault(genres: issue.genres),
                        const SizedBox(
                          height: 16,
                        ),
                        const Text(
                          'About',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Text(
                          issue.description,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        if ((issue.statelessCovers?.length ?? 0) > 1) ...[
                          const SizedBox(
                            height: 8,
                          ),
                          const Divider(
                            thickness: 1,
                            color: ColorPalette.boxBackground300,
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          const Text(
                            'Rarities',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          RaritiesWidget(covers: issue.statelessCovers!),
                        ],
                        if (issue.collaborators != null &&
                            issue.collaborators!.isNotEmpty) ...[
                          const SizedBox(
                            height: 16,
                          ),
                          const Text(
                            'Authors list',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          ...issue.collaborators!.map((author) {
                            return AuthorWidget(author: author);
                          }).toList(),
                        ],
                      ],
                    ),
                    ListView(
                      children: const [
                        Text('Hello'),
                        Text('Hello'),
                        Text('Hello'),
                        Text('Hello'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      error: (err, stack) {
        Sentry.captureException(err, stackTrace: stack);
        return const Text(
          'Something went wrong',
          style: TextStyle(color: Colors.red),
        );
      },
      loading: () => const SizedBox(),
    );
  }
}

class AuthorWidget extends StatelessWidget {
  final Collaborator author;
  const AuthorWidget({
    super.key,
    required this.author,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      '${author.role} - ${author.name}',
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

class RaritiesWidget extends StatelessWidget {
  final List<StatelessCover> covers;
  const RaritiesWidget({
    super.key,
    required this.covers,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 240,
      child: ListView.builder(
        itemCount: covers.length,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Column(
            children: [
              CachedImageBgPlaceholder(
                imageUrl: covers[index].image,
                width: 137,
                height: 197,
              ),
              const SizedBox(
                height: 16,
              ),
              RarityWidget(
                rarity: covers[index].rarity?.rarityEnum ?? NftRarity.none,
                iconPath: 'assets/icons/rarity.svg',
              ),
            ],
          );
        },
      ),
    );
  }
}
