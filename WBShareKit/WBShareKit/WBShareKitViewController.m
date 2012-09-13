//
//  WBShareKitViewController.m
//  WBShareKit
//
//  Created by Gao Semaus on 11-8-8.
//  Copyright 2011年 Chlova. All rights reserved.
//

#import "WBShareKitViewController.h"
#import "CHShareManager.h"

@implementation WBShareKitViewController

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -

- (IBAction)sinaSend:(id)sender {
    if (![[CHShareManager mainManager] sinaIsVailed]) {
        [[CHShareManager mainManager] showLoginOnViewController:self type:@"sina" finish:@selector(logInDidFinished:) failed:@selector(logInDidFailed:Error:)];
    }
    else{
        [[CHShareManager mainManager] sendWeibo:@"WBShareKit test" image:nil type:@"sina" vc:self finish:@selector(sendDidFinished:) failed:@selector(sendDidError:)];
    }
    
}

- (IBAction)qqSend:(id)sender {
    if (![[CHShareManager mainManager] qqIsVailed]) {
        [[CHShareManager mainManager] showLoginOnViewController:self type:@"qq" finish:@selector(logInDidFinished:) failed:@selector(logInDidFailed:error:)];
    }
    else
    {
        [[CHShareManager mainManager] sendWeibo:@"WBShareKit test" image:nil type:@"qq" vc:self finish:@selector(sendDidFinished:) failed:@selector(sendDidError:)];//暂时不支持发送图片，可利用分享api传入image url来实现发送目的。
    }
}

#pragma mark - api delegate
- (void)logInDidFinished:(WBEngine *)_engine
{
    UIAlertView *al = [[UIAlertView alloc] initWithTitle:@"登录成功" message:_engine.snsType delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
    [al show];
    [al release];
}

- (void)logInDidFailed:(WBEngine *)_engine error:(NSError *)_error
{
    
}

- (void)sendDidFinished:(id)_result
{
    NSLog(@"send did finished:%@",_result);
}

- (void)sendDidError:(NSError *)_error
{
    NSLog(@"%@",_error);
}
@end
