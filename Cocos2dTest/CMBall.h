//
//  CMBall.h
//  Cocos2dTest
//
//  Created by Tore Saue on 30.01.13.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface CMBall : NSObject

@property (nonatomic, readonly) int size;
@property (nonatomic, readonly) float xSpeed;
@property (nonatomic, readonly) float ySpeed;
@property (nonatomic, readonly, assign) CCSprite *sprite;

- (id)initWithSprite:(CCSprite *)sprite size:(int)size position:(CGPoint)pos;
- (void) moveWithDelta:(ccTime)dt;
- (BOOL) isCollitionWithRect:(CGRect) rect;

@end
