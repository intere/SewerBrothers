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
            [_playerSprite runLeft];
        } else {
            [_playerSprite runRight];
        }
    }
}

-(void)update:(NSTimeInterval)currentTime {
    /* Called before each frame is rendered.  */
}

@end
