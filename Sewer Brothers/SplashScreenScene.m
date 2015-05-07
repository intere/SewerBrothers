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
    
    SKLabelNode *myText = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    myText.text = @"Press To Start";
    myText.name = @"startNode";
    myText.fontSize = 30;
    myText.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)-100);
    
    SKAction *themeSong = [SKAction playSoundFileNamed:@"Theme.caf" waitForCompletion:NO];
    [self runAction:themeSong];
    
    [self addChild:myText];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    for (UITouch *touch in touches) {
        SKNode *instructionNode = [self childNodeWithName:@"instructionNode"];
        
        if(instructionNode != nil) {
            // second tap - on to the game:
            [instructionNode removeFromParent];
            
            SKNode *splashNode = [self childNodeWithName:SPLASH_NODE];
            SKNode *startNode = [self childNodeWithName:@"startNode"];
            if(splashNode) {
                splashNode.name = nil;
                SKAction *zoom = [SKAction scaleTo:4.0 duration:1];
                SKAction *fadeAway = [SKAction fadeOutWithDuration:1];
                SKAction *grouped = [SKAction group:@[zoom, fadeAway]];
                [startNode runAction:grouped];
                [splashNode runAction:grouped completion:^{
                    GameScene *nextScene = [[GameScene alloc]initWithSize:self.size];
                    SKTransition *doors = [SKTransition doorwayWithDuration:0.5];
                    [self.view presentScene:nextScene transition:doors];
                }];
            }
        } else {
            // first tap - show instructions
            SKSpriteNode *instruction = [SKSpriteNode spriteNodeWithImageNamed:@"Instructions"];
            instruction.name = @"instructionNode";
            instruction.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
            [self addChild:instruction];
        }
    }
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
