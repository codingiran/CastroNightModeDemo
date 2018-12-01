//
//  UINavigationController+Theme.m
//  CastroNightModeDemo
//
//  Created by 邱一郎 on 2018/11/30.
//  Copyright © 2018 CodingIran. All rights reserved.
//

#import "UINavigationController+Theme.h"

@implementation UINavigationController (Theme)

- (UIViewController *)childViewControllerForStatusBarStyle
{
    return self.topViewController;
}

@end
