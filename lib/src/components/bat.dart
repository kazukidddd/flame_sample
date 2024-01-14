import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

import '../brick_breaker.dart';

// DragCallbacks = ドラッグ時のコールバックを受け取る、指かマウスで操作できる
class Bat extends PositionComponent
    with DragCallbacks, HasGameReference<BrickBreaker> {
  Bat({
    required this.cornerRadius,
    required super.position,
    required super.size,
  }) : super(
          anchor: Anchor.center,
          children: [RectangleHitbox()], // 他のコンポーネントと衝突判定を行う
        );

  final Radius cornerRadius;

  final _paint = Paint()
    ..color = const Color(0xff1e6091)
    ..style = PaintingStyle.fill;

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    // renderの中で描画処理を行う
    canvas.drawRRect(
        RRect.fromRectAndRadius(
          Offset.zero & size.toSize(),
          cornerRadius,
        ),
        _paint);
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    super.onDragUpdate(event);
    // x座標をドラッグした分だけ移動させる
    position.x = (position.x + event.localDelta.x)
        .clamp(width / 2, game.width - width / 2);
  }

  void moveBy(double dx) {
    // x座標をdx分だけ移動させる
    add(MoveToEffect(
      Vector2(
        (position.x + dx).clamp(width / 2, game.width - width / 2),
        position.y,
      ),
      EffectController(duration: 0.1),
    ));
  }
}
