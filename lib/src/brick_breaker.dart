import 'dart:async';
import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:flame/game.dart';

import 'components/components.dart';
import 'config.dart';

// HasCollisionDetection = 他のコンポーネントと衝突判定を行う
class BrickBreaker extends FlameGame with HasCollisionDetection {
  BrickBreaker()
      : super(
          camera: CameraComponent.withFixedResolution(
            width: gameWidth,
            height: gameHeight,
          ),
        );

  final rand = math.Random();
  double get width => size.x;
  double get height => size.y;

  @override
  FutureOr<void> onLoad() async {
    super.onLoad();

    camera.viewfinder.anchor = Anchor.topLeft;

    // worldはゲーム画面のこと
    world.add(PlayArea());

    // ボールを作成
    world.add(Ball(
        radius: ballRadius,
        position: size / 2, // 画面の中心に配置
        // ボールの初期速度と角度をランダムに設定
        velocity: Vector2((rand.nextDouble() - 0.5) * width, height * 0.2)
            .normalized() // 速度を正規化
          ..scale(height / 2))); // 速度をゲームの高さの1/4にする

    debugMode = true;
  }
}
