//
//  WBRequest.m
//  WBShareKit
//
//  Created by Gao Semaus on 11-8-12.
//  Copyright 2011年 Chlova. All rights reserved.
//

#import "WBRequest.h"

@implementation WBRequest

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

#pragma mark 获得时间戳
+ (NSString *)_generateTimestamp 
{
    return [NSString stringWithFormat:@"%d", time(NULL)];
}

#pragma mark 获得随时字符串
+ (NSString *)_generateNonce 
{
    CFUUIDRef theUUID = CFUUIDCreate(NULL);
    CFStringRef string = CFUUIDCreateString(NULL, theUUID);
    NSMakeCollectable(theUUID);
    return (NSString *)string;
}

+ (WBRequest *)requestWithURL:(NSString *)_url dic:(NSDictionary *)_dic method:(NSString *)_method withServers:(NSString *)_servers requestToken:(BOOL)_requestToken accessToken:(BOOL)_accessToken
{
	OAHMAC_SHA1SignatureProvider *hmacSha1Provider = [[OAHMAC_SHA1SignatureProvider alloc] init];
    
    NSString *key,*secret;
    if ([_servers isEqualToString:@"tx"]) {
        key = TXAPPKEY;
        secret = TXAPPSECRET;
    }
    else if ([_servers isEqualToString:@"sina"]) {
        key = SINAAPPKEY;
        secret = SINAAPPSECRET;
    }
    else if ([_servers isEqualToString:@"douban"]) {
        key = DOUBANAPPKEY;
        secret = DOUBANAPPSECRET;
    }
    else if ([_servers isEqualToString:@"twitter"]) {
        key = TWITTERAPPKEY;
        secret = TWITTERAPPSECRET;
    }
    else if ([_servers isEqualToString:@"wy"])
    {
        key = WYAPPKEY;
        secret = WYAPPSECRET;
    }
    
	OAConsumer *_consumer = [[OAConsumer alloc] initWithKey:key secret:secret];
	
	OAToken *_token = nil;
	
    NSUserDefaults *info = [NSUserDefaults standardUserDefaults];
    NSString *strAccess = nil;
    if (_accessToken) {
        strAccess = [info valueForKey:@"WBShareKit_responseBody"];
    }
    else
    {
        strAccess = [info valueForKey:[NSString stringWithFormat:@"WBShareKit_%@Token",_servers]];
    }
    
	if (nil != strAccess && (!_requestToken || _accessToken)) {
		_token = [[[OAToken alloc] initWithHTTPResponseBody:strAccess] autorelease];
		//NSLog(@"%@,%@",token.secret,token.key);
	}
	
	WBRequest *hmacSha1Request = [[[WBRequest alloc] initWithURL:[NSURL URLWithString:_url]
																			consumer:_consumer
																			   token:_token
																			   realm:NULL
																   signatureProvider:hmacSha1Provider
																			   nonce:[self _generateNonce]
																		   timestamp:[self _generateTimestamp]] autorelease];
	
	//	OARequestParameter *pa1 = [[OARequestParameter alloc] initWithName:@"x_auth_username" value:strUserName];
	//	OARequestParameter *pa2 = [[OARequestParameter alloc] initWithName:@"x_auth_password" value:strUserPwd];
	//	OARequestParameter *pa3 = [[OARequestParameter alloc] initWithName:@"x_auth_mode" value:@"client_auth"];
	if (nil != _dic) {
        if ([_method isEqualToString:@"POST"]) {
            for (NSString *key in [_dic allKeys]) {
                [hmacSha1Request setOAuthParameterName:key withValue:[_dic valueForKey:key]];
            }
        }
        else
        {
            NSMutableString *strurl = [[NSMutableString alloc] initWithString:_url];
            for (NSString *key in [_dic allKeys]) {
                if ([[[_dic allKeys] objectAtIndex:0] isEqual:key]) {
                    [strurl appendString:@"?"];
                }
                else
                {
                    [strurl appendString:@"&"];
                }
                
                [strurl appendFormat:@"%@=%@",key,[_dic valueForKey:key]];
            }
            [hmacSha1Request setURL:[NSURL URLWithString:strurl]];
            [strurl release];
        }
		
	}
	
    //    [hmacSha1Request setOAuthParameterName:@"oauth_verifier" withValue:[info valueForKey:@"WBShareKit_ver"]];
	
	//[hmacSha1Request1 setParameters:[NSArray arrayWithObjects:pa1,pa2,pa3,nil]];
	if (nil != _method) {
		[hmacSha1Request setHTTPMethod:_method];
	}
	
    [hmacSha1Request prepare];
    
	[hmacSha1Provider release];
	[_consumer release];
	//[hmacSha1Request1 release];
	return hmacSha1Request;
}

@end
