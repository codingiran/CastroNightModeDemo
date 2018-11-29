//
//  QueueListViewController.m
//  CastroNightModeDemo
//
//  Created by 邱一郎 on 2018/11/29.
//  Copyright © 2018 CodingIran. All rights reserved.
//

#import "QueueListViewController.h"

@interface QueueListViewController ()

@property (weak, nonatomic) IBOutlet UITableView *queueTableView;

@end

@implementation QueueListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *setting = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"setting"] style:UIBarButtonItemStylePlain target:self action:@selector(setting:)];
    self.navigationItem.leftBarButtonItem = setting;
}

- (void)setting:(UIBarButtonItem *)sender
{
    
}





@end
