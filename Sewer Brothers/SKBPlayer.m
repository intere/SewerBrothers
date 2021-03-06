//
//  Player.m
//  Sewer Brothers
//
//  Created by Eric Internicola on 4/25/15.
//  Copyright (c) 2015 iColaSoft. All rights reserved.
//

#import "SKBPlayer.h"
#import "GameScene.h"

@implementation SKBPlayer

-(void)runRight {
    _playerStatus = SBPlayerRunningRight;
    SKAction *walkAnimation = [SKAction animateWithTextures:_spriteTextures.playerRunRightTextures timePerFrame:0.05];
    SKAction *walkForever = [SKAction repeatActionForever:walkAnimation];
    [self runAction:walkForever];
    
    SKAction *moveRight = [SKAction moveByX:kPlayerRunningIncrement y:0 duration:1];
    SKAction *moveForever = [SKAction repeatActionForever:moveRight];
    [self runAction:moveForever];
    
    // Sound effect for running
    SKAction *shortPause = [SKAction waitForDuration:0.01];
    SKAction *sequence = [SKAction sequence:@[_runSound, shortPause]];
    SKAction *soundContinuous = [SKAction repeatActionForever:sequence];
    [self runAction:soundContinuous withKey:@"soundContinuous"];
}

-(void)runLeft {
    _playerStatus = SBPlayerRunningLeft;
    SKAction *walkAnimation = [SKAction animateWithTextures:_spriteTextures.playerRunLeftTextures timePerFrame:0.05];
    SKAction *walkForever = [SKAction repeatActionForever:walkAnimation];
    [self runAction:walkForever];
    
    SKAction *moveLeft = [SKAction moveByX:-kPlayerRunningIncrement y:0 duration:1];
    SKAction *moveForever = [SKAction repeatActionForever:moveLeft];
    [self runAction:moveForever];
    
    // Sound effect for running
    SKAction *shortPause = [SKAction waitForDuration:0.01];
    SKAction *sequence = [SKAction sequence:@[_runSound, shortPause]];
    SKAction *soundContinuous = [SKAction repeatActionForever:sequence];
    [self runAction:soundContinuous withKey:@"soundContinuous"];
    
}

-(void)skidRight {
    [self removeAllActions];
    _playerStatus = SBPlayerSkiddingRight;
    
    NSArray *playerSkidTextures = _spriteTextures.playerSkiddingRightTextures;
    NSArray *playerStillTextures = _spriteTextures.playerStillFacingRightTextures;
    
    SKAction *skidAnimation = [SKAction animateWithTextures:playerSkidTextures timePerFrame:0.2];
    SKAction *skidAwhile = [SKAction repeatAction:skidAnimation count:1];
    
    SKAction *moveLeft = [SKAction moveByX:kPlayerSkiddingIncrement y:0 duration:0.2];
    SKAction *moveAwhile = [SKAction repeatAction:moveLeft count:1];
    
    SKAction *stillAnimation = [SKAction animateWithTextures:playerStillTextures timePerFrame:0.1];
    SKAction *stillAwhile = [SKAction repeatAction:stillAnimation count:1];
    
    SKAction *sequence = [SKAction sequence:@[skidAwhile, moveAwhile, stillAwhile]];
    SKAction *group = [SKAction group:@[sequence, _skidSound]];
    
    [self runAction:group completion:^{
        _playerStatus = SBPlayerFacingRight;
    }];
}

-(void)skidLeft {
    [self removeAllActions];
    _playerStatus = SBPlayerSkiddingLeft;
    
    NSArray *playerSkidTextures = _spriteTextures.playerSkiddingLeftTextures;
    NSArray *playerStillTextures = _spriteTextures.playerStillFacingLeftTextures;
    
    SKAction *skidAnimation = [SKAction animateWithTextures:playerSkidTextures timePerFrame:1];
    SKAction *skidAwhile = [SKAction repeatAction:skidAnimation count:0.2];
    
    SKAction *moveLeft = [SKAction moveByX:-kPlayerSkiddingIncrement y:0 duration:0.2];
    SKAction *moveAwhile = [SKAction repeatAction:moveLeft count:1];
    
    SKAction *stillAnimation = [SKAction animateWithTextures:playerStillTextures timePerFrame:1];
    SKAction *stillAwhile = [SKAction repeatAction:stillAnimation count:0.1];
    
    SKAction *sequence = [SKAction sequence:@[skidAwhile, moveAwhile, stillAwhile]];
    SKAction *group = [SKAction group:@[sequence, _skidSound]];
    
    [self runAction:group completion:^{
        _playerStatus = SBPlayerFacingLeft;
    }];
}

-(void)jump {
    // Stop running sound effects
    [self removeActionForKey:@"soundContinuous"];
    
    NSArray *playerJumpTextures = nil;
    SBPlayerStatus nextplayerStatus = 0;
    
    // determine direction and next phase
    if(self.playerStatus == SBPlayerRunningLeft || self.playerStatus == SBPlayerSkiddingLeft) {
        self.playerStatus = SBPlayerJumpingLeft;
        playerJumpTextures = _spriteTextures.playerJumpLeftTextures;
        nextplayerStatus = SBPlayerRunningLeft;
    } else if(self.playerStatus == SBPlayerRunningRight || self.playerStatus == SBPlayerSkiddingRight) {
        self.playerStatus = SBPlayerJumpingRight;
        playerJumpTextures = _spriteTextures.playerJumpRightTextures;
        nextplayerStatus = SBPlayerRunningRight;
    } else if(self.playerStatus == SBPlayerFacingLeft) {
        self.playerStatus = SBPlayerJumpingUpFacingLeft;
        playerJumpTextures = _spriteTextures.playerJumpLeftTextures;
        nextplayerStatus = SBPlayerFacingLeft;
    } else if(self.playerStatus == SBPlayerFacingRight) {
        self.playerStatus = SBPlayerJumpingUpFacingRight;
        playerJumpTextures = _spriteTextures.playerJumpRightTextures;
        nextplayerStatus = SBPlayerFacingRight;
    } else {
        NSLog(@"SKBPlayer::jump encountered invalid value...");
    }
    
    // applicable animation
    SKAction *jumpAction = [SKAction animateWithTextures:playerJumpTextures timePerFrame:0.2];
    SKAction *jumpAwhile = [SKAction repeatAction:jumpAction count:4.0];
    SKAction *groupedJump = [SKAction group:@[_jumpSound, jumpAwhile]];
    
    // run jump action and when completed, handle next phase
    [self runAction:groupedJump completion:^{
        if(nextplayerStatus == SBPlayerRunningLeft) {
            [self removeAllActions];
            [self runLeft];
        } else if(nextplayerStatus == SBPlayerRunningRight) {
            [self removeAllActions];
            [self runRight];
        } else if(nextplayerStatus == SBPlayerFacingLeft) {
            NSArray *playerStillTextures = _spriteTextures.playerStillFacingLeftTextures;
            SKAction *stillAnimation = [SKAction animateWithTextures:playerStillTextures timePerFrame:1];
            SKAction *stillAwhile = [SKAction repeatAction:stillAnimation count:0.1];
            [self runAction:stillAwhile];
            self.playerStatus = SBPlayerFacingLeft;
        } else if(nextplayerStatus == SBPlayerFacingRight) {
            NSArray *playerStillTextures = _spriteTextures.playerStillFacingRightTextures;
            SKAction *stillAnimation = [SKAction animateWithTextures:playerStillTextures timePerFrame:1];
            SKAction *stillAwhile = [SKAction repeatAction:stillAnimation count:0.1];
            [self runAction:stillAwhile];
            self.playerStatus = SBPlayerFacingRight;
        } else {
            NSLog(@"SKBPlayer::jump completion block encountered invalid value... %d", nextplayerStatus);
        }
    }];
    
    // jump impulse applied
    [self.physicsBody applyImpulse:CGVectorMake(0, kPlayerJumpingIncrement)];
}

-(void)spawnedInScene:(SKScene *)whichScene {
    GameScene *theScene = (GameScene *)whichScene;
    _spriteTextures = theScene.spriteTextures;
    
    // Sounds
    _spawnSound = [SKAction playSoundFileNamed:kPlayerSpawnSoundFileName waitForCompletion:NO];
    _bittenSound = [SKAction playSoundFileNamed:kPlayerBittenSoundFileName waitForCompletion:NO];
    _splashSound = [SKAction playSoundFileNamed:kPlayerSplashedSoundFileName waitForCompletion:NO];
    _runSound = [SKAction playSoundFileNamed:kPlayerRunSoundFileName waitForCompletion:NO];
    _jumpSound = [SKAction playSoundFileNamed:kPlayerJumpSoundFileName waitForCompletion:NO];
    _skidSound = [SKAction playSoundFileNamed:kPlayerSkidSoundFileName waitForCompletion:NO];
    
    // Play sound
    [self runAction:_spawnSound];
}

+(SKBPlayer *)initNewPlayer:(SKScene *)whichScene startingPoint:(CGPoint)location {
    // initial frame
    SKTexture *f1 = [SKTexture textureWithImageNamed:kPlayerStillRightFileName];
    
    // our player character sprite & starting position in the scene
    SKBPlayer *player = [SKBPlayer spriteNodeWithTexture:f1];
    player.position = location;
    player.name = @"player1";
    player.playerStatus = SBPlayerFacingRight;
    
    // physics
    player.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:player.size];
    player.physicsBody.categoryBitMask = kPlayerCategory;
    player.physicsBody.contactTestBitMask = kBaseCategory | kWallCategory | kCoinCategory | kLedgeCategory | kRatzCategory | kGatorzCategory;
    player.physicsBody.collisionBitMask = kBaseCategory | kWallCategory | kLedgeCategory | kRatzCategory | kGatorzCategory;
    player.physicsBody.density = 1.0;
    player.physicsBody.linearDamping = 0.1;
    player.physicsBody.restitution = 0.2;  // 0.5 is fun :)
    player.physicsBody.allowsRotation = NO;
    
    // add the sprite to the scene
    [whichScene addChild:player];
    return player;
}

#pragma mark Screen wrap
-(void)wrapPlayer:(CGPoint)where {
    SKPhysicsBody *storePB = self.physicsBody;
    self.physicsBody = nil;
    self.position = where;
    self.physicsBody = storePB;
}

#pragma mark Contact
-(void)playerKilled:(SKScene *)whichScene {
    NSLog(@"Player has died");
    [self removeAllActions];
    
    // Update status
    _playerStatus = SBPlayerFalling;
    
    // Play sound
    [whichScene runAction:_bittenSound];
    
    // upward impulse applied
    [self.physicsBody applyForce:CGVectorMake(0, kPlayerBittenIncrement)];
    
    // While flying upward, wait for a short spell before altering physics body
    SKAction *shortDelay = [SKAction waitForDuration:0.5];
    
    [self runAction:shortDelay completion:^{
        // Make a new physics body that is much, much smaller as to not affect ledges as he falls
        self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(1, 1)];
        self.physicsBody.categoryBitMask = kPlayerCategory;
        self.physicsBody.contactTestBitMask = kWallCategory;
        self.physicsBody.collisionBitMask = kWallCategory;
        self.physicsBody.linearDamping = 1.0;
        self.physicsBody.allowsRotation = NO;
    }];
}

-(void)playerHitWater:(SKScene *)whichScene {
    // Play Sound
    [whichScene runAction:_splashSound];
    
    // splash eye candy
    NSString *emitterPath = [[NSBundle mainBundle] pathForResource:@"Splashed" ofType:@"sks"];
    SKEmitterNode *splash = [NSKeyedUnarchiver unarchiveObjectWithFile:emitterPath];
    splash.position = self.position;
    NSLog(@"splash (%f, %f)", splash.position.x, splash.position.y);
    splash.name = @"ratzSplash";
    splash.targetNode = whichScene.scene;
    [whichScene addChild:splash];
    
    [self removeFromParent];

}


@end
