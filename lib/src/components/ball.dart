import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_sample/src/brick_breaker.dart';
import 'package:flame_sample/src/components/components.dart';
import 'package:flutter/material.dart';

// CircleComponentを継承してBallクラスを作成
// CollisionCallbacks = 衝突時のコールバックを受け取る
// HasGameReference = ゲームの参照
class Ball extends CircleComponent
    with CollisionCallbacks, HasGameReference<BrickBreaker> {
  Ball({
    required this.velocity,
    required super.position,
    required double radius,
  }) : super(
            radius: radius,
            anchor: Anchor.center,
            paint: Paint()
              ..color = const Color(0xff1e6091)
              ..style = PaintingStyle.fill,
            children: [CircleHitbox()]); // 他のコンポーネントと衝突判定を行う

  final Vector2 velocity;

  @override
  void update(double dt) {
    super.update(dt);
    // 速度を時間で割って、1秒あたりの移動距離を計算
    position += velocity * dt;
  }

  @override // 衝突時のコールバック
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is PlayArea) {
      if (intersectionPoints.first.y <= 0) {
        velocity.y = -velocity.y; // 画面上端に衝突したら反射
      } else if (intersectionPoints.first.x <= 0) {
        velocity.x = -velocity.x; // 画面左端に衝突したら反射
      } else if (intersectionPoints.first.x >= game.width) {
        velocity.x = -velocity.x; // 画面右端に衝突したら反射
      } else if (intersectionPoints.first.y >= game.height) {
        removeFromParent(); // 画面外に出たら削除
      }
    } else {
      debugPrint('collision with $other');
    }
  }
}
