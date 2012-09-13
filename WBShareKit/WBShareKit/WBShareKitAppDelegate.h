//
//  WBShareKitAppDelegate.h
//  WBShareKit
//
//  Created by Gao Semaus on 11-8-8.
//  Copyright 2011年 Chlova. All rights reserved.
//

#import <UIKit/UIKit.h>


@class WBShareKitViewController;

@interface WBShareKitAppDelegate : NSObject <UIApplicationDelegate>

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet WBShareKitViewController *viewController;

@end
