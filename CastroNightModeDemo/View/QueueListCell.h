//
//  QueueListCell.h
//  CastroNightModeDemo
//
//  Created by 邱一郎 on 2018/11/29.
//  Copyright © 2018 CodingIran. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Queue;

NS_ASSUME_NONNULL_BEGIN

@interface QueueListCell : UITableViewCell

@property(nonatomic, strong) Queue *queue;

+ (instancetype)queueListCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
