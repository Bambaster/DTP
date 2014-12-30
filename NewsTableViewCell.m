//
//  NewsTableViewCell.m
//  dtp
//
//  Created by Lowtrack on 29.12.14.
//  Copyright (c) 2014 AR for YOU. All rights reserved.
//

#import "NewsTableViewCell.h"

@implementation NewsTableViewCell

- (void)awakeFromNib {
//    self.textView_News.frame = CGRectMake(66, 41, self.textView_News.frame.size.width, [self measureHeightOfUITextView:self.textView_News]);

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



- (CGFloat)measureHeightOfUITextView:(UITextView *)textView
{
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1)
    {
        // This is the code for iOS 7. contentSize no longer returns the correct value, so
        // we have to calculate it.
        //
        // This is partly borrowed from HPGrowingTextView, but I've replaced the
        // magic fudge factors with the calculated values (having worked out where
        // they came from)
        
        CGRect frame = textView.bounds;
        
        // Take account of the padding added around the text.
        
        UIEdgeInsets textContainerInsets = textView.textContainerInset;
        UIEdgeInsets contentInsets = textView.contentInset;
        
        CGFloat leftRightPadding = textContainerInsets.left + textContainerInsets.right + textView.textContainer.lineFragmentPadding * 2 + contentInsets.left + contentInsets.right;
        CGFloat topBottomPadding = textContainerInsets.top + textContainerInsets.bottom + contentInsets.top + contentInsets.bottom;
        
        frame.size.width -= leftRightPadding;
        frame.size.height -= topBottomPadding;
        
        NSString *textToMeasure = textView.text;
        if ([textToMeasure hasSuffix:@"\n"])
        {
            textToMeasure = [NSString stringWithFormat:@"%@-", textView.text];
        }
        
        // NSString class method: boundingRectWithSize:options:attributes:context is
        // available only on ios7.0 sdk.
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineBreakMode:NSLineBreakByWordWrapping];
        
        NSDictionary *attributes = @{ NSFontAttributeName: textView.font, NSParagraphStyleAttributeName : paragraphStyle };
        
        CGRect size = [textToMeasure boundingRectWithSize:CGSizeMake(CGRectGetWidth(frame), MAXFLOAT)
                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                               attributes:attributes
                                                  context:nil];
        
        CGFloat measuredHeight = ceilf(CGRectGetHeight(size) + topBottomPadding);
        return measuredHeight;
    }
    else
    {
        return textView.contentSize.height;
    }
}


//#pragma mark - Create Attributed String
//+ (NSMutableAttributedString *)attributedStringFromLoremIpsum:(NSString *)loremIpsum {
//    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:loremIpsum];
//    // Add Background Color for Smooth rendering
//    [attributedString setAttributes:@{NSBackgroundColorAttributeName:[UIColor whiteColor]} range:NSMakeRange(0, attributedString.length)];
//    // Add Main Font Color
//    [attributedString setAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithWhite:0.23 alpha:1.0]} range:NSMakeRange(0, attributedString.length)];
//    // Add paragraph style
//    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//    [paragraphStyle setLineBreakMode:NSLineBreakByWordWrapping];
//    [attributedString setAttributes:@{NSParagraphStyleAttributeName:paragraphStyle} range:NSMakeRange(0, attributedString.length)];
//    // Add Font
//    [attributedString setAttributes:@{NSFontAttributeName:[NewsTableViewCell customCellFont]} range:NSMakeRange(0, attributedString.length)];
//    // Add Font Color for "Lorem" string
//    [attributedString setAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]} range:[loremIpsum rangeOfString:@" "]];
//    
//    // Return the string
//    return attributedString;
//}
//
//
//#pragma mark - System Font
//+ (UIFont *)customCellFont {
//    return [UIFont fontWithName:@"PFAgoraSansPro-Light" size:14.0];
//}
//
//
//#pragma mark - Set Cell Content
//- (void)setCellContentWithLoremIpsumString:(NSString *)loremIpsum {
//    //
//    // THIS IS IMPORTANT!
//    //  - The separator insets start your cell off at xOrigin = 15, instead of 0
//    //  - like in iOS 6 and lower. Calling responds to selector means this won't break
//    //  - in iOS 6 and lower either!
//    //
//    if ([self respondsToSelector:@selector(separatorInset)]) {
//        self.separatorInset = UIEdgeInsetsZero;
//    }
//    
//    // THIS IS ALSO IMPORTANT!
//    // - You need to make sure the label's line # is set to 0 (aka any amount)
//    self.label_News.numberOfLines = 0;
//    
//    // Set Attributed String
//    [self.label_News setAttributedText:[NewsTableViewCell attributedStringFromLoremIpsum:loremIpsum]];
//    
//    
//    // We want the label to appear inside of the cell with 10px padding on each side like so:
//    //   ---------------------------------
//    //  |                                 |
//    //  | LABEL BEGINS HERE AND ENDS HERE |
//    //  | UNLESS IT ENCOMPASSES MORE THAN |
//    //  | ONE LINE!                       |
//    //  |                                 |
//    //   ---------------------------------
//    
//    
//    // Get Size from String
//    // - if the string responds to selector "boundingRectForSize:", then we are on iOS6+
//    // - else, use the deprecated "sizeWithFont:" method
//    CGSize labelSize = CGSizeZero;
//    if ([self.label_News.attributedText respondsToSelector:@selector(boundingRectWithSize:options:context:)]) {
//        CGRect boundingRect = [self.label_News.attributedText boundingRectWithSize:CGSizeMake(self.frame.size.width - 2*CAPSCustomCellHorizontalPad, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
//        labelSize = boundingRect.size;
//    }
//    else {
//   //     labelSize = [loremIpsum sizeWithFont:[NewsTableViewCell customCellFont] constrainedToSize:CGSizeMake(self.frame.size.width - 2*CAPSCustomCellHorizontalPad, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
//  
//        CGSize maximumLabelSize = CGSizeMake(self.frame.size.width - 2*CAPSCustomCellHorizontalPad, MAXFLOAT);
//        
//        NSStringDrawingOptions options = NSStringDrawingTruncatesLastVisibleLine |
//        NSStringDrawingUsesLineFragmentOrigin;
//        
//        NSDictionary *attr = @{NSFontAttributeName: [NewsTableViewCell customCellFont]};
//        CGRect labelBounds = [loremIpsum boundingRectWithSize:maximumLabelSize
//                                                      options:options
//                                                   attributes:attr
//                                                      context:nil];
//        
//        labelSize = labelBounds.size;
//         
//        
//    }
//    
//    
//    // Set the heights of the frame and label now!
//    
//    CGFloat cell_height;
//    if (self.contentView.frame.size.height <= 100) {
//        cell_height = 100;
//    }
//    
//    else {
//        cell_height = self.label_News.frame.size.height + 2*CAPSCustomCellVerticalPad;
//    }
//    
//    NSLog(@"cell_height %f", cell_height),
//    
//    self.label_News.frame = CGRectMake(70, 40, self.label_News.frame.size.width, ceilf(labelSize.height));
//    self.frame = CGRectMake(0, 0, self.frame.size.width, self.label_News.frame.size.height + 2*CAPSCustomCellVerticalPad);
//    if ([self respondsToSelector:@selector(contentView)]) {
//        self.contentView.frame = self.frame;
//    }
//}
//
//
//#pragma mark - Height for Cell
//+ (float)heightForLoremIpsumString:(NSString *)loremIpsum tableView:(UITableView *)tableView {
//    NSAttributedString *attributedLoremIpsum = [self attributedStringFromLoremIpsum:loremIpsum];
//    
//    // Get Size from String
//    // - if the string responds to selector "boundingRectForSize:", then we are on iOS6+
//    // - else, use the deprecated "sizeWithFont:" method
//    CGSize labelSize = CGSizeZero;
//    if ([attributedLoremIpsum respondsToSelector:@selector(boundingRectWithSize:options:context:)]) {
//        CGRect boundingRect = [attributedLoremIpsum boundingRectWithSize:CGSizeMake(tableView.frame.size.width - 2*CAPSCustomCellHorizontalPad, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
//        labelSize = boundingRect.size;
//    }
//    else {
//   //     labelSize = [loremIpsum sizeWithFont:[NewsTableViewCell customCellFont] constrainedToSize:CGSizeMake(tableView.frame.size.width - 2*CAPSCustomCellHorizontalPad, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
//        
//        CGSize maximumLabelSize = CGSizeMake(tableView.frame.size.width - 2*CAPSCustomCellHorizontalPad, MAXFLOAT);
//        
//        NSStringDrawingOptions options = NSStringDrawingTruncatesLastVisibleLine |
//        NSStringDrawingUsesLineFragmentOrigin;
//        
//        NSDictionary *attr = @{NSFontAttributeName: [NewsTableViewCell customCellFont]};
//        CGRect labelBounds = [loremIpsum boundingRectWithSize:maximumLabelSize
//                                                  options:options
//                                               attributes:attr
//                                                  context:nil];
//
//       labelSize = labelBounds.size;
//    
//        
//    }
//    
//    // Return the calculated height of the label + 2 * the VerticalPadding (for top and bottom)
//    return labelSize.height + 2*CAPSCustomCellVerticalPad;
//}


@end
