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
#import "SKBGatorz.h"
#import "SKBCoin.h"
#import "SKBScores.h"

#define kNumberOfLevelsMax      1

#define kPlayerLivesMax         3

@interface GameScene : SKScene<SKPhysicsContactDelegate>
@property (strong, nonatomic) SKBPlayer *playerSprite;
@property (strong, nonatomic) SKBSpriteTextures *spriteTextures;
@property (strong, nonatomic) NSArray *castTypeArray, *castDelayArray, *castStartXindexArray;

@property int frameCounter;
@property int spawnedEnemyCount, activeEnemyCount;
@property BOOL enemyIsSpawningFlag;
@property BOOL playerIsDeadFlag;
@property int playerLivesRemaining;
@property BOOL gameIsOverFlag, gameIsPaused;
@property int currentLevel;


@property (nonatomic, strong) SKBScores *scoreDisplay;
@property int playerScore, highScore;
@end
