//
//  SKBScores.m
//  Sewer Brothers
//
//  Created by Eric Internicola on 4/28/15.
//  Copyright (c) 2015 iColaSoft. All rights reserved.
//

#import "SKBScores.h"

@implementation SKBScores

-(void)createScoreNumberTextures {
    NSMutableArray *textureFileArray = [NSMutableArray arrayWithArray:@[kTextNumber0FileName, kTextNumber1FileName, kTextNumber2FileName, kTextNumber3FileName, kTextNumber4FileName, kTextNumber5FileName, kTextNumber6FileName, kTextNumber7FileName, kTextNumber8FileName, kTextNumber9FileName]];
    NSMutableArray *textureArray = [NSMutableArray arrayWithCapacity:textureFileArray.count];
    for (NSString *fileName in textureFileArray) {
        SKTexture *texture = [SKTexture textureWithImageNamed:fileName];
        [textureArray addObject:texture];
    }
    _arrayOfNumberTextures = [NSArray arrayWithArray:textureArray];
    NSLog(@"NumberTextures created...");
}

-(void)createScoreNode:(SKScene *)whichScene {
    if(!_arrayOfNumberTextures) {
        [self createScoreNumberTextures];
    }
    
    SKTexture *headerTexture = [SKTexture textureWithImageNamed:kTextPlayerHeaderFileName];
    CGPoint startWhere = CGPointMake(CGRectGetMinX(whichScene.frame)+kScorePlayer1DistanceFromLeft, CGRectGetMaxY(whichScene.frame)-kScoreDistanceFromTop);
    
    // Header
    SKSpriteNode *header = [SKSpriteNode spriteNodeWithTexture:headerTexture];
    header.name = @"score_player_header";
    header.position = startWhere;
    header.xScale = 2;
    header.yScale = 2;
    header.physicsBody.dynamic = NO;
    [whichScene addChild:header];
    
    // Score, 5-digits
    SKTexture *textNumber0Texture = [SKTexture textureWithImageNamed:kTextNumber0FileName];
    for(int index=1; index <= kScoreDigitCount; index++) {
        SKSpriteNode *zero = [SKSpriteNode spriteNodeWithTexture:textNumber0Texture];
        zero.name = [NSString stringWithFormat:@"score_player_digit%d", index];
        zero.position = CGPointMake(startWhere.x+20+(16*index), CGRectGetMaxY(whichScene.frame)-kScoreDistanceFromTop);
        zero.xScale = 2;
        zero.yScale = 2;
        zero.physicsBody.dynamic = NO;
        [whichScene addChild:zero];
    }
}

-(void)updateScore:(SKScene *)whichScene newScore:(int)theScore {
    NSString *numberString = [NSString stringWithFormat:@"00000%d", theScore];
    NSString *substring = [numberString substringFromIndex:[numberString length]-5];
    
    for(int index=1; index<=5; index++) {
        [whichScene enumerateChildNodesWithName:[NSString stringWithFormat:@"score_player_digit%d", index] usingBlock:^(SKNode *node, BOOL *stop) {
            NSString *charAtIndex = [substring substringWithRange:NSMakeRange(index-1, 1)];
            int charIntValue = [charAtIndex intValue];
            SKTexture *digitTexture = [_arrayOfNumberTextures objectAtIndex:charIntValue];
            SKAction *newDigit = [SKAction animateWithTextures:@[digitTexture] timePerFrame:0.1];
            [node runAction:newDigit];
        }];
    }
}
@end
