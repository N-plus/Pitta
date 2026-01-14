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

class FruitGame extends Forge2DGame with PanDetector, TapCallbacks {
  // ゲーム設定
  static const double gameWidth = 400;
  static const double gameHeight = 700;
  static const double wallThickness = 20;
  static const double topMargin = 120;
  
  // ワールドスケール（ピクセルと物理世界の変換）
  final double worldScale = 10.0;
  
  // ゲーム状態
  int score = 0;
  bool isGameOver = false;
  bool canDrop = true;
  FruitData? nextFruit;
  double dropX = gameWidth / 2;
  
  // コールバック
  final Function(int)? onScoreChanged;
  final VoidCallback? onGameOver;
  
  // マージ予約リスト
  final List<_MergePair> _pendingMerges = [];
  
  // ゲームオーバーチェック用タイマー
  double _gameOverCheckTimer = 0;
  static const _gameOverCheckInterval = 1.0;
  
  FruitGame({
    this.onScoreChanged,
    this.onGameOver,
  }) : super(
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
    await _createWalls();
    
    // ドロッププレビューを追加
    await add(DropPreview());
    
    // 最初のフルーツを準備
    _prepareNextFruit();
  }
  
  Future<void> _createWalls() async {
    final worldWidth = gameWidth / worldScale;
    final worldHeight = gameHeight / worldScale;
    final wallOffset = wallThickness / worldScale;
    
    // 左壁
    await add(Wall(
      start: Vector2(wallOffset, topMargin / worldScale),
      end: Vector2(wallOffset, worldHeight - wallOffset),
    ));
    
    // 右壁
    await add(Wall(
      start: Vector2(worldWidth - wallOffset, topMargin / worldScale),
      end: Vector2(worldWidth - wallOffset, worldHeight - wallOffset),
    ));
    
    // 床
    await add(Wall(
      start: Vector2(wallOffset, worldHeight - wallOffset),
      end: Vector2(worldWidth - wallOffset, worldHeight - wallOffset),
    ));
    
    // ゲームオーバーライン
    await add(GameOverLine(
      start: Vector2(wallOffset, topMargin / worldScale),
      end: Vector2(worldWidth - wallOffset, topMargin / worldScale),
      y: topMargin / worldScale,
    ));
  }
  
  void _prepareNextFruit() {
    final types = [FruitType.cherry, FruitType.grape, FruitType.orange];
    final random = Random();
    nextFruit = fruitDataMap[types[random.nextInt(types.length)]];
  }
  
  @override
  void onPanStart(DragStartInfo info) {
    if (isGameOver || !canDrop) return;
    _updateDropPosition(info.eventPosition);
  }
  
  @override
  void onPanUpdate(DragUpdateInfo info) {
    if (isGameOver || !canDrop) return;
    _updateDropPosition(info.eventPosition);
  }
  
  void _updateDropPosition(dynamic eventPos) {
    // イベント位置をゲームウィジェット内の座標に変換
    double newX;
    
    try {
      // まずカメラの座標変換を試す（最も正確）
      final globalPos = eventPos.global as Vector2;
      final localPos = camera.globalToLocal(globalPos);
      newX = localPos.x;
    } catch (e) {
      // カメラ変換が失敗した場合、screen座標を使用
      // screen座標はGameWidget内の座標を返す
      try {
        final screenPos = eventPos.screen as Vector2;
        newX = screenPos.x;
      } catch (e2) {
        // screenも失敗した場合、global座標から手動で計算
        final globalPos = eventPos.global as Vector2;
        final screenSize = size;
        if (screenSize.x > 0 && screenSize.x >= gameWidth) {
          // ゲームウィジェットは画面中央に配置されている
          final gameOffsetX = (screenSize.x - gameWidth) / 2;
          newX = globalPos.x - gameOffsetX;
        } else {
          // フォールバック：global座標を直接使用
          newX = globalPos.x;
        }
      }
    }
    
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
    } else {
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
