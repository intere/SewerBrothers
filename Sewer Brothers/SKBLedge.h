//
//  SKBLedge.h
//  Sewer Brothers
//
//  Created by Eric Internicola on 4/27/15.
//  Copyright (c) 2015 iColaSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>
#import "AppDelegate.h"

#define kLedgeBrickFileName     @"LedgeBrick.png"
#define kLedgeBrickSpacing      9
#define kLedgeSideBufferSpacing 4

@interface SKBLedge : NSObject
/** Creates you a set of ledges.  */
-(void)createNewSetOfLedgeNodes:(SKScene *)whichScene startingPoint:(CGPoint)leftSide withHowManyBlocks:(int)blockCount startingIndex:(int)indexStart;
@end
