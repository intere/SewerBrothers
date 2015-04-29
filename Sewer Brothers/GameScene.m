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
        
        // add backdrop image to screen
        [self addChild:backdrop];
        
        // add surfaces to screen
        [self createSceneContents];
        
        // compose cast of characters from propertyList
        [self loadCastOfCharacters];
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
    if(!_enemyIsSpawningFlag && _spawnedEnemyCount < _castTypeArray.count) {
        _enemyIsSpawningFlag = YES;
        int castIndex = _spawnedEnemyCount;
        
        int leftSideX = CGRectGetMinX(self.frame)+kEnemySpawnEdgeBufferX;
        int rightSideX = CGRectGetMaxX(self.frame)-kEnemySpawnEdgeBufferX;
        int topSideY = CGRectGetMaxY(self.frame)-kEnemySpanwEdgeBufferY;
        
        // from castOfCharacters file, the sprite Type
        NSNumber *theNumber = [_castTypeArray objectAtIndex:castIndex];
        SKBEnemyTypes castType = [theNumber intValue];
        
        // from castOfCharacters file, the sprite Delay
        theNumber = [_castDelayArray objectAtIndex:castIndex];
        int castDelay = [theNumber intValue];
        
        // from castOfCharacters file, the sprite startXindex
        int startX = 0;
        // determine which side
        theNumber = [_castStartXindexArray objectAtIndex:castIndex];
        
        if([theNumber intValue]==0) {
            startX = leftSideX;
        } else {
            startX = rightSideX;
        }
        int startY = topSideY;
        
        // begin delay and when completed, spawn enemy
        SKAction *spacing = [SKAction waitForDuration:castDelay];
        [self runAction:spacing completion:^{
            // Create & spawn the new Enemy
            _enemyIsSpawningFlag = NO;
            _spawnedEnemyCount = _spawnedEnemyCount + 1;
            
            if(castType == SKBEnemyTypeCoin) {
                SKBCoin *newCoin = [SKBCoin initNewCoin:self startingPoint:CGPointMake(startX, startY) coinIndex:castIndex];
                [newCoin spawnedInScene:self];
            } else if(castType == SKBEnemyTypeRatz) {
                SKBRatz *newEnemy = [SKBRatz initNewRatz:self startingPoint:CGPointMake(startX, startY) ratzIndex:castIndex];
                [newEnemy spawnedInScene:self];
            }
        }];
    }
}

-(void)loadCastOfCharacters {
    // load cast from plist file
    NSString *path = [[NSBundle mainBundle] pathForResource:kCastOfCharactersFileName ofType:@"plist"];
    NSDictionary *plistDictionary = [NSDictionary dictionaryWithContentsOfFile:path];
    
    if(plistDictionary) {
        NSDictionary *levelDictionary = [plistDictionary valueForKey:@"Level"];
        if(levelDictionary) {
            NSArray *levelOneArray = [levelDictionary valueForKey:@"One"];
            if(levelOneArray) {
                NSDictionary *enemyDictionary = nil;
                NSMutableArray *newTypeArray = [NSMutableArray arrayWithCapacity:levelOneArray.count];
                NSMutableArray *newDelayArray = [NSMutableArray arrayWithCapacity:levelOneArray.count];
                NSMutableArray *newStartArray = [NSMutableArray arrayWithCapacity:levelOneArray.count];
                NSNumber *rawType, *rawDelay, *rawStartXindex;
                int enemyType, spawnDelay, startXindex = 0;
                
                for(int index=0; index<levelOneArray.count; index++) {
                    enemyDictionary = [levelOneArray objectAtIndex:index];
                    
                    // NSNumbers from dictionary
                    rawType = [enemyDictionary valueForKey:@"Type"];
                    rawDelay = [enemyDictionary valueForKey:@"Delay"];
                    rawStartXindex = [enemyDictionary valueForKey:@"StartXindex"];
                    
                    // local integer values
                    enemyType = [rawType intValue];
                    spawnDelay = [rawDelay intValue];
                    startXindex = [rawStartXindex intValue];
                    
                    // long term storage
                    [newTypeArray addObject:rawType];
                    [newDelayArray addObject:rawDelay];
                    [newStartArray addObject:rawStartXindex];
                    
                    NSLog(@"%d, %d, %d, %d", index, enemyType, spawnDelay, startXindex);
                }
                
                // store data locally
                _castTypeArray = [NSArray arrayWithArray:newTypeArray];
                _castDelayArray = [NSArray arrayWithArray:newDelayArray];
                _castStartXindexArray = [NSArray arrayWithArray:newStartArray];
            } else {
                NSLog(@"No levelOneArray");
            }
        } else {
            NSLog(@"No levelDictionary");
        }
    } else {
        NSLog(@"No plist loaded from '%@'", path);
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
    
    // Coin / Ratz
    if(((firstBody.categoryBitMask & kRatzCategory) != 0) && ((secondBody.categoryBitMask & kCoinCategory) !=0)) {
        SKBRatz *theRatz = (SKBRatz *)firstBody.node;
        SKBCoin *theCoin = (SKBCoin *)secondBody.node;
        
        NSLog(@"%@ & %@ have collided...", theCoin.name, theRatz.name);
        
        // cause coin to turn and change directions
        if(theCoin.coinStatus == SBCoinRunningLeft) {
            [theCoin turnRight];
        } else if(theCoin.coinStatus == SBCoinRunningRight) {
            [theCoin turnLeft];
        }
        
        // cause Ratz to turn and change directions
        if(theRatz.ratzStatus == SBRatzRunningLeft) {
            [theRatz turnRight];
        } else if(theRatz.ratzStatus == SBRatzRunningRight) {
            [theRatz turnLeft];
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
    
    // Scoring
    SKBScores *sceneScores = [[SKBScores alloc]init];
    [sceneScores createScoreNode:self];
    _scoreDisplay = sceneScores;
    _playerScore = 85942;
    [_scoreDisplay updateScore:self newScore:_playerScore];
}

@end
