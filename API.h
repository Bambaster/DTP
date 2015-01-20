//
//  API.h
//  dtp
//
//  Created by Lowtrack on 30.12.14.
//  Copyright (c) 2014 AR for YOU. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface API : NSObject

@property (strong, nonatomic) NSDictionary * answer;

+ (API*) sharedManager;
- (void) get_request:(NSDictionary*) params
                    onSuccess:(void(^)(NSDictionary* answer)) success
                    onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure;


//- (NSDictionary *) get_request: (NSDictionary *) parameters;

@end
