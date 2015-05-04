//
//  Gatorz.h
//  Sewer Brothers
//
//  Created by Eric Internicola on 5/4/15.
//  Copyright (c) 2015 iColaSoft. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "AppDelegate.h"
#import "SKBSpriteTextures.h"

#define kGatorzSpawnSoundFileName       @"SpawnEnemy.caf"
#define kGatorzKOSoundFileName          @"EnemyKO.caf"
#define kGatorzCollectedFileName        @"EnemyCollected.caf"
#define kGatorzSplashedSoundFileName    @"Splash.caf"

#define kGatorzRunningIncrement         30
#define kGatorzKickedIncrement          5
#define kGatorzPointValue               150

typedef enum : int {
    SBGatorzRunningLeft = 0,
    SBGatorzRunningRight,
    SBGatorzKOfacingLeft,
    SBGatorzKOfacingRight,
    SBGatorzKicked
} SBGatorzStatus;

@interface SKBGatorz : SKSpriteNode

@property SBGatorzStatus gatorzStatus;
@property int lastKnownXposition, lastKnownYposition;
@property (nonatomic, strong) NSString *lastKnownContactedLedge;
@property (nonatomic, strong) SKBSpriteTextures *spriteTextures;

@property (nonatomic, strong) SKAction *spawnSound, *koSound, *collectedSound, *splashSound;

/** Instantiates a new gator in the provided scene for you.  */
+(SKBGatorz *)initNewGatorz:(SKScene *)whichScene startingPoint:(CGPoint)location gatorzIndex:(int)index;

/** Handles the spawning in the scene.  */
-(void)spawnedInScene:(SKScene *)whichScene;

/** Wrapz the gator around to the next wall.  */
-(void)wrapGatorz:(CGPoint)where;

-(void)gatorzHitLeftPipe:(SKScene *)whichScene;
-(void)gatorzHitRightPipe:(SKScene *)whichScene;

-(void)gatorzKnockedOut:(SKScene *)whichScene;
-(void)gatorzCollected:(SKScene *)whichScene;
-(void)gatorzHitWater:(SKScene *)whichScene;

-(void)runRight;
-(void)runLeft;
-(void)turnRight;
-(void)turnLeft;

@end
