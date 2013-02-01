//
//  GameOverLayer.m
//  Cocos2dTest
//
//  Created by Tore Saue on 30.01.13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "UserMenuLayer.h"
#import "HelloWorldLayer.h"

@implementation UserMenuLayer

+(CCScene *) sceneGameOver {
    return [UserMenuLayer sceneForLevel:0];
}

+(CCScene *) sceneForLevel:(int)level {
    CCScene *scene = [CCScene node];
    UserMenuLayer *layer = [[[UserMenuLayer alloc] initForLevel:level] autorelease];
    [scene addChild: layer];
    return scene;
}

- (id)initForLevel:(int)level {
    if ((self = [super initWithColor:ccc4(0, 0, 0, 255)])) {
        
        NSString *message;
        NSString *buttonText;
        if (level == 4) {
            message = @"You Won!";
            buttonText = @"Try Again";
        } else if(level == 0) {
            message = @"Game Over!";
            buttonText = @"Try Again";
        } else {
            message = [NSString stringWithFormat:@"Level %i Cleared!", level];
            buttonText = @"Next level";
        }
        
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        CCLabelTTF * label = [CCLabelTTF labelWithString:message fontName:@"Arial" fontSize:42];
        [label setPosition:ccp(winSize.width/2, winSize.height/2)];
        [self addChild:label];
        
        CCMenuItemFont *button = [CCMenuItemFont itemWithString:buttonText
                                                              target:self
                                                            selector:@selector(startAgain:)];
        CCMenu *menu = [CCMenu menuWithItems:button, nil];
        [menu setPosition:ccp(winSize.width/2, 50)];
        
        [self addChild:menu];
    }
    return self;
}

- (void)startAgain:(id)sender
{
    [[CCDirector sharedDirector] replaceScene:[HelloWorldLayer scene]];
}

@end
