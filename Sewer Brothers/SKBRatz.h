//
//  SKBRatz.h
//  Sewer Brothers
//
//  Created by Eric Internicola on 4/27/15.
//  Copyright (c) 2015 iColaSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"
#import "SKBSpriteTextures.h"

#define kRatzSpawnSoundFileName         @"SpawnEnemy.caf"
#define kRatzKOSoundFileName            @"EnemyKO.caf"
#define kRatzCollectedSoundFileName     @"EnemyCollected.caf"

#define kRatzRunningIncrement           40
#define kRatzPointValue                 100
#define kRatzKickedIncrement            5

typedef enum : int {
    SBRatzRunningLeft = 0,
    SBRatzRunningRight,
    SBRatzKOfacingLeft,
    SBRatzKOfacingRight,
    SBRatzKicked
} SBRatzStatus;

@interface SKBRatz : SKSpriteNode
@property SBRatzStatus ratzStatus;
@property int lastKnownXposition, lastKnownYposition;
@property NSString *lastKnownContactedLedge;
@property (nonatomic, strong) SKBSpriteTextures *spriteTextures;
@property (nonatomic, strong) SKAction *spawnSound, *koSound, *collectedSound;

/** Factory Ratz Creation method.  */
+(SKBRatz *)initNewRatz:(SKScene *)whichScene startingPoint:(CGPoint)location ratzIndex:(int)index;

/** Set the scene that the Ratz is spawned in.  */
-(void)spawnedInScene:(SKScene *)whichScene;

/** Wrap the Ratz from one side to the other.  */
-(void)wrapRatz:(CGPoint)where;

/** Handles the case where the ratz hits the left pipe.  */
-(void)ratzHitLeftPipe:(SKScene *)whichScene;

/** Handles the case where the ratz hits the right pipe.  */
-(void)ratzHitRightPipe:(SKScene *)whichScene;

/** The Ratz is knocked out!  */
-(void)ratzKnockedOut:(SKScene *)whichScene;

/** The Ratz has been collected!  */
-(void)ratzCollected:(SKScene *)whichScene;

/** Ratz run Right.  */
-(void)runRight;

/** Ratz run Left.  */
-(void)runLeft;

/** Turns Right. */
-(void)turnRight;

/** Turns Left.  */
-(void)turnLeft;

@end
