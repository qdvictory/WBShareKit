//
//  WBRequest.h
//  WBShareKit
//
//  Created by Gao Semaus on 11-8-12.
//  Copyright 2011年 Chlova. All rights reserved.
//

#import "OAMutableURLRequest.h"
#import "OAToken.h"
#import "OAServiceTicket.h"
#import "OAAsynchronousDataFetcher.h"
#import "WBShareKey.h"

@interface WBRequest : OAMutableURLRequest
{
    
}
+ (WBRequest *)requestWithURL:(NSString *)_url dic:(NSDictionary *)_dic method:(NSString *)_method withServers:(NSString *)_servers requestToken:(BOOL)_requestToken accessToken:(BOOL)_accessToken;
@end
