//
//  CHShareManager.m
//  isoccer
//
//  Created by Seamus on 9/11/12.
//  Copyright (c) 2012 Chlova. All rights reserved.
//

#import "CHShareManager.h"
#import "URLParser.h"


@implementation CHShareManager
static CHShareManager *_console;

+(CHShareManager *)mainManager
{
    if (nil == _console) {
        _console = [[CHShareManager alloc] init];
    }
    
    return _console;
}

- (id)init
{
    self = [super init];
    if (self) {
        sinaEngine = [[WBEngine alloc] initWithAppKey:kWBAppkey appSecret:kWBSecret];
        sinaEngine.snsType = @"sina";
//        [sinaEngine setRootViewController:self];
        [sinaEngine setDelegate:self];
//        [sinaEngine setRedirectURI:@"www.qq.com"];
        [sinaEngine setIsUserExclusive:NO];
        
//        [sinaEngine logOut];
        
        qqEngine = [[WBEngine alloc] initWithAppKey:kQQAppkey appSecret:kQQSecret];
        qqEngine.snsType = @"qq";
        //        [sinaEngine setRootViewController:self];
        [qqEngine setDelegate:self];
        [qqEngine setRedirectURI:@"qq.com"];
        [qqEngine setIsUserExclusive:NO];
        
//        [qqEngine logOut];
        
    }
    return self;
}

- (void)dealloc
{
    [sinaEngine release];
    sinaEngine = nil;
    [qqEngine release];
    qqEngine = nil;
    [vc release];
    vc = nil;
    [super dealloc];
}


#pragma mark -

- (BOOL)sinaIsVailed
{
    return [sinaEngine isLoggedIn] && ![sinaEngine isAuthorizeExpired];
}

- (BOOL)qqIsVailed
{
    return [qqEngine isLoggedIn] && ![qqEngine isAuthorizeExpired];
}

- (void)showLoginOnViewController:(UIViewController *)_vc type:(NSString *)_type finish:(SEL)_success failed:(SEL)_failed
{
    
    
    [vc release];
    vc = nil;
    vc = [_vc retain];
    
    sel_success = _success;
    sel_failed = _failed;
    
    WBEngine *e = nil;
    if ([_type isEqualToString:@"sina"]) {
        e = sinaEngine;
//        e.redirectURI = @"oauth://minroad.com"
    }
    else if ([_type isEqualToString:@"qq"])
    {
        e = qqEngine;
    }
    
//    [e setRootViewController:vc];
    
    if ([_type isEqualToString:@"sina"]) {
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:kSinaSSOUrl]]) {
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?client_id=%@&redirect_uri=%@&callback_uri=%@",kSinaSSOUrl,kWBAppkey,@"http://",[NSString stringWithFormat:@"wb%@://minroad.com",kWBAppkey]]];
            [[UIApplication sharedApplication] openURL:url];
            return;
        }
    }
    
    [e logIn];
}

//- (void)getProfile:(NSString *)_type vc:(UIViewController *)_vc
//{
//    [vc release];
//    vc = nil;
//    vc = [_vc retain];
//    
//    if ([_type isEqualToString:@"sina"]) {
//        [sinaEngine loadRequestWithMethodName:@"users/show.json"
//                                   httpMethod:@"GET"
//                                       params:@{@"uid":sinaEngine.userID}
//                                 postDataType:kWBRequestPostDataTypeNone
//                             httpHeaderFields:nil];
//    }
//    else if ([_type isEqualToString:@"qq"])
//    {
//        NSDictionary *params = @{@"format":@"json",@"oauth_consumer_key":qqEngine.appKey,@"openid":qqEngine.userID};
//        [qqEngine loadRequestWithMethodName:@"user/get_user_info"
//                                 httpMethod:@"GET"
//                                     params:params
//                               postDataType:kWBRequestPostDataTypeNone
//                           httpHeaderFields:nil];
//    }
//}

- (void)sendWeibo:(NSString *)_status image:(UIImage *)_img type:(NSString *)_type vc:(UIViewController *)_vc finish:(SEL)_success failed:(SEL)_failed
{
    [vc release];
    vc = nil;
    vc = [_vc retain];
    
    sel_success = _success;
    sel_failed = _failed;
    
    if ([_type isEqualToString:@"qq"]) {
        [qqEngine sendWeiBoWithText:_status image:_img];
    }
    else if ([_type isEqualToString:@"sina"])
    {
        [sinaEngine sendWeiBoWithText:_status image:_img];
    }
    
}

#pragma mark -
- (void)handleOpenURL:(NSURL *)_url
{
    NSString *str = [NSString stringWithFormat:@"%@",_url];
    
    if ([str rangeOfString:@"user_cancelled"].location != NSNotFound) {
        [sinaEngine authorize:nil didFailWithError:nil];
    }
    else
    {
        URLParser *parser = [[[URLParser alloc] initWithURLString:str] autorelease];
        [sinaEngine authorize:nil didSucceedWithAccessToken:[parser valueForVariable:@"access_token"] userID:[parser valueForVariable:@"uid"] expiresIn:[[parser valueForVariable:@"expires_in"] intValue]];
    }
}

#pragma mark - wbengine
- (void)engineAlreadyLoggedIn:(WBEngine *)engine
{
    [vc release];
    vc = nil;
}

- (void)engineDidLogIn:(WBEngine *)engine
{
    if ([vc respondsToSelector:sel_success]) {
        [vc performSelector:sel_success withObject:engine];
    }
    
    // do sth.
    [vc release];
    vc = nil;
}

- (void)engine:(WBEngine *)engine didFailToLogInWithError:(NSError *)error
{
    if ([vc respondsToSelector:sel_failed]) {
        [vc performSelector:sel_failed withObject:engine withObject:error];
    }
    
    [vc release];
    vc = nil;
}


- (void)engineDidLogOut:(WBEngine *)engine
{
    
}

- (void)engineNotAuthorized:(WBEngine *)engine
{
    [vc release];
    vc = nil;
}

- (void)engineAuthorizeExpired:(WBEngine *)engine
{
    [vc release];
    vc = nil;
}

- (void)engine:(WBEngine *)engine requestDidFailWithError:(NSError *)error
{
    if ([vc respondsToSelector:sel_failed]) {
        [vc performSelector:sel_failed withObject:error];
    }
    
    
    [vc release];
    vc = nil;
}

- (void)engine:(WBEngine *)engine requestDidSucceedWithResult:(id)result
{
    if ([vc respondsToSelector:sel_success]) {
        [vc performSelector:sel_success withObject:result];
    }
    
    [vc release];
    vc = nil;
}

@end
