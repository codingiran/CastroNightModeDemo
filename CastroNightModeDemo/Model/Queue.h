//
//  Queue.h
//  CastroNightModeDemo
//
//  Created by 邱一郎 on 2018/11/29.
//  Copyright © 2018 CodingIran. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Queue : NSObject

@property(nonatomic, copy, readonly) NSString *artworkImageName;
@property(nonatomic, copy, readonly) NSString *artworkTitle;
@property(nonatomic, copy, readonly) NSString *artworkLength;


- (instancetype)initWithArtworkImageName:(NSString *)artworkImageName
                            artworkTitle:(NSString *)artworkTitle
                        andArtworkLength:(NSString *)artworkLength;

@end

NS_ASSUME_NONNULL_END
