//
//  DetailCompanyViewController.h
//  dtp
//
//  Created by Lowtrack on 05.01.15.
//  Copyright (c) 2015 AR for YOU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailCompanyViewController : UIViewController
@property (strong, nonatomic) IBOutlet UILabel *label_Name_Company;
@property (strong, nonatomic) NSString * company_name;

@property (assign, nonatomic) int plus_count;
@property (assign, nonatomic) int minus_count;






@end
