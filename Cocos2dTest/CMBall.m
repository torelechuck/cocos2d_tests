//
//  CMBall.m
//  Cocos2dTest
//
//  Created by Tore Saue on 30.01.13.
//
//

#import "CMBall.h"
#import "cocos2d.h"

@implementation CMBall

@synthesize size, xSpeed, ySpeed, sprite;

- (id)initWithSprite:(CCSprite*)sprt size:(int)sz position:(CGPoint)pos
{
    if(self = [super init])
    {
        size = sz;
        sprite = sprt;
        xSpeed = 100;
        ySpeed = 0;
        [sprite setPosition:pos];
        [sprite setScale:(float)size/2.0];
    }
    return self;
}

-(BOOL) isCollitionWithRect:(CGRect) rect
{
    return CGRectIntersectsRect([[self sprite] boundingBox], rect);
}

-(void) moveWithDelta:(ccTime)dt
{
    double x = [self sprite].position.x + [self xSpeed] * dt;
    double y = [self sprite].position.y + [self ySpeed] * dt;
    [[self sprite] setPosition:ccp(x,y)];
    [self calculateXSpeed:x];
    [self calculateYSpeed:y withDelta:dt];
}

-(void) calculateXSpeed:(double)x
{
    double xCenter = [[self sprite] contentSize].width / 2.0;
    double maxX = [[CCDirector sharedDirector] winSize].width;
    if(([self xSpeed] > 0 && x > maxX - xCenter) || ([self xSpeed] < 0 && x < 0 + xCenter))
    {
        xSpeed = - xSpeed;
    }
}

-(void) calculateYSpeed:(double)y withDelta:(ccTime)dt
{
    double yCenter = [[self sprite] contentSize].height / 2.0;
    if(y < 0 + yCenter && [self ySpeed] < 0)
    {
        ySpeed = -ySpeed;
    }
    else
    {
        ySpeed = ySpeed - 300 * dt;
    }
}

- (void) dealloc
{
    sprite = nil;
	[super dealloc];
}

@end
