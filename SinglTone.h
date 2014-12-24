//
//  SinglTone.h
//  dtp
//
//  Created by Lowtrack on 18.12.14.
//  Copyright (c) 2014 AR for YOU. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SinglTone : NSObject
+(SinglTone *) singleton;


@property (nonatomic, copy) NSString * phone_number;
@property (nonatomic, strong) NSString * type_of_review;



@end
