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

#define kRatzRunningIncrement 40

typedef enum : int {
    SBRatzRunningLeft = 0,
    SBRatzRunningRight
} SBRatzStatus;

@interface SKBRatz : SKSpriteNode
@property SBRatzStatus ratzStatus;
@property (nonatomic, strong) SKBSpriteTextures *spriteTextures;

/** Factory Ratz Creation method.  */
+(SKBRatz *)initNewRatz:(SKScene *)whichScene startingPoint:(CGPoint)location ratzIndex:(int)index;

/** Set the scene that the Ratz is spawned in.  */
-(void)spawnedInScene:(SKScene *)whichScene;

/** Wrap the Ratz from one side to the other.  */
-(void)wrapRatz:(CGPoint)where;

/** Ratz run Right.  */
-(void)runRight;

/** Ratz run Left.  */
-(void)runLeft;

/** Turns Right. */
-(void)turnRight;

/** Turns Left.  */
-(void)turnLeft;

@end