//
//  GameScene.h
//  Sewer Brothers
//
//  Created by Eric Internicola on 4/25/15.
//  Copyright (c) 2015 iColaSoft. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "AppDelegate.h"
#import "SKBPlayer.h"
#import "SKBLedge.h"
#import "SKBRatz.h"

#define kEnemySpawnEdgeBufferX 60
#define kEnemySpanwEdgeBufferY 60

@interface GameScene : SKScene<SKPhysicsContactDelegate>
@property (strong, nonatomic) SKBPlayer *playerSprite;
@property (strong, nonatomic) SKBSpriteTextures *spriteTextures;

@property int spawnedEnemyCount;
@property BOOL enemyIsSpawningFlag;
@end
