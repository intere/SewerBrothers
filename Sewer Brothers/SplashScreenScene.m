//
//  GameScene.m
//  Sewer Brothers
//
//  Created by Eric Internicola on 4/25/15.
//  Copyright (c) 2015 iColaSoft. All rights reserved.
//

#import "SplashScreenScene.h"
#import "GameScene.h"

#define SPLASH_NODE @"splashNode"

@implementation SplashScreenScene

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
    splash.name = SPLASH_NODE;
    splash.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    
    [self addChild:splash];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    for (UITouch *touch in touches) {
        SKNode *splashNode = [self childNodeWithName:SPLASH_NODE];
        if(splashNode) {
            splashNode.name = nil;
            SKAction *zoom = [SKAction scaleTo:4.0 duration:1];
            SKAction *fadeAway = [SKAction fadeOutWithDuration:1];
            SKAction *grouped = [SKAction group:@[zoom, fadeAway]];
            [splashNode runAction:grouped completion:^{
                GameScene *nextScene = [[GameScene alloc]initWithSize:self.size];
                SKTransition *doors = [SKTransition doorwayWithDuration:0.5];
                [self.view presentScene:nextScene transition:doors];
            }];
        }
    }
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
