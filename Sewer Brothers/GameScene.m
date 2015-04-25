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
        
        // 4 animation frames stored as textures
        SKTexture *f1 = [SKTexture textureWithImageNamed:@"Player_Right1.png"];
        SKTexture *f2 = [SKTexture textureWithImageNamed:@"Player_Right2.png"];
        SKTexture *f3 = [SKTexture textureWithImageNamed:@"Player_Right3.png"];
        SKTexture *f4 = [SKTexture textureWithImageNamed:@"Player_Right4.png"];
        
        // an arrray of these textures
        NSArray *textureArray = @[f1, f2, f3, f4];
        
        // our player character sprite & starting position in the scene
        _playerSprite = [SKSpriteNode spriteNodeWithTexture:f1];
        _playerSprite.position = location;
        
        // An Action using our array of textures iwth each frame lasting 0.1 seconds
        SKAction *runRightAction = [SKAction animateWithTextures:textureArray timePerFrame:0.1];
        
        // don't run just once, but loop indefinitely
        SKAction *runForever = [SKAction repeatActionForever:runRightAction];
        
        // attach the completed action to our sprite
        [_playerSprite runAction:runForever];
        
        // add the sprite to the scene
        [self addChild:_playerSprite];
    }
}

-(void)update:(NSTimeInterval)currentTime {
    /* Called before each frame is rendered.  */
}

@end
