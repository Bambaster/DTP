//
//  SetShadow.m
//  dtp
//
//  Created by Lowtrack on 13.12.14.
//  Copyright (c) 2014 AR for YOU. All rights reserved.
//

#import "SetShadow.h"

@implementation SetShadow


- (void) setShadow:(UIView *) navBar {
    
    [navBar.layer setShadowColor:[UIColor grayColor].CGColor];
    [navBar.layer setShadowOpacity:0.8];
    [navBar.layer setShadowRadius:2.0];
    [navBar.layer setShadowOffset:CGSizeMake(0.3, 0.3)];
}



@end
