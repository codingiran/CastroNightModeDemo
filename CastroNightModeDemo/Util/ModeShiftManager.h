//
//  ModeShiftManager.h
//  CastroNightModeDemo
//
//  Created by 邱一郎 on 2018/11/29.
//  Copyright © 2018 CodingIran. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

FOUNDATION_EXPORT NSString * const kModeSetting;

#define UIColorMake(r, g, b)     [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0];
#define ModeShifter              [ModeShiftManager sharedManager]

typedef NS_ENUM(NSUInteger, ThemeMode) {
    ThemeModeNight,
    ThemeModeDay,
};

NS_ASSUME_NONNULL_BEGIN

@interface ModeShiftManager : NSObject

// mode color
@property(nonatomic, strong, readonly) UIColor *viewBkgColor;
@property(nonatomic, strong, readonly) UIColor *navigationColor;
@property(nonatomic, strong, readonly) UIColor *navigationTintColor;
@property(nonatomic, strong, readonly) UIColor *cellBkgColor;
@property(nonatomic, strong, readonly) UIColor *cellTextColor;
@property(nonatomic, strong, readonly) UIColor *cellDetailTextColor;
@property(nonatomic, strong, readonly) UIColor *cellBorderColor;
@property(nonatomic, strong, readonly) UIColor *cellImageMaskColor;

// mode property
@property(nonatomic, assign, readwrite) ThemeMode themeMode;

// singleton
+ (instancetype)sharedManager;

@end

NS_ASSUME_NONNULL_END
