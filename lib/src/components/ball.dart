import 'package:flame/components.dart';
import 'package:flutter/material.dart';

// CircleComponentを継承してBallクラスを作成
class Ball extends CircleComponent {
  Ball({
    required this.velocity,
    required super.position,
    required double radius,
  }) : super(
            radius: radius,
            anchor: Anchor.center,
            paint: Paint()
              ..color = const Color(0xff1e6091)
              ..style = PaintingStyle.fill);

  final Vector2 velocity;

  @override
  void update(double dt) {
    super.update(dt);
    // 速度を時間で割って、1秒あたりの移動距離を計算
    position += velocity * dt;
  }
}
