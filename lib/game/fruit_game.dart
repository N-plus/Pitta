import 'dart:math';
import 'package:flame/events.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
import 'fruit_types.dart';
import 'fruit_body.dart';
import 'wall.dart';
import 'effects.dart';
import 'drop_preview.dart';
import 'audio_manager.dart';

class FruitGame extends Forge2DGame with TapCallbacks {
  // ゲーム設定
  static const double defaultGameWidth = 400;
  static const double defaultGameHeight = 700;
  static const double wallThickness = 20;
  static const double topMargin = 72;
  
  // ワールドスケール（ピクセルと物理世界の変換）
  final double worldScale = 10.0;

  double gameWidth;
  double gameHeight;
  
  // ゲーム状態
  int score = 0;
  bool isGameOver = false;
  bool canDrop = true;
  FruitData? nextFruit;
  double dropX;
  double _dropDirection = 1;
  static const double _autoDropSpeed = 140;
  static const double _devilDropChance = 0.12;
  
  // コールバック
  final Function(int)? onScoreChanged;
  final VoidCallback? onGameOver;
  
  // マージ予約リスト
  final List<_MergePair> _pendingMerges = [];

  final List<BodyComponent> _boundaryComponents = [];
  
  // ゲームオーバーチェック用タイマー
  double _gameOverCheckTimer = 0;
  static const _gameOverCheckInterval = 1.0;
  
  FruitGame({
    this.onScoreChanged,
    this.onGameOver,
    double? initialGameWidth,
    double? initialGameHeight,
  })  : gameWidth = initialGameWidth ?? defaultGameWidth,
        gameHeight = initialGameHeight ?? defaultGameHeight,
        dropX = (initialGameWidth ?? defaultGameWidth) / 2,
        super(
    gravity: Vector2(0, 30), // ゆっくり落下
    zoom: 1,
  );
  
  @override
  Color backgroundColor() => const Color(0xFFFFF5F7);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    
    // BGMを再生
    AudioManager().playBgm('assets/sounds/bgm.mp3');
    
    // 壁を作成
    await _rebuildBounds();
    
    // ドロッププレビューを追加
    await add(DropPreview());
    
    // 最初のフルーツを準備
    _prepareNextFruit();
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    updateGameSize(size.x, size.y);
  }

  void updateGameSize(double width, double height) {
    if (width <= 0 || height <= 0) return;
    if ((gameWidth - width).abs() < 0.5 && (gameHeight - height).abs() < 0.5) {
      return;
    }

    gameWidth = width;
    gameHeight = height;
    dropX = gameWidth / 2;
    _rebuildBounds();
  }
  
  Future<void> _rebuildBounds() async {
    if (gameWidth <= 0 || gameHeight <= 0) return;

    for (final component in _boundaryComponents) {
      component.removeFromParent();
    }
    _boundaryComponents.clear();

    final worldWidth = gameWidth / worldScale;
    final worldHeight = gameHeight / worldScale;
    final wallOffset = wallThickness / worldScale;
    
    // 左壁
    final leftWall = Wall(
      start: Vector2(wallOffset, topMargin / worldScale),
      end: Vector2(wallOffset, worldHeight - wallOffset),
    );
    await add(leftWall);
    _boundaryComponents.add(leftWall);
    
    // 右壁
    final rightWall = Wall(
      start: Vector2(worldWidth - wallOffset, topMargin / worldScale),
      end: Vector2(worldWidth - wallOffset, worldHeight - wallOffset),
    );
    await add(rightWall);
    _boundaryComponents.add(rightWall);
    
    // 床
    final floor = Wall(
      start: Vector2(wallOffset, worldHeight - wallOffset),
      end: Vector2(worldWidth - wallOffset, worldHeight - wallOffset),
    );
    await add(floor);
    _boundaryComponents.add(floor);
    
    // ゲームオーバーライン
    final gameOverLine = GameOverLine(
      start: Vector2(wallOffset, topMargin / worldScale),
      end: Vector2(worldWidth - wallOffset, topMargin / worldScale),
      y: topMargin / worldScale,
    );
    await add(gameOverLine);
    _boundaryComponents.add(gameOverLine);
  }
  
  void _prepareNextFruit() {
    final types = [FruitType.cherry, FruitType.grape, FruitType.orange];
    final random = Random();
    final isDevil = random.nextDouble() < _devilDropChance;
    if (isDevil) {
      nextFruit = fruitDataMap[FruitType.devil];
    } else {
      nextFruit = fruitDataMap[types[random.nextInt(types.length)]];
    }
  }
  
  void _updateDropPosition(double newX) {
    // 座標をクランプ
    final minX = wallThickness + (nextFruit?.radius ?? 30);
    final maxX = gameWidth - wallThickness - (nextFruit?.radius ?? 30);
    dropX = newX.clamp(minX, maxX);
  }
  
  @override
  void onTapUp(TapUpEvent event) {
    if (isGameOver || !canDrop || nextFruit == null) return;
    _dropFruit();
  }
  
  void _dropFruit() {
    if (nextFruit == null) return;
    
    canDrop = false;
    
    // ドロップ効果音を再生
    AudioManager().playSe('assets/sounds/drop.mp3');
    
    // フルーツを生成
    final fruit = FruitBody(
      fruitData: nextFruit!,
      initialPosition: Vector2(dropX / worldScale, topMargin / worldScale - 2),
    );
    add(fruit);
    
    // 次のフルーツを準備（少し待ってから）
    Future.delayed(const Duration(milliseconds: 500), () {
      if (!isGameOver) {
        _prepareNextFruit();
        canDrop = true;
      }
    });
  }
  
  /// フルーツのマージをスケジュール
  void scheduleMerge(FruitBody fruit1, FruitBody fruit2) {
    if (fruit1.isMarkedForMerge || fruit2.isMarkedForMerge) return;
    
    fruit1.isMarkedForMerge = true;
    fruit2.isMarkedForMerge = true;
    _pendingMerges.add(_MergePair(fruit1, fruit2));
  }
  
  @override
  void update(double dt) {
    super.update(dt);
    
    // マージ処理
    _processMerges();
    
    // ゲームオーバーチェック
    _gameOverCheckTimer += dt;
    if (_gameOverCheckTimer >= _gameOverCheckInterval) {
      _gameOverCheckTimer = 0;
      _checkGameOver();
    }

    _updateAutoDropPosition(dt);
  }

  void _updateAutoDropPosition(double dt) {
    if (isGameOver || !canDrop || nextFruit == null) return;
    final delta = _autoDropSpeed * dt * _dropDirection;
    _updateDropPosition(dropX + delta);

    final minX = wallThickness + (nextFruit?.radius ?? 30);
    final maxX = gameWidth - wallThickness - (nextFruit?.radius ?? 30);
    if (dropX <= minX + 0.1) {
      _dropDirection = 1;
    } else if (dropX >= maxX - 0.1) {
      _dropDirection = -1;
    }
  }
  
  void _processMerges() {
    for (final pair in _pendingMerges) {
      _performMerge(pair.fruit1, pair.fruit2);
    }
    _pendingMerges.clear();
  }
  
  void _performMerge(FruitBody fruit1, FruitBody fruit2) {
    // 中間位置を計算
    final pos1 = fruit1.body.position;
    final pos2 = fruit2.body.position;
    final mergePos = Vector2(
      (pos1.x + pos2.x) / 2,
      (pos1.y + pos2.y) / 2,
    );
    
    // 合体効果音を再生
    AudioManager().playSe('assets/sounds/merge.mp3');
    
    // スコア加算
    final points = fruit1.fruitData.points;
    score += points;
    onScoreChanged?.call(score);
    
    // エフェクト追加（スクリーン座標で）
    final screenPos = Vector2(mergePos.x * worldScale, mergePos.y * worldScale);
    add(PopEffect(position: screenPos.clone()));
    add(SparkleEffect(position: screenPos.clone()));
    add(ScorePopup(position: screenPos.clone(), points: points));
    
    // 次のフルーツを生成
    final nextData = fruit1.fruitData.next;
    if (nextData != null) {
      final newFruit = FruitBody(
        fruitData: nextData,
        initialPosition: mergePos,
      );
      add(newFruit);
      
      // 最終フルーツの場合は特別なエフェクト
      if (nextData.isFinal) {
        _addFinalFruitEffect(screenPos);
      }
    } else if (fruit1.fruitData.isFinal) {
      // 最終フルーツ同士の合体（ボーナス）
      score += 50;
      onScoreChanged?.call(score);
      _addFinalFruitEffect(screenPos);
    }
    
    // 古いフルーツを削除
    fruit1.removeFromParent();
    fruit2.removeFromParent();
  }
  
  void _addFinalFruitEffect(Vector2 position) {
    // 特大キラキラ
    for (int i = 0; i < 3; i++) {
      Future.delayed(Duration(milliseconds: i * 100), () {
        if (!isGameOver) {
          add(SparkleEffect(
            position: position.clone(),
            color: const Color(0xFFFFD700),
            particleCount: 20,
          ));
        }
      });
    }
  }
  
  void _checkGameOver() {
    if (isGameOver) return;
    
    // 全てのフルーツボディをチェック
    for (final child in children) {
      if (child is FruitBody && child.hasSettled) {
        final y = child.body.position.y * worldScale;
        if (y < topMargin) {
          // ゲームオーバー
          isGameOver = true;
          onGameOver?.call();
          break;
        }
      }
    }
  }
  
  /// ゲームをリセット
  void resetGame() {
    // 全てのフルーツを削除
    final toRemove = <FruitBody>[];
    for (final child in children) {
      if (child is FruitBody) {
        toRemove.add(child);
      }
    }
    for (final fruit in toRemove) {
      fruit.removeFromParent();
    }
    
    // 状態をリセット
    score = 0;
    isGameOver = false;
    canDrop = true;
    dropX = gameWidth / 2;
    _dropDirection = 1;
    _pendingMerges.clear();
    
    _prepareNextFruit();
    onScoreChanged?.call(score);
  }
  
  /// プレビュー用のフルーツ描画情報
  FruitData? get currentFruit => nextFruit;
  double get currentDropX => dropX;
}

class _MergePair {
  final FruitBody fruit1;
  final FruitBody fruit2;
  
  _MergePair(this.fruit1, this.fruit2);
}
