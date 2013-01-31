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
long invincibleToLineIdx;

- (id)initWithSprite:(CCSprite*)sprt size:(int)sz position:(CGPoint)pos
{ 
    return [self initWithSprite:sprt size:sz position:pos xSpeed:100 ySpeed:0 lineIdx:0];
}

- (id)initWithSprite:(CCSprite *)sprt sourceBall:(CMBall*)ball isInOppositeDirection:(BOOL)isOpposite lineIdx:(long) lineIdx
{
    int dx = [ball xSpeed];
    if(isOpposite) dx = -dx;
    return [self initWithSprite:sprt
                           size:[ball size]/2
                       position:[[ball sprite] position]
                         xSpeed:dx
                         ySpeed:[ball ySpeed]
                        lineIdx:lineIdx];
}

-(id)initWithSprite:(CCSprite*)sprt
               size:(int)sz
           position:(CGPoint)pos
             xSpeed:(float)dx
             ySpeed:(float)dy
            lineIdx:(long)lineIdx
{
    if(self = [super init])
    {
        size = sz;
        sprite = sprt;
        xSpeed = dx;
        ySpeed = dy;
        invincibleToLineIdx = lineIdx;
        [sprite setPosition:pos];
        [sprite setScale:(float)size/2.0];
    }
    return self;
}

-(BOOL) isCollitionWithLine:(CCSprite *) line
{
    return [self isCollitionWithRect:[line boundingBox]] && line.tag != invincibleToLineIdx;
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

@end
