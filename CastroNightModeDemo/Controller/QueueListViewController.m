//
//  QueueListViewController.m
//  CastroNightModeDemo
//
//  Created by 邱一郎 on 2018/11/29.
//  Copyright © 2018 CodingIran. All rights reserved.
//

#import "QueueListViewController.h"
#import "QueueListCell.h"
#import "Queue.h"

@interface QueueListViewController ()<UITableViewDelegate, UITableViewDataSource>

@property(weak, nonatomic) IBOutlet UITableView *queueTableView;

@property(nonatomic, strong) NSArray<Queue *> *queueList;

@end

@implementation QueueListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *setting = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"setting"] style:UIBarButtonItemStylePlain target:self action:@selector(setting:)];
    self.navigationItem.leftBarButtonItem = setting;
    
    // header 20 space
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 20)];
    header.backgroundColor = [UIColor clearColor];
    self.queueTableView.tableHeaderView = header;
    
    // refresh
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    [refresh addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    self.queueTableView.refreshControl = refresh;
}


- (void)setting:(UIBarButtonItem *)sender
{}

- (void)refresh:(UIRefreshControl *)sender
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [sender endRefreshing];
    });
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.queueList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    QueueListCell *cell = [QueueListCell queueListCellWithTableView:tableView];
    cell.queue = self.queueList[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110;
}


#pragma mark - getter
- (NSArray<Queue *> *)queueList
{
    if (!_queueList) {
        Queue *queue0 = [[Queue alloc] initWithArtworkImageName:@"bo" artworkTitle:@"#126.求助：你听到专门为博物馆展览谱写的氛围音乐吗？" andArtworkLength:@"44m remaining"];
        Queue *queue1 = [[Queue alloc] initWithArtworkImageName:@"ux" artworkTitle:@"#63：世上最难画的不是喜怒哀乐，而是生活（小崽子表情作者脏小白）" andArtworkLength:@"40m"];
        Queue *queue2 = [[Queue alloc] initWithArtworkImageName:@"mie" artworkTitle:@"日文的『文学者』是什么意思？" andArtworkLength:@"2h"];
        Queue *queue3 = [[Queue alloc] initWithArtworkImageName:@"fan" artworkTitle:@"129《找到你》（5.8分）：民粹时代的『现实主义』" andArtworkLength:@"20m remaining"];
        Queue *queue4 = [[Queue alloc] initWithArtworkImageName:@"hard" artworkTitle:@"Episode 74: 美国的文化西部与真实西部：Red Dead Redemption 2" andArtworkLength:@"44m"];
        
        
        _queueList = @[queue0, queue1, queue2, queue3, queue4];
    }
    return _queueList;
}


@end
