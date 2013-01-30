//
//  HelloWorldLayer.m
//  Cocos2dTest
//
//  Created by Tore Saue on 27.01.13.
//  Copyright __MyCompanyName__ 2013. All rights reserved.
//


// Import the interfaces
#import "HelloWorldLayer.h"

#import "GameOverLayer.h"

#import "CMBall.h"

// Needed to obtain the Navigation Controller
#import "AppDelegate.h"

#import <tgmath.h>

#pragma mark - HelloWorldLayer

CCSprite *man;
CMBall *ball;
double xSpeed;
double ySpeed;

// HelloWorldLayer implementation
@implementation HelloWorldLayer

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [HelloWorldLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if( (self=[super initWithColor:ccc4(80,128,255,255)]) ) {
        CCSprite *ballspr = [CCSprite spriteWithFile:@"glyph_rock_icon.png"];
        CGPoint ballPos = ccp([ballspr contentSize].width/2,200);
        ball = [[CMBall alloc] initWithSprite:ballspr size:2 position:ballPos];
        [self addChild:[ball sprite]];
        [self schedule:@selector(nextFrame:)];
        man = [CCSprite spriteWithFile:@"coffeeman.png"];
        [man setPosition:ccp(200,[man contentSize].width/2)];
        [self addChild:man];
        [self setIsTouchEnabled:YES];
        [self schedule:@selector(update:)];
    }
	return self;
}

-(void) nextFrame:(ccTime)dt
{
    [ball moveWithDelta:dt];
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint newLocation = ccp([self convertTouchToNodeSpace:touch].x, [man position].y);
    CGFloat winWidth = [[CCDirector sharedDirector] winSize].width;
    CGFloat velocity = winWidth/2; //2 seconds from one end to the other
    CGFloat distance = fabs([man position].x - newLocation.x);
    CGFloat duration = distance/velocity;
    [man runAction:[CCMoveTo actionWithDuration:duration position:newLocation]];
}

- (void)update:(ccTime)dt
{
    if ([ball isCollitionWithRect:[man boundingBox]])
    {
        CCScene *gameOverScene = [GameOverLayer sceneWithWon:NO];
        [self runAction:
         [CCSequence actions:
          [CCDelayTime actionWithDuration:0.1],
          [CCCallBlockN actionWithBlock:^(CCNode *node) {
             [[CCDirector sharedDirector] replaceScene:gameOverScene];
         }],
          nil]];
    }
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
    [ball dealloc];
    ball = nil;
	[super dealloc];
}

#pragma mark GameKit delegate

-(void) achievementViewControllerDidFinish:(GKAchievementViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}

-(void) leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}
@end
