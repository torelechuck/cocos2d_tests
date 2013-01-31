//
//  CMLevel.m
//  Cocos2dTest
//
//  Created by Tore Saue on 31.01.13.
//
//

#import "CMBallCreator.h"
#import "CMBall.h"
#import "cocos2d.h"

@implementation CMBallCreator

static NSString * const BALL_FILE_NAME = @"glyph_rock_icon.png";

+(NSMutableArray*) createBallsForLevel:(int)levelNumber
{
    NSMutableArray *balls = [[[NSMutableArray alloc] init] autorelease];
    if(levelNumber == 1)
    {
        CCSprite *ballSprite = [CCSprite spriteWithFile:BALL_FILE_NAME];
        CGPoint ballPos = ccp([ballSprite boundingBox].origin.x/2,200);
        [balls addObject:[[CMBall alloc] initMovingRightWithSprite:ballSprite size:2 position:ballPos]];
    }
    if(levelNumber == 2 || levelNumber == 3 || levelNumber == 4)
    {
        CCSprite *ballSprite = [CCSprite spriteWithFile:BALL_FILE_NAME];
        CGPoint ballPos = ccp(200,200);
        [balls addObject:[[CMBall alloc] initMovingLeftWithSprite:ballSprite size:4 position:ballPos]];
    }
    if(levelNumber == 3)
    {
        CCSprite *ballSprite = [CCSprite spriteWithFile:BALL_FILE_NAME];
        CGPoint ballPos = ccp(300,300);
        [balls addObject:[[CMBall alloc] initMovingRightWithSprite:ballSprite size:2 position:ballPos]];
    }
    if(levelNumber == 4)
    {
        CCSprite *ballSprite = [CCSprite spriteWithFile:BALL_FILE_NAME];
        CGPoint ballPos = ccp(350,300);
        [balls addObject:[[CMBall alloc] initMovingRightWithSprite:ballSprite size:4 position:ballPos]];
    }
    return balls;
}

+(NSMutableArray*) splitBall:(CMBall*)ball withLineNumber:(int)lineNumber
{
    NSMutableArray *res = [[[NSMutableArray alloc] init] autorelease];
    CCSprite *sprite1 = [CCSprite spriteWithFile:BALL_FILE_NAME];
    CMBall *ball1 = [[[CMBall alloc] initWithSprite:sprite1
                                        sourceBall:ball
                             isInOppositeDirection:false
                                           lineIdx:lineNumber] autorelease];
    [res addObject:ball1];
    CCSprite *sprite2 = [CCSprite spriteWithFile:BALL_FILE_NAME];
    CMBall *ball2 = [[[CMBall alloc] initWithSprite:sprite2
                                        sourceBall:ball
                            isInOppositeDirection:true
                                    lineIdx:lineNumber] autorelease];
    [res addObject:ball2];
    return res;
}

@end
