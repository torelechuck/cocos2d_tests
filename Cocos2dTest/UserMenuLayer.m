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

+(CCScene *) sceneWithWon:(BOOL)won {
    CCScene *scene = [CCScene node];
    UserMenuLayer *layer = [[[UserMenuLayer alloc] initWithWon:won] autorelease];
    [scene addChild: layer];
    return scene;
}

- (id)initWithWon:(BOOL)won {
    if ((self = [super initWithColor:ccc4(0, 0, 0, 255)])) {
        
        NSString * message;
        if (won) {
            message = @"You Won!";
        } else {
            message = @"Game Over!";
        }
        
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        CCLabelTTF * label = [CCLabelTTF labelWithString:message fontName:@"Arial" fontSize:42];
        [label setPosition:ccp(winSize.width/2, winSize.height/2)];
        [self addChild:label];
        
        CCMenuItemFont *againButton = [CCMenuItemFont itemWithString:@"Try Again"
                                                              target:self
                                                            selector:@selector(startAgain:)];
        CCMenu *againMenu = [CCMenu menuWithItems:againButton, nil];
        [againMenu setPosition:ccp(winSize.width/2, 50)];
        
        [self addChild:againMenu];
    }
    return self;
}

- (void)startAgain:(id)sender
{
    [[CCDirector sharedDirector] replaceScene:[HelloWorldLayer scene]];
}

@end
