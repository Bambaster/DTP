//
//  SinglTone.m
//  dtp
//
//  Created by Lowtrack on 18.12.14.
//  Copyright (c) 2014 AR for YOU. All rights reserved.
//

#import "SinglTone.h"

@implementation SinglTone


+(SinglTone *) singleton
{
    static SinglTone *singletonObject = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singletonObject = [[self alloc] init];
    });
    return singletonObject;
}

@end
