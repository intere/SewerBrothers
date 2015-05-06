//
//  AppDelegate.h
//  Sewer Brothers
//
//  Created by Eric Internicola on 4/25/15.
//  Copyright (c) 2015 iColaSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kCastOfCharactersFileName @"CastOfCharacters"

#define kEnemySpawnEdgeBufferX 30
#define kEnemySpawnEdgeBufferY 30

// Global project constants
static const uint32_t kPlayerCategory = 0x1 << 0;
static const uint32_t kRatzCategory = 0x1 << 1;
static const uint32_t kCoinCategory = 0x1 << 2;
static const uint32_t kBaseCategory = 0x1 << 3;
static const uint32_t kWallCategory = 0x1 << 4;
static const uint32_t kLedgeCategory = 0x1 << 5;
static const uint32_t kPipeCategory = 0x1 << 6;
static const uint32_t kGatorzCategory = 0x1 << 7;

typedef enum : uint8_t {
    SKBEnemyTypeCoin = 0,
    SKBEnemyTypeRatz,
    SKBEnemyTypeGatorz
} SKBEnemyTypes;

@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property (strong, nonatomic) UIWindow *window;
@end

