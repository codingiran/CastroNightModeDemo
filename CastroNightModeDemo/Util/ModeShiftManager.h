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

@property(nonatomic, strong) UIColor *viewBkgColor;
@property(nonatomic, strong) UIColor *navigationColor;
@property(nonatomic, strong) UIColor *navigationTintColor;
@property(nonatomic, strong) UIColor *cellBkgColor;
@property(nonatomic, strong) UIColor *cellTextColor;
@property(nonatomic, strong) UIColor *cellDetailTextColor;

@property(nonatomic, assign) ThemeMode themeMode;

+ (instancetype)sharedManager;


@end

NS_ASSUME_NONNULL_END
