//
//  JSMessageInputView.m
//
//  Created by Jesse Squires on 2/12/13.
//  Copyright (c) 2013 Hexed Bits. All rights reserved.
//
//  http://www.hexedbits.com
//
//
//  Largely based on work by Sam Soffes
//  https://github.com/soffes
//
//  SSMessagesViewController
//  https://github.com/soffes/ssmessagesviewcontroller
//
//
//  The MIT License
//  Copyright (c) 2013 Jesse Squires
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and
//  associated documentation files (the "Software"), to deal in the Software without restriction, including
//  without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the
//  following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT
//  LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
//  IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
//  IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
//  OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import "JSMessageInputView.h"
#import "JSBubbleView.h"
#import "NSString+JSMessagesView.h"
#import "UIImage+JSMessagesView.h"
#import "UIColor+JSMessagesView.h"
#import "SinglTone.h"
#import "AppConstant.h"



#define SEND_BUTTON_WIDTH 78.0f

static id<JSMessageInputViewDelegate> __delegate;

@interface JSMessageInputView ()

- (void)setup;
- (void)setupTextView;

@end



@implementation JSMessageInputView

@synthesize sendButton;

#pragma mark - Initialization
- (id)initWithFrame:(CGRect)frame delegate:(id<UITextViewDelegate, JSMessageInputViewDelegate>)delegate
{
    self = [super initWithFrame:frame];
    if(self) {
        __delegate = delegate;
        [self setup];
        self.textView.delegate = delegate;
    }
    return self;
}

+ (JSInputBarStyle)inputBarStyle
{
    if ([__delegate respondsToSelector:@selector(inputBarStyle)])
        return [__delegate inputBarStyle];
    
    return JSInputBarStyleDefault;
}

- (void)dealloc
{
    self.textView = nil;
    self.sendButton = nil;
}

- (BOOL)resignFirstResponder
{
    [self.textView resignFirstResponder];
    return [super resignFirstResponder];
}
#pragma mark - Setup
- (void)setup
{
 //   self.image = [UIImage inputBar];
    [[NSUserDefaults standardUserDefaults] setObject:@"Положительный отзыв" forKey:Type_of_Review];
    [[NSUserDefaults standardUserDefaults] synchronize];
    self.backgroundColor = [UIColor whiteColor];
    self.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin);
    self.opaque = YES;
    self.userInteractionEnabled = YES;
    [self setupTextView];
}

- (void)setupTextView
{
    CGFloat width = (self.frame.size.width - SEND_BUTTON_WIDTH) + 20;
    CGFloat height = [JSMessageInputView textViewLineHeight];
    
    // JeremyStone
    JSInputBarStyle style = [JSMessageInputView inputBarStyle];
    
    if (style == JSInputBarStyleDefault)
    {
        self.textView = [[JSMessageTextView  alloc] initWithFrame:CGRectMake(6.0f, 3.0f, width, height)];
        self.textView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.textView.backgroundColor = [UIColor redColor];
    }
    else
    {
        
        
        
        self.textView = [[JSMessageTextView  alloc] initWithFrame:CGRectMake(8.0f, 86.0f, width, height)];
        self.textView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.textView.backgroundColor = [UIColor clearColor];

        self.textView.layer.borderColor = [[UIColor colorWithWhite:.8 alpha:1.0] CGColor];
        self.textView.layer.borderWidth = 1.0f;
        self.textView.layer.cornerRadius = 4.0f;
    }
    
    
    self.segment_choose_Type_Review = [[UISegmentedControl alloc]initWithItems:[NSArray arrayWithObjects:@"Отрицательный", @"Положительный", nil]];
    
    NSString * type = [[NSUserDefaults standardUserDefaults] stringForKey:Type_of_Review];
    if ([type isEqualToString:@"Положительный отзыв"]) {
        [self.segment_choose_Type_Review setSelectedSegmentIndex:1];
    }
    
    else {
        
        [self.segment_choose_Type_Review setSelectedSegmentIndex:0];

    }
    self.segment_choose_Type_Review.frame = CGRectMake (8.0f, 4.0f, width , height);
    self.segment_choose_Type_Review.tintColor = [UIColor colorWithRed:23.0/255.0 green:129.0/255.0 blue:241.0/255.0 alpha:1.0];
    [self.segment_choose_Type_Review setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"PFAgoraSansPro-Light" size:16.0], NSFontAttributeName, nil] forState:UIControlStateNormal];
    [self.segment_choose_Type_Review addTarget:self action:@selector(choose_TypeReview:) forControlEvents: UIControlEventValueChanged];
    
    
    self.button_choose_Company = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.button_choose_Company.frame = CGRectMake (8.0f, 45.0f, width , height);
    self.button_choose_Company.layer.borderColor = [[UIColor colorWithRed:23.0/255.0 green:129.0/255.0 blue:241.0/255.0 alpha:1.0] CGColor];
    self.button_choose_Company.layer.borderWidth = 1.0f;
    self.button_choose_Company.layer.cornerRadius = 4.0f;
   // [self.button_choose_Company.titleLabel setFont:[UIFont fontWithName:@"PFAgoraSansPro-Light" size:16.0]];
    self.button_choose_Company.titleEdgeInsets = UIEdgeInsetsMake(2, -24, 0, 0);
//    [self.button_choose_Company setTitle:@"Выбирите страховую компанию" forState:UIControlStateNormal];
    self.button_choose_Company.tintColor = [UIColor colorWithRed:23.0/255.0 green:129.0/255.0 blue:241.0/255.0 alpha:1.0];
    [self.button_choose_Company addTarget:self action:@selector(choose_comapany:) forControlEvents:UIControlEventTouchUpInside];
    [self.button_choose_Company setBackgroundImage:[self imageWithColor:[UIColor colorWithRed:23.0/255.0 green:129.0/255.0 blue:241.0/255.0 alpha:0.5]] forState:UIControlStateHighlighted];
    
//    [self.button_choose_Company setBa setTitle:@"Выбирите страховую компанию" forState:UIControlStateNormal];
    
//    self.textView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
//    self.textView.keyboardAppearance = UIKeyboardAppearanceDefault;
//    self.textView.keyboardType = UIKeyboardTypeDefault;
//    self.textView.returnKeyType = UIReturnKeyDefault;
//    self.textView.scrollEnabled = YES;
//    self.textView.scrollsToTop = NO;
//    self.textView.userInteractionEnabled = YES;
//    self.textView.textColor = [UIColor blackColor];
//    self.textView.font = [JSBubbleView font];
//    self.textView.scrollIndicatorInsets = UIEdgeInsetsMake(10.0f, 0.0f, 10.0f, 0.0f);

    [self addSubview:self.segment_choose_Type_Review];
    [self addSubview:self.textView];
    [self addSubview:self.button_choose_Company];

    
    if (style == JSInputBarStyleDefault)
    {
        UIImageView *inputFieldBack = [[UIImageView alloc] initWithFrame:CGRectMake(self.textView.frame.origin.x - 1.0f,
                                                                                    0.0f,
                                                                                    self.textView.frame.size.width + 2.0f,
                                                                                    self.frame.size.height)];
        inputFieldBack.image = [UIImage inputField];
        inputFieldBack.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
        inputFieldBack.backgroundColor = [UIColor whiteColor];
        [self addSubview:inputFieldBack];
    }
}

- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color  CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}


- (void) choose_TypeReview: (UISegmentedControl *) sender {
    

    if (self.segment_choose_Type_Review.selectedSegmentIndex == 0){
        
        [[NSUserDefaults standardUserDefaults] setObject:@"Отрицательный отзыв" forKey:Type_of_Review];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    else {
        
        [[NSUserDefaults standardUserDefaults] setObject:@"Положительный отзыв" forKey:Type_of_Review];
        [[NSUserDefaults standardUserDefaults] synchronize];

    }
    
        
    
    NSLog(@"seg setSelectedSegmentIndex %ld", (long)self.segment_choose_Type_Review.selectedSegmentIndex);
}


- (void) choose_comapany: (UIButton *) sender {
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"Show_Companies" object:nil userInfo:nil];

    
//    NSLog(@"__%s__",__func__);
}

#pragma mark - Setters
- (void)setSendButton:(UIButton *)btn
{
    if(sendButton)
        [sendButton removeFromSuperview];
    
    sendButton = btn;
    [self addSubview:self.sendButton];
}

#pragma mark - Message input view
- (void)adjustTextViewHeightBy:(CGFloat)changeInHeight
{
    CGRect prevFrame = self.textView.frame;
    
    NSUInteger numLines = MAX([self.textView numberOfLinesOfText],[self.textView.text numberOfLines]);
    
    self.textView.frame = CGRectMake(prevFrame.origin.x,
                                     prevFrame.origin.y,
                                     prevFrame.size.width,
                                     prevFrame.size.height + changeInHeight);
    
    self.textView.contentInset = UIEdgeInsetsMake((numLines >= 6 ? 4.0f : 0.0f),
                                                  0.0f,
                                                  (numLines >= 6 ? 4.0f : 0.0f),
                                                  0.0f);
    
    self.textView.scrollEnabled = (numLines >= 4);
    
    if(numLines >= 6) {
        CGPoint bottomOffset = CGPointMake(0.0f, self.textView.contentSize.height - self.textView.bounds.size.height);
        [self.textView setContentOffset:bottomOffset animated:YES];
    }
}

+ (CGFloat)textViewLineHeight
{
    return 36.0f; // for fontSize 16.0f
}

+ (CGFloat)maxLines
{
    return 14.0f;
}

+ (CGFloat)maxHeight
{
    return ([JSMessageInputView maxLines] + 1.0f) * [JSMessageInputView textViewLineHeight];
}

@end