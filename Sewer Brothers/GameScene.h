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

@interface GameScene : SKScene<SKPhysicsContactDelegate>
@property (strong, nonatomic) SKBPlayer *playerSprite;

@end
