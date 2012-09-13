//
//  WBShareKitAppDelegate.m
//  WBShareKit
//
//  Created by Gao Semaus on 11-8-8.
//  Copyright 2011年 Chlova. All rights reserved.
//

#import "WBShareKitAppDelegate.h"

#import "WBShareKitViewController.h"

@implementation WBShareKitAppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
//	NSLog(@"获得已授权的key:%@",url);
    
//    [[WBShareKit mainShare] handleOpenURL:url];
    
    
    return YES;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
     
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

- (void)dealloc
{
    [_window release];
    [_viewController release];
    [super dealloc];
}

//#pragma mark sina delegate
//- (void)sinaSuccess:(NSData *)_data
//{
//    NSLog(@"sina ok:%@",_data);
//}
//
//- (void)sinaError:(NSError *)_error
//{
//    NSLog(@"sina error:%@",_error);
//}
//#pragma mark douban delegate
//- (void)doubanSuccess:(NSData *)_data
//{
//    NSLog(@"douban ok:%@",_data);
//}
//
//- (void)doubanError:(NSError *)_error
//{
//    NSLog(@"douban error:%@",_error);
//}
//#pragma mark tx delegate
//- (void)txSuccess:(NSData *)_data
//{
//    NSLog(@"tx ok:%@",_data);
//}
//
//- (void)txError:(NSError *)_error
//{
//    NSLog(@"tx error:%@",_error);
//}
//
//#pragma mark twitter delegate
//- (void)twitterSuccess:(NSData *)_data
//{
//    NSLog(@"twitter ok:%@",_data);
//}
//
//- (void)twitterError:(NSError *)_error
//{
//    NSLog(@"twitter error:%@",_error);
//}
//
//#pragma mark 163 delegate
//- (void)wySuccess:(NSData *)_data
//{
//    NSLog(@"wy ok:%@",_data);
//}
//
//- (void)wyError:(NSError *)_error
//{
//    NSLog(@"wy error:%@",_error);
//}

@end
