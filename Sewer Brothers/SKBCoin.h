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

#define kCoinRunningIncrement 40

typedef enum : int {
    SBCoinRunningLeft = 0,
    SBCoinRunningRight
} SBCoinStatus;

@interface SKBCoin : SKSpriteNode

@property SBCoinStatus coinStatus;
@property (nonatomic, strong) SKBSpriteTextures *spriteTextures;
@property (nonatomic, strong) SKAction *spawnSound;

/** Factory Coin Creation Method.  */
+(SKBCoin *)initNewCoin:(SKScene *)whichScene startingPoint:(CGPoint)location coinIndex:(int)index;

/** Handles the spawning of the coin in the scene.  */
-(void)spawnedInScene:(SKScene *)whichScene;

/** Wraps the coin around to the other side.  */
-(void)wrapCoin:(CGPoint)where;

/** Moves Right.  */
-(void)runRight;

/** Moves Left.  */
-(void)runLeft;

/** Turns Right.  */
-(void)turnRight;

/** Turns Left.  */
-(void)turnLeft;

@end
