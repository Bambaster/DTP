//
//  DetailCompanyViewController.h
//  dtp
//
//  Created by Lowtrack on 05.01.15.
//  Copyright (c) 2015 AR for YOU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailCompanyViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>
@property (strong, nonatomic) IBOutlet UILabel *label_Name_Company;
@property (strong, nonatomic) NSString * company_name;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *dataSource;
@property (strong, nonatomic) NSArray *array_review;



@property (assign, nonatomic) int plus_count;
@property (assign, nonatomic) int minus_count;






@end
