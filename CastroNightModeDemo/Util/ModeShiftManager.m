//
//  ModeShiftManager.m
//  CastroNightModeDemo
//
//  Created by 邱一郎 on 2018/11/29.
//  Copyright © 2018 CodingIran. All rights reserved.
//


#import "ModeShiftManager.h"

NSString * const kModeSetting = @"modeSetting";

@interface ModeShiftManager ()

@property(nonatomic, strong, readwrite) UIColor *viewBkgColor;
@property(nonatomic, strong, readwrite) UIColor *navigationColor;
@property(nonatomic, strong, readwrite) UIColor *navigationTintColor;
@property(nonatomic, strong, readwrite) UIColor *cellBkgColor;
@property(nonatomic, strong, readwrite) UIColor *cellTextColor;
@property(nonatomic, strong, readwrite) UIColor *cellDetailTextColor;
@property(nonatomic, strong, readwrite) UIColor *cellBorderColor;
@property(nonatomic, strong, readwrite) UIColor *cellImageMaskColor;

@end

@implementation ModeShiftManager

static ModeShiftManager *modeShiftManager = nil;
+ (instancetype)sharedManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        modeShiftManager = [[super allocWithZone:NULL] init];
    });
    return modeShiftManager;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    return [self sharedManager];
}

- (id)copy
{
    return [self.class sharedManager];
}

- (id)mutableCopy
{
    return [self.class sharedManager];
}

- (void)setThemeMode:(ThemeMode)themeMode
{
    _themeMode = themeMode;
    
    switch (themeMode) {
        case ThemeModeDay:
        {
            self.viewBkgColor = UIColorMake(229, 229, 229);
            self.navigationColor = UIColorMake(244, 244, 244);
            self.navigationTintColor = UIColorMake(10, 10, 10);
            self.cellBkgColor = UIColorMake(252, 252, 252);
            self.cellTextColor = UIColorMake(10, 10, 10);
            self.cellDetailTextColor = UIColorMake(150, 150, 150);
            self.cellBorderColor = self.cellBkgColor;
            self.cellImageMaskColor = [UIColor clearColor];
        }
            break;
        case ThemeModeNight:
        {
            self.viewBkgColor = UIColorMake(23, 23, 23);
            self.navigationColor = UIColorMake(44, 44, 44);
            self.navigationTintColor = UIColorMake(252, 252, 252);
            self.cellBkgColor = UIColorMake(29, 29, 29);
            self.cellTextColor = UIColorMake(242, 242, 242);
            self.cellDetailTextColor = UIColorMake(100, 100, 100);
            self.cellBorderColor = UIColorMake(49, 49, 49);
            self.cellImageMaskColor = [[UIColor blackColor] colorWithAlphaComponent:0.15];
        }
            break;
            
        default:
            break;
    }
    
    // save to setting
    [[NSUserDefaults standardUserDefaults] setObject:@(themeMode) forKey:kModeSetting];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


@end
