//
//  ViewController.h
//  dtp
//
//  Created by Lowtrack on 13.12.14.
//  Copyright (c) 2014 AR for YOU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EAIntroView.h"
#import <QuartzCore/QuartzCore.h>
#import "Animations.h"
#import <Foundation/Foundation.h>
#import "SinglTone.h"



@interface ViewController : UIViewController <EAIntroDelegate, UITextFieldDelegate> {
    
    BOOL isFirstInstruktion;
}

@property (nonatomic, strong)UIImagePickerController *imagePicker;
@property (nonatomic, strong)UIImage *image;



@end

