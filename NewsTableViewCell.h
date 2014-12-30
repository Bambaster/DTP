//
//  NewsTableViewCell.h
//  dtp
//
//  Created by Lowtrack on 29.12.14.
//  Copyright (c) 2014 AR for YOU. All rights reserved.
//

#import <UIKit/UIKit.h>
#define CAPSCustomCellHorizontalPad 10
#define CAPSCustomCellVerticalPad 40



@interface NewsTableViewCell : UITableViewCell <UITextViewDelegate>
@property (strong, nonatomic) IBOutlet UILabel *label_InshCompany;
@property (strong, nonatomic) IBOutlet UILabel *label_ReviewCount;

@property (strong, nonatomic) IBOutlet UITextView *textView_News;


@property (strong, nonatomic) IBOutlet UILabel *label_News;


- (CGFloat)measureHeightOfUITextView:(UITextView *)textView;
//
//- (void)setCellContentWithLoremIpsumString:(NSString *)loremIpsum;
//+ (float)heightForLoremIpsumString:(NSString *)loremIpsum tableView:(UITableView *)tableView;

@end
