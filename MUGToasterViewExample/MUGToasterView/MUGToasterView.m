//
//  MUGToasterView.m
//  MuG
//
//  Created by Anil Ardahanli on 2/1/15.
//  Copyright (c) 2015 Anil Ardahanli. All rights reserved.
//

#import "MUGToasterView.h"
#import <pop/POP.h>

@interface MUGToasterView ()

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIView *section0View;
@property (nonatomic, strong) UIView *section0ContainerView;
@property (nonatomic, strong) UIView *section1View;
@property (nonatomic, strong) UIView *section1ContainerView;
@property (nonatomic, strong) UIImageView *section0ImageView;

@property (nonatomic, copy) DismissBlock dismissBlock;
@property (nonatomic, strong) UIViewController *rootViewController;

@property (nonatomic) NSTimeInterval animationDuration;
@property (nonatomic) CGFloat titleFontSize;
@property (nonatomic) CGFloat subTitleFontSize;
@property (nonatomic, strong) NSString *titleFontFamily;
@property (nonatomic, strong) NSString *subTitleFontFamily;

@property (nonatomic) BOOL isCountdownWorking;
@property (nonatomic) BOOL isToastPresenting;

@end

@implementation MUGToasterView

CGFloat kToasterDefaultHeight;

CGFloat kSection0Percentage;
CGFloat kSection1Percentage;
CGFloat kSection0ImageSize;
CGFloat kSectionDefaultPadding;

//Title & Subtitle
CGFloat kTitleLabelPaddingTop;
CGFloat kTitleLabelPaddingLeft;

CGFloat kSubtitleLabelPaddingTop;
CGFloat kSubtitleLabelPaddingLeft;

CGFloat kTitleLabelHeightRelativeToContainer;
CGFloat kSubtitleLabelHeightRelativeToContainer;

//container height: 64
//title label height: 30
//subtitle label height: 20
//padding top: 10 (twice)
//(64-10) = 54
//54 > 100 = 30 ? %55.5
//54 > 100 = 20 ? %37.0


NSTimer *mugDurationTimer;

@synthesize rootViewController = _rootViewController;

- (instancetype)init {
    
    self = [super init];
    if (self) {
        
        //Config && Init in here
        _isCountdownWorking = NO;
        _isToastPresenting = NO;
        
        kToasterDefaultHeight = 64.0f;
        kSection0Percentage = 0.20f;
        kSection1Percentage = 0.80f;
        kSectionDefaultPadding = 5.0f;
        kSection0ImageSize = 30.0f;
        
        kSubtitleLabelPaddingLeft = 5;
        kSubtitleLabelPaddingTop = 5;
        kTitleLabelPaddingLeft = 5;
        kTitleLabelPaddingTop = 5;
        
        kTitleLabelHeightRelativeToContainer = 0.55;
        kSubtitleLabelHeightRelativeToContainer = 0.37;
        
        _titleLabel = [[UILabel alloc] init];
        _subTitleLabel = [[UILabel alloc] init];
        
        _containerView = [[UIView alloc] init];
        _section0View = [[UIView alloc] init];
        _section0ContainerView = [[UIView alloc] init];
        _section1ContainerView = [[UIView alloc] init];
        _section1View = [[UIView alloc] init];
        _section0ImageView = [[UIImageView alloc] init];
        
        _backgroundColor = [UIColor whiteColor];
        _titleTextColor = [UIColor whiteColor];
        _subTitleTextColor = [UIColor whiteColor];
        
        _titleFontFamily = @"HelveticaNeue";
        _subTitleFontFamily = @"HelveticaNeue";
        _titleFontSize = 18.0f;
        _subTitleFontSize = 13.0f;
        _animationType = SlideVertical;
        _animationDuration = 2.0f;
        
        _titleFont = [UIFont fontWithName:_titleFontFamily
                                     size:_titleFontSize];
        _subTitleFont = [UIFont fontWithName:_subTitleFontFamily
                                        size:_subTitleFontSize];
        
        NSLog(@"[toaster]init complete.");
        
    }
    
    return self;
}

- (void)handleLayoutWithHideLocation:(NSString *)location {
    
    CGRect rect = self.view.frame;
    
    if ([location isEqualToString:@"top"])
        [_containerView setFrame:CGRectMake(0, -kToasterDefaultHeight, rect.size.width, kToasterDefaultHeight)];
    else if ([location isEqualToString:@"left"])
        [_containerView setFrame:CGRectMake(0-rect.size.width, 0, rect.size.width, kToasterDefaultHeight)];
    else if ([location isEqualToString:@"bottom"])
        [_containerView setFrame:CGRectMake(0, kToasterDefaultHeight, rect.size.width, kToasterDefaultHeight)];
    else if ([location isEqualToString:@"right"])
        [_containerView setFrame:CGRectMake(rect.size.width, 0, rect.size.width, kToasterDefaultHeight)];
    
    [_section0View setFrame:CGRectMake(0,
                                       0,
                                       (rect.size.width) * kSection0Percentage,
                                       kToasterDefaultHeight)];
    [_containerView addSubview:_section0View];
    [_section1View setFrame:CGRectMake((rect.size.width) * kSection0Percentage,
                                       0,
                                       (rect.size.width) * kSection1Percentage,
                                       kToasterDefaultHeight)];
    
    [_containerView addSubview:_section1View];
    
    [_section0ContainerView setFrame:CGRectMake(kSectionDefaultPadding, kSectionDefaultPadding, _section0View.frame.size.width-2*kSectionDefaultPadding, _section0View.frame.size.height-2*kSectionDefaultPadding)];
    
    [_section0View addSubview:_section0ContainerView];
    
    [_section1ContainerView setFrame:CGRectMake(kSectionDefaultPadding, kSectionDefaultPadding, _section1View.frame.size.width-2*kSectionDefaultPadding, _section1View.frame.size.height-2*kSectionDefaultPadding)];
    
    [_section1View addSubview:_section1ContainerView];
    
    //Imageview size is constant 30x30 width:64 x: (64-30)/2 = 17
    [_section0ImageView setFrame:CGRectMake((_section0ContainerView.frame.size.width-kSection0ImageSize)/2,
                                            (_section0ContainerView.frame.size.height-kSection0ImageSize)/2,
                                            kSection0ImageSize,
                                            kSection0ImageSize)];
    
    [_section0ContainerView addSubview:_section0ImageView];
    
    //TitleLabel
    [_titleLabel setFrame:CGRectMake(kTitleLabelPaddingLeft,
                                     kTitleLabelPaddingTop,
                                     (_section1ContainerView.frame.size.width-kTitleLabelPaddingTop)*0.9,
                                     (_containerView.frame.size.height - 2*kTitleLabelPaddingTop) * kTitleLabelHeightRelativeToContainer)];
    
    [_section1ContainerView addSubview:_titleLabel];
    
    //SubtitleLabel
    [_subTitleLabel setFrame:CGRectMake(kTitleLabelPaddingLeft,
                                        _titleLabel.frame.size.height,
                                        (_section1ContainerView.frame.size.width-kTitleLabelPaddingTop) * 0.9,
                                        (_containerView.frame.size.height - 2 * kTitleLabelPaddingTop) * kSubtitleLabelHeightRelativeToContainer)];
    
    [_section1ContainerView addSubview:_subTitleLabel];
    [_subTitleLabel setNumberOfLines:0];
    
    
}

- (void)generateToastCosmetics {
    
    _containerView.backgroundColor = _backgroundColor;
    
}

-(void)showSuccessToast:(UIViewController *)viewController
              titleText:(NSString *)titleText
           subTitleText:(NSString *)subTitleText
               duration:(NSTimeInterval)duration {
    
    [self showToasterAt:viewController
          leftSideImage:nil
        backgroundColor:UIColorFromRGB(0x2ecc71)
              titleText:titleText
           subTitleText:subTitleText
               duration:duration
           toasterStyle:kMUGSuccess];
    
}

-(void)showErrorToast:(UIViewController *)viewController
            titleText:(NSString *)titleText
         subTitleText:(NSString *)subTitleText
             duration:(NSTimeInterval)duration {
    
    [self showToasterAt:viewController
          leftSideImage:nil
        backgroundColor:UIColorFromRGB(0xe74c3c)
              titleText:titleText
           subTitleText:subTitleText
               duration:duration
           toasterStyle:kMUGError];
    
}

#pragma mark - Main Presenting Arguments
- (void)showToasterAtView:(UIView *)parentView
            leftSideImage:(UIImage *)image
          backgroundColor:(UIColor *)color
                titleText:(NSString *)titleText
             subTitleText:(NSString *)subTitleText
                 duration:(NSTimeInterval)duration
               toastStyle:(MUGToasterViewStyle)style
            animationType:(MUGToasterAnimationType)animationType
                withBlock:(void (^)(NSString *, BOOL))toastingFinished {
    
    if (_isToastPresenting == NO) {
        
        _isToastPresenting = YES;
        if (animationType == SlideVertical) {
            [self handleLayoutWithHideLocation:@"top"];
        }
        else if (animationType == SlideHorizontal) {
            [self handleLayoutWithHideLocation:@"left"];
        }
        
        _backgroundColor = color;
        
        if (image != nil) {
            [_section0ImageView setImage:image];
            _section0ImageView.image = [_section0ImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            [_section0ImageView setTintColor:[UIColor whiteColor]];
        }
        
        _titleLabel.text = titleText;
        _subTitleLabel.text = subTitleText;
        _titleLabel.textColor = _titleTextColor;
        _subTitleLabel.textColor = _subTitleTextColor;
        _titleLabel.font = _titleFont;
        _subTitleLabel.font = _subTitleFont;
        
        //Before adding the view, re-generating cosmetics
        [self generateToastCosmetics];
        
        [parentView addSubview:_containerView];
        [_containerView pop_addAnimation:[self prepareSpringAnimationForType:SlideVertical
                                                                 areWeHiding:NO
                                                               identifierKey:@"slideVertical"] forKey:@"slideVertical"];
        
        
        mugDurationTimer =  [NSTimer scheduledTimerWithTimeInterval:duration
                                                             target:self
                                                           selector:@selector(hideToast)
                                                           userInfo:nil
                                                            repeats:NO];
        
        toastingFinished(@"success", YES);
    }
    
    else {
        //
    }
    
    
}

- (void)hideToast {
    
    [_containerView pop_addAnimation:[self prepareSpringAnimationForType:SlideVertical
                                                             areWeHiding:YES
                                                           identifierKey:@"slideVertical"]
                              forKey:@"slideVertical"];
    _isToastPresenting = NO;
    
}

- (void)hideToasterWithAnimationType:(MUGToasterAnimationType)animationType
                           withBlock:(void (^)(BOOL))hidingFinished {
    
    [mugDurationTimer invalidate];
    if (animationType == SlideVertical) {
        [_containerView pop_addAnimation:[self prepareSpringAnimationForType:SlideVertical
                                                                 areWeHiding:YES
                                                               identifierKey:@"slideVertical"] forKey:@"slideVertical"];
        
    }
    
    _isToastPresenting = NO;
    hidingFinished(YES);
}

- (void)showToasterAt:(UIViewController *)viewController
        leftSideImage:(UIImage *)image
      backgroundColor:(UIColor *)color
            titleText:(NSString *)titleText
         subTitleText:(NSString *)subTitleText
             duration:(NSTimeInterval)duration
         toasterStyle:(MUGToasterViewStyle)style {
    
    
    //[viewController.view addSubview:_containerView];
    
}

#pragma mark - Getters & Setters
-(void)setTitleFont:(UIFont *)titleFont {
    
    _titleFont = titleFont;
    
}

-(void)setToasterHeight:(CGFloat)toasterHeight {
    
    kToasterDefaultHeight = toasterHeight;
}


- (CGFloat)toasterHeight {
    
    return kToasterDefaultHeight;
}

- (void)setTitleTextColor:(UIColor *)titleTextColor {
    
    _titleTextColor = titleTextColor;
}

- (void)setSubTitleTextColor:(UIColor *)subTitleTextColor {
    
    _subTitleTextColor = subTitleTextColor;
    
}

- (POPSpringAnimation *)prepareSpringAnimationForType:(MUGToasterAnimationType)type
                                          areWeHiding:(BOOL)hiding
                                        identifierKey:(NSString *)identifierKey {
    
    NSLog(@"hiding: %i" ,hiding);
    
    POPSpringAnimation *springAnimation = [POPSpringAnimation animation];
    springAnimation.property = [POPAnimatableProperty propertyWithName:kPOPViewFrame];
    springAnimation.springBounciness = 5;
    springAnimation.springSpeed = 3;
    
    if (type == SlideVertical && hiding == 0 )
        springAnimation.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, self.view.frame.size.width, kToasterDefaultHeight)];
    else if (type == SlideVertical && hiding == 1)
        springAnimation.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0-kToasterDefaultHeight, self.view.frame.size.width, kToasterDefaultHeight)];
    
    springAnimation.name = identifierKey;
    
    return springAnimation;
}

@end