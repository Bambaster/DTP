//
//  WebCompanyViewController.h
//  dtp
//
//  Created by Lowtrack on 10.01.15.
//  Copyright (c) 2015 AR for YOU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebCompanyViewController : UIViewController <UIWebViewDelegate>
@property (nonatomic, strong) NSString * url;
@property (nonatomic, strong) NSString * labelNavText;


@end
