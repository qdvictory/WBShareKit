//
//  WBShareKit.m
//  WBShareKit
//
//  Created by Gao Semaus on 11-8-8.
//  Copyright 2011年 Chlova. All rights reserved.
//

#import "WBShareKit.h"

@implementation WBShareKit

NSString *WBShareKit_BOUNDARY = @"WBShareKit_Oauth_Kit";

static WBShareKit *_shareKit;

+ (WBShareKit *)mainShare
{
    if (nil == _shareKit) {
        _shareKit = [[WBShareKit alloc] init];
    }
    return _shareKit;
}

- (void)dealloc
{
    [super dealloc];
}

- (NSString *)replaceURLPlus:(NSString *)_str
{
//    return _str;
	return [_str stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
}

//#pragma mark setDelegate
//- (void)setDelegate:(id)delegate
//{
//    NSString *path = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"WBShareKit.delegate"];
//    [NSKeyedArchiver archiveRootObject:delegate toFile:path];
//}

#pragma mark 获得时间戳
- (NSString *)_generateTimestamp 
{
    return [NSString stringWithFormat:@"%d", time(NULL)];
}

#pragma mark 获得随时字符串
- (NSString *)_generateNonce 
{
    CFUUIDRef theUUID = CFUUIDCreate(NULL);
    CFStringRef string = CFUUIDCreateString(NULL, theUUID);
    NSMakeCollectable(theUUID);
    return (NSString *)string;
}



#pragma mark -
- (OAMutableURLRequest *)sinaRequestWithURL:(NSString *)_url dic:(NSDictionary *)_dic method:(NSString *)_method
{
	OAHMAC_SHA1SignatureProvider *hmacSha1Provider = [[OAHMAC_SHA1SignatureProvider alloc] init];
	OAConsumer *consumer = [[OAConsumer alloc] initWithKey:SINAAPPKEY secret:SINAAPPSECRET];
	
	OAToken *token = nil;
	
    NSUserDefaults *info = [NSUserDefaults standardUserDefaults];
    NSString *strAccess = [info valueForKey:@"WBShareKit_sinaToken"];
    
	if (nil != strAccess) {
		token = [[[OAToken alloc] initWithHTTPResponseBody:strAccess] autorelease];
		//NSLog(@"%@,%@",token.secret,token.key);
	}
	
	OAMutableURLRequest *hmacSha1Request = [[[OAMutableURLRequest alloc] initWithURL:[NSURL URLWithString:_url]
																			consumer:consumer
																			   token:token
																			   realm:NULL
																   signatureProvider:hmacSha1Provider
																			   nonce:[self _generateNonce]
																		   timestamp:[self _generateTimestamp]] autorelease];
	
	//	OARequestParameter *pa1 = [[OARequestParameter alloc] initWithName:@"x_auth_username" value:strUserName];
	//	OARequestParameter *pa2 = [[OARequestParameter alloc] initWithName:@"x_auth_password" value:strUserPwd];
	//	OARequestParameter *pa3 = [[OARequestParameter alloc] initWithName:@"x_auth_mode" value:@"client_auth"];
	if (nil != _dic) {
		for (NSString *key in [_dic allKeys]) {
			[hmacSha1Request setOAuthParameterName:key withValue:[_dic valueForKey:key]];
		}
	}
	
//    [hmacSha1Request setOAuthParameterName:@"oauth_verifier" withValue:[info valueForKey:@"WBShareKit_ver"]];
	
	//[hmacSha1Request1 setParameters:[NSArray arrayWithObjects:pa1,pa2,pa3,nil]];
	if (nil != _method) {
		[hmacSha1Request setHTTPMethod:_method];
	}
	
	[hmacSha1Provider release];
	[consumer release];
	//[hmacSha1Request1 release];
	return hmacSha1Request;
}

#pragma mark -
- (OAMutableURLRequest *)doubanRequestWithURL:(NSString *)_url dic:(NSDictionary *)_dic method:(NSString *)_method
{
	OAHMAC_SHA1SignatureProvider *hmacSha1Provider = [[OAHMAC_SHA1SignatureProvider alloc] init];
	OAConsumer *consumer = [[OAConsumer alloc] initWithKey:DOUBANAPPKEY secret:DOUBANAPPSECRET];
	
	OAToken *token = nil;
	
    NSUserDefaults *info = [NSUserDefaults standardUserDefaults];
    NSString *strAccess = [info valueForKey:@"WBShareKit_doubanToken"];
    
	if (nil != strAccess) {
		token = [[[OAToken alloc] initWithHTTPResponseBody:strAccess] autorelease];
		//NSLog(@"%@,%@",token.secret,token.key);
	}
	
	OAMutableURLRequest *hmacSha1Request = [[[OAMutableURLRequest alloc] initWithURL:[NSURL URLWithString:_url]
																			consumer:consumer
																			   token:token
																			   realm:NULL
																   signatureProvider:hmacSha1Provider
																			   nonce:[self _generateNonce]
																		   timestamp:[self _generateTimestamp]] autorelease];
	
	//	OARequestParameter *pa1 = [[OARequestParameter alloc] initWithName:@"x_auth_username" value:strUserName];
	//	OARequestParameter *pa2 = [[OARequestParameter alloc] initWithName:@"x_auth_password" value:strUserPwd];
	//	OARequestParameter *pa3 = [[OARequestParameter alloc] initWithName:@"x_auth_mode" value:@"client_auth"];
	if (nil != _dic) {
		for (NSString *key in [_dic allKeys]) {
			[hmacSha1Request setOAuthParameterName:key withValue:[_dic valueForKey:key]];
		}
	}
	
    //    [hmacSha1Request setOAuthParameterName:@"oauth_verifier" withValue:[info valueForKey:@"WBShareKit_ver"]];
	
	//[hmacSha1Request1 setParameters:[NSArray arrayWithObjects:pa1,pa2,pa3,nil]];
	if (nil != _method) {
		[hmacSha1Request setHTTPMethod:_method];
	}
	
	[hmacSha1Provider release];
	[consumer release];
	//[hmacSha1Request1 release];
	return hmacSha1Request;
}

#pragma mark -
- (OAMutableURLRequest *)txRequestWithURL:(NSString *)_url dic:(NSDictionary *)_dic method:(NSString *)_method
{
	OAHMAC_SHA1SignatureProvider *hmacSha1Provider = [[OAHMAC_SHA1SignatureProvider alloc] init];
	OAConsumer *consumer = [[OAConsumer alloc] initWithKey:TXAPPKEY secret:TXAPPSECRET];
	
	OAToken *token = nil;
	
    NSUserDefaults *info = [NSUserDefaults standardUserDefaults];
    NSString *strAccess = [info valueForKey:@"WBShareKit_txToken"];
    
	if (nil != strAccess) {
		token = [[[OAToken alloc] initWithHTTPResponseBody:strAccess] autorelease];
		//NSLog(@"%@,%@",token.secret,token.key);
	}
	
	OAMutableURLRequest *hmacSha1Request = [[[OAMutableURLRequest alloc] initWithURL:[NSURL URLWithString:_url]
																			consumer:consumer
																			   token:token
																			   realm:NULL
																   signatureProvider:hmacSha1Provider
																			   nonce:[self _generateNonce]
																		   timestamp:[self _generateTimestamp]] autorelease];
	
	//	OARequestParameter *pa1 = [[OARequestParameter alloc] initWithName:@"x_auth_username" value:strUserName];
	//	OARequestParameter *pa2 = [[OARequestParameter alloc] initWithName:@"x_auth_password" value:strUserPwd];
	//	OARequestParameter *pa3 = [[OARequestParameter alloc] initWithName:@"x_auth_mode" value:@"client_auth"];
	if (nil != _dic) {
		for (NSString *key in [_dic allKeys]) {
			[hmacSha1Request setOAuthParameterName:key withValue:[_dic valueForKey:key]];
		}
	}
	
    //    [hmacSha1Request setOAuthParameterName:@"oauth_verifier" withValue:[info valueForKey:@"WBShareKit_ver"]];
	
	//[hmacSha1Request1 setParameters:[NSArray arrayWithObjects:pa1,pa2,pa3,nil]];
	if (nil != _method) {
		[hmacSha1Request setHTTPMethod:_method];
	}
	
	[hmacSha1Provider release];
	[consumer release];
	//[hmacSha1Request1 release];
	return hmacSha1Request;
}

#pragma mark -
- (OAMutableURLRequest *)twitterRequestWithURL:(NSString *)_url dic:(NSDictionary *)_dic method:(NSString *)_method
{
	OAHMAC_SHA1SignatureProvider *hmacSha1Provider = [[OAHMAC_SHA1SignatureProvider alloc] init];
	OAConsumer *consumer = [[OAConsumer alloc] initWithKey:TWITTERAPPKEY secret:TWITTERAPPSECRET];
	
	OAToken *token = nil;
	
    NSUserDefaults *info = [NSUserDefaults standardUserDefaults];
    NSString *strAccess = [info valueForKey:@"WBShareKit_twitterToken"];
    
	if (nil != strAccess) {
		token = [[[OAToken alloc] initWithHTTPResponseBody:strAccess] autorelease];
		//NSLog(@"%@,%@",token.secret,token.key);
	}
	
	OAMutableURLRequest *hmacSha1Request = [[[OAMutableURLRequest alloc] initWithURL:[NSURL URLWithString:_url]
																			consumer:consumer
																			   token:token
																			   realm:NULL
																   signatureProvider:hmacSha1Provider
																			   nonce:[self _generateNonce]
																		   timestamp:[self _generateTimestamp]] autorelease];
	
	//	OARequestParameter *pa1 = [[OARequestParameter alloc] initWithName:@"x_auth_username" value:strUserName];
	//	OARequestParameter *pa2 = [[OARequestParameter alloc] initWithName:@"x_auth_password" value:strUserPwd];
	//	OARequestParameter *pa3 = [[OARequestParameter alloc] initWithName:@"x_auth_mode" value:@"client_auth"];
	if (nil != _dic) {
		for (NSString *key in [_dic allKeys]) {
			[hmacSha1Request setOAuthParameterName:key withValue:[_dic valueForKey:key]];
		}
	}
	
    //    [hmacSha1Request setOAuthParameterName:@"oauth_verifier" withValue:[info valueForKey:@"WBShareKit_ver"]];
	
	//[hmacSha1Request1 setParameters:[NSArray arrayWithObjects:pa1,pa2,pa3,nil]];
	if (nil != _method) {
		[hmacSha1Request setHTTPMethod:_method];
	}
	
	[hmacSha1Provider release];
	[consumer release];
	//[hmacSha1Request1 release];
	return hmacSha1Request;
}

#pragma mark -
- (OAMutableURLRequest *)wyRequestWithURL:(NSString *)_url dic:(NSDictionary *)_dic method:(NSString *)_method
{
	OAHMAC_SHA1SignatureProvider *hmacSha1Provider = [[OAHMAC_SHA1SignatureProvider alloc] init];
	OAConsumer *consumer = [[OAConsumer alloc] initWithKey:WYAPPKEY secret:WYAPPSECRET];
	
	OAToken *token = nil;
	
    NSUserDefaults *info = [NSUserDefaults standardUserDefaults];
    NSString *strAccess = [info valueForKey:@"WBShareKit_wyToken"];
    
	if (nil != strAccess) {
		token = [[[OAToken alloc] initWithHTTPResponseBody:strAccess] autorelease];
		//NSLog(@"%@,%@",token.secret,token.key);
	}
	
	OAMutableURLRequest *hmacSha1Request = [[[OAMutableURLRequest alloc] initWithURL:[NSURL URLWithString:_url]
																			consumer:consumer
																			   token:token
																			   realm:NULL
																   signatureProvider:hmacSha1Provider
																			   nonce:[self _generateNonce]
																		   timestamp:[self _generateTimestamp]] autorelease];
	
	//	OARequestParameter *pa1 = [[OARequestParameter alloc] initWithName:@"x_auth_username" value:strUserName];
	//	OARequestParameter *pa2 = [[OARequestParameter alloc] initWithName:@"x_auth_password" value:strUserPwd];
	//	OARequestParameter *pa3 = [[OARequestParameter alloc] initWithName:@"x_auth_mode" value:@"client_auth"];
	if (nil != _dic) {
		for (NSString *key in [_dic allKeys]) {
			[hmacSha1Request setOAuthParameterName:key withValue:[_dic valueForKey:key]];
		}
	}
	
    //    [hmacSha1Request setOAuthParameterName:@"oauth_verifier" withValue:[info valueForKey:@"WBShareKit_ver"]];
	
	//[hmacSha1Request1 setParameters:[NSArray arrayWithObjects:pa1,pa2,pa3,nil]];
	if (nil != _method) {
		[hmacSha1Request setHTTPMethod:_method];
	}
	
	[hmacSha1Provider release];
	[consumer release];
	//[hmacSha1Request1 release];
	return hmacSha1Request;
}

#pragma mark -
#pragma mark sina
- (void)startSinaOauthWithSelector:(SEL)_sSel withFailedSelector:(SEL)_eSel
{
    NSString *strSSel = NSStringFromSelector(_sSel);
    NSString *strESel = NSStringFromSelector(_eSel);
    
    NSUserDefaults *info = [NSUserDefaults standardUserDefaults];
	[info setValue:strSSel forKey:@"WBShareKit_SSel"];
    [info setValue:strESel forKey:@"WBShareKit_ESel"];
    [info synchronize];
    
//    OAConsumer *consumer = [[OAConsumer alloc] initWithKey:SINAAPPKEY secret:SINAAPPSECRET];
//	
//	OAHMAC_SHA1SignatureProvider *hmacSha1Provider = [[OAHMAC_SHA1SignatureProvider alloc] init];
//	OAMutableURLRequest *hmacSha1Request = [[OAMutableURLRequest alloc] initWithURL:[NSURL URLWithString:SINARequestURL]
//                                                                           consumer:consumer
//                                                                              token:NULL
//                                                                              realm:NULL
//                                                                  signatureProvider:hmacSha1Provider
//                                                                              nonce:[self _generateNonce]
//                                                                          timestamp:[self _generateTimestamp]];
//    [hmacSha1Request setHTTPMethod:@"GET"];
//    
//    [hmacSha1Request prepare];
//	
    WBRequest *hmacSha1Request = [WBRequest requestWithURL:SINARequestURL dic:nil method:@"GET" withServers:@"sina" requestToken:YES accessToken:NO];
    
    OAAsynchronousDataFetcher *fetcher = [[OAAsynchronousDataFetcher alloc] initWithRequest:hmacSha1Request delegate:self didFinishSelector:@selector(sinaRequestTokenTicket:finishedWithData:) didFailSelector:@selector(sinaRequestTokenTicket:failedWithError:)];
    [fetcher start];
    [fetcher release];

}

- (void)sinaRequestTokenTicket:(OAServiceTicket *)ticket failedWithError:(NSError *)error {
	NSLog(@"sina 获取未授权token失败 错误:%@",error);
}


- (void)sinaRequestTokenTicket:(OAServiceTicket *)ticket finishedWithData:(NSMutableData *)data {
    
    NSString *responseBody = [[[NSString alloc] initWithData:data
                                                   encoding:NSUTF8StringEncoding] autorelease];
    NSLog(@"获得未授权的KEY:%@",responseBody);
    
    OAToken *token = [[OAToken alloc] initWithHTTPResponseBody:responseBody];
    
    NSString *tt = [token.key URLEncodedString];
    NSString *url = [NSString stringWithFormat:@"%@?oauth_token=%@&oauth_callback=%@",SINAAuthorizeURL,tt,CallBackURL];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    
    NSUserDefaults *info = [NSUserDefaults standardUserDefaults];
	[info setValue:responseBody forKey:@"WBShareKit_responseBody"];
    [info setValue:@"sina" forKey:@"WBShareKit_type"];
    [info synchronize];
    
    [token release];
//    [responseBody release];
}

- (void)startSinaAccessWithVerifier:(NSString *)_ver
{
//    NSUserDefaults *info = [NSUserDefaults standardUserDefaults];
//    OAConsumer *consumer = [[OAConsumer alloc] initWithKey:SINAAPPKEY secret:SINAAPPSECRET];
//    OAToken *token = [[OAToken alloc] initWithHTTPResponseBody:[info valueForKey:@"WBShareKit_responseBody"]];
//    OAHMAC_SHA1SignatureProvider *hmacSha1Provider = [[OAHMAC_SHA1SignatureProvider alloc] init];
//    
//	OAMutableURLRequest *hmacSha1Request = [[OAMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?oauth_verifier=%@",SINAAccessURL,_ver]]
//                                                                           consumer:consumer
//                                                                              token:token
//                                                                              realm:NULL
//                                                                  signatureProvider:hmacSha1Provider
//                                                                              nonce:[self _generateNonce]
//                                                                          timestamp:[self _generateTimestamp]];
//	[hmacSha1Request setHTTPMethod:@"GET"];
//    
//    [hmacSha1Request prepare];
    
    WBRequest *hmacSha1Request = [WBRequest requestWithURL:SINAAccessURL dic:[NSDictionary dictionaryWithObjectsAndKeys:_ver,@"oauth_verifier", nil] method:@"GET" withServers:@"sina" requestToken:NO accessToken:YES];
    
    OAAsynchronousDataFetcher *fetcher = [[OAAsynchronousDataFetcher alloc] initWithRequest:hmacSha1Request delegate:self didFinishSelector:@selector(sinaAccessTokenTicket:finishedWithData:) didFailSelector:@selector(sinaAccessTokenTicket:failedWithError:)];
    [fetcher start];
    [fetcher release];
}

- (void)sinaAccessTokenTicket:(OAServiceTicket *)ticket failedWithError:(NSError *)error {
	NSLog(@"sina 获取access token失败 错误:%@",error);
    
    NSUserDefaults *info = [NSUserDefaults standardUserDefaults];
    id delegate = [[UIApplication sharedApplication] delegate];
    [delegate performSelector:NSSelectorFromString([info valueForKey:@"WBShareKit_ESel"]) withObject:error];
}


- (void)sinaAccessTokenTicket:(OAServiceTicket *)ticket finishedWithData:(NSMutableData *)data {
    NSString *responseBody = [[[NSString alloc] initWithData:data
                                                   encoding:NSUTF8StringEncoding] autorelease];
    NSUserDefaults *info = [NSUserDefaults standardUserDefaults];
	[info setValue:responseBody forKey:@"WBShareKit_sinaToken"];
    [info synchronize];
    
    NSLog(@"获取access token:%@",responseBody);
    
//    NSUserDefaults *info = [NSUserDefaults standardUserDefaults];
    id delegate = [[UIApplication sharedApplication] delegate];
    [delegate performSelector:NSSelectorFromString([info valueForKey:@"WBShareKit_SSel"]) withObject:data];
    
//    [responseBody release];
}

#pragma mark -
- (void)sendSinaRecordWithStatus:(NSString *)_status lat:(double)_lat lng:(double)_lng delegate:(id)_delegate successSelector:(SEL)_sSel failSelector:(SEL)_eSel
{
    _successSEL = _sSel;
    _failSEL = _eSel;
    
    NSMutableString *url = [NSMutableString stringWithFormat:@"http://api.t.sina.com.cn/statuses/update.json",SINAAPPKEY];
    NSMutableString *body = [NSMutableString stringWithString:@""];
	if ([_status length] != 0) {
		[body appendFormat:@"status=%@",[[self replaceURLPlus:_status] URLEncodedString]];
	}
    if (_lat != 0) {
		[body appendFormat:@"&lat=%f",_lat];
	}
	if (_lng != 0) {
		[body appendFormat:@"&long=%f",_lng];
	}
    
	OAMutableURLRequest *request = [self sinaRequestWithURL:url
													dic:nil 
												 method:@"POST"];
	
	[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
	
    int contentLength = [body lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
    
    [request setValue:[NSString stringWithFormat:@"%d", contentLength] forHTTPHeaderField:@"Content-Length"];
	
	[request setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
	
	[request prepare];
	
	OAAsynchronousDataFetcher *addRecordFetcher = [[[OAAsynchronousDataFetcher alloc] init] autorelease];
	[addRecordFetcher initWithRequest:request 
                             delegate:_delegate
                    didFinishSelector:_sSel
                      didFailSelector:_eSel];
	[addRecordFetcher start];
//    [addRecordFetcher release];
}

- (NSString*) nameValString: (NSDictionary*) dict {
	NSArray* keys = [dict allKeys];
	NSString* result = [NSString string];
	int i;
	for (i = 0; i < [keys count]; i++) {
        result = [result stringByAppendingString:
                  [@"--" stringByAppendingString:
                   [WBShareKit_BOUNDARY stringByAppendingString:
                    [@"\r\nContent-Disposition: form-data; name=\"" stringByAppendingString:
                     [[keys objectAtIndex: i] stringByAppendingString:
                      [@"\"\r\n\r\n" stringByAppendingString:
                       [[dict valueForKey: [keys objectAtIndex: i]] stringByAppendingString: @"\r\n"]]]]]]];
	}
	
	return result;
}


- (void)sendSinaPhotoWithStatus:(NSString *)_status lat:(double)_lat lng:(double)_lng path:(NSString *)_path delegate:(id)_delegate successSelector:(SEL)_sSel failSelector:(SEL)_eSel
{
    _successSEL = _sSel;
    _failSEL = _eSel;
    
	NSMutableString *url = [NSMutableString stringWithFormat:@"http://api.t.sina.com.cn/statuses/upload.json"];
    NSDictionary *dic;
	if (_lat != 0 && _lng != 0) {
		dic = [NSDictionary dictionaryWithObjectsAndKeys:
			   [[self replaceURLPlus:_status] URLEncodedString] , @"status",
			   SINAAPPKEY, @"source",
			   [NSString stringWithFormat:@"%f",_lat],@"lat",
			   [NSString stringWithFormat:@"%f",_lng],@"long",
			   nil];
	}
	else {
		dic = [NSDictionary dictionaryWithObjectsAndKeys:
               [[self replaceURLPlus:_status] URLEncodedString] , @"status",
               SINAAPPKEY, @"source",
               nil];
	}
	
	int i;
	NSArray *names = [dic allKeys];
	for (i = 0; i < [names count]; i++) {
		if (i == 0) {
			[url appendString:@"?"];
		} else if (i > 0) {
			[url appendString:@"&"];
		}
		NSString *name = [names objectAtIndex:i];
		[url appendString:[NSString stringWithFormat:@"%@=%@", 
						   name,[[dic objectForKey:name] URLEncodedString]]];
	}
	
	
	NSString *param = [self nameValString:dic];
    NSString *footer = [NSString stringWithFormat:@"\r\n--%@--\r\n", WBShareKit_BOUNDARY];
    
    param = [param stringByAppendingString:[NSString stringWithFormat:@"--%@\r\n", WBShareKit_BOUNDARY]];
    param = [param stringByAppendingString:@"Content-Disposition: form-data; name=\"pic\";filename=\"image.jpg\"\r\nContent-Type: image/jpeg\r\n\r\n"];
    
	NSData *jpeg = UIImageJPEGRepresentation([UIImage imageWithContentsOfFile:_path], 0.55);
	//NSLog(@"jpeg size: %d", [jpeg length]);
	
    NSMutableData *data = [NSMutableData data];
    [data appendData:[param dataUsingEncoding:NSUTF8StringEncoding]];
    [data appendData:jpeg];
    [data appendData:[footer dataUsingEncoding:NSUTF8StringEncoding]];
	
//    NSLog(@"%@,%@",param,footer);
	//NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    //	[params setObject:APPKEY forKey:@"source"];
    //	[params setObject:_status forKey:@"status"];
	
	
	OAMutableURLRequest *request = [self sinaRequestWithURL:url
													dic:nil 
												 method:@"POST"];
	
	//[request setParameters:params];
	
	
	
	NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", WBShareKit_BOUNDARY];
    [request setHTTPShouldHandleCookies:NO];
    [request setHTTPMethod:@"POST"];
    [request setValue:contentType forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%d", [data length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:data];
    
    [request prepare];
	
	OAAsynchronousDataFetcher *addRecordFetcher = [[[OAAsynchronousDataFetcher alloc] init] autorelease];
	[addRecordFetcher initWithRequest:request 
                             delegate:_delegate
                    didFinishSelector:_successSEL
                      didFailSelector:_failSEL];
	[addRecordFetcher start];
//    [addRecordFetcher release];
}

#pragma mark -
#pragma mark douban
- (void)startDoubanOauthWithSelector:(SEL)_sSel withFailedSelector:(SEL)_eSel
{
    NSString *strSSel = NSStringFromSelector(_sSel);
    NSString *strESel = NSStringFromSelector(_eSel);
    
    NSUserDefaults *info = [NSUserDefaults standardUserDefaults];
	[info setValue:strSSel forKey:@"WBShareKit_SSel"];
    [info setValue:strESel forKey:@"WBShareKit_ESel"];
    [info synchronize];
    
//    OAConsumer *consumer = [[OAConsumer alloc] initWithKey:DOUBANAPPKEY secret:DOUBANAPPSECRET];
//	
//	OAHMAC_SHA1SignatureProvider *hmacSha1Provider = [[OAHMAC_SHA1SignatureProvider alloc] init];
//	OAMutableURLRequest *hmacSha1Request = [[OAMutableURLRequest alloc] initWithURL:[NSURL URLWithString:DOUBANRequestURL]
//                                                                           consumer:consumer
//                                                                              token:NULL
//                                                                              realm:NULL
//                                                                  signatureProvider:hmacSha1Provider
//                                                                              nonce:[self _generateNonce]
//                                                                          timestamp:[self _generateTimestamp]];
//    [hmacSha1Request setHTTPMethod:@"GET"];
//    
//    [hmacSha1Request prepare];

	WBRequest *hmacSha1Request = [WBRequest requestWithURL:DOUBANRequestURL dic:nil method:@"GET" withServers:@"douban" requestToken:YES accessToken:NO];
    
    OAAsynchronousDataFetcher *fetcher = [[OAAsynchronousDataFetcher alloc] initWithRequest:hmacSha1Request delegate:self didFinishSelector:@selector(doubanRequestTokenTicket:finishedWithData:) didFailSelector:@selector(doubanRequestTokenTicket:failedWithError:)];
    [fetcher start];
    [fetcher release];
}

- (void)doubanRequestTokenTicket:(OAServiceTicket *)ticket failedWithError:(NSError *)error {
	NSLog(@"douban 获取未授权token失败 错误:%@",error);
}


- (void)doubanRequestTokenTicket:(OAServiceTicket *)ticket finishedWithData:(NSMutableData *)data {
    
    NSString *responseBody = [[[NSString alloc] initWithData:data
                                                   encoding:NSUTF8StringEncoding] autorelease];
    NSLog(@"获得未授权的KEY:%@",responseBody);
    
    OAToken *token = [[OAToken alloc] initWithHTTPResponseBody:responseBody];
    
    NSString *tt = [token.key URLEncodedString];
    NSString *url = [NSString stringWithFormat:@"%@?oauth_token=%@&oauth_callback=%@",DOUBANAuthorizeURL,tt,CallBackURL];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    
    NSUserDefaults *info = [NSUserDefaults standardUserDefaults];
	[info setValue:responseBody forKey:@"WBShareKit_responseBody"];
    [info setValue:@"douban" forKey:@"WBShareKit_type"];
    [info synchronize];
    
    [token release];
//    [responseBody release];
}

- (void)startDoubanAccess
{
//    NSUserDefaults *info = [NSUserDefaults standardUserDefaults];
//    OAConsumer *consumer = [[OAConsumer alloc] initWithKey:DOUBANAPPKEY secret:DOUBANAPPSECRET];
//    OAToken *token = [[OAToken alloc] initWithHTTPResponseBody:[info valueForKey:@"WBShareKit_responseBody"]];
//    OAHMAC_SHA1SignatureProvider *hmacSha1Provider = [[OAHMAC_SHA1SignatureProvider alloc] init];
//    
//	OAMutableURLRequest *hmacSha1Request = [[OAMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",DOUBANAccessURL]]
//                                                                           consumer:consumer
//                                                                              token:token
//                                                                              realm:NULL
//                                                                  signatureProvider:hmacSha1Provider
//                                                                              nonce:[self _generateNonce]
//                                                                          timestamp:[self _generateTimestamp]];
//	[hmacSha1Request setHTTPMethod:@"GET"];
//    
//    [hmacSha1Request prepare];

    WBRequest *hmacSha1Request = [WBRequest requestWithURL:DOUBANAccessURL dic:nil method:@"GET" withServers:@"douban" requestToken:NO accessToken:YES];
    
    OAAsynchronousDataFetcher *fetcher = [[OAAsynchronousDataFetcher alloc] initWithRequest:hmacSha1Request delegate:self didFinishSelector:@selector(doubanAccessTokenTicket:finishedWithData:) didFailSelector:@selector(doubanAccessTokenTicket:failedWithError:)];
    [fetcher start];
    [fetcher release];
}

- (void)doubanAccessTokenTicket:(OAServiceTicket *)ticket failedWithError:(NSError *)error {
	NSLog(@"douban 获取access token失败 错误:%@",error);
    
    NSUserDefaults *info = [NSUserDefaults standardUserDefaults];
    id delegate = [[UIApplication sharedApplication] delegate];
    [delegate performSelector:NSSelectorFromString([info valueForKey:@"WBShareKit_ESel"]) withObject:error];
}


- (void)doubanAccessTokenTicket:(OAServiceTicket *)ticket finishedWithData:(NSMutableData *)data {
    NSString *responseBody = [[[NSString alloc] initWithData:data
                                                    encoding:NSUTF8StringEncoding] autorelease];
    NSUserDefaults *info = [NSUserDefaults standardUserDefaults];
	[info setValue:responseBody forKey:@"WBShareKit_doubanToken"];
    [info synchronize];
    
    NSLog(@"获取access token:%@",responseBody);
    
//    NSUserDefaults *info = [NSUserDefaults standardUserDefaults];
    id delegate = [[UIApplication sharedApplication] delegate];
    [delegate performSelector:NSSelectorFromString([info valueForKey:@"WBShareKit_SSel"]) withObject:data];
    
//    [responseBody release];
}

#pragma mark -
- (void)sendDoubanShuoWithStatus:(NSString *)_status delegate:(id)_delegate successSelector:(SEL)_sSel failSelector:(SEL)_eSel
{
    _successSEL = _sSel;
    _failSEL = _eSel;
    
    NSMutableString *url = [NSMutableString stringWithFormat:@"http://api.douban.com/miniblog/saying"];
    NSMutableString *body = [NSMutableString stringWithString:@""];
	if ([_status length] != 0) {
		[body appendString:[NSString stringWithFormat:@"<?xml version='1.0' encoding='UTF-8'?><entry xmlns:ns0=\"http://www.w3.org/2005/Atom\" xmlns:db=\"http://www.douban.com/xmlns/\"><content>%@</content></entry>",_status]];
	}
	
	OAMutableURLRequest *request = [self doubanRequestWithURL:url
                                                        dic:nil
                                                     method:@"POST"];
	[request prepare];
    
    [request setValue:@"json" forHTTPHeaderField:@"alt"];//返回json
    
	[request setValue:@"application/atom+xml" forHTTPHeaderField:@"Content-Type"];
	
    int contentLength = [body lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
    
    [request setValue:[NSString stringWithFormat:@"%d", contentLength] forHTTPHeaderField:@"Content-Length"];
	
	[request setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
	
    //	[request prepare];
	
	OAAsynchronousDataFetcher *addRecordFetcher = [[[OAAsynchronousDataFetcher alloc] init] autorelease];
	[addRecordFetcher initWithRequest:request 
                             delegate:_delegate
                    didFinishSelector:_sSel
                      didFailSelector:_eSel];
	[addRecordFetcher start];
//    [addRecordFetcher release];
}

#pragma mark -
#pragma mark tx
- (void)startTxOauthWithSelector:(SEL)_sSel withFailedSelector:(SEL)_eSel
{
    NSString *strSSel = NSStringFromSelector(_sSel);
    NSString *strESel = NSStringFromSelector(_eSel);
    
    NSUserDefaults *info = [NSUserDefaults standardUserDefaults];
	[info setValue:strSSel forKey:@"WBShareKit_SSel"];
    [info setValue:strESel forKey:@"WBShareKit_ESel"];
    [info synchronize];
    
    OAConsumer *consumer = [[OAConsumer alloc] initWithKey:TXAPPKEY secret:TXAPPSECRET];
	
	OAHMAC_SHA1SignatureProvider *hmacSha1Provider = [[OAHMAC_SHA1SignatureProvider alloc] init];
	OAMutableURLRequest *hmacSha1Request = [[[OAMutableURLRequest alloc] initWithURL:[NSURL URLWithString:TXRequestURL]
                                                                           consumer:consumer
                                                                              token:NULL
                                                                              realm:NULL
                                                                  signatureProvider:hmacSha1Provider
                                                                              nonce:[self _generateNonce]
                                                                          timestamp:[self _generateTimestamp]] autorelease];
//    [hmacSha1Request setOAuthParameterName:@"oauth_callback" withValue:CallBackURL];
    [hmacSha1Request setHTTPMethod:@"GET"];
    [hmacSha1Request setParameters:[NSArray arrayWithObject:[OARequestParameter requestParameterWithName:@"oauth_callback" value:CallBackURL]]];
    NSString *url = [NSString stringWithFormat:@"%@?oauth_callback=%@&%@",TXRequestURL,[CallBackURL URLEncodedString],[hmacSha1Request txBaseString]];
//    NSLog(@"tx:%@",url);
    [hmacSha1Request setURL:[NSURL URLWithString:url]];
    
    OAAsynchronousDataFetcher *fetcher = [[OAAsynchronousDataFetcher alloc] initWithRequest:hmacSha1Request delegate:self didFinishSelector:@selector(txRequestTokenTicket:finishedWithData:) didFailSelector:@selector(txRequestTokenTicket:failedWithError:)];
    [fetcher start];
    [fetcher release];
    
    [consumer release];
}

- (void)txRequestTokenTicket:(OAServiceTicket *)ticket failedWithError:(NSError *)error {
	NSLog(@"tx 获取未授权token失败 错误:%@",error);
}


- (void)txRequestTokenTicket:(OAServiceTicket *)ticket finishedWithData:(NSMutableData *)data {
    
    NSString *responseBody = [[[NSString alloc] initWithData:data
                                                   encoding:NSUTF8StringEncoding] autorelease];
    NSLog(@"获得未授权的KEY:%@",responseBody);
    
    OAToken *token = [[OAToken alloc] initWithHTTPResponseBody:responseBody];
    
    NSString *tt = [token.key URLEncodedString];
    NSString *url = [NSString stringWithFormat:@"%@?oauth_token=%@&oauth_callback=%@",TXAuthorizeURL,tt,CallBackURL];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    
    NSUserDefaults *info = [NSUserDefaults standardUserDefaults];
	[info setValue:responseBody forKey:@"WBShareKit_responseBody"];
    [info setValue:@"tx" forKey:@"WBShareKit_type"];
    [info synchronize];
    
    [token release];
//    [responseBody release];
}

- (void)startTxAccessWithVerifier:(NSString *)_ver
{
    NSUserDefaults *info = [NSUserDefaults standardUserDefaults];
    OAConsumer *consumer = [[OAConsumer alloc] initWithKey:TXAPPKEY secret:TXAPPSECRET];
    OAToken *token = [[OAToken alloc] initWithHTTPResponseBody:[info valueForKey:@"WBShareKit_responseBody"]];
    OAHMAC_SHA1SignatureProvider *hmacSha1Provider = [[OAHMAC_SHA1SignatureProvider alloc] init];
    
	OAMutableURLRequest *hmacSha1Request = [[[OAMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?oauth_verifier=%@",TXAccessURL,_ver]]
                                                                           consumer:consumer
                                                                              token:token
                                                                              realm:NULL
                                                                  signatureProvider:hmacSha1Provider
                                                                              nonce:[self _generateNonce]
                                                                          timestamp:[self _generateTimestamp]] autorelease];
	[hmacSha1Request setHTTPMethod:@"GET"];
    [hmacSha1Request setParameters:[NSArray arrayWithObject:[OARequestParameter requestParameterWithName:@"oauth_verifier" value:_ver]]];
    NSString *url = [NSString stringWithFormat:@"%@?oauth_verifier=%@&%@",TXAccessURL,_ver,[hmacSha1Request txBaseString]];
    
//    NSString *url = [NSString stringWithFormat:@"%@?%@",TXRequestURL,[hmacSha1Request txBaseString]];
//    NSLog(@"%@",url);
    [hmacSha1Request setURL:[NSURL URLWithString:url]];

    
    OAAsynchronousDataFetcher *fetcher = [[OAAsynchronousDataFetcher alloc] initWithRequest:hmacSha1Request delegate:self didFinishSelector:@selector(txAccessTokenTicket:finishedWithData:) didFailSelector:@selector(txAccessTokenTicket:failedWithError:)];
    [fetcher start];
    [fetcher release];
    
    [token release];
    [hmacSha1Provider release];
    [consumer release];
}

- (void)txAccessTokenTicket:(OAServiceTicket *)ticket failedWithError:(NSError *)error {
	NSLog(@"tx 获取access token失败 错误:%@",error);
    
    NSUserDefaults *info = [NSUserDefaults standardUserDefaults];
    id delegate = [[UIApplication sharedApplication] delegate];
    [delegate performSelector:NSSelectorFromString([info valueForKey:@"WBShareKit_ESel"]) withObject:error];
}


- (void)txAccessTokenTicket:(OAServiceTicket *)ticket finishedWithData:(NSMutableData *)data {
    NSString *responseBody = [[[NSString alloc] initWithData:data
                                                    encoding:NSUTF8StringEncoding] autorelease];
    NSUserDefaults *info = [NSUserDefaults standardUserDefaults];
	[info setValue:responseBody forKey:@"WBShareKit_txToken"];
    [info synchronize];
    
    NSLog(@"获取access token:%@",responseBody);
    
//    NSUserDefaults *info = [NSUserDefaults standardUserDefaults];
    id delegate = [[UIApplication sharedApplication] delegate];
    [delegate performSelector:NSSelectorFromString([info valueForKey:@"WBShareKit_SSel"]) withObject:data];
    
//    [responseBody release];
}

#pragma mark -
- (void)sendTxRecordWithStatus:(NSString *)_status lat:(double)_lat lng:(double)_lng format:(NSString *)_format delegate:(id)_delegate successSelector:(SEL)_sSel failSelector:(SEL)_eSel
{
    _successSEL = _sSel;
    _failSEL = _eSel;
    
    NSMutableString *url = [NSMutableString stringWithFormat:@"http://open.t.qq.com/api/t/add"];
    NSMutableString *body = [NSMutableString stringWithString:@""];

	OAMutableURLRequest *request = [self txRequestWithURL:url dic:nil method:@"POST"];
    
    NSMutableArray *parameters = [[NSMutableArray alloc] initWithCapacity:0];
    if (nil != _status) {
        [parameters addObject:[OARequestParameter requestParameterWithName:@"content" value:_status]];
    }
    if (0 != _lng || 0 != _lat) {
        [parameters addObject:[OARequestParameter requestParameterWithName:@"Wei" value:[NSString stringWithFormat:@"%f",_lat]]];
        [parameters addObject:[OARequestParameter requestParameterWithName:@"Jing" value:[NSString stringWithFormat:@"%f",_lng]]];
    }
    if (nil != _format) {
        [parameters addObject:[OARequestParameter requestParameterWithName:@"format" value:_format]];
    }
    else
    {
        [parameters addObject:[OARequestParameter requestParameterWithName:@"format" value:@"json"]];
    }
    
    [parameters addObject:[OARequestParameter requestParameterWithName:@"clientip" value:@"127.0.0.1"]];
    
    [request setParameters:parameters];
    
    [body appendFormat:@"%@",[request txBaseString]];
    
//    NSLog(@"%@",body);
    [request setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];

	
	OAAsynchronousDataFetcher *addRecordFetcher = [[[OAAsynchronousDataFetcher alloc] init] autorelease];
	[addRecordFetcher initWithRequest:request 
                             delegate:_delegate
                    didFinishSelector:_sSel
                      didFailSelector:_eSel];
	[addRecordFetcher start];
//    [addRecordFetcher release];
    
    [parameters release];
}

- (void)sendTxRecordWithStatus:(NSString *)_status lat:(double)_lat lng:(double)_lng format:(NSString *)_format path:(NSString *)_path delegate:(id)_delegate successSelector:(SEL)_sSel failSelector:(SEL)_eSel
{
    _successSEL = _sSel;
    _failSEL = _eSel;
    
    _successSEL = _sSel;
    _failSEL = _eSel;
    
    NSMutableString *url = [NSMutableString stringWithFormat:@"http://open.t.qq.com/api/t/add_pic"];
    NSMutableString *body = [NSMutableString stringWithString:@""];
    
	OAMutableURLRequest *request = [self txRequestWithURL:url dic:nil method:@"POST"];
    
    NSMutableArray *parameters = [[NSMutableArray alloc] initWithCapacity:0];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:0];
    if (nil != _status) {
//        [parameters addObject:[OARequestParameter requestParameterWithName:@"content" value:_status]];
        [dic setValue:_status forKey:@"content"];
    }
    if (0 != _lng || 0 != _lat) {
//        [parameters addObject:[OARequestParameter requestParameterWithName:@"Wei" value:[NSString stringWithFormat:@"%f",_lat]]];
//        [parameters addObject:[OARequestParameter requestParameterWithName:@"Jing" value:[NSString stringWithFormat:@"%f",_lng]]];
        [dic setValue:[NSString stringWithFormat:@"%f",_lat] forKey:@"Wei"];
        [dic setValue:[NSString stringWithFormat:@"%f",_lng] forKey:@"Jing"];
    }
    if (nil != _format) {
//        [parameters addObject:[OARequestParameter requestParameterWithName:@"format" value:_format]];
        [dic setValue:_format forKey:@"format"];
    }
    else
    {
//        [parameters addObject:[OARequestParameter requestParameterWithName:@"format" value:@"json"]];
        [dic setValue:@"json" forKey:@"format"];
    }
    
//    [parameters addObject:[OARequestParameter requestParameterWithName:@"clientip" value:@"127.0.0.1"]];
    [dic setValue:@"127.0.0.1" forKey:@"clientip"];
    
    for (NSString *key in [dic allKeys]) {
        [parameters addObject:[OARequestParameter requestParameterWithName:key value:[dic valueForKey:key]]];
    }
    
    [request setParameters:parameters];
    
    [body appendFormat:@"%@",[request txBaseString]];
    
//    NSString *url = [NSString stringWithFormat:@"%@?oauth_callback=%@&%@",TXRequestURL,[CallBackURL URLEncodedString],[hmacSha1Request txBaseString]];
    NSString *_url = [NSString stringWithFormat:@"%@?%@",url,body];
    [request setURL:[NSURL URLWithString:_url]];
//    NSLog(@"%@",_url);
    
    
    NSMutableData *postbody = [[NSMutableData alloc] init];
    
    NSString *param = [self nameValString:dic];
    NSString *footer = [NSString stringWithFormat:@"\r\n--%@--\r\n", WBShareKit_BOUNDARY];
    
    param = [param stringByAppendingString:[NSString stringWithFormat:@"--%@\r\n", WBShareKit_BOUNDARY]];
    param = [param stringByAppendingString:@"Content-Disposition: form-data; name=\"pic\";filename=\"image.jpg\"\r\nContent-Type: image/jpeg\r\n\r\n"];
    NSData *jpeg = UIImageJPEGRepresentation([UIImage imageWithContentsOfFile:_path], 0.55);

    [postbody appendData:[param dataUsingEncoding:NSUTF8StringEncoding]];
    [postbody appendData:jpeg];
    [postbody appendData:[footer dataUsingEncoding:NSUTF8StringEncoding]];
    
//    NSString *headerTemplate = @"--%@\r\nContent-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\nContent-Type: \"image/jpeg\"\r\n\r\n";
//	NSData *boundaryBytes = [[NSString stringWithFormat:@"\r\n--%@--\r\n", WBShareKit_BOUNDARY] dataUsingEncoding:NSUTF8StringEncoding];
//    NSString *filePath = _path;
//    NSData *fileData = UIImageJPEGRepresentation([UIImage imageWithContentsOfFile:filePath], 0.01);
//    NSString *header = [NSString stringWithFormat:headerTemplate,WBShareKit_BOUNDARY, @"Pic", [[filePath componentsSeparatedByString:@"/"] lastObject]];
//    [postbody appendData:[header dataUsingEncoding:NSUTF8StringEncoding]];
//    [postbody appendData:fileData];
//    [postbody appendData:boundaryBytes];

    [request setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@", WBShareKit_BOUNDARY] forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%d", [postbody length]] forHTTPHeaderField:@"Content-Length"];
    
//    NSLog(@"%@",body);
    [request setHTTPBody:postbody];
    
	
	OAAsynchronousDataFetcher *addRecordFetcher = [[[OAAsynchronousDataFetcher alloc] init] autorelease];
	[addRecordFetcher initWithRequest:request 
                             delegate:_delegate
                    didFinishSelector:_sSel
                      didFailSelector:_eSel];
	[addRecordFetcher start];
//    [addRecordFetcher release];
    [parameters release];
    [postbody release];
}

#pragma mark -
#pragma mark twitter
- (void)startTwitterOauthWithSelector:(SEL)_sSel withFailedSelector:(SEL)_eSel
{
    NSString *strSSel = NSStringFromSelector(_sSel);
    NSString *strESel = NSStringFromSelector(_eSel);
    
    NSUserDefaults *info = [NSUserDefaults standardUserDefaults];
	[info setValue:strSSel forKey:@"WBShareKit_SSel"];
    [info setValue:strESel forKey:@"WBShareKit_ESel"];
    [info synchronize];
    
//    OAConsumer *consumer = [[OAConsumer alloc] initWithKey:TWITTERAPPKEY secret:TWITTERAPPSECRET];
//	
//	OAHMAC_SHA1SignatureProvider *hmacSha1Provider = [[OAHMAC_SHA1SignatureProvider alloc] init];
//	OAMutableURLRequest *hmacSha1Request = [[OAMutableURLRequest alloc] initWithURL:[NSURL URLWithString:TWITTERRequestURL]
//                                                                           consumer:consumer
//                                                                              token:NULL
//                                                                              realm:NULL
//                                                                  signatureProvider:hmacSha1Provider
//                                                                              nonce:[self _generateNonce]
//                                                                          timestamp:[self _generateTimestamp]];
//    [hmacSha1Request setHTTPMethod:@"GET"];
//    [hmacSha1Request setParameters:[NSArray arrayWithObjects:[[OARequestParameter alloc] initWithName:@"oauth_callback" value:@"oauth://minroad.com"],nil]];
//    
//    [hmacSha1Request prepare];

	
    WBRequest *hmacSha1Request = [WBRequest requestWithURL:TWITTERRequestURL dic:[NSDictionary dictionaryWithObjectsAndKeys:@"oauth://minroad.com",@"oauth_callback",nil] method:@"GET" withServers:@"twitter" requestToken:YES accessToken:NO];
    
    OAAsynchronousDataFetcher *fetcher = [[OAAsynchronousDataFetcher alloc] initWithRequest:hmacSha1Request delegate:self didFinishSelector:@selector(twitterRequestTokenTicket:finishedWithData:) didFailSelector:@selector(twitterRequestTokenTicket:failedWithError:)];
    [fetcher start];
    [fetcher release];
}

- (void)twitterRequestTokenTicket:(OAServiceTicket *)ticket failedWithError:(NSError *)error {
	NSLog(@"twitter 获取未授权token失败 错误:%@",error);
}


- (void)twitterRequestTokenTicket:(OAServiceTicket *)ticket finishedWithData:(NSMutableData *)data {
    
    NSString *responseBody = [[[NSString alloc] initWithData:data
                                                   encoding:NSUTF8StringEncoding] autorelease];
    NSLog(@"获得未授权的KEY:%@",responseBody);
    
    OAToken *token = [[OAToken alloc] initWithHTTPResponseBody:responseBody];
    
    NSString *tt = [token.key URLEncodedString];
    NSString *url = [NSString stringWithFormat:@"%@?oauth_token=%@&oauth_callback=%@",TWITTERAuthorizeURL,tt,CallBackURL];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    
    NSUserDefaults *info = [NSUserDefaults standardUserDefaults];
	[info setValue:responseBody forKey:@"WBShareKit_responseBody"];
    [info setValue:@"twitter" forKey:@"WBShareKit_type"];
    [info synchronize];
    
    [token release];
//    [responseBody release];
}

- (void)startTwitterAccess
{
//    NSUserDefaults *info = [NSUserDefaults standardUserDefaults];
//    OAConsumer *consumer = [[OAConsumer alloc] initWithKey:TWITTERAPPKEY secret:TWITTERAPPSECRET];
//    OAToken *token = [[OAToken alloc] initWithHTTPResponseBody:[info valueForKey:@"WBShareKit_responseBody"]];
//    OAHMAC_SHA1SignatureProvider *hmacSha1Provider = [[OAHMAC_SHA1SignatureProvider alloc] init];
//    
//	OAMutableURLRequest *hmacSha1Request = [[OAMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",TWITTERAccessURL]]
//                                                                           consumer:consumer
//                                                                              token:token
//                                                                              realm:NULL
//                                                                  signatureProvider:hmacSha1Provider
//                                                                              nonce:[self _generateNonce]
//                                                                          timestamp:[self _generateTimestamp]];
//	[hmacSha1Request setHTTPMethod:@"GET"];
//    
//    [hmacSha1Request prepare];

    WBRequest *hmacSha1Request = [WBRequest requestWithURL:TWITTERAccessURL dic:nil method:@"GET" withServers:@"twitter" requestToken:NO accessToken:YES];
    
    OAAsynchronousDataFetcher *fetcher = [[OAAsynchronousDataFetcher alloc] initWithRequest:hmacSha1Request delegate:self didFinishSelector:@selector(twitterAccessTokenTicket:finishedWithData:) didFailSelector:@selector(twitterAccessTokenTicket:failedWithError:)];
    [fetcher start];
    [fetcher release];
}

- (void)twitterAccessTokenTicket:(OAServiceTicket *)ticket failedWithError:(NSError *)error {
	NSLog(@"twitter 获取access token失败 错误:%@",error);
    
    NSUserDefaults *info = [NSUserDefaults standardUserDefaults];
    id delegate = [[UIApplication sharedApplication] delegate];
    [delegate performSelector:NSSelectorFromString([info valueForKey:@"WBShareKit_ESel"]) withObject:error];
}


- (void)twitterAccessTokenTicket:(OAServiceTicket *)ticket finishedWithData:(NSMutableData *)data {
    NSString *responseBody = [[[NSString alloc] initWithData:data
                                                    encoding:NSUTF8StringEncoding] autorelease];
    NSUserDefaults *info = [NSUserDefaults standardUserDefaults];
	[info setValue:responseBody forKey:@"WBShareKit_twitterToken"];
    [info synchronize];

    NSLog(@"获取access token:%@",responseBody);
    
//    NSUserDefaults *info = [NSUserDefaults standardUserDefaults];
    id delegate = [[UIApplication sharedApplication] delegate];
    [delegate performSelector:NSSelectorFromString([info valueForKey:@"WBShareKit_SSel"]) withObject:data];
//    [responseBody release];
}

#pragma mark -
- (void)sendTwitterWithStatus:(NSString *)_status lat:(double)_lat lng:(double)_lng delegate:(id)_delegate successSelector:(SEL)_sSel failSelector:(SEL)_eSel
{
    _successSEL = _sSel;
    _failSEL = _eSel;
    
    NSMutableString *url = [NSMutableString stringWithFormat:@"http://api.twitter.com/1/statuses/update.json",TWITTERAPPKEY];
    NSMutableString *body = [NSMutableString stringWithString:@""];
	if ([_status length] != 0) {
		[body appendFormat:@"status=%@",[[self replaceURLPlus:_status] URLEncodedString]];
	}
    if (_lat != 0) {
		[body appendFormat:@"&lat=%f",_lat];
	}
	if (_lng != 0) {
		[body appendFormat:@"&long=%f",_lng];
	}
	
	OAMutableURLRequest *request = [self twitterRequestWithURL:url
                                                        dic:nil 
                                                     method:@"POST"];
	
	[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
	
    int contentLength = [body lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
    
    [request setValue:[NSString stringWithFormat:@"%d", contentLength] forHTTPHeaderField:@"Content-Length"];
	
	[request setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
	
	[request prepare];
	
	OAAsynchronousDataFetcher *addRecordFetcher = [[[OAAsynchronousDataFetcher alloc] init] autorelease];
	[addRecordFetcher initWithRequest:request 
                             delegate:_delegate
                    didFinishSelector:_sSel
                      didFailSelector:_eSel];
	[addRecordFetcher start];
//    [addRecordFetcher release];
}

#pragma mark -
#pragma mark 163
- (void)startWyOauthWithSelector:(SEL)_sSel withFailedSelector:(SEL)_eSel
{
    NSString *strSSel = NSStringFromSelector(_sSel);
    NSString *strESel = NSStringFromSelector(_eSel);
    
    NSUserDefaults *info = [NSUserDefaults standardUserDefaults];
	[info setValue:strSSel forKey:@"WBShareKit_SSel"];
    [info setValue:strESel forKey:@"WBShareKit_ESel"];
    [info synchronize];
    

    WBRequest *hmacSha1Request = [WBRequest requestWithURL:WYRequestURL dic:nil method:@"GET" withServers:@"wy" requestToken:YES accessToken:NO];
    
    OAAsynchronousDataFetcher *fetcher = [[OAAsynchronousDataFetcher alloc] initWithRequest:hmacSha1Request delegate:self didFinishSelector:@selector(wyRequestTokenTicket:finishedWithData:) didFailSelector:@selector(wyRequestTokenTicket:failedWithError:)];
    [fetcher start];
    [fetcher release];
    
}

- (void)wyRequestTokenTicket:(OAServiceTicket *)ticket failedWithError:(NSError *)error {
	NSLog(@"wy 获取未授权token失败 错误:%@",error);
}


- (void)wyRequestTokenTicket:(OAServiceTicket *)ticket finishedWithData:(NSMutableData *)data {
    
    NSString *responseBody = [[[NSString alloc] initWithData:data
                                                    encoding:NSUTF8StringEncoding] autorelease];
    NSLog(@"获得未授权的KEY:%@",responseBody);
    
    OAToken *token = [[OAToken alloc] initWithHTTPResponseBody:responseBody];
    
    NSString *tt = [token.key URLEncodedString];
    NSString *url = [NSString stringWithFormat:@"%@?oauth_token=%@&oauth_callback=%@",WYAuthorizeURL,tt,CallBackURL];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    
    NSUserDefaults *info = [NSUserDefaults standardUserDefaults];
	[info setValue:responseBody forKey:@"WBShareKit_responseBody"];
    [info setValue:@"wy" forKey:@"WBShareKit_type"];
    [info synchronize];
    
    [token release];
    //    [responseBody release];
}

- (void)startWyAccess
{
    WBRequest *hmacSha1Request = [WBRequest requestWithURL:WYAccessURL dic:nil method:@"GET" withServers:@"wy" requestToken:NO accessToken:YES];
    
    OAAsynchronousDataFetcher *fetcher = [[OAAsynchronousDataFetcher alloc] initWithRequest:hmacSha1Request delegate:self didFinishSelector:@selector(wyAccessTokenTicket:finishedWithData:) didFailSelector:@selector(wyAccessTokenTicket:failedWithError:)];
    [fetcher start];
    [fetcher release];
}

- (void)wyAccessTokenTicket:(OAServiceTicket *)ticket failedWithError:(NSError *)error {
	NSLog(@"wy 获取access token失败 错误:%@",error);
    
    NSUserDefaults *info = [NSUserDefaults standardUserDefaults];
    id delegate = [[UIApplication sharedApplication] delegate];
    [delegate performSelector:NSSelectorFromString([info valueForKey:@"WBShareKit_ESel"]) withObject:error];
}


- (void)wyAccessTokenTicket:(OAServiceTicket *)ticket finishedWithData:(NSMutableData *)data {
    NSString *responseBody = [[[NSString alloc] initWithData:data
                                                    encoding:NSUTF8StringEncoding] autorelease];
    NSUserDefaults *info = [NSUserDefaults standardUserDefaults];
	[info setValue:responseBody forKey:@"WBShareKit_wyToken"];
    [info synchronize];
    
    NSLog(@"获取access token:%@",responseBody);
    
//    NSUserDefaults *info = [NSUserDefaults standardUserDefaults];
    id delegate = [[UIApplication sharedApplication] delegate];
    [delegate performSelector:NSSelectorFromString([info valueForKey:@"WBShareKit_SSel"]) withObject:data];
    
    //    [responseBody release];
}

#pragma mark -
- (void)sendWyRecordWithStatus:(NSString *)_status lat:(double)_lat lng:(double)_lng delegate:(id)_delegate successSelector:(SEL)_sSel failSelector:(SEL)_eSel
{
    _successSEL = _sSel;
    _failSEL = _eSel;
    
    NSMutableString *url = [NSMutableString stringWithFormat:@"http://api.t.163.com/statuses/update.json"];
    NSMutableString *body = [NSMutableString stringWithString:@""];
	if ([_status length] != 0) {
		[body appendFormat:@"status=%@",[[self replaceURLPlus:_status] URLEncodedString]];
	}
    if (_lat != 0) {
		[body appendFormat:@"&lat=%f",_lat];
	}
	if (_lng != 0) {
		[body appendFormat:@"&long=%f",_lng];
	}
	
	OAMutableURLRequest *request = [self wyRequestWithURL:url
                                                        dic:nil 
                                                     method:@"POST"];
	
	[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
	
    int contentLength = [body lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
    
    [request setValue:[NSString stringWithFormat:@"%d", contentLength] forHTTPHeaderField:@"Content-Length"];
	
	[request setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
	
	[request prepare];
	
	OAAsynchronousDataFetcher *addRecordFetcher = [[[OAAsynchronousDataFetcher alloc] init] autorelease];
	[addRecordFetcher initWithRequest:request 
                             delegate:_delegate
                    didFinishSelector:_sSel
                      didFailSelector:_eSel];
	[addRecordFetcher start];
    //    [addRecordFetcher release];
}


- (void)sendWyPhotoWithStatus:(NSString *)_status lat:(double)_lat lng:(double)_lng path:(NSString *)_path delegate:(id)_delegate successSelector:(SEL)_sSel failSelector:(SEL)_eSel
{
    _successSEL = _sSel;
    _failSEL = _eSel;
    
	NSMutableString *url = [NSMutableString stringWithFormat:@"http://api.t.163.com/statuses/upload.json"];
    NSDictionary *dic;
	if (_lat != 0 && _lng != 0) {
		dic = [NSDictionary dictionaryWithObjectsAndKeys:
			   [[self replaceURLPlus:_status] URLEncodedString] , @"status",
			   WYAPPKEY, @"source",
			   [NSString stringWithFormat:@"%f",_lat],@"lat",
			   [NSString stringWithFormat:@"%f",_lng],@"long",
			   nil];
	}
	else {
		dic = [NSDictionary dictionaryWithObjectsAndKeys:
               [[self replaceURLPlus:_status] URLEncodedString] , @"status",
               WYAPPKEY, @"source",
               nil];
	}
	
	int i;
	NSArray *names = [dic allKeys];
	for (i = 0; i < [names count]; i++) {
		if (i == 0) {
			[url appendString:@"?"];
		} else if (i > 0) {
			[url appendString:@"&"];
		}
		NSString *name = [names objectAtIndex:i];
		[url appendString:[NSString stringWithFormat:@"%@=%@", 
						   name,[[dic objectForKey:name] URLEncodedString]]];
	}
	
	
	NSString *param = [self nameValString:dic];
    NSString *footer = [NSString stringWithFormat:@"\r\n--%@--\r\n", WBShareKit_BOUNDARY];
    
    param = [param stringByAppendingString:[NSString stringWithFormat:@"--%@\r\n", WBShareKit_BOUNDARY]];
    param = [param stringByAppendingString:@"Content-Disposition: form-data; name=\"pic\";filename=\"image.jpg\"\r\nContent-Type: image/jpeg\r\n\r\n"];
    
	NSData *jpeg = UIImageJPEGRepresentation([UIImage imageWithContentsOfFile:_path], 0.55);
	//NSLog(@"jpeg size: %d", [jpeg length]);
	
    NSMutableData *data = [NSMutableData data];
    [data appendData:[param dataUsingEncoding:NSUTF8StringEncoding]];
    [data appendData:jpeg];
    [data appendData:[footer dataUsingEncoding:NSUTF8StringEncoding]];
	
    //    NSLog(@"%@,%@",param,footer);
	//NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    //	[params setObject:APPKEY forKey:@"source"];
    //	[params setObject:_status forKey:@"status"];
	
	
	OAMutableURLRequest *request = [self wyRequestWithURL:url
                                                        dic:nil 
                                                     method:@"POST"];
	
	//[request setParameters:params];
	
	
	
	NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", WBShareKit_BOUNDARY];
    [request setHTTPShouldHandleCookies:NO];
    [request setHTTPMethod:@"POST"];
    [request setValue:contentType forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%d", [data length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:data];
    
    [request prepare];
	
	OAAsynchronousDataFetcher *addRecordFetcher = [[[OAAsynchronousDataFetcher alloc] init] autorelease];
	[addRecordFetcher initWithRequest:request 
                             delegate:_delegate
                    didFinishSelector:_successSEL
                      didFailSelector:_failSEL];
	[addRecordFetcher start];
    //    [addRecordFetcher release];
}

#pragma mark app delegate
- (void)handleOpenURL:(NSURL *)url
{
    NSUserDefaults *info = [NSUserDefaults standardUserDefaults];
    NSString *type = [info valueForKey:@"WBShareKit_type"];
    if ([type isEqualToString:@"sina"]) {
        NSString *string = [[url query] substringWithRange:NSMakeRange([[url query] length]-6, 6)];
        
        
        [info setValue:string forKey:@"WBShareKit_ver"];
        //	[info setValue:[url query] forKey:@"WBShareKit_responseBody"];
        [info synchronize];
        
        [self startSinaAccessWithVerifier:string];
    }
    else if ([type isEqualToString:@"douban"]) {
        [self startDoubanAccess];
    }
    else if ([type isEqualToString:@"tx"])
    {
        NSString *string = [[url query] substringWithRange:NSMakeRange([[url query] length]-6, 6)];
        
        
        [info setValue:string forKey:@"WBShareKit_ver"];
        //	[info setValue:[url query] forKey:@"WBShareKit_responseBody"];
        [info synchronize];
        [self startTxAccessWithVerifier:string];
    }
    else if ([type isEqualToString:@"twitter"])
    {
        [self startTwitterAccess];
    }
    else if ([type isEqualToString:@"wy"])
    {
        [self startWyAccess];
    }
    
}

@end
