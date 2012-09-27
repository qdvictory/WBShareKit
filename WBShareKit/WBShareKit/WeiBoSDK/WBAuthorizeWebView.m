//
//  WBAuthorizeWebView.m
//  SinaWeiBoSDK
//  Based on OAuth 2.0
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//
//  Copyright 2011 Sina. All rights reserved.
//

#import "WBAuthorizeWebView.h"
#import <QuartzCore/QuartzCore.h> 
#import "WBAuthorize.h"
#import "JSON.h"
#import "NSString+URLEncoding.h"
#import "SFHFKeychainUtils.h"

#define kQQCallback @"qq.com"

@interface WBAuthorizeWebView (Private)

- (void)bounceOutAnimationStopped;
- (void)bounceInAnimationStopped;
- (void)bounceNormalAnimationStopped;
- (void)allAnimationsStopped;

- (UIInterfaceOrientation)currentOrientation;
- (void)sizeToFitOrientation:(UIInterfaceOrientation)orientation;
- (CGAffineTransform)transformForOrientation:(UIInterfaceOrientation)orientation;
- (BOOL)shouldRotateToOrientation:(UIInterfaceOrientation)orientation;

- (void)addObservers;
- (void)removeObservers;

@end

@implementation WBAuthorizeWebView
@synthesize snsType;
@synthesize delegate;

#pragma mark - WBAuthorizeWebView Life Circle

- (id)init
{
    if (self = [super initWithFrame:CGRectMake(0, 0, 320, 480)])
    {
        // background settings
        [self setBackgroundColor:[UIColor clearColor]];
        [self setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
        
        // add the panel view
        panelView = [[UIView alloc] initWithFrame:CGRectMake(10, 30, 300, 440)];
        [panelView setBackgroundColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.55]];
        [[panelView layer] setMasksToBounds:NO]; // very important
        [[panelView layer] setCornerRadius:10.0];
        [self addSubview:panelView];
        
        // add the conainer view
        containerView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, 280, 420)];
        [[containerView layer] setBorderColor:[UIColor colorWithRed:0. green:0. blue:0. alpha:0.7].CGColor];
        [[containerView layer] setBorderWidth:1.0];
        
        
        // add the web view
        webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 280, 390)];
		[webView setDelegate:self];
        webView.scalesPageToFit = YES;
		[containerView addSubview:webView];
        
        [panelView addSubview:containerView];
        
        // add the buttons & labels
		UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
		[closeButton setShowsTouchWhenHighlighted:YES];
		[closeButton setFrame:CGRectMake(280, 0, 19, 19)];
		[closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		[closeButton setBackgroundImage:[UIImage imageNamed:@"close_btn.png"] forState:UIControlStateNormal];
//		[closeButton setTitle:NSLocalizedString(@"关闭", nil) forState:UIControlStateNormal];
		[closeButton.titleLabel setFont:[UIFont boldSystemFontOfSize:13.0f]];
		[closeButton addTarget:self action:@selector(onCloseButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
		[panelView addSubview:closeButton];
        
        indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [indicatorView setCenter:CGPointMake(160, 240)];
        [self addSubview:indicatorView];
    }
    return self;
}

- (void)dealloc
{
    [snsType release],snsType= nil;
    [panelView release], panelView = nil;
    [containerView release], containerView = nil;
    [webView release], webView = nil;
    [indicatorView release], indicatorView = nil;
    
    [super dealloc];
}

#pragma mark Actions

- (void)onCloseButtonTouched:(id)sender
{
    [self hide:YES];
}

#pragma mark Orientations

- (UIInterfaceOrientation)currentOrientation
{
    return [UIApplication sharedApplication].statusBarOrientation;
}

- (void)sizeToFitOrientation:(UIInterfaceOrientation)orientation
{
    [self setTransform:CGAffineTransformIdentity];
    
    if (UIInterfaceOrientationIsLandscape(orientation))
    {
        [self setFrame:CGRectMake(0, 0, 480, 320)];
        [panelView setFrame:CGRectMake(10, 30, 460, 280)];
        [containerView setFrame:CGRectMake(10, 10, 440, 260)];
        [webView setFrame:CGRectMake(0, 0, 440, 260)];
        [indicatorView setCenter:CGPointMake(240, 160)];
    }
    else
    {
        [self setFrame:CGRectMake(0, 0, 320, 480)];
        [panelView setFrame:CGRectMake(10, 30, 300, 440)];
        [containerView setFrame:CGRectMake(10, 10, 280, 420)];
        [webView setFrame:CGRectMake(0, 0, 280, 420)];
        [indicatorView setCenter:CGPointMake(160, 240)];
    }
    
    [self setCenter:CGPointMake(160, 240)];
    
    [self setTransform:[self transformForOrientation:orientation]];
    
    previousOrientation = orientation;
}

- (CGAffineTransform)transformForOrientation:(UIInterfaceOrientation)orientation
{  
	if (orientation == UIInterfaceOrientationLandscapeLeft)
    {
		return CGAffineTransformMakeRotation(-M_PI / 2);
	}
    else if (orientation == UIInterfaceOrientationLandscapeRight)
    {
		return CGAffineTransformMakeRotation(M_PI / 2);
	}
    else if (orientation == UIInterfaceOrientationPortraitUpsideDown)
    {
		return CGAffineTransformMakeRotation(-M_PI);
	}
    else
    {
		return CGAffineTransformIdentity;
	}
}

- (BOOL)shouldRotateToOrientation:(UIInterfaceOrientation)orientation 
{
	if (orientation == previousOrientation)
    {
		return NO;
	}
    else
    {
		return orientation == UIInterfaceOrientationLandscapeLeft
		|| orientation == UIInterfaceOrientationLandscapeRight
		|| orientation == UIInterfaceOrientationPortrait
		|| orientation == UIInterfaceOrientationPortraitUpsideDown;
	}
    return YES;
}

#pragma mark Obeservers

- (void)addObservers
{
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(deviceOrientationDidChange:)
												 name:@"UIDeviceOrientationDidChangeNotification" object:nil];
}

- (void)removeObservers
{
	[[NSNotificationCenter defaultCenter] removeObserver:self
													name:@"UIDeviceOrientationDidChangeNotification" object:nil];
}


#pragma mark Animations

- (void)bounceOutAnimationStopped
{
    [UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.13];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(bounceInAnimationStopped)];
    [panelView setAlpha:0.8];
	[panelView setTransform:CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9)];
	[UIView commitAnimations];
}

- (void)bounceInAnimationStopped
{
    [UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.13];
    [UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(bounceNormalAnimationStopped)];
    [panelView setAlpha:1.0];
	[panelView setTransform:CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0)];
	[UIView commitAnimations];
}

- (void)bounceNormalAnimationStopped
{
    [self allAnimationsStopped];
}

- (void)allAnimationsStopped
{
    // nothing shall be done here
}

#pragma mark Dismiss

- (void)hideAndCleanUp
{
    [self removeObservers];
	[self removeFromSuperview];
}

#pragma mark - WBAuthorizeWebView Public Methods

- (void)loadRequestWithURL:(NSURL *)url
{
    NSURLRequest *request =[NSURLRequest requestWithURL:url
                                            cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                        timeoutInterval:60.0];
    [webView loadRequest:request];
}

- (void)show:(BOOL)animated
{
    [self sizeToFitOrientation:[self currentOrientation]];
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
	if (!window)
    {
		window = [[UIApplication sharedApplication].windows objectAtIndex:0];
	}
  	[window addSubview:self];
    
    if (animated)
    {
        [panelView setAlpha:0];
        CGAffineTransform transform = CGAffineTransformIdentity;
        [panelView setTransform:CGAffineTransformScale(transform, 0.3, 0.3)];
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.2];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(bounceOutAnimationStopped)];
        [panelView setAlpha:0.5];
        [panelView setTransform:CGAffineTransformScale(transform, 1.1, 1.1)];
        [UIView commitAnimations];
    }
    else
    {
        [self allAnimationsStopped];
    }
    
    [self addObservers];
}

- (void)hide:(BOOL)animated
{
	if (animated)
    {
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.3];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(hideAndCleanUp)];
		[self setAlpha:0];
		[UIView commitAnimations];
	} 
    [self hideAndCleanUp];
}

#pragma mark - UIDeviceOrientationDidChangeNotification Methods

- (void)deviceOrientationDidChange:(id)object
{
	UIInterfaceOrientation orientation = [self currentOrientation];
	if ([self shouldRotateToOrientation:orientation])
    {
        NSTimeInterval duration = [UIApplication sharedApplication].statusBarOrientationAnimationDuration;
    
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:duration];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
		[self sizeToFitOrientation:orientation];
		[UIView commitAnimations];
	}
}

#pragma mark - qq get info from url
- (NSString *) getStringFromUrl: (NSString*) url needle:(NSString *) needle {
	NSString * str = nil;
	NSRange start = [url rangeOfString:needle];
	if (start.location != NSNotFound) {
		NSRange end = [[url substringFromIndex:start.location+start.length] rangeOfString:@"&"];
		NSUInteger offset = start.location+start.length;
		str = end.location == NSNotFound
		? [url substringFromIndex:offset]
		: [url substringWithRange:NSMakeRange(offset, end.location)];
		str = [str stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	}
	
	return str;
}

#pragma mark - UIWebViewDelegate Methods

- (void)webViewDidStartLoad:(UIWebView *)aWebView
{
	[indicatorView startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)aWebView
{
	[indicatorView stopAnimating];
}

- (void)webView:(UIWebView *)aWebView didFailLoadWithError:(NSError *)error
{
    [indicatorView stopAnimating];
}

- (BOOL)webView:(UIWebView *)aWebView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if ([snsType isEqualToString:@"sina"]) {
        NSRange range = [request.URL.absoluteString rangeOfString:@"code="];
        
        if (range.location != NSNotFound)
        {
            NSString *code = [request.URL.absoluteString substringFromIndex:range.location + range.length];
            
            if ([delegate respondsToSelector:@selector(authorizeWebView:didReceiveAuthorizeCode:)])
            {
                [delegate authorizeWebView:self didReceiveAuthorizeCode:code];
            }
        }
        
        return YES;
    }
    else if ([snsType isEqualToString:@"qq"])
    {
        NSLog(@"%@",request.URL);
//        if ([request.URL.host isEqualToString:@"graph.qq.com"] || [request.URL.host isEqualToString:@"openapi.qzone.qq.com"]) {
//            return YES;
//        }
//        else
        if ([request.URL.host isEqualToString:kQQCallback])
        {
            NSURL* url = request.URL;
            NSRange start = [[url absoluteString] rangeOfString:@"access_token="];
//            NSLog(@"%@,%@",url,[url absoluteString]);
            if (start.location != NSNotFound)
            {
                NSString * token = [self getStringFromUrl:[url absoluteString] needle:@"access_token="];
                NSString * expireTime = [self getStringFromUrl:[url absoluteString] needle:@"expires_in="];
//                NSDate *expirationDate =nil;
                
//                if (expireTime != nil) {
//                    int expVal = [expireTime intValue];
//                    if (expVal == 0) {
//                        expirationDate = [NSDate distantFuture];
//                    } else {
//                        expirationDate = [NSDate dateWithTimeIntervalSinceNow:expVal];
//                    } 
//                } 
                
                if ((token == (NSString *) [NSNull null]) || (token.length == 0)){
                    [delegate performSelector:@selector(request:didFailWithError:) withObject:request withObject:nil];
                } else {
//                    [delegate performSelector:@selector(request:didFinishLoadingWithResult:) withObject:request withObject:@{ @"access_token": token,@"expires_in":expireTime }];
                    NSURLRequest *r = [[NSURLRequest alloc] initWithURL:[NSURL  URLWithString:[NSString stringWithFormat:@"https://graph.qq.com/oauth2.0/me?format=json&access_token=%@&oauth_consumer_key=%@",token,[((WBAuthorize *)delegate) appKey]]]];
                    
                    [NSURLConnection sendAsynchronousRequest:r queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData * d, NSError *e) {
                        NSString *str = [[NSString alloc] initWithData:d encoding:NSUTF8StringEncoding];
//                        NSLog(@"%@",str);
                        if ([[str substringToIndex:8] isEqualToString:@"callback"]) {
                            NSString * responseString = [str substringWithRange:NSMakeRange(10, [str length]-13)];
                            
                            NSDictionary *dic = [responseString JSONValue];
                            if ([[dic allKeys] containsObject:@"openid"]) {
                                if ([delegate respondsToSelector:@selector(request:didFinishLoadingWithResult:)]) {
                                    [delegate performSelector:@selector(request:didFinishLoadingWithResult:) withObject:request withObject:@{ @"access_token": token,@"expires_in":expireTime,@"uid":[dic valueForKey:@"openid"] }];
                                }
                                
                            }
                        }
                        else
                        {
                            if ([delegate respondsToSelector:@selector(request:didFailWithError:)]) {
                                [delegate performSelector:@selector(request:didFailWithError:) withObject:request withObject:nil];
                            }
                            
                        }
                        
                        
                        [str release];
                    }];
                    [r release];
                    
                }
//                NSLog(@"%@,%@",token,expirationDate);
                
                [self hide:YES];
            }
            
            return NO;
        }
//        NSLog(@"%@",request);
//        NSLog(@"%@",request.URL.host);
        
        return YES;
    }
    return YES;
}

@end
