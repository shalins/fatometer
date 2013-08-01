//
//  GhostMonster.m
//  _MGWU-SideScroller-Template_
//
//  Created by Benjamin Encz on 5/16/13.
//  Copyright (c) 2013 MakeGamesWithUs Inc. Free to use for all purposes.
//

#import "Sandwich.h"
#import "GameMechanics.h"
#import "GameplayLayer.h"

@implementation Sandwich

- (id)initWithMonsterPicture
{
    self = [super initWithFile:@"sandwich.png"];
    if (IS_IPHONE_5 || IS_IPOD_5 || IS_IPOD || IS_IPHONE) {
        self.scale = 1.0f;
    } else if (IS_IPAD) {
        self.scale = 1.3f;
    } else if (IS_IPAD_RETINA) {
        self.scale = 1.6f;
    }
    if (self)
    {
        self.initialHitPoints = 1;
        self.animationFrames = [NSMutableArray array];
        [self scheduleUpdate];
    }
    
    return self;
}

- (void)spawn
{
	// Select a spawn location just outside the right side of the screen, with random y position
	CGRect screenRect = [[CCDirector sharedDirector] screenRect];
	CGSize spriteSize = [self contentSize];
	float xPos = screenRect.size.width + spriteSize.width * 0.5f;
    //	float yPos = CCRANDOM_0_1() * (0.25 * screenRect.size.height - spriteSize.height) + spriteSize.height * 0.5f;
    float yPos = 0.21 * screenRect.size.height - spriteSize.height;
	self.position = CGPointMake(xPos, yPos);
    
    if (IS_IPHONE_5 || IS_IPOD_5 || IS_IPOD || IS_IPHONE) {
        float xPos = screenRect.size.width + spriteSize.width * 0.5f;
        float yPos = 0.21 * screenRect.size.height - spriteSize.height;
        self.position = CGPointMake(xPos, yPos);

    } else if (IS_IPAD) {
        float xPos = screenRect.size.width + spriteSize.width * 0.5f;
        float yPos = 0.10 * screenRect.size.height - spriteSize.height;
        self.position = CGPointMake(xPos, yPos);
    } else if (IS_IPAD_RETINA) {
        float xPos = screenRect.size.width + spriteSize.width * 0.5f;
        float yPos = 0.8 * screenRect.size.height - spriteSize.height;
        self.position = CGPointMake(xPos, yPos);
    }
    
    self.visible = YES;
	// reset health
	self.hitPoints = self.initialHitPoints;
}

- (void)gotCollected
{
    
    CCParticleSystem* system = [CCParticleSystemQuad particleWithFile:@"fx-explosion.plist"];
    system.positionType = kCCPositionTypeFree;
    system.autoRemoveOnFinish = YES;
    system.position = self.position;
    [[[GameMechanics sharedGameMechanics] gameScene] addChild:system];
    
    //    CCSprite *coinSprite = [CCSprite spriteWithFile:@"coin.png"];
    //    coinSprite.position = self.position;
    //    [[[GameMechanics sharedGameMechanics] gameScene] addChild:coinSprite];
    //    CGSize screenSize = [[GameMechanics sharedGameMechanics] gameScene].contentSize;
    //    CGPoint coinDestination = ccp(21, screenSize.height-27);
    //    CCMoveTo *move = [CCMoveTo actionWithDuration:2.f position:coinDestination];
    //    id easeMove = [CCEaseBackInOut actionWithAction:move];
    //
    //    CCAction *movementCompleted = [CCCallBlock actionWithBlock:^{
    //        // this code is called when the movement is completed, then we we want to clean up the coinSprite
    //        coinSprite.visible = FALSE;
    //        [coinSprite removeFromParent];
    //        coinSprite.zOrder = MAX_INT -1;
    //    }];
    //
    //    CCSequence *coinMovementSequence = [CCSequence actions:easeMove, movementCompleted, nil];
    //
    //    [coinSprite runAction: coinMovementSequence];
    
    // mark as unvisible and move off screen
    self.visible = FALSE;
    self.position = ccp(-MAX_INT, 0);
    [[GameMechanics sharedGameMechanics] game].fatness += 19;
    [[GameMechanics sharedGameMechanics] game].foodsCollected = [[GameMechanics sharedGameMechanics] game].foodsCollected += 1;
}

- (void)update:(ccTime)delta
{
    // only execute the block, if the game is in 'running' mode
    if ([[GameMechanics sharedGameMechanics] gameState] == GameStateRunning)
    {
        [self updateRunningMode:delta];
    }
}

- (void)updateRunningMode:(ccTime)delta
{
    // apply background scroll speed
    float xVelocity = self.velocity.x;
    float backgroundScrollSpeedX = [[GameMechanics sharedGameMechanics] backGroundScrollSpeedX];
    
    xVelocity -= backgroundScrollSpeedX;
    CGPoint combinedVelocity = ccp(xVelocity, self.velocity.y);
    // move the monster until it leaves the left edge of the screen
    if (self.position.x > (self.contentSize.width * (-1)))
    {
        [self setPosition:ccpAdd(self.position, ccpMult(combinedVelocity,delta))];
    }
}

@end