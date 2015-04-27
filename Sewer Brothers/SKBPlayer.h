//
//  Player.h
//  Sewer Brothers
//
//  Created by Eric Internicola on 4/25/15.
//  Copyright (c) 2015 iColaSoft. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "AppDelegate.h"
#import "SKBSpriteTextures.h"

#define kPlayerRunningIncrement 100
#define kPlayerSkiddingIncrement 20
#define kPlayerJumpingIncrement  8

typedef enum : int {
    SBPlayerFacingLeft = 0,
    SBPlayerFacingRight,
    SBPlayerRunningLeft,
    SBPlayerRunningRight,
    SBPlayerSkiddingLeft,
    SBPlayerSkiddingRight,
    SBPlayerJumpingLeft,
    SBPlayerJumpingRight,
    SBPlayerJumpingUpFacingLeft,
    SBPlayerJumpingUpFacingRight
} SBPlayerStatus;

@interface SKBPlayer : SKSpriteNode

@property (nonatomic, strong) SKBSpriteTextures *spriteTextures;
@property SBPlayerStatus playerStatus;

/** Causes the player to run right.  */
-(void)runRight;

/** Causes the player to run left.  */
-(void)runLeft;

/** Causes the player to skid right.  */
-(void)skidRight;

/** Causes the player to skid left.  */
-(void)skidLeft;

/** Wraps the player to the specified point.  */
-(void)wrapPlayer:(CGPoint)where;

/** Makes the user jump.  */
-(void)jump;

/** Factory creation method of a new player for you.  */
+(SKBPlayer *)initNewPlayer:(SKScene *)whichScene startingPoint:(CGPoint)location;
@end
