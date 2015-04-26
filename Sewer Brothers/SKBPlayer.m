//
//  Player.m
//  Sewer Brothers
//
//  Created by Eric Internicola on 4/25/15.
//  Copyright (c) 2015 iColaSoft. All rights reserved.
//

#import "SKBPlayer.h"

@implementation SKBPlayer

-(void)runRight {
    NSLog(@"run Right");
    _playerStatus = SBPlayerRunningRight;
    SKAction *walkAnimation = [SKAction animateWithTextures:_spriteTextures.playerRunRightTextures timePerFrame:0.05];
    SKAction *walkForever = [SKAction repeatActionForever:walkAnimation];
    [self runAction:walkForever];
    
    SKAction *moveRight = [SKAction moveByX:kPlayerRunningIncrement y:0 duration:1];
    SKAction *moveForever = [SKAction repeatActionForever:moveRight];
    [self runAction:moveForever];
}

-(void)runLeft {
    NSLog(@"run Left");
    _playerStatus = SBPlayerRunningLeft;
    SKAction *walkAnimation = [SKAction animateWithTextures:_spriteTextures.playerRunLeftTextures timePerFrame:0.05];
    SKAction *walkForever = [SKAction repeatActionForever:walkAnimation];
    [self runAction:walkForever];
    
    SKAction *moveLeft = [SKAction moveByX:-kPlayerRunningIncrement y:0 duration:1];
    SKAction *moveForever = [SKAction repeatActionForever:moveLeft];
    [self runAction:moveForever];
}

+(SKBPlayer *)initNewPlayer:(SKScene *)whichScene startingPoint:(CGPoint)location {
    // initialize and create our sprite textures
    SKBSpriteTextures *playerTextures = [[SKBSpriteTextures alloc]init];
    [playerTextures createAnimationTextures];
    
    // initial frame
    SKTexture *f1 = [SKTexture textureWithImageNamed:kPlayerRunRight1FileName];
    
    // our player character sprite & starting position in the scene
    SKBPlayer *player = [SKBPlayer spriteNodeWithTexture:f1];
    player.position = location;
    player.spriteTextures = playerTextures;
    
    // add the sprite to the scene
    [whichScene addChild:player];
    return player;
}
@end
