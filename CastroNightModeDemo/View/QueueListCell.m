//
//  QueueListCell.m
//  CastroNightModeDemo
//
//  Created by 邱一郎 on 2018/11/29.
//  Copyright © 2018 CodingIran. All rights reserved.
//

#import "QueueListCell.h"
#import "Queue.h"
#import "ModeShiftManager.h"

static NSString * const kCellResuseIdentifier = @"QueueListCell";
static CGFloat const kCellMargin = 6;

@interface QueueListCell ()

@property (weak, nonatomic) IBOutlet UIView *imageMask;
@property (weak, nonatomic) IBOutlet UIImageView *artworkImage;
@property (weak, nonatomic) IBOutlet UILabel *artworkTitle;
@property (weak, nonatomic) IBOutlet UILabel *artworkLength;
@property (weak, nonatomic) IBOutlet UIView *upperLine;
@property (weak, nonatomic) IBOutlet UIView *underLine;

@end

@implementation QueueListCell

+ (instancetype)queueListCellWithTableView:(UITableView *)tableView
{
    QueueListCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellResuseIdentifier];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([QueueListCell class]) owner:self options:nil].lastObject;
    }
    return cell;
}

- (void)refreshUI
{
    self.backgroundColor = ModeShifter.cellBkgColor;
    self.artworkTitle.textColor = ModeShifter.cellTextColor;
    self.artworkLength.textColor = ModeShifter.cellDetailTextColor;
    self.upperLine.backgroundColor = ModeShifter.cellBorderColor;
    self.underLine.backgroundColor = ModeShifter.cellBorderColor;
    self.imageMask.backgroundColor = ModeShifter.cellImageMaskColor;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self refreshUI];
    
    self.artworkImage.layer.cornerRadius = 6;
    self.artworkImage.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.artworkImage.layer.borderWidth = 0.5;
    self.artworkImage.layer.masksToBounds = YES;
    
    self.imageMask.layer.cornerRadius = self.artworkImage.layer.cornerRadius;
    self.imageMask.layer.masksToBounds = YES;
}

- (void)setFrame:(CGRect)frame
{
    frame.origin.y += kCellMargin;
    frame.size.height -= kCellMargin * 2;
    [super setFrame:frame];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)setQueue:(Queue *)queue
{
    _queue = queue;
    self.artworkImage.image = [UIImage imageNamed:queue.artworkImageName];
    self.artworkTitle.text = queue.artworkTitle;
    self.artworkLength.text = queue.artworkLength;
}

@end
