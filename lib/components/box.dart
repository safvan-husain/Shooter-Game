import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class Box extends SpriteAnimationComponent {
  final Color color;
  late final Paint _paint;
  Box([this.color = Colors.white])  {
    _paint = Paint()..color = color;
}

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    if(color == Colors.white) {
    //   angle = 20;
      add(Box(Colors.red)..width = 50..height = 50..anchor = Anchor.topLeft..position = size / 2);
      // angle = 30;
    }
  }



  @override
  void render(Canvas canvas) {
    canvas.drawRect(size.toRect(), _paint);
    super.render(canvas);
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (color == Colors.white) {
      angle += dt * 1;
    }
  }
}