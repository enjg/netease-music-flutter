import 'package:flutter/material.dart';
import '../../../config/theme/app_colors.dart';
import '../../../data/models/banner_model.dart';

class BannerWidget extends StatefulWidget {
  final List<BannerModel> banners;
  final void Function(BannerModel banner)? onBannerTap;
  const BannerWidget({super.key, required this.banners, this.onBannerTap});

  @override
  State<BannerWidget> createState() => _BannerWidgetState();
}

class _BannerWidgetState extends State<BannerWidget> {
  int _current = 0;
  final _controller = PageController();

  @override
  void initState() {
    super.initState();
    if (widget.banners.length > 1) {
      Future.doWhile(() async {
        await Future.delayed(const Duration(seconds: 4));
        if (!mounted || widget.banners.isEmpty) return false;
        _current = (_current + 1) % widget.banners.length;
        _controller.animateToPage(_current, duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
        return true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.banners.isEmpty) return const SizedBox.shrink();
    return Column(children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: AspectRatio(aspectRatio: 2 / 1,
            child: PageView.builder(
              controller: _controller,
              itemCount: widget.banners.length,
              onPageChanged: (i) => setState(() => _current = i),
              itemBuilder: (_, i) {
                final b = widget.banners[i];
                return GestureDetector(
                  onTap: () => widget.onBannerTap?.call(b),
                  child: Stack(fit: StackFit.expand, children: [
                    Image.network(b.pic, fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(color: AppColors.surface)),
                    Positioned(bottom: 8, right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(color: Colors.black.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(6)),
                        child: Text(b.typeTitle, style: const TextStyle(fontSize: 10, color: Colors.white)))),
                  ]),
                );
              })),
        ),
      ),
      const SizedBox(height: 10),
      Row(mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(widget.banners.length, (i) => Container(
          width: i == _current ? 16 : 6, height: 6,
          margin: const EdgeInsets.symmetric(horizontal: 2),
          decoration: BoxDecoration(
            color: i == _current ? AppColors.accent : AppColors.textTertiary.withOpacity(0.3),
            borderRadius: BorderRadius.circular(3))))),
    ]);
  }
}
