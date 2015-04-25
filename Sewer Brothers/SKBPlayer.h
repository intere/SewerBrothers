//
//  Player.h
//  Sewer Brothers
//
//  Created by Eric Internicola on 4/25/15.
//  Copyright (c) 2015 iColaSoft. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

#define kPlayerRunningIncrement 100

@interface SKBPlayer : SKSpriteNode
/** Causes the player to run right.  */
-(void)runRight;

/** Causes the player to run left.  */
-(void)runLeft;

/** Factory creation method of a new player for you.  */
+(SKBPlayer *)initNewPlayer:(SKScene *)whichScene startingPoint:(CGPoint)location;
@end
