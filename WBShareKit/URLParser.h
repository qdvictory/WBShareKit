//
//  URLParser.h
//  isoccer
//
//  Created by Seamus on 1/25/13.
//  Copyright (c) 2013 Chlova. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface URLParser : NSObject {
    NSArray *variables;
}

@property (nonatomic, retain) NSArray *variables;

- (id)initWithURLString:(NSString *)url;
- (NSString *)valueForVariable:(NSString *)varName;

@end