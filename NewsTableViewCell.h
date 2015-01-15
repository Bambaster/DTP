//
//  NewsTableViewCell.h
//  dtp
//
//  Created by Lowtrack on 12.01.15.
//  Copyright (c) 2015 AR for YOU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *label_News_Title;
@property (strong, nonatomic) IBOutlet UILabel *label_News_Body;
@property (strong, nonatomic) IBOutlet UILabel *label_Reviews_Count;
@property (strong, nonatomic) IBOutlet UILabel *label_News_Date;

@end
