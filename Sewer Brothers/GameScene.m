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
        CGRect edgeRect = CGRectMake(0.0, 0.0, self.frame.size.width, self.frame.size.height+100.0);
        self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:edgeRect];
        self.physicsBody.categoryBitMask = kWallCategory;
        self.physicsWorld.contactDelegate = self;
        
        // initialize and create our sprite textures
        _spriteTextures = [[SKBSpriteTextures alloc]init];
        [_spriteTextures createAnimationTextures];
        
        NSString *fileName = @"";
        if(self.frame.size.width == 480) {
            fileName = @"Backdrop_480";     // iPhone Retina (3.5-inch)
        } else {
            fileName = @"Backdrop_568";     // iPhone Retina (4-inch)
        }
        SKSpriteNode *backdrop = [SKSpriteNode spriteNodeWithImageNamed:fileName];
        backdrop.name = @"backdropNode";
        backdrop.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        
        [self addChild:backdrop];
        
        [self createSceneContents];
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins.  */
    for(UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        SBPlayerStatus status = _playerSprite.playerStatus;
        
        if(!_playerSprite) {
            _playerSprite = [SKBPlayer initNewPlayer:self startingPoint:location];
            [_playerSprite spawnedInScene:self];
            
            SKAction *spawnDelay = [SKAction waitForDuration:4];
            [self runAction:spawnDelay completion:^{
                SKBRatz *newEnemy = [SKBRatz initNewRatz:self startingPoint:CGPointMake(50,280) ratzIndex:0];
                [newEnemy spawnedInScene:self];
            }];
        } else if(location.y >= (self.frame.size.height / 2)) {
            // user touched upper half of the screen (zero = bottom of screen)
            if(status != SBPlayerJumpingLeft && status != SBPlayerJumpingRight && status != SBPlayerJumpingUpFacingLeft && status != SBPlayerJumpingUpFacingRight) {
                [_playerSprite jump];
            }
        } else if(location.x <= (self.frame.size.width / 2)) {
            // user touched left side of the screen
            if(status == SBPlayerRunningRight) {
                [_playerSprite skidRight];
            } else if(status == SBPlayerFacingLeft || status == SBPlayerFacingRight) {
                [_playerSprite runLeft];
            }
        } else {
            // user touched right side of the screen
            if(status == SBPlayerRunningLeft) {
                [_playerSprite skidLeft];
            } else if(status == SBPlayerFacingLeft || status == SBPlayerFacingRight) {
                [_playerSprite runRight];
            }
        }
    }
}

-(void)update:(NSTimeInterval)currentTime {
    /* Called before each frame is rendered.  */
    if(!_enemyIsSpawningFlag && _spawnedEnemyCount < 25) {
        _enemyIsSpawningFlag = YES;
        int castIndex = _spawnedEnemyCount;
        
        int scheduledDelay = 2;
        int leftSideX = CGRectGetMinX(self.frame)+kEnemySpawnEdgeBufferX;
        int rightSideX = CGRectGetMaxX(self.frame)-kEnemySpawnEdgeBufferX;
        int topSideY = CGRectGetMaxY(self.frame)-kEnemySpanwEdgeBufferY;
        
        int startX = 0;
        // alternate sides for every other spawn
        if(castIndex % 2 == 0) {
            startX = leftSideX;
        } else {
            startX = rightSideX;
        }
        int startY = topSideY;
        
        // begin delay and when completed, spawn enemy
        SKAction *spacing = [SKAction waitForDuration:scheduledDelay];
        [self runAction:spacing completion:^{
            // Create & spawn the new Enemy
            _enemyIsSpawningFlag = NO;
            _spawnedEnemyCount = _spawnedEnemyCount + 1;
            
            if(castIndex % 5 == 0) {
                SKBCoin *newCoin = [SKBCoin initNewCoin:self startingPoint:CGPointMake(startX, startY) coinIndex:castIndex];
                [newCoin spawnedInScene:self];
            } else {
                SKBRatz *newEnemy = [SKBRatz initNewRatz:self startingPoint:CGPointMake(startX, startY) ratzIndex:castIndex];
                [newEnemy spawnedInScene:self];
            }
        }];
    }
}

#pragma mark - SKPhysicsContactDelegate methods
-(void)didBeginContact:(SKPhysicsContact *)contact {
    SKPhysicsBody *firstBody, *secondBody;
    
    if(contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask) {
        firstBody = contact.bodyA;
        secondBody = contact.bodyB;
    } else {
        firstBody = contact.bodyB;
        secondBody = contact.bodyA;
    }
    
    // contact body name
    NSString *firstBodyName = firstBody.node.name;
    
    // Player / sideWalls
    if (((firstBody.categoryBitMask & kPlayerCategory) != 0) && ((secondBody.categoryBitMask & kWallCategory) !=0)) {
        if([firstBodyName isEqualToString:@"player1"]) {
            if (_playerSprite.position.y > CGRectGetMaxY(self.frame)-20) {
                NSLog(@"player hit top of screen");
            } else if(_playerSprite.position.x < 20) {
                NSLog(@"player contacted left edge");
                [_playerSprite wrapPlayer:CGPointMake(self.frame.size.width-10, _playerSprite.position.y)];
            } else {
                NSLog(@"player contacted right edge");
                [_playerSprite wrapPlayer:CGPointMake(10, _playerSprite.position.y)];
            }
        }
    }
    
    // Ratz / sideWalls
    if(((firstBody.categoryBitMask & kRatzCategory) != 0) && ((secondBody.categoryBitMask & kWallCategory) !=0)) {
        SKBRatz *theRatz = (SKBRatz *)firstBody.node;
        if(theRatz.position.x < 100) {
            [theRatz wrapRatz:CGPointMake(self.frame.size.width-20, theRatz.position.y)];
        } else {
            [theRatz wrapRatz:CGPointMake(20, theRatz.position.y)];
        }
    }
    
    // Ratz / Ratz
    if(((firstBody.categoryBitMask & kRatzCategory) != 0) && ((secondBody.categoryBitMask & kRatzCategory) !=0)) {
        SKBRatz *theFirstRatz = (SKBRatz *)firstBody.node;
        SKBRatz *theSecondRatz = (SKBRatz *)secondBody.node;
        
        NSLog(@"%@ & %@ have collided...", theFirstRatz.name, theSecondRatz.name);
        
        // case first ratz to turn and change directions
        if(theFirstRatz.ratzStatus == SBRatzRunningLeft) {
            [theFirstRatz turnRight];
        } else if(theFirstRatz.ratzStatus == SBRatzRunningRight) {
            [theFirstRatz turnLeft];
        }
        
        if(theSecondRatz.ratzStatus == SBRatzRunningLeft) {
            [theSecondRatz turnRight];
        } else if(theSecondRatz.ratzStatus == SBRatzRunningRight) {
            [theSecondRatz turnLeft];
        }
    }
    
    // Coin / sidewalls
    if(((firstBody.categoryBitMask & kCoinCategory) != 0) && ((secondBody.categoryBitMask & kWallCategory) !=0)) {
        SKBCoin *theCoin = (SKBCoin *)firstBody.node;
        if(theCoin.position.x < 100) {
            [theCoin wrapCoin:CGPointMake(CGRectGetMaxX(self.frame)-10, theCoin.position.y)];
        } else {
            [theCoin wrapCoin:CGPointMake(10, theCoin.position.y)];
        }
    }
    
    // Coin / Coin
    if(((firstBody.categoryBitMask & kCoinCategory) != 0) && ((secondBody.categoryBitMask & kCoinCategory) !=0)) {
        SKBCoin *theFirstCoin = (SKBCoin *)firstBody.node;
        SKBCoin *theSecondCoin = (SKBCoin *)secondBody.node;
        
        NSLog(@"%@ & %@ have collided...", theFirstCoin.name, theSecondCoin.name);
        
        // case first ratz to turn and change directions
        if(theFirstCoin.coinStatus == SBCoinRunningLeft) {
            [theFirstCoin turnRight];
        } else if(theFirstCoin.coinStatus == SBCoinRunningRight) {
            [theFirstCoin turnLeft];
        }
        
        if(theSecondCoin.coinStatus == SBCoinRunningLeft) {
            [theSecondCoin turnRight];
        } else if(theSecondCoin.coinStatus == SBCoinRunningRight) {
            [theSecondCoin turnLeft];
        }
    }
}

#pragma mark - Private Methods
-(void)createSceneContents {
    // Initialize Enemies & Schedule
    _spawnedEnemyCount = 0;
    _enemyIsSpawningFlag = NO;
    
    // brick base
    SKSpriteNode *brickBase = [SKSpriteNode spriteNodeWithImageNamed:@"Base_600"];
    brickBase.name = @"brickBaseNode";
    brickBase.position = CGPointMake(CGRectGetMidX(self.frame), brickBase.size.height / 2);
    brickBase.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:brickBase.size];
    brickBase.physicsBody.categoryBitMask = kBaseCategory;
    brickBase.physicsBody.dynamic = NO;
    
    [self addChild:brickBase];
    
    // ledge
    SKBLedge *sceneLedge = [[SKBLedge alloc]init];
    int ledgeIndex = 0;
    
    // ledge, bottom left
    int howMany = (CGRectGetMaxX(self.frame) < 500) ? 18 : 23;
    [sceneLedge createNewSetOfLedgeNodes:self startingPoint:CGPointMake(kLedgeSideBufferSpacing, brickBase.position.y+80) withHowManyBlocks:howMany startingIndex:ledgeIndex];
    ledgeIndex += howMany;
    
    // ledge, bottom right
    [sceneLedge createNewSetOfLedgeNodes:self startingPoint:CGPointMake(CGRectGetMaxX(self.frame)-kLedgeSideBufferSpacing-((howMany-1)*kLedgeBrickSpacing), brickBase.position.y + 80) withHowManyBlocks:howMany startingIndex:ledgeIndex];
    ledgeIndex += howMany;
    
    // ledge, middle left
    howMany = (CGRectGetMaxX(self.frame) < 500) ? 6 : 8;
    [sceneLedge createNewSetOfLedgeNodes:self startingPoint:CGPointMake(CGRectGetMinX(self.frame)+kLedgeSideBufferSpacing, brickBase.position.y + 142) withHowManyBlocks:howMany startingIndex:ledgeIndex];
    ledgeIndex += howMany;
    
    // ledge, middle middle
    howMany = (CGRectGetMaxX(self.frame) < 500) ? 31 : 36;
    [sceneLedge createNewSetOfLedgeNodes:self startingPoint:CGPointMake(CGRectGetMidX(self.frame)-((howMany * kLedgeBrickSpacing) / 2), brickBase.position.y + 152) withHowManyBlocks:howMany startingIndex:ledgeIndex];
    ledgeIndex += howMany;
    
    // ledge, middle right
    howMany = (CGRectGetMaxX(self.frame) < 500) ? 6 : 9;
    [sceneLedge createNewSetOfLedgeNodes:self startingPoint:CGPointMake(CGRectGetMaxX(self.frame)-kLedgeSideBufferSpacing-((howMany-1)*kLedgeBrickSpacing), brickBase.position.y + 142) withHowManyBlocks:howMany startingIndex:ledgeIndex];
    ledgeIndex += howMany;
    
    // ledge, top left
    howMany = (CGRectGetMaxX(self.frame) < 500) ? 23 : 28;
    [sceneLedge createNewSetOfLedgeNodes:self startingPoint:CGPointMake(CGRectGetMinX(self.frame)+kLedgeSideBufferSpacing, brickBase.position.y + 224) withHowManyBlocks:howMany startingIndex:ledgeIndex];
    ledgeIndex += howMany;
    
    // ledge, top right
    [sceneLedge createNewSetOfLedgeNodes:self startingPoint:CGPointMake(CGRectGetMaxX(self.frame)-kLedgeSideBufferSpacing-((howMany-1)*kLedgeBrickSpacing), brickBase.position.y + 224) withHowManyBlocks:howMany startingIndex:ledgeIndex];
    ledgeIndex += howMany;
}

@end
