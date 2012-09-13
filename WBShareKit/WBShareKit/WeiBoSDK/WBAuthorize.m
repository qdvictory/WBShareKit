//
//  WBAuthorize.m
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

#import "WBAuthorize.h"
#import "WBRequest.h"
#import "WBSDKGlobal.h"

#define kWBAuthorizeURL     @"https://api.weibo.com/oauth2/authorize"
#define kWBAccessTokenURL   @"https://api.weibo.com/oauth2/access_token"
#define kQQAuthorizeURL     @"https://graph.qq.com/oauth2.0/authorize"

@interface WBAuthorize (Private)

- (void)dismissModalViewController;
- (void)requestAccessTokenWithAuthorizeCode:(NSString *)code;
- (void)requestAccessTokenWithUserID:(NSString *)userID password:(NSString *)password;

@end

@implementation WBAuthorize
@synthesize snsType;
@synthesize appKey;
@synthesize appSecret;
@synthesize redirectURI;
@synthesize request;
@synthesize rootViewController;
@synthesize delegate;

#pragma mark - WBAuthorize Life Circle

- (id)initWithAppKey:(NSString *)theAppKey appSecret:(NSString *)theAppSecret
{
    if (self = [super init])
    {
        self.appKey = theAppKey;
        self.appSecret = theAppSecret;
    }
    
    return self;
}

- (void)dealloc
{
    [snsType release],snsType= nil;
    [appKey release], appKey = nil;
    [appSecret release], appSecret = nil;
    
    [redirectURI release], redirectURI = nil;
    
    [request setDelegate:nil];
    [request disconnect];
    [request release], request = nil;
    
    rootViewController = nil;
    delegate = nil;
    
    [super dealloc];
}

#pragma mark - WBAuthorize Private Methods

- (void)dismissModalViewController
{
    [rootViewController dismissModalViewControllerAnimated:YES];
}

- (void)requestAccessTokenWithAuthorizeCode:(NSString *)code
{
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:appKey, @"client_id",
                                                                      appSecret, @"client_secret",
                                                                      @"authorization_code", @"grant_type",
                                                                      redirectURI, @"redirect_uri",
                                                                      code, @"code", nil];
    [request disconnect];
    
    self.request = [WBRequest requestWithURL:kWBAccessTokenURL
                                   httpMethod:@"POST"
                                       params:params
                                 postDataType:kWBRequestPostDataTypeNormal
                             httpHeaderFields:nil 
                                     delegate:self];
    
    [request connect];
}

- (void)requestAccessTokenWithUserID:(NSString *)userID password:(NSString *)password
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:appKey, @"client_id",
                                                                      appSecret, @"client_secret",
                                                                      @"password", @"grant_type",
                                                                      redirectURI, @"redirect_uri",
                                                                      userID, @"username",
                                                                      password, @"password", nil];
    
    if ([snsType isEqualToString:@"qq"]) {
        [params setValuesForKeysWithDictionary:@{@"token":@"response_type",
         @"user_agent":@"type",
         [NSString stringWithFormat:@"%f",[[[UIDevice currentDevice] systemVersion] floatValue]]:@"status_os",
         [[UIDevice currentDevice] name]:@"status_machine",
         @"v2.0":@"status_version"}];
        
        NSArray *_permissions = [NSArray arrayWithObjects:
         @"get_user_info",@"add_share", @"add_topic",@"add_one_blog", @"list_album",
         @"upload_pic",@"list_photo", @"add_album", @"check_page_fans",nil];
        
        NSString* scope = [_permissions componentsJoinedByString:@","];
		[params setValue:scope forKey:@"scope"];
        
//        NSLog(@"%@",params);
    }
    
    [request disconnect];
    
    self.request = [WBRequest requestWithURL:kWBAccessTokenURL
                                   httpMethod:@"POST"
                                       params:params
                                 postDataType:kWBRequestPostDataTypeNormal
                             httpHeaderFields:nil 
                                     delegate:self];
    
    [request connect];
}

#pragma mark - WBAuthorize Public Methods

- (void)startAuthorize
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:appKey, @"client_id",
                                                                      @"code", @"response_type",
                                                                      redirectURI, @"redirect_uri", 
                                                                      @"mobile", @"display",@"1657944925",@"tid", nil];
    
    if ([snsType isEqualToString:@"qq"]) {
        [params setValuesForKeysWithDictionary:@{@"response_type":@"token",
         @"type":@"user_agent",
         @"status_os":[NSString stringWithFormat:@"%f",[[[UIDevice currentDevice] systemVersion] floatValue]],
         @"status_machine":[[UIDevice currentDevice] name],
         @"status_version":@"v2.0"}];
        
        NSArray *_permissions = [NSArray arrayWithObjects:
                                 @"get_user_info",@"add_share", @"add_topic",@"add_one_blog", @"list_album",
                                 @"upload_pic",@"list_photo", @"add_album", @"check_page_fans",nil];
        
        NSString* scope = [_permissions componentsJoinedByString:@","];
		[params setValue:scope forKey:@"scope"];
        
//        NSLog(@"%@",params);
    }
    
    NSString *url = kWBAuthorizeURL;
    if ([snsType isEqualToString:@"sina"]) {
        
    }
    else if ([snsType isEqualToString:@"qq"])
    {
        url = kQQAuthorizeURL;
    }
    NSString *urlString = [WBRequest serializeURL:url
                                           params:params
                                       httpMethod:@"GET"];
    
//    NSLog(@"%@",urlString);
    
    WBAuthorizeWebView *webView = [[WBAuthorizeWebView alloc] init];
    [webView setDelegate:self];
    webView.snsType = self.snsType;
    [webView loadRequestWithURL:[NSURL URLWithString:urlString]];
    [webView show:YES];
    [webView release];
}

- (void)startAuthorizeUsingUserID:(NSString *)userID password:(NSString *)password
{
    [self requestAccessTokenWithUserID:userID password:password];
}

#pragma mark - WBAuthorizeWebViewDelegate Methods

- (void)authorizeWebView:(WBAuthorizeWebView *)webView didReceiveAuthorizeCode:(NSString *)code
{
    [webView hide:YES];
    
    // if not canceled
//    NSLog(@"%@",code);
    if (![code isEqualToString:@"21330"])
    {
        [self requestAccessTokenWithAuthorizeCode:code];
    }
}

#pragma mark - WBRequestDelegate Methods

- (void)request:(WBRequest *)theRequest didFinishLoadingWithResult:(id)result
{
    BOOL success = NO;
    if ([result isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *dict = (NSDictionary *)result;
        
        NSString *token = [dict objectForKey:@"access_token"];
        NSString *userID = [dict objectForKey:@"uid"];
    
        NSInteger seconds = [[dict objectForKey:@"expires_in"] intValue];
        
        success = token && userID;
        
//        NSLog(@"%d",success);
        
        if (success && [delegate respondsToSelector:@selector(authorize:didSucceedWithAccessToken:userID:expiresIn:)])
        {
            [delegate authorize:self didSucceedWithAccessToken:token userID:userID expiresIn:seconds];
        }
    }
    
    // should not be possible
    if (!success && [delegate respondsToSelector:@selector(authorize:didFailWithError:)])
    {
        NSError *error = [NSError errorWithDomain:kWBSDKErrorDomain 
                                             code:kWBErrorCodeSDK 
                                         userInfo:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%d", kWBSDKErrorCodeAuthorizeError] 
                                                                              forKey:kWBSDKErrorCodeKey]];
        [delegate authorize:self didFailWithError:error];
    }
    
    
}

- (void)request:(WBRequest *)theReqest didFailWithError:(NSError *)error
{
    if ([delegate respondsToSelector:@selector(authorize:didFailWithError:)])
    {
        [delegate authorize:self didFailWithError:error];
    }
    

}

@end
