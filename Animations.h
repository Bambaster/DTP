//
//  Animations.h
//  dtp
//
//  Created by Lowtrack on 13.12.14.
//  Copyright (c) 2014 AR for YOU. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Animations : NSObject

- (void) set_First_View : (UIView *) navBar F_Label: (UILabel *) mainLabel S_Label: (UILabel *) label_info_one T_Label: (UILabel *) label_info_two Seven_Label: (UILabel *) label_seven Text_Field: (UITextField *) text_Field;

//----------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------

- (void) set_Dot_Empty : (UIImageView * ) dot_View ImageName:(UIImage *) image_dot;
- (void) set_Dot_full: (UIImageView * ) dot_View ImageName:(UIImage *) image_dot;
- (void) dots_Wrong : (UIImageView * ) dot_View1 DOT2: (UIImageView * ) dot_View2 DOT3: (UIImageView * ) dot_View3 DOT4: (UIImageView * ) dot_View4 Image1: (UIImage *) image_dot1 Image2: (UIImage *) image_dot2 Image3: (UIImage *) image_dot3 Image4 : (UIImage *) image_dot4;
//----------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------

@end
