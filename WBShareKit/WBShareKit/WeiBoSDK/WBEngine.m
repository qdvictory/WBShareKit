//
//  WBEngine.m
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

#import "WBEngine.h"
#import "SFHFKeychainUtils.h"
#import "WBSDKGlobal.h"
#import "WBUtil.h"

#define kWBURLSchemePrefix              @"WB_"

#define kWBKeychainServiceNameSuffix    @"_WeiBoServiceName"
#define kWBKeychainUserID               @"WeiBoUserID"
#define kWBKeychainAccessToken          @"WeiBoAccessToken"
#define kWBKeychainExpireTime           @"WeiBoExpireTime"

#define kQQURLSchemePrefix              @"QQ_"

#define kQQKeychainServiceNameSuffix    @"_QQServiceName"
#define kQQKeychainUserID               @"QQUserID"
#define kQQKeychainAccessToken          @"QQAccessToken"
#define kQQKeychainExpireTime           @"QQExpireTime"

@interface WBEngine (Private)

- (NSString *)urlSchemeString;

- (void)saveAuthorizeDataToKeychain;
- (void)readAuthorizeDataFromKeychain;
- (void)deleteAuthorizeDataInKeychain;

@end

@implementation WBEngine
@synthesize snsType;
@synthesize appKey;
@synthesize appSecret;
@synthesize userID;
@synthesize accessToken;
@synthesize expireTime;
@synthesize redirectURI;
@synthesize isUserExclusive;
@synthesize request;
@synthesize authorize;
@synthesize delegate;
@synthesize rootViewController;

#pragma mark - WBEngine Life Circle

- (id)initWithAppKey:(NSString *)theAppKey appSecret:(NSString *)theAppSecret
{
    if (self = [super init])
    {
        self.appKey = theAppKey;
        self.appSecret = theAppSecret;
        
        isUserExclusive = NO;
        
        [self readAuthorizeDataFromKeychain];
        
    }
    
    return self;
}

- (void)setSnsType:(NSString *)_snstype
{
    snsType = _snstype;
    [self readAuthorizeDataFromKeychain];
}

- (void)dealloc
{
    [snsType release],snsType= nil;
    [appKey release], appKey = nil;
    [appSecret release], appSecret = nil;
    
    [userID release], userID = nil;
    [accessToken release], accessToken = nil;
    
    [redirectURI release], redirectURI = nil;
    
    [request setDelegate:nil];
    [request disconnect];
    [request release], request = nil;
    
    [authorize setDelegate:nil];
    [authorize release], authorize = nil;
    
    delegate = nil;
    rootViewController = nil;
    
    [super dealloc];
}

#pragma mark - WBEngine Private Methods

- (NSString *)urlSchemeString
{
    if ([snsType isEqualToString:@"sina"]) {
        return [NSString stringWithFormat:@"%@%@", kWBURLSchemePrefix, appKey];
    }
    else if ([snsType isEqualToString:@"qq"])
    {
        return [NSString stringWithFormat:@"%@%@", kQQURLSchemePrefix, appKey];
    }
    return nil;
}

- (void)saveAuthorizeDataToKeychain
{
    if ([snsType isEqualToString:@"sina"]) {
        NSString *serviceName = [[self urlSchemeString] stringByAppendingString:kWBKeychainServiceNameSuffix];
        [SFHFKeychainUtils storeUsername:kWBKeychainUserID andPassword:userID forServiceName:serviceName updateExisting:YES error:nil];
        [SFHFKeychainUtils storeUsername:kWBKeychainAccessToken andPassword:accessToken forServiceName:serviceName updateExisting:YES error:nil];
        [SFHFKeychainUtils storeUsername:kWBKeychainExpireTime andPassword:[NSString stringWithFormat:@"%lf", expireTime] forServiceName:serviceName updateExisting:YES error:nil];
    }
    else if ([snsType isEqualToString:@"qq"])
    {
        NSString *serviceName = [[self urlSchemeString] stringByAppendingString:kQQKeychainServiceNameSuffix];
        [SFHFKeychainUtils storeUsername:kQQKeychainUserID andPassword:userID forServiceName:serviceName updateExisting:YES error:nil];
        [SFHFKeychainUtils storeUsername:kQQKeychainAccessToken andPassword:accessToken forServiceName:serviceName updateExisting:YES error:nil];
        [SFHFKeychainUtils storeUsername:kQQKeychainExpireTime andPassword:[NSString stringWithFormat:@"%lf", expireTime] forServiceName:serviceName updateExisting:YES error:nil];
    }
}

- (void)readAuthorizeDataFromKeychain
{
    if ([snsType isEqualToString:@"sina"]) {
        NSString *serviceName = [[self urlSchemeString] stringByAppendingString:kWBKeychainServiceNameSuffix];
        self.userID = [SFHFKeychainUtils getPasswordForUsername:kWBKeychainUserID andServiceName:serviceName error:nil];
        self.accessToken = [SFHFKeychainUtils getPasswordForUsername:kWBKeychainAccessToken andServiceName:serviceName error:nil];
        self.expireTime = [[SFHFKeychainUtils getPasswordForUsername:kWBKeychainExpireTime andServiceName:serviceName error:nil] doubleValue];
    }
    else if ([snsType isEqualToString:@"qq"])
    {
        NSString *serviceName = [[self urlSchemeString] stringByAppendingString:kQQKeychainServiceNameSuffix];
        self.userID = [SFHFKeychainUtils getPasswordForUsername:kQQKeychainUserID andServiceName:serviceName error:nil];
        self.accessToken = [SFHFKeychainUtils getPasswordForUsername:kQQKeychainAccessToken andServiceName:serviceName error:nil];
        self.expireTime = [[SFHFKeychainUtils getPasswordForUsername:kQQKeychainExpireTime andServiceName:serviceName error:nil] doubleValue];
    }
}

- (void)deleteAuthorizeDataInKeychain
{
    self.userID = nil;
    self.accessToken = nil;
    self.expireTime = 0;
    
    if ([snsType isEqualToString:@"sina"]) {
        NSString *serviceName = [[self urlSchemeString] stringByAppendingString:kWBKeychainServiceNameSuffix];
        [SFHFKeychainUtils deleteItemForUsername:kWBKeychainUserID andServiceName:serviceName error:nil];
        [SFHFKeychainUtils deleteItemForUsername:kWBKeychainAccessToken andServiceName:serviceName error:nil];
        [SFHFKeychainUtils deleteItemForUsername:kWBKeychainExpireTime andServiceName:serviceName error:nil];
    }
    else if ([snsType isEqualToString:@"qq"])
    {
        NSString *serviceName = [[self urlSchemeString] stringByAppendingString:kQQKeychainServiceNameSuffix];
        [SFHFKeychainUtils deleteItemForUsername:kQQKeychainUserID andServiceName:serviceName error:nil];
        [SFHFKeychainUtils deleteItemForUsername:kQQKeychainAccessToken andServiceName:serviceName error:nil];
        [SFHFKeychainUtils deleteItemForUsername:kQQKeychainExpireTime andServiceName:serviceName error:nil];
    }
    
    
}

#pragma mark - WBEngine Public Methods

#pragma mark Authorization

- (void)logIn
{
    if ([self isLoggedIn])
    {
        if ([delegate respondsToSelector:@selector(engineAlreadyLoggedIn:)])
        {
            [delegate engineAlreadyLoggedIn:self];
        }
        if (isUserExclusive)
        {
            return;
        }
    }
    
    WBAuthorize *auth = [[WBAuthorize alloc] initWithAppKey:appKey appSecret:appSecret];
    [auth setRootViewController:rootViewController];
    [auth setDelegate:self];
    auth.snsType = self.snsType;
    self.authorize = auth;
    [auth release];
    
    if ([redirectURI length] > 0)
    {
        [authorize setRedirectURI:redirectURI];
    }
    else
    {
        [authorize setRedirectURI:@"http://"];
    }
    
    [authorize startAuthorize];
}

- (void)logInUsingUserID:(NSString *)theUserID password:(NSString *)thePassword
{
    self.userID = theUserID;
    
    if ([self isLoggedIn])
    {
        if ([delegate respondsToSelector:@selector(engineAlreadyLoggedIn:)])
        {
            [delegate engineAlreadyLoggedIn:self];
        }
        if (isUserExclusive)
        {
            return;
        }
    }
    
    WBAuthorize *auth = [[WBAuthorize alloc] initWithAppKey:appKey appSecret:appSecret];
    [auth setRootViewController:rootViewController];
    [auth setDelegate:self];
    self.authorize = auth;
    [auth release];
    
    if ([redirectURI length] > 0)
    {
        [authorize setRedirectURI:redirectURI];
    }
    else
    {
        [authorize setRedirectURI:@"http://"];
    }
    
    [authorize startAuthorizeUsingUserID:theUserID password:thePassword];
}

- (void)logOut
{
    [self deleteAuthorizeDataInKeychain];
    
    if ([delegate respondsToSelector:@selector(engineDidLogOut:)])
    {
        [delegate engineDidLogOut:self];
    }
}

- (BOOL)isLoggedIn
{
    //    return userID && accessToken && refreshToken;
//    NSLog(@"%@,%@,%f",userID,accessToken,expireTime);
    return userID && accessToken && (expireTime > 0);
}

- (BOOL)isAuthorizeExpired
{
    if ([[NSDate date] timeIntervalSince1970] > expireTime)
    {
        // force to log out
        [self deleteAuthorizeDataInKeychain];
        return YES;
    }
    return NO;
}

#pragma mark Request

- (void)loadRequestWithMethodName:(NSString *)methodName
                       httpMethod:(NSString *)httpMethod
                           params:(NSDictionary *)params
                     postDataType:(WBRequestPostDataType)postDataType
                 httpHeaderFields:(NSDictionary *)httpHeaderFields
{
    // Step 1.
    // Check if the user has been logged in.
	if (![self isLoggedIn])
	{
        if ([delegate respondsToSelector:@selector(engineNotAuthorized:)])
        {
            [delegate engineNotAuthorized:self];
        }
        return;
	}
    
	// Step 2.
    // Check if the access token is expired.
    if ([self isAuthorizeExpired])
    {
        if ([delegate respondsToSelector:@selector(engineAuthorizeExpired:)])
        {
            [delegate engineAuthorizeExpired:self];
        }
        return;
    }
    
    [request disconnect];
    
    if ([snsType isEqualToString:@"sina"]) {
        self.request = [WBRequest requestWithAccessToken:accessToken
                                                     url:[NSString stringWithFormat:@"%@%@", kWBSDKAPIDomain, methodName]
                                              httpMethod:httpMethod
                                                  params:params
                                            postDataType:postDataType
                                        httpHeaderFields:httpHeaderFields
                                                delegate:self];
    }
    else if ([snsType isEqualToString:@"qq"])
    {
        self.request = [WBRequest requestWithAccessToken:accessToken
                                                     url:[NSString stringWithFormat:@"%@%@", kQQSDKAPIDomain, methodName]
                                              httpMethod:httpMethod
                                                  params:params
                                            postDataType:postDataType
                                        httpHeaderFields:httpHeaderFields
                                                delegate:self];
    }
    
    
	
	[request connect];
}

- (void)sendWeiBoWithText:(NSString *)text image:(UIImage *)image
{
    if ([snsType isEqualToString:@"sina"]) {
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:2];
        
        //NSString *sendText = [text URLEncodedString];
        
        [params setObject:(text ? text : @"") forKey:@"status"];
        
        if (image)
        {
            [params setObject:image forKey:@"pic"];
            
            [self loadRequestWithMethodName:@"statuses/upload.json"
                                 httpMethod:@"POST"
                                     params:params
                               postDataType:kWBRequestPostDataTypeMultipart
                           httpHeaderFields:nil];
        }
        else
        {
            [self loadRequestWithMethodName:@"statuses/update.json"
                                 httpMethod:@"POST"
                                     params:params
                               postDataType:kWBRequestPostDataTypeNormal
                           httpHeaderFields:nil];
        }
    }
    else if ([snsType isEqualToString:@"qq"])
    {
        
        
        
//        if (image)
//        {
//            NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
//                                           image, @"picture",
//                                           @"手机相册",@"albumid",
//                                           text,@"title",
//                                           @"WBShareKit",@"photodesc",
//                                           nil];
//            [params setValue:@"json" forKey:@"format"];
//            [params setValue:self.appKey forKey:@"oauth_consumer_key"];
//            [params setValue:self.accessToken forKey:@"access_token"];
//            [params setValue:self.userID forKey:@"openid"];
//            
//            [params setObject:image forKey:@"pic"];
//
//            [self loadRequestWithMethodName:@"photo/upload_pic"
//                                 httpMethod:@"POST"
//                                     params:params
//                               postDataType:kWBRequestPostDataTypeMultipart
//                           httpHeaderFields:nil];
//        }
//        else
//        {
            NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                           @"WBShareKit", @"title",
                                           @"http://www.minroad.com", @"url",
                                           @"Test",@"comment",
                                           text,@"summary",
                                           //								   @"http://img1.gtimg.com/tech/pics/hv1/95/153/847/55115285.jpg",@"images",
                                           @"4",@"source",
                                           nil];
            [params setValue:@"json" forKey:@"format"];
            [params setValue:self.appKey forKey:@"oauth_consumer_key"];
            [params setValue:self.accessToken forKey:@"access_token"];
            [params setValue:self.userID forKey:@"openid"];
            
            [self loadRequestWithMethodName:@"share/add_share"
                                 httpMethod:@"POST"
                                     params:params
                               postDataType:kWBRequestPostDataTypeNormal
                           httpHeaderFields:nil];
//        }
    }
}

#pragma mark - WBAuthorizeDelegate Methods

- (void)authorize:(WBAuthorize *)authorize didSucceedWithAccessToken:(NSString *)theAccessToken userID:(NSString *)theUserID expiresIn:(NSInteger)seconds
{
    self.accessToken = theAccessToken;
    self.userID = theUserID;
    self.expireTime = [[NSDate date] timeIntervalSince1970] + seconds;
    
    [self saveAuthorizeDataToKeychain];
    
    if ([delegate respondsToSelector:@selector(engineDidLogIn:)])
    {
        [delegate engineDidLogIn:self];
    }
    
//NSLog(@"%@,%@,%f",self.accessToken,self.userID,self.expireTime);
}

- (void)authorize:(WBAuthorize *)authorize didFailWithError:(NSError *)error
{
    if ([delegate respondsToSelector:@selector(engine:didFailToLogInWithError:)])
    {
        [delegate engine:self didFailToLogInWithError:error];
    }
}

#pragma mark - WBRequestDelegate Methods

- (void)request:(WBRequest *)request didFinishLoadingWithResult:(id)result
{
//    NSLog(@"%@",result);
    if ([delegate respondsToSelector:@selector(engine:requestDidSucceedWithResult:)])
    {
        [delegate engine:self requestDidSucceedWithResult:result];
    }
}

- (void)request:(WBRequest *)request didFailWithError:(NSError *)error
{
    if ([delegate respondsToSelector:@selector(engine:requestDidFailWithError:)])
    {
        [delegate engine:self requestDidFailWithError:error];
    }
}

@end
