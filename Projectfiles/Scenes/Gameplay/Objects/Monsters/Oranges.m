//
//  Oranges.m
//  Fat
//
//  Created by Shalin Shah on 7/15/13.
//  Copyright (c) 2013 MakeGamesWithUs Inc. All rights reserved.
//

#import "Oranges.h"
#import "GameMechanics.h"

@implementation Oranges

- (id)initWithMonsterPicture
{
    self = [super initWithFile:@"orange.png"];
    if (self)
    {
        self.animationFrames = [NSMutableArray array];
        [self scheduleUpdate];
    }
    
    return self;
}


- (void)gotCollected {
    
    CCParticleSystem* system = [CCParticleSystemQuad particleWithFile:@"fx-explosion.plist"];
    // Set some parameters that can't be set in Particle Designer
    system.positionType = kCCPositionTypeFree;
    system.autoRemoveOnFinish = YES;
    system.position = self.position;
    [[[GameMechanics sharedGameMechanics] gameScene] addChild:system];
    
    // mark as unvisible and move off screen
    self.visible = FALSE;
    self.position = ccp(-MAX_INT, 0);
    [[GameMechanics sharedGameMechanics] game].fatness = [[GameMechanics sharedGameMechanics] game].fatness -= 3;
    [[GameMechanics sharedGameMechanics] game].foodsCollected = [[GameMechanics sharedGameMechanics] game].foodsCollected += 1;
}

@end
