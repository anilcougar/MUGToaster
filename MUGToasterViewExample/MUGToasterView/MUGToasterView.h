//
//  MUGToasterView.h
//  MuG
//
//  Created by Anil Ardahanli on 2/1/15.
//  Copyright (c) 2015 Anil Ardahanli. All rights reserved.
//

@import UIKit;

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)

//Hex->UI Converter
#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


typedef void (^DismissBlock)(void);

@interface MUGToasterView : UIViewController

typedef NS_ENUM(NSInteger, MUGToasterViewStyle) {
    
    kMUGError,
    kMUGValidation,
    kMUGWarning,
    kMUGInfo,
    kMUGSuccess,
    kMUGCustom,
};

typedef NS_ENUM(NSInteger, MUGToasterHideLocation) {
    
    HideAtTop,
    HideAtLeft,
    HideAtBottom,
    HideAtRight,
    
};

typedef NS_ENUM(NSInteger, MUGToasterAnimationType) {
    
    Fade,
    SlideVertical,
    SlideHorizontal,
    
};

/**
 Title Label.
 */
@property (nonatomic, strong) UILabel *titleLabel;
/**
 Subtitle Label.
 */
@property (nonatomic, strong) UILabel *subTitleLabel;

/**
 * Title label text font
 */
@property (nonatomic, strong) UIFont *titleFont;

/**
 * Subtitle label text font
 */
@property (nonatomic, strong) UIFont *subTitleFont;

/**
 * Background color
 */
@property (nonatomic, strong) UIColor *backgroundColor;

/**
 * Title text Color
 */
@property (nonatomic, strong) UIColor *titleTextColor;

/**
 * Subtitle text color
 */
@property (nonatomic, strong) UIColor *subTitleTextColor;

/**
 * Toaster Style
 */
@property (nonatomic) MUGToasterViewStyle toasterStyle;

/**
 * Animation type
 */
@property (nonatomic) MUGToasterAnimationType animationType;

/**
 * Toaster Height
 */
@property (nonatomic) CGFloat toasterHeight;

/** Show Success Type MUGToasterView.
 *
 * @param viewController This is main view controller we're gonna use for showing our toaster.
 * @param titleText The text to be displayed in title
 * @param subTitleText The text to be displayed in subtitle
 * @param duration How long do you want the toaster view stay on screen in seconds. IF you set this variable to 0, toaster won't remove automatically.
 */
- (void)showSuccessToast:(UIViewController *)viewController
               titleText:(NSString *)titleText
            subTitleText:(NSString *)subTitleText
                duration:(NSTimeInterval)duration;

/** Show Error Type MUGToasterView.
 * @param viewController This is main view controller we're gonna use for showing our toaster.
 * @param titleText The text to be displayed in title
 * @param subTitleText The text to be displayed in subtitle
 * @param duration How long do you want the toaster view stay on screen in seconds. IF you set this variable to 0, toaster won't remove automatically.
 */
- (void)showErrorToast:(UIViewController *)viewController
             titleText:(NSString *)titleText
          subTitleText:(NSString *)subTitleText
              duration:(NSTimeInterval)duration;


- (void)showToasterAtView:(UIView *)parentView
            leftSideImage:(UIImage *)image
          backgroundColor:(UIColor *)color
                titleText:(NSString *)titleText
             subTitleText:(NSString *)subTitleText
                 duration:(NSTimeInterval)duration
               toastStyle:(MUGToasterViewStyle)style
            animationType:(MUGToasterAnimationType)animationType
                withBlock:(void (^)(NSString *statusString, BOOL finished))toastingFinished;

- (void)hideToasterWithAnimationType:(MUGToasterAnimationType)animationType
                           withBlock:(void (^)(BOOL hideComplete))hidingFinished;


@end
