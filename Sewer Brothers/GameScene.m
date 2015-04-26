//
//  GameScene.m
//  Sewer Brothers
//
//  Created by Eric Internicola on 4/25/15.
//  Copyright (c) 2015 iColaSoft. All rights reserved.
//

#import "GameScene.h"

@implementation GameScene
-(id)initWithSize:(CGSize)size {
    if(self = [super initWithSize:size]) {
        /* Setup your scene here.  */
        self.backgroundColor = [SKColor blackColor];
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins.  */
    for(UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        
        if(!_playerSprite) {
            _playerSprite = [SKBPlayer initNewPlayer:self startingPoint:location];
        } else if(location.x <= (self.frame.size.width / 2)) {
            // user touched left side of the screen
            if(_playerSprite.playerStatus == SBPlayerRunningRight) {
                _playerSprite.playerStatus = SBPlayerFacingRight;
                
                // stop running by switching to a single frame
                [_playerSprite removeAllActions];
                SKAction *standingFrame = [SKAction animateWithTextures:_playerSprite.spriteTextures.playerStillFacingRightTextures timePerFrame:0.05];
                SKAction *standForever = [SKAction repeatActionForever:standingFrame];
                [_playerSprite runAction:standForever];
            } else {
                [_playerSprite runLeft];
            }
        } else {
            // user touched right side of the screen
            if(_playerSprite.playerStatus == SBPlayerRunningLeft) {
                _playerSprite.playerStatus = SBPlayerFacingLeft;
                
                // stop running by switching to a single frame
                [_playerSprite removeAllActions];
                SKAction *standingFrame = [SKAction animateWithTextures:_playerSprite.spriteTextures.playerStillFacingLeftTextures timePerFrame:0.05];
                SKAction *standForever = [SKAction repeatActionForever:standingFrame];
                [_playerSprite runAction:standForever];
            } else {
                [_playerSprite runRight];
            }
        }
    }
}

-(void)update:(NSTimeInterval)currentTime {
    /* Called before each frame is rendered.  */
}

@end
