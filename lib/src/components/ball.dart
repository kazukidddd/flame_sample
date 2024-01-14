import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
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
    required this.difficultyModifier,
  }) : super(
            radius: radius,
            anchor: Anchor.center,
            paint: Paint()
              ..color = const Color(0xff1e6091)
              ..style = PaintingStyle.fill,
            children: [CircleHitbox()]); // 他のコンポーネントと衝突判定を行う

  final Vector2 velocity;
  final double difficultyModifier;

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
        // ボールが表示可能なプレイエリアから出た後、ボールをゲーム世界から削除します。
        add(RemoveEffect(
          delay: 0.35,
        ));
      }
    } else if (other is Bat) {
      // batとの衝突時には、ボールの速度を変更します。
      velocity.y = -velocity.y;
      velocity.x = velocity.x +
          (position.x - other.position.x) / other.size.x * game.width * 0.3;
    } else if (other is Brick) {
      // レンガとの衝突時には、ボールの速度を変更します。
      if (position.y < other.position.y - other.size.y / 2) {
        // ボールがレンガの上端に衝突した場合、ボールの速度を反転します。
        velocity.y = -velocity.y;
      } else if (position.y > other.position.y + other.size.y / 2) {
        // ボールがレンガの下端に衝突した場合、ボールの速度を反転します。
        velocity.y = -velocity.y;
      } else if (position.x < other.position.x) {
        // ボールがレンガの左端に衝突した場合、ボールの速度を反転します。
        velocity.x = -velocity.x;
      } else if (position.x > other.position.x) {
        // ボールがレンガの右端に衝突した場合、ボールの速度を反転します。
        velocity.x = -velocity.x;
      }
      velocity.setFrom(velocity * difficultyModifier); // To here.
    }
  }
}
