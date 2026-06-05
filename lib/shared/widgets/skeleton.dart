import 'package:flutter/material.dart';
import '../../config/theme/app_colors.dart';

/// 通用骨架屏组件 - 暗色主题液态玻璃风格
class Skeleton extends StatefulWidget {
  final double width;
  final double height;
  final double borderRadius;

  const Skeleton({
    super.key,
    this.width = double.infinity,
    required this.height,
    this.borderRadius = 8,
  });

  @override
  State<Skeleton> createState() => _SkeletonState();
}

class _SkeletonState extends State<Skeleton>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      duration: const Duration(milliseconds: 1500), vsync: this,
    )..repeat();
    _anim = Tween(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) => Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          gradient: LinearGradient(
            begin: Alignment(_anim.value - 1, 0),
            end: Alignment(_anim.value, 0),
            colors: const [
              Color(0xFF1A1A1A),
              Color(0xFF252525),
              Color(0xFF1A1A1A),
            ],
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
      ),
    );
  }
}

/// 首页骨架屏
class HomeSkeleton extends StatelessWidget {
  const HomeSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 顶栏
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: Row(children: [
                const Skeleton(width: 34, height: 34, borderRadius: 17),
                const SizedBox(width: 10),
                const Skeleton(width: 60, height: 24),
                const Spacer(),
                const Skeleton(width: 36, height: 36, borderRadius: 18),
                const SizedBox(width: 10),
                const Skeleton(width: 36, height: 36, borderRadius: 18),
              ]),
            ),
            // 搜索框
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Skeleton(height: 40, borderRadius: 20),
            ),
            // Banner
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Skeleton(height: 160, borderRadius: 14),
            ),
            // 快捷入口
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(5, (_) => Column(children: const [
                  Skeleton(width: 52, height: 52, borderRadius: 16),
                  SizedBox(height: 8),
                  Skeleton(width: 36, height: 12),
                ])),
              ),
            ),
            // 推荐歌单
            _sectionTitleSkeleton(),
            SizedBox(
              height: 140,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: 4,
                separatorBuilder: (_, __) => const SizedBox(width: 10),
                itemBuilder: (_, __) => Column(children: const [
                  Skeleton(width: 110, height: 110, borderRadius: 14),
                  SizedBox(height: 6),
                  Skeleton(width: 110, height: 12),
                ]),
              ),
            ),
            // 新歌速递
            _sectionTitleSkeleton(),
            ...List.generate(3, (_) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              child: Row(children: const [
                Skeleton(width: 44, height: 44, borderRadius: 8),
                SizedBox(width: 12),
                Expanded(child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Skeleton(width: 120, height: 14),
                    SizedBox(height: 4),
                    Skeleton(width: 80, height: 10),
                  ],
                )),
              ]),
            )),
            const SizedBox(height: 160),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitleSkeleton() => const Padding(
    padding: EdgeInsets.fromLTRB(16, 20, 16, 12),
    child: Skeleton(width: 80, height: 20),
  );
}

/// 播客页骨架屏
class PodcastSkeleton extends StatelessWidget {
  const PodcastSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 标题
            Padding(
              padding: EdgeInsets.fromLTRB(16, MediaQuery.of(context).padding.top + 8, 16, 16),
              child: const Skeleton(width: 60, height: 28),
            ),
            // 分类标签
            SizedBox(
              height: 40,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: 5,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (_, __) => const Skeleton(width: 64, height: 36, borderRadius: 20),
              ),
            ),
            // 推荐电台
            _sectionTitleSkeleton(),
            SizedBox(
              height: 150,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: 4,
                separatorBuilder: (_, __) => const SizedBox(width: 10),
                itemBuilder: (_, __) => Column(children: const [
                  Skeleton(width: 100, height: 100, borderRadius: 14),
                  SizedBox(height: 6),
                  Skeleton(width: 100, height: 12),
                ]),
              ),
            ),
            // 排行榜
            _sectionTitleSkeleton(),
            ...List.generate(3, (_) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              child: Row(children: const [
                Skeleton(width: 30, height: 20),
                SizedBox(width: 12),
                Skeleton(width: 44, height: 44, borderRadius: 8),
                SizedBox(width: 12),
                Expanded(child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Skeleton(width: 120, height: 14),
                    SizedBox(height: 4),
                    Skeleton(width: 80, height: 10),
                  ],
                )),
              ]),
            )),
            const SizedBox(height: 200),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitleSkeleton() => const Padding(
    padding: EdgeInsets.fromLTRB(16, 20, 16, 12),
    child: Skeleton(width: 80, height: 20),
  );
}
