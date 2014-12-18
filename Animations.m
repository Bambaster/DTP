//
//  Animations.m
//  dtp
//
//  Created by Lowtrack on 13.12.14.
//  Copyright (c) 2014 AR for YOU. All rights reserved.
//

#import "Animations.h"

static double const ADuration = 0.4;
static NSUInteger const Delay = 80;

@implementation Animations


#pragma mark - first view 

- (void) set_First_View : (UIView *) navBar F_Label: (UILabel *) mainLabel S_Label: (UILabel *) label_info_one T_Label: (UILabel *) label_info_two Seven_Label: (UILabel *) label_seven Text_Field: (UITextField *) text_Field {
    
    CATransition *transitionAnimation = [CATransition animation];
    
    [transitionAnimation setType:kCATransitionPush];
    [transitionAnimation setSubtype:kCATransitionFromBottom];
    [transitionAnimation setDuration:ADuration];
    [transitionAnimation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [transitionAnimation setFillMode:kCAFillModeForwards];
    
    int64_t delayInSeconds = Delay;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_MSEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        [navBar.layer addAnimation:transitionAnimation forKey:@"FromRightAnimation"];
        navBar.alpha = 1;
        
        int64_t delayInSeconds = Delay;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_MSEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            
            
            CATransition *transitionAnimation_Labels = [CATransition animation];
            
            [transitionAnimation_Labels setType:kCATransitionPush];
            [transitionAnimation_Labels setSubtype:kCATransitionFromTop];
            [transitionAnimation_Labels setDuration:ADuration];
            [transitionAnimation_Labels setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
            [transitionAnimation_Labels setFillMode:kCAFillModeForwards];
            
            [mainLabel.layer addAnimation:transitionAnimation_Labels forKey:@"FromRightAnimation"];
            mainLabel.alpha = 1;
            
            int64_t delayInSeconds = Delay;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_MSEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                
                [label_info_one.layer addAnimation:transitionAnimation_Labels forKey:@"FromRightAnimation"];
                label_info_one.alpha = 1;
                
                int64_t delayInSeconds = Delay;
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_MSEC);
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                    
                    [label_info_two.layer addAnimation:transitionAnimation_Labels forKey:@"FromRightAnimation"];
                    label_info_two.alpha = 1;
                    
                    
                    int64_t delayInSeconds = Delay;
                    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_MSEC);
                    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                        
                        CATransition *transitionAnimation_Seven = [CATransition animation];
                        
                        [transitionAnimation_Seven setType:kCATransitionPush];
                        [transitionAnimation_Seven setSubtype:kCATransitionFromLeft];
                        [transitionAnimation_Seven setDuration:ADuration];
                        [transitionAnimation_Seven setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
                        [transitionAnimation_Seven setFillMode:kCAFillModeForwards];
                        
                        [label_seven.layer addAnimation:transitionAnimation_Seven forKey:@"FromRightAnimation"];
                        label_seven.alpha = 1;
                        
                        int64_t delayInSeconds = Delay;
                        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_MSEC);
                        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                            
                            CATransition *transitionAnimation_Text_Field = [CATransition animation];
                            
                            [transitionAnimation_Text_Field setType:kCATransitionPush];
                            [transitionAnimation_Text_Field setSubtype:kCATransitionFromRight];
                            [transitionAnimation_Text_Field setDuration:ADuration];
                            [transitionAnimation_Text_Field setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
                            [transitionAnimation_Text_Field setFillMode:kCAFillModeForwards];
                            
                            [text_Field.layer addAnimation:transitionAnimation_Text_Field forKey:@"FromRightAnimation"];
                            text_Field.alpha = 1;
                            
                            
                            
                        });
                        
                        
                        
                    });
                    
                    
                    
                });
                
                
                
            });
            
            
            
        });
        
        
        
    });
    
}



//----------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------

#pragma mark - change dots

- (void) set_Dot_full: (UIImageView * ) dot_View ImageName:(UIImage *) image_dot  {
    
    CATransition *transitionAnimation = [CATransition animation];
    
    [transitionAnimation setType:kCATransitionFade];
    [transitionAnimation setDuration:ADuration];
    [transitionAnimation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [transitionAnimation setFillMode:kCAFillModeForwards];

        
        [dot_View.layer addAnimation:transitionAnimation forKey:@"FromRightAnimation"];
        dot_View.image = image_dot;
    
}

- (void) set_Dot_Empty : (UIImageView * ) dot_View ImageName:(UIImage *) image_dot{
    
    CATransition *transitionAnimation = [CATransition animation];
    
    [transitionAnimation setType:kCATransitionFade];
    [transitionAnimation setDuration:ADuration];
    [transitionAnimation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [transitionAnimation setFillMode:kCAFillModeForwards];
    
    
    [dot_View.layer addAnimation:transitionAnimation forKey:@"FromRightAnimation"];
    dot_View.image = image_dot;
    
}

- (void) dots_Wrong : (UIImageView * ) dot_View1 DOT2: (UIImageView * ) dot_View2 DOT3: (UIImageView * ) dot_View3 DOT4: (UIImageView * ) dot_View4 Image1: (UIImage *) image_dot1 Image2: (UIImage *) image_dot2 Image3: (UIImage *) image_dot3 Image4 : (UIImage *) image_dot4 {
    
    CATransition *transitionAnimation3 = [CATransition animation];
    [transitionAnimation3 setType:kCATransitionPush];
    [transitionAnimation3 setSubtype:kCATransitionFromBottom];
    [transitionAnimation3 setDuration:ADuration];
    [transitionAnimation3 setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [transitionAnimation3 setFillMode:kCAFillModeForwards];
    
    


    [dot_View1.layer addAnimation:transitionAnimation3 forKey:@"FromRightAnimation"];
    dot_View1.image = image_dot1;

    

    int64_t delayInSeconds = Delay;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_MSEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        [dot_View2.layer addAnimation:transitionAnimation3 forKey:@"FromRightAnimation"];
        dot_View2.image = image_dot2;

        
        int64_t delayInSeconds = Delay;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_MSEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            
            
            
            [dot_View3.layer addAnimation:transitionAnimation3 forKey:@"FromRightAnimation"];
            dot_View3.image = image_dot3;
            
            int64_t delayInSeconds = Delay;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_MSEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [dot_View4.layer addAnimation:transitionAnimation3 forKey:@"FromRightAnimation"];
                dot_View4.image = image_dot4;
  
                
            });
            
        });
        
        
        
    });
    
}


//----------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------

#pragma mark - settings

- (void) show_Label_NoName : (UILabel * )label {
    
    CATransition *transitionAnimation = [CATransition animation];
    
    [transitionAnimation setType:kCATransitionPush];
    [transitionAnimation setSubtype:kCATransitionFromRight];
    [transitionAnimation setDuration:ADuration];
    [transitionAnimation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [transitionAnimation setFillMode:kCAFillModeForwards];
    
    
    [label.layer addAnimation:transitionAnimation forKey:@"FromRightAnimation"];
    label.alpha = 1;
    
}

- (void) hide_Label_NoName : (UILabel * )label {
    
    CATransition *transitionAnimation = [CATransition animation];
    
    [transitionAnimation setType:kCATransitionPush];
    [transitionAnimation setSubtype:kCATransitionFromLeft];
    [transitionAnimation setDuration:ADuration];
    [transitionAnimation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [transitionAnimation setFillMode:kCAFillModeForwards];
    
    
    [label.layer addAnimation:transitionAnimation forKey:@"FromRightAnimation"];
    label.alpha = 0;
    
}

- (void) show_Activity : (UIActivityIndicatorView * )activity {
    
    CATransition *transitionAnimation = [CATransition animation];
    
    [transitionAnimation setType:kCATransitionPush];
    [transitionAnimation setSubtype:kCATransitionFromTop];
    [transitionAnimation setDuration:ADuration];
    [transitionAnimation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [transitionAnimation setFillMode:kCAFillModeForwards];
    
    
    [activity.layer addAnimation:transitionAnimation forKey:@"FromRightAnimation"];
    activity.alpha = 1;
    
}

@end
