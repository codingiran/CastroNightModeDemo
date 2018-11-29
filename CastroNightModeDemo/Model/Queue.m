//
//  Queue.m
//  CastroNightModeDemo
//
//  Created by 邱一郎 on 2018/11/29.
//  Copyright © 2018 CodingIran. All rights reserved.
//

#import "Queue.h"
@interface Queue ()

@property(nonatomic, copy, readwrite) NSString *artworkImageName;
@property(nonatomic, copy, readwrite) NSString *artworkTitle;
@property(nonatomic, copy, readwrite) NSString *artworkLength;

@end

@implementation Queue

- (instancetype)initWithArtworkImageName:(NSString *)artworkImageName
                            artworkTitle:(NSString *)artworkTitle
                        andArtworkLength:(NSString *)artworkLength
{
    if (self = [super init]) {
        self.artworkImageName = artworkImageName;
        self.artworkTitle = artworkTitle;
        self.artworkLength = artworkLength;
    }
    return self;
}

@end
