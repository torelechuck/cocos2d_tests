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
#import "CMBallCreator.h"

// Needed to obtain the Navigation Controller
#import "AppDelegate.h"

#import <tgmath.h>

#pragma mark - HelloWorldLayer

CCSprite *man;
NSMutableArray *_balls;
NSMutableArray *_lines;
double xSpeed;
double ySpeed;
static NSString * const BALL_FILE_NAME = @"glyph_rock_icon.png";
long currLineIdx;

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
	if( (self=[super initWithColor:ccc4(80,128,255,255)]) ) {
        
        _balls = [[NSMutableArray alloc] init];
        for(CMBall *ball in [CMBallCreator createBallsForLevel:4])
        {
         [self addBall:ball];
        }
        
        man = [CCSprite spriteWithFile:@"coffeeman.png"];
        [man setPosition:ccp(200,[man contentSize].width/2)];
        [self addChild:man];
        
        _lines = [[NSMutableArray alloc] init];
        currLineIdx = 1;
        
        [self setIsTouchEnabled:YES];
        [self schedule:@selector(nextFrame:)];
    }
	return self;
}

-(void) addBall:(CMBall*)ball
{
    [_balls addObject:ball];
    [self addChild:[ball sprite]];
}

-(void) removeBall:(CMBall*)ball
{
    [_balls removeObject:ball];
    [self removeChild:[ball sprite] cleanup:YES];
}

-(void) nextFrame:(ccTime)dt
{
    [self moveBalls:dt];
    if([self checkIfGameOver]) return;
    [self handleBallHits:dt];
}

-(void) moveBalls:(ccTime)dt
{
    for(CMBall *ball in _balls)
    {
        [ball moveWithDelta:dt];
    }
}

-(BOOL) checkIfGameOver
{
    for (CMBall *ball in _balls)
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
            return true;
        }
    }
    return false;
}

-(void) handleBallHits:(ccTime)dt
{    
    NSMutableArray *newBalls = [[NSMutableArray alloc] init];
    NSMutableArray *deletedBalls = [[NSMutableArray alloc] init];
    for (CMBall *ball in _balls)
    {
        for (CCSprite *line in _lines)
        {
            if ([ball isCollitionWithLine:line])
            {
                if([ball size] > 1)
                {
                    [newBalls addObjectsFromArray:[CMBallCreator splitBall:ball withLineNumber:[line tag]]];
                }
                [deletedBalls addObject:ball];
            }
        }
    }
    for(CMBall *ball in deletedBalls)
    {
        [self removeBall:ball];
    }
    for(CMBall *ball in newBalls)
    {
        [self addBall:ball];
    }
    [newBalls release];
    [deletedBalls release];
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint touchLoc = ccp([self convertTouchToNodeSpace:touch].x, [self convertTouchToNodeSpace:touch].y);
    if(CGRectContainsPoint([man boundingBox], touchLoc))
    {
        [self throwLine:touchLoc];
    }
    else
    {
        [self moveCoffeeMan:touchLoc];
    }
}

-(void)moveCoffeeMan:(CGPoint)location
{
    CGPoint newLocation = ccp(location.x, [man position].y);
    CGFloat winWidth = [[CCDirector sharedDirector] winSize].width;
    CGFloat velocity = winWidth/2; //2 seconds from one end to the other
    CGFloat distance = fabs([man position].x - newLocation.x);
    CGFloat duration = distance/velocity;
    [man runAction:[CCMoveTo actionWithDuration:duration position:newLocation]];
}

-(void)throwLine:(CGPoint)location
{
    CCSprite *line = [CCSprite spriteWithFile:@"line1.png"];
    line.tag = currLineIdx;
    currLineIdx++;
    [self addChild:line];
    [_lines addObject:line];
    [line setScaleY:100];
    CGFloat lineCentreY = [line contentSize].height * [line scaleY] / 2;
    [line setPosition:ccp(location.x, -lineCentreY)];
    CGFloat winHeight = [[CCDirector sharedDirector] winSize].height;
    CGPoint newPos = ccp([line position].x, [line position].y + winHeight);
    CCCallBlockN *lineShotDone = [CCCallBlockN actionWithBlock:^(CCNode *node) {
        [_lines removeObject:node];
        [node removeFromParentAndCleanup:YES];
    }];
    [line runAction:[CCSequence actions:
                     [CCMoveTo actionWithDuration:1 position:newPos],
                     [CCDelayTime actionWithDuration:0.2],
                     lineShotDone,
                     nil]];
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
    [_balls release];
    _balls = nil;
    [_lines release];
    _lines = nil;
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
