//
//  CHShareManager.h
//  isoccer
//
//  Created by Seamus on 9/11/12.
//  Copyright (c) 2012 Chlova. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WBEngine.h"
#define kWBAppkey @"2396343608"
#define kWBSecret @"bb5bdc7df7609a13ffdf7201c32de2b0"
#define kQQAppkey @"100304947"
#define kQQSecret @""
#define kSinaSSOUrl @"sinaweibosso://login"

@interface CHShareManager : NSObject<WBEngineDelegate>
{
    WBEngine *sinaEngine;
    WBEngine *qqEngine;
    
    UIViewController *vc;
    SEL sel_success,sel_failed;
    
}

+(CHShareManager *)mainManager;
- (void)handleOpenURL:(NSURL *)_url;
- (BOOL)sinaIsVailed;
- (BOOL)qqIsVailed;
//- (void)getProfile:(NSString *)_type vc:(UIViewController *)_vc;
- (void)sendWeibo:(NSString *)_status image:(UIImage *)_img type:(NSString *)_type vc:(UIViewController *)_vc finish:(SEL)_success failed:(SEL)_failed;
- (void)showLoginOnViewController:(UIViewController *)_vc type:(NSString *)_type finish:(SEL)_success failed:(SEL)_failed;
@end
