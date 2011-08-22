//
//  WBShareKitViewController.m
//  WBShareKit
//
//  Created by Gao Semaus on 11-8-8.
//  Copyright 2011年 Chlova. All rights reserved.
//

#import "WBShareKitViewController.h"

@implementation WBShareKitViewController

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

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

- (IBAction)StartSina:(id)sender {
//    [[WBShareKit mainShare] setDelegate:self];
    [[WBShareKit mainShare] startSinaOauthWithSelector:@selector(sinaSuccess:) withFailedSelector:@selector(sinaError:)];
}

- (IBAction)StartSendSinaWeibo:(id)sender {
    [[WBShareKit mainShare] sendSinaRecordWithStatus:@"WBShareKit test" lat:0 lng:0 delegate:self successSelector:@selector(sendRecordTicket:finishedWithData:) failSelector:@selector(sendRecordTicket:failedWithError:)];
}

- (IBAction)StartSinaPhotoWeibo:(id)sender {
    NSLog(@"%@",[[NSBundle mainBundle] pathForResource:@"WBShareKit" ofType:@"png"]);
    [[WBShareKit mainShare] sendSinaPhotoWithStatus:@"WBShareKit Photo test" lat:0 lng:0 path:[[NSBundle mainBundle] pathForResource:@"WBShareKit" ofType:@"png"] delegate:self successSelector:@selector(sendRecordTicket:finishedWithData:) failSelector:@selector(sendRecordTicket:failedWithError:)];
}

- (IBAction)StartDouban:(id)sender {
//    [[WBShareKit mainShare] setDelegate:self];
    [[WBShareKit mainShare] startDoubanOauthWithSelector:@selector(doubanSuccess:) withFailedSelector:@selector(doubanError:)];
}

- (IBAction)StartSendDoubanShuo:(id)sender {
    [[WBShareKit mainShare] sendDoubanShuoWithStatus:@"WBShareKit test" delegate:self successSelector:@selector(sendDoubanShuoTicket:finishedWithData:) failSelector:@selector(sendDoubanShuoTicket:failedWithError:)];
}

- (IBAction)StartTX:(id)sender {
//    [[WBShareKit mainShare] setDelegate:self];
    [[WBShareKit mainShare] startTxOauthWithSelector:@selector(txSuccess:) withFailedSelector:@selector(txError:)];
}

- (IBAction)StartTXWeibo:(id)sender {
    [[WBShareKit mainShare] sendTxRecordWithStatus:@"WBShareKit test" lat:0 lng:0 format:@"json" delegate:self successSelector:@selector(sendRecordTicket:finishedWithData:) failSelector:@selector(sendRecordTicket:failedWithError:)];
}

- (IBAction)StartTXPhotoWeibo:(id)sender {
    [[WBShareKit mainShare] sendTxRecordWithStatus:@"WBShareKit Photo test" lat:0 lng:0 format:@"json" path:[[NSBundle mainBundle] pathForResource:@"WBShareKit" ofType:@"png"] delegate:self successSelector:@selector(sendRecordTicket:finishedWithData:) failSelector:@selector(sendRecordTicket:failedWithError:)];
}

- (IBAction)StartTwitter:(id)sender {
//    [[WBShareKit mainShare] setDelegate:self];
    [[WBShareKit mainShare] startTwitterOauthWithSelector:@selector(twitterSuccess:) withFailedSelector:@selector(twitterError:)];
}

- (IBAction)StartSendTwitter:(id)sender {
    [[WBShareKit mainShare] sendTwitterWithStatus:@"WBShareKit test" lat:0 lng:0 delegate:self successSelector:@selector(sendRecordTicket:finishedWithData:) failSelector:@selector(sendRecordTicket:failedWithError:)];
}

- (IBAction)StartWy:(id)sender {
//    [[WBShareKit mainShare] setDelegate:self];
    [[WBShareKit mainShare] startWyOauthWithSelector:@selector(wySuccess:) withFailedSelector:@selector(wyError:)];
}

- (IBAction)StartSendWyWeibo:(id)sender {
    [[WBShareKit mainShare] sendWyRecordWithStatus:@"WBShareKit test" lat:0 lng:0 delegate:self successSelector:@selector(sendRecordTicket:finishedWithData:) failSelector:@selector(sendRecordTicket:failedWithError:)];
}

- (IBAction)StartSendWyPhotoWeibo:(id)sender {
    [[WBShareKit mainShare] sendWyPhotoWithStatus:@"WBShareKit Photo test" lat:0 lng:0 path:[[NSBundle mainBundle] pathForResource:@"WBShareKit" ofType:@"png"] delegate:self successSelector:@selector(sendRecordTicket:finishedWithData:) failSelector:@selector(sendRecordTicket:failedWithError:)];
}


#pragma mark sina&163&tx&twitter delegate

- (void)sendRecordTicket:(OAServiceTicket *)ticket finishedWithData:(NSMutableData *)data
{
    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"%@",string);
    UIAlertView *al = [[UIAlertView alloc] initWithTitle:@"发送微博成功" message:string delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [al show];
    [al release];
    
}
- (void)sendRecordTicket:(OAServiceTicket *)ticket failedWithError:(NSError *)error
{
    
}

#pragma mark douban delegate

- (void)sendDoubanShuoTicket:(OAServiceTicket *)ticket finishedWithData:(NSMutableData *)data
{
    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"%@",[string URLDecodedString]);
    UIAlertView *al = [[UIAlertView alloc] initWithTitle:@"发送豆瓣说成功" message:string delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [al show];
    [al release];
    
}
- (void)sendDoubanShuoTicket:(OAServiceTicket *)ticket failedWithError:(NSError *)error
{
    
}


@end
