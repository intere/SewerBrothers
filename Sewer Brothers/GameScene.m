//
//  GameScene.m
//  Sewer Brothers
//
//  Created by Eric Internicola on 4/25/15.
//  Copyright (c) 2015 iColaSoft. All rights reserved.
//

#import "GameScene.h"

@implementation GameScene

//
// NOTE: The book refers to the initWithSize method, but the code is actually in the didMoveToView: method
//

-(void)didMoveToView:(SKView *)view {
    /** Setup your scene here  */
    self.backgroundColor = [SKColor blackColor];
    NSString *fileName = @"";
    if(self.frame.size.width == 480) {
        fileName = @"SewerSplash_480";  // iPhone Retina (3.5-inch)
    } else {
        fileName = @"SewerSplash_568";  // iPhone Retina (4-inch)
    }
    
    SKSpriteNode *splash = [SKSpriteNode spriteNodeWithImageNamed:fileName];
    splash.name = @"spashNode";
    splash.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    
    [self addChild:splash];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        
        SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithImageNamed:@"pico"];
        
        sprite.xScale = 0.5;
        sprite.yScale = 0.5;
        sprite.position = location;
        
        SKAction *action = [SKAction rotateByAngle:M_PI duration:1];
        
        [sprite runAction:[SKAction repeatActionForever:action]];
        
        [self addChild:sprite];
    }
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
