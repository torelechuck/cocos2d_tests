//
//  CMLevel.h
//  Cocos2dTest
//
//  Created by Tore Saue on 31.01.13.
//
//

#import <Foundation/Foundation.h>
#import "CMBall.h"

@interface CMBallCreator : NSObject

+(NSMutableArray*) createBallsForLevel:(int)levelNumber;
+(NSMutableArray*) splitBall:(CMBall*)ball withLineNumber:(int)lineNumber;
@end
