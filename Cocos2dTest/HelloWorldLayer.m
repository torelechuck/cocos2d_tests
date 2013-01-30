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

// Needed to obtain the Navigation Controller
#import "AppDelegate.h"

#import <tgmath.h>

#pragma mark - HelloWorldLayer

CCSprite *rock;
CCSprite *man;
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
		rock = [CCSprite spriteWithFile:@"glyph_rock_icon.png"];
        [rock setPosition:ccp([rock contentSize].width/2,200)];
        xSpeed = 100;
        ySpeed = 0;
        [self addChild:rock];
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
    double x = rock.position.x + xSpeed * dt;
    double y = rock.position.y + ySpeed * dt;
    [rock setPosition:ccp(x,y)];
    [self calculateXSpeed:x];
    [self calculateYSpeed:y withDelta:dt];
}

-(void) calculateXSpeed:(double)x
{
    double rockCenter = [rock contentSize].width / 2.0;
    double maxX = [[CCDirector sharedDirector] winSize].width;
    if((xSpeed > 0 && x > maxX - rockCenter) || (xSpeed < 0 && x < 0 + rockCenter))
    {
        xSpeed = -xSpeed;
    }
}

-(void) calculateYSpeed:(double)y withDelta:(ccTime)dt
{
    double rockCenter = [rock contentSize].height / 2.0;
    if(y < 0 + rockCenter && ySpeed < 0)
    {
        ySpeed = -ySpeed;
    }
    else
    {
        ySpeed = ySpeed - 300*dt;
    }
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
    if (CGRectIntersectsRect([rock boundingBox], [man boundingBox]))
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
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
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
