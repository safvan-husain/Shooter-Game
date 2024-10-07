import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flutter/material.dart';
import 'package:shooter_game/bloc/game_bloc.dart';

class Gun extends SpriteAnimationComponent
    with FlameBlocListenable<GameCubit, GameState> {
  final Vector2 _size;
  final Paint _paint;

  Gun(this._size, this._paint)
      : super(
          size: _size,
          anchor: Anchor.bottomCenter,
          paint: _paint,
        );

  @override
  Future<void> onLoad() async {
    add(RectangleHitbox(collisionType: CollisionType.passive));
    super.onLoad();
  }

  @override
  void render(canvas) async {
    double totalW = _size.x;
    double totalH = _size.y;
    double primaryGunW = totalW * .45;
    double space = 3;
    double sideGunW = (totalW - primaryGunW - (2 * space)) / 2;
    double sideGunH = totalH * .4;
    //left side element
    drawSideGun(
      Vector2(sideGunW, sideGunH),
      canvas,
      paint,
      totalH - sideGunH,
      0,
    );
    drawPrimaryGun(
      Vector2(primaryGunW, totalH),
      canvas,
      paint,
      0,
      sideGunW + space,
    );
    //right side element
    drawSideGun(
      Vector2(sideGunW, sideGunH),
      canvas,
      paint,
      totalH - sideGunH,
      sideGunW + primaryGunW + (space * 2),
    );
    super.render(canvas);
  }

  @override
  void onNewState(state) {
    angle = state.angle;
  }
}

void drawPrimaryGun(
  Vector2 size,
  Canvas canvas,
  Paint paint,
  double prefixH,
  double prefixW,
) {
  final Path path = Path();

  path.moveTo(prefixW + 0, prefixH + (size.y * .5));
  path.lineTo(prefixW + (size.x * .5), 0);
  path.lineTo(prefixW + size.x, prefixH + (size.y * .5));
  path.lineTo(prefixW + size.x, prefixH + size.y);
  path.lineTo(prefixW + 0, prefixH + size.y);
  path.close();

  canvas.drawPath(path, paint);

  final Path shadowPath = Path();
  shadowPath.moveTo(prefixW + (size.x * .5), 0);
  shadowPath.lineTo(prefixW + size.x, prefixH + (size.y * .5));
  shadowPath.quadraticBezierTo(
    prefixW + (size.x / 2),
    prefixH + (size.y * .5) + 10,
    prefixW + 0,
    prefixH + (size.y * .5),
  );

  canvas.drawPath(shadowPath, Paint()..color = Colors.black.withAlpha(50));
}

void drawSideGun(
  Vector2 size,
  Canvas canvas,
  Paint paint,
  double prefixH,
  double prefixW,
) {
  final Path path = Path();

  path.moveTo(prefixW + 0, prefixH + size.y);
  path.quadraticBezierTo(
      prefixW + (size.x / 2), 0, prefixW + size.x, prefixH + size.y);
  path.close();

  canvas.drawPath(path, paint);
}
