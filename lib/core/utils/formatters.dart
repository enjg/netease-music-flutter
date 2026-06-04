/// 格式化工具
class Formatters {
  Formatters._();

  /// 播放次数: 12345 -> 1.2万
  static String playCount(int count) {
    if (count >= 100000000) return '${(count / 100000000).toStringAsFixed(1)}亿';
    if (count >= 10000) return '${(count / 10000).toStringAsFixed(1)}万';
    return count.toString();
  }

  /// 时长: 秒 -> m:ss
  static String duration(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return '$m:${s.toString().padLeft(2, '0')}';
  }

  /// 时长: 毫秒 -> m:ss
  static String durationMs(int ms) => duration(ms ~/ 1000);

  /// 日期: 时间戳 -> yyyy.MM.dd
  static String date(int timestamp) {
    final d = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return '${d.year}.${d.month}.${d.day}';
  }

  /// 相对时间
  static String relativeTime(int timestamp) {
    final d = DateTime.fromMillisecondsSinceEpoch(timestamp);
    final diff = DateTime.now().difference(d);
    if (diff.inMinutes < 1) return '刚刚';
    if (diff.inHours < 1) return '${diff.inMinutes}分钟前';
    if (diff.inDays < 1) return '${diff.inHours}小时前';
    if (diff.inDays < 7) return '${diff.inDays}天前';
    return date(timestamp);
  }

  /// 数字简写: 12345 -> 1.2万
  static String number(int n) => playCount(n);
}
