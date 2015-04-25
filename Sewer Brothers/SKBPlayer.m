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
    SKAction *moveRight = [SKAction moveByX:kPlayerRunningIncrement y:0 duration:1];
    SKAction *moveForever = [SKAction repeatActionForever:moveRight];
    [self runAction:moveForever];
}

-(void)runLeft {
    NSLog(@"run Left");
    SKAction *moveLeft = [SKAction moveByX:-kPlayerRunningIncrement y:0 duration:1];
    SKAction *moveForever = [SKAction repeatActionForever:moveLeft];
    [self runAction:moveForever];
}

+(SKBPlayer *)initNewPlayer:(SKScene *)whichScene startingPoint:(CGPoint)location {
    // 4 animation frames stored as textures
    SKTexture *f1 = [SKTexture textureWithImageNamed:@"Player_Right1.png"];
    SKTexture *f2 = [SKTexture textureWithImageNamed:@"Player_Right2.png"];
    SKTexture *f3 = [SKTexture textureWithImageNamed:@"Player_Right3.png"];
    SKTexture *f4 = [SKTexture textureWithImageNamed:@"Player_Right4.png"];
    
    // an arrray of these textures
    NSArray *textureArray = @[f1, f2, f3, f4];
    
    // our player character sprite & starting position in the scene
    SKBPlayer *player = [SKBPlayer spriteNodeWithTexture:f1];
    player.position = location;
    
    // An Action using our array of textures iwth each frame lasting 0.1 seconds
    SKAction *runRightAction = [SKAction animateWithTextures:textureArray timePerFrame:0.1];
    
    // don't run just once, but loop indefinitely
    SKAction *runForever = [SKAction repeatActionForever:runRightAction];
    
    // attach the completed action to our sprite
    [player runAction:runForever];
    
    // add the sprite to the scene
    [whichScene addChild:player];
    return player;
}
@end
