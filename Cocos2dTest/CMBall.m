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
NSString *fileName;

- (id)initWithFile:(NSString*)file size:(int)sz position:(CGPoint)pos
{
    return [self initWithFile:file size:sz position:pos xSpeed:100 ySpeed:0];
}

-(id)initWithFile:(NSString *)file size:(int)sz position:(CGPoint)pos xSpeed:(float)dx ySpeed:(float)dy
{
    if(self = [super init])
    {
        fileName = file;
        size = sz;
        sprite = [CCSprite spriteWithFile:file];
        xSpeed = dx;
        ySpeed = dy;
        [sprite setPosition:pos];
        [sprite setScale:(float)size/2.0];
    }
    return self;
}

-(BOOL) isCollitionWithRect:(CGRect) rect
{
    return CGRectIntersectsRect([[self sprite] boundingBox], rect);
}

-(NSMutableArray*) splitBall
{
    NSMutableArray *newBalls = [[NSMutableArray alloc] init];
    if(size == 1) return newBalls;//too small to split, return empty array
    CMBall *ball1 = [[CMBall alloc] initWithFile:fileName
                                                size:size/2
                                            position:[sprite position]
                                              xSpeed:xSpeed
                                              ySpeed:ySpeed];
    CMBall *ball2 = [[CMBall alloc] initWithFile:fileName
                                                 size:size/2
                                             position:[sprite position]
                                               xSpeed:-xSpeed
                                               ySpeed:ySpeed];
    [newBalls addObject:ball1];
    [newBalls addObject:ball2];
    return newBalls;
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
