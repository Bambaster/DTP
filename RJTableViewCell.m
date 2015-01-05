//
//  RJCell.m
//  TableViewController
//
//  Created by Kevin Muldoon & Tyler Fox on 10/5/13.
//  Copyright (c) 2013 RobotJackalope. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "RJTableViewCell.h"

#define kLabelHorizontalInsets      70.0f
#define kLabelHorizontalInsetsRight 5.0f

#define kLabelVerticalInsets        10.0f


#define kImage_Left 5.0f


@interface RJTableViewCell ()

@property (nonatomic, assign) BOOL didSetupConstraints;

@end

@implementation RJTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
        self.titleLabel = [UILabel newAutoLayoutView];
        [self.titleLabel setLineBreakMode:NSLineBreakByTruncatingTail];
        [self.titleLabel setNumberOfLines:1];
        [self.titleLabel setTextAlignment:NSTextAlignmentLeft];
        [self.titleLabel setTextColor:[UIColor blackColor]];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        
        self.bodyLabel = [UILabel newAutoLayoutView];
        [self.bodyLabel setLineBreakMode:NSLineBreakByCharWrapping];
        [self.bodyLabel sizeToFit];
        [self.bodyLabel setNumberOfLines:0];
        [self.bodyLabel setTextAlignment:NSTextAlignmentLeft];
        [self.bodyLabel setTextColor:[UIColor darkGrayColor]];
        self.bodyLabel.backgroundColor = [UIColor clearColor];
        
        self.image_company = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 50, 50)];
        self.image_company.contentMode = UIViewContentModeScaleAspectFill;
        self.image_company.layer.cornerRadius = self.image_company.frame.size.width / 2;
        self.image_company.clipsToBounds = YES;
        self.image_company.userInteractionEnabled  = YES;

        self.image_company.backgroundColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:0.1];
        
        
        self.label_review_count = [UILabel newAutoLayoutView];
        self.label_review_count.font = [UIFont fontWithName:@"PFAgoraSansPro-Regular" size:15];
        self.label_review_count.textColor = [UIColor redColor];
        self.label_review_count.textAlignment = NSTextAlignmentRight;
        
        self.label_review_count.text = @"review_count";
        
        self.label_time = [[UILabel alloc] initWithFrame:CGRectMake(10, 68, 50, 12)];
        self.label_time.font = [UIFont fontWithName:@"PFAgoraSansPro-Light" size:13.0];
        self.label_time.textColor = [UIColor redColor];
        self.label_time.text = @"Time";
        self.label_time.textAlignment = NSTextAlignmentCenter;

        
        
        self.label_date = [[UILabel alloc] initWithFrame:CGRectMake(10, 84, 50, 12)];
        self.label_date.font = [UIFont fontWithName:@"PFAgoraSansPro-Light" size:13.0];
        self.label_date.textColor = [UIColor redColor];
        self.label_date.text = @"Date";
        self.label_date.textAlignment = NSTextAlignmentCenter;

        

        
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.bodyLabel];
        [self.contentView addSubview:self.image_company];
        [self.contentView addSubview:self.label_review_count];
        [self.contentView addSubview:self.label_date];
        [self.contentView addSubview:self.label_time];

        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap)];
        [tapRecognizer setDelegate:self];
        [tapRecognizer setNumberOfTapsRequired:1];
        [self.image_company addGestureRecognizer:tapRecognizer];
        
        [self updateFonts];
    }
    
    return self;
}

- (void)updateConstraints
{
    if (!self.didSetupConstraints) {
        // Note: if the constraints you add below require a larger cell size than the current size (which is likely to be the default size {320, 44}), you'll get an exception.
        // As a fix, you can temporarily increase the size of the cell's contentView so that this does not occur using code similar to the line below.
        //      See here for further discussion: https://github.com/Alex311/TableCellWithAutoLayout/commit/bde387b27e33605eeac3465475d2f2ff9775f163#commitcomment-4633188
        // self.contentView.bounds = CGRectMake(0.0f, 0.0f, 99999.0f, 99999.0f);
        
        [UIView autoSetPriority:UILayoutPriorityRequired forConstraints:^{
            [self.titleLabel autoSetContentCompressionResistancePriorityForAxis:ALAxisVertical];
        }];
        [self.titleLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kLabelVerticalInsets];
        [self.titleLabel autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:kLabelHorizontalInsets];
        [self.titleLabel autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:kLabelHorizontalInsetsRight];
       
        
        
        
        [UIView autoSetPriority:UILayoutPriorityRequired forConstraints:^{
            [self.label_review_count autoSetContentCompressionResistancePriorityForAxis:ALAxisVertical];
        }];
        [self.label_review_count autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kLabelVerticalInsets];
        [self.label_review_count autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:kLabelHorizontalInsets];
        [self.label_review_count autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:kLabelHorizontalInsetsRight];
        // This is the constraint that connects the title and body labels. It is a "greater than or equal" inequality so that if the row height is
        // slightly larger than what is actually required to fit the cell's subviews, the extra space will go here. (This is the case on iOS 7
        // where the cell separator is only 0.5 points tall, but in the tableView:heightForRowAtIndexPath: method of the view controller, we add
        // a full 1.0 point in extra height to account for it, which results in 0.5 points extra space in the cell.)
        // See https://github.com/smileyborg/TableViewCellWithAutoLayout/issues/3 for more info.
        [self.bodyLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.titleLabel withOffset:kLabelVerticalInsets relation:NSLayoutRelationGreaterThanOrEqual];
        

        
        [UIView autoSetPriority:UILayoutPriorityRequired forConstraints:^{
            [self.bodyLabel autoSetContentCompressionResistancePriorityForAxis:ALAxisVertical];
        }];
        [self.bodyLabel autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:kLabelHorizontalInsets];
        [self.bodyLabel autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:kLabelHorizontalInsetsRight];
        [self.bodyLabel autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:kLabelVerticalInsets];
        
        
    //    [self.image_company autoPinEdge:ALEdgeLeading  toEdge:ALEdgeTrailing ofView:self.titleLabel withOffset:kLabelHorizontalInsets relation:NSLayoutRelationGreaterThanOrEqual];
        
        
//        [UIView autoSetPriority:UILayoutPriorityRequired forConstraints:^{
//            [self.image_company autoSetContentCompressionResistancePriorityForAxis:ALAxisVertical];
//        }];
//        [self.image_company autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:kImage_Left];
//        [self.image_company autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:kLabelHorizontalInsetsRight];
//        [self.image_company autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:kLabelVerticalInsets];
        
        self.didSetupConstraints = YES;
    }
    
    [super updateConstraints];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // Make sure the contentView does a layout pass here so that its subviews have their frames set, which we
    // need to use to set the preferredMaxLayoutWidth below.
    [self.contentView setNeedsLayout];
    [self.contentView layoutIfNeeded];
    
    // Set the preferredMaxLayoutWidth of the mutli-line bodyLabel based on the evaluated width of the label's frame,
    // as this will allow the text to wrap correctly, and as a result allow the label to take on the correct height.
    self.bodyLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.bodyLabel.frame);
}

- (void)updateFonts
{
    self.titleLabel.font = [UIFont fontWithName:@"PFAgoraSansPro-Regular" size:15];
    self.bodyLabel.font = [UIFont fontWithName:@"PFAgoraSansPro-Light" size:14];
}



- (void)handleSingleTap
{
    NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
    [dict setValue:self.titleLabel.text forKey:@"company_name"];
    [dict setValue:self.bodyLabel.text forKey:@"review"];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"DetailVievCompany" object:nil userInfo:dict];
}

@end
