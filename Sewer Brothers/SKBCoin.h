//
//  SKBCoin.h
//  Sewer Brothers
//
//  Created by Eric Internicola on 4/28/15.
//  Copyright (c) 2015 iColaSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>
#import "AppDelegate.h"
#import "SKBSpriteTextures.h"

#define kCoinSpawnSoundFileName @"SpawnCoin.caf"
#define kCoinCollectedSoundFileName @"CoinCollected.caf"

#define kCoinRunningIncrement 40
#define kCoinPointValue 60

typedef enum : int {
    SBCoinRunningLeft = 0,
    SBCoinRunningRight
} SBCoinStatus;

@interface SKBCoin : SKSpriteNode

@property SBCoinStatus coinStatus;
@property int lastKnownXposition, lastKnownYposition;
@property (nonatomic, strong) SKBSpriteTextures *spriteTextures;
@property (nonatomic, strong) SKAction *spawnSound, *collectedSound;

/** Factory Coin Creation Method.  */
+(SKBCoin *)initNewCoin:(SKScene *)whichScene startingPoint:(CGPoint)location coinIndex:(int)index;

/** Handles the spawning of the coin in the scene.  */
-(void)spawnedInScene:(SKScene *)whichScene;

/** Wraps the coin around to the other side.  */
-(void)wrapCoin:(CGPoint)where;

/** Handles the case when the coin hits a pipe.  */
-(void)coinHitPipe;

/** Handles the case when the player collects the coin.  */
-(void)coinCollected:(SKScene *)whichScene;

/** Moves Right.  */
-(void)runRight;

/** Moves Left.  */
-(void)runLeft;

/** Turns Right.  */
-(void)turnRight;

/** Turns Left.  */
-(void)turnLeft;

@end
