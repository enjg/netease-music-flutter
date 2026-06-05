import 'package:get/get.dart';
import '../modules/splash/splash_page.dart';
import '../modules/main/main_page.dart';
import '../modules/main/main_binding.dart';
import '../modules/home/home_page.dart';
import '../modules/home/home_binding.dart';
import '../modules/login/login_page.dart';
import '../modules/login/login_binding.dart';
import '../modules/search/search_page.dart';
import '../modules/search/search_binding.dart';
import '../modules/player/player_page.dart';
import '../modules/player/player_binding.dart';
import '../modules/fm/fm_page.dart';
import '../modules/fm/fm_binding.dart';
import '../modules/playlist/playlist_page.dart';
import '../modules/playlist/playlist_binding.dart';
import '../modules/artist/artist_page.dart';
import '../modules/artist/artist_binding.dart';
import '../modules/album/album_page.dart';
import '../modules/album/album_binding.dart';
import '../modules/charts/charts_page.dart';
import '../modules/charts/charts_binding.dart';
import '../modules/comments/comments_page.dart';
import '../modules/comments/comments_binding.dart';
import '../modules/messages/messages_page.dart';
import '../modules/messages/messages_binding.dart';
import '../modules/yunbei/yunbei_page.dart';
import '../modules/yunbei/yunbei_binding.dart';
import '../modules/style/style_page.dart';
import '../modules/style/style_binding.dart';
import '../modules/live/live_page.dart';
import '../modules/live/live_binding.dart';
import '../modules/musician/musician_page.dart';
import '../modules/musician/musician_binding.dart';
import '../modules/listentogether/listentogether_page.dart';
import '../modules/listentogether/listentogether_binding.dart';
import '../modules/comment/comment_page.dart';
import '../modules/mv/mv_page.dart';
import '../modules/mv/mv_binding.dart';
import '../modules/dj/dj_page.dart';
import '../modules/dj/dj_binding.dart';
import '../modules/radio/radio_page.dart';
import '../modules/radio/radio_binding.dart';
import '../modules/video/video_page.dart';
import '../modules/video/video_binding.dart';
import '../modules/user_profile/user_profile_page.dart';
import '../modules/user_profile/user_profile_binding.dart';
import '../modules/vip/vip_page.dart';
import '../modules/vip/vip_binding.dart';
import '../modules/msg/msg_page.dart';
import '../modules/msg/msg_binding.dart';

/// 路由表
class AppRoutes {
  AppRoutes._();

  static const splash = '/splash';
  static const main = '/main';
  static const home = '/home';
  static const login = '/login';
  static const search = '/search';
  static const player = '/player';
  static const fm = '/fm';
  static const playlistDetail = '/playlist/detail';
  static const playlistSquare = '/playlist/square';
  static const artistDetail = '/artist/detail';
  static const albumDetail = '/album/detail';
  static const charts = '/charts';
  static const comments = '/comments';
  static const messages = '/messages';
  static const yunbei = '/yunbei';
  static const style = '/style';
  static const live = '/live';
  static const musician = '/musician';
  static const listentogether = '/listentogether';
  static const account = '/account';
  static const follow = '/follow';
  static const mine = '/mine';
  static const podcast = '/podcast';
  static const mvDetail = '/mv/detail';
  static const djDetail = '/dj/detail';
  static const djList = '/dj/list';
  static const commentList = '/comment/list';
  static const radio = '/radio';
  static const videoDetail = '/video/detail';
  static const userProfile = '/user/profile';
  static const vip = '/vip';
  static const msg = '/msg';

  static final pages = <GetPage>[
    GetPage(name: splash, page: () => const SplashPage()),
    GetPage(name: main, page: () => const MainPage(), binding: MainBinding()),
    GetPage(name: home, page: () => const HomePage(), binding: HomeBinding()),
    GetPage(name: login, page: () => const LoginPage(), binding: LoginBinding()),
    GetPage(name: search, page: () => const SearchPage(), binding: SearchBinding()),
    GetPage(name: player, page: () => const PlayerPage(), binding: PlayerBinding()),
    GetPage(name: fm, page: () => const FmPage(), binding: FmBinding()),
    GetPage(name: playlistDetail, page: () => const PlaylistPage(), binding: PlaylistBinding()),
    GetPage(name: playlistSquare, page: () => const PlaylistPage(), binding: PlaylistBinding()),
    GetPage(name: artistDetail, page: () => const ArtistPage(), binding: ArtistBinding()),
    GetPage(name: albumDetail, page: () => const AlbumPage(), binding: AlbumBinding()),
    GetPage(name: charts, page: () => const ChartsPage(), binding: ChartsBinding()),
    GetPage(name: comments, page: () => const CommentsPage(), binding: CommentsBinding()),
    GetPage(name: messages, page: () => const MessagesPage(), binding: MessagesBinding()),
    GetPage(name: yunbei, page: () => const YunbeiPage(), binding: YunbeiBinding()),
    GetPage(name: style, page: () => const StylePage(), binding: StyleBinding()),
    GetPage(name: live, page: () => const LivePage(), binding: LiveBinding()),
    GetPage(name: musician, page: () => const MusicianPage(), binding: MusicianBinding()),
    GetPage(name: listentogether, page: () => const ListentogetherPage(), binding: ListentogetherBinding()),
    GetPage(name: mvDetail, page: () => const MvPage(), binding: MvBinding()),
    GetPage(name: djDetail, page: () => const DjPage(), binding: DjBinding()),
    GetPage(name: djList, page: () => const DjPage(), binding: DjBinding()),
    GetPage(name: commentList, page: () => CommentPage(resourceId: 0, resourceType: 0)),
    GetPage(name: radio, page: () => const RadioPage(), binding: RadioBinding()),
    GetPage(name: videoDetail, page: () => const VideoPage(), binding: VideoBinding()),
    GetPage(name: userProfile, page: () => const UserProfilePage(), binding: UserProfileBinding()),
    GetPage(name: vip, page: () => const VipPage(), binding: VipBinding()),
    GetPage(name: msg, page: () => const MsgPage(), binding: MsgBinding()),
  ];
}
