//
//  GameOverLayer.h
//  Cocos2dTest
//
//  Created by Tore Saue on 30.01.13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface UserMenuLayer : CCLayerColor {
    
}

+(CCScene *) sceneGameOver;
+(CCScene *) sceneForLevel:(int)level;

@end
