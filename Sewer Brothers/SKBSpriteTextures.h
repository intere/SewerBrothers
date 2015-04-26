//
//  SKBSpriteTextures.h
//  Sewer Brothers
//
//  Created by Eric Internicola on 4/25/15.
//  Copyright (c) 2015 iColaSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>

#define kPlayerRunRight1FileName @"Player_Right1.png"
#define kPlayerRunRight2FileName @"Player_Right2.png"
#define kPlayerRunRight3FileName @"Player_Right3.png"
#define kPlayerRunRight4FileName @"Player_Right4.png"
#define kPlayerStillRightFileName @"Player_Right_Still.png"

#define kPlayerRunLeft1FileName @"Player_Left1.png"
#define kPlayerRunLeft2FileName @"Player_Left2.png"
#define kPlayerRunLeft3FileName @"Player_Left3.png"
#define kPlayerRunLeft4FileName @"Player_Left4.png"
#define kPlayerStillLeftFileName @"Player_Left_Still.png"

@interface SKBSpriteTextures : NSObject

@property (nonatomic, strong) NSArray *playerRunRightTextures, *playerStillFacingRightTextures;
@property (nonatomic, strong) NSArray *playerRunLeftTextures, *playerStillFacingLeftTextures;

-(void)createAnimationTextures;

@end
