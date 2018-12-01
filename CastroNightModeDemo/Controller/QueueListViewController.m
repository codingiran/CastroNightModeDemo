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
#import "ModeShiftManager.h"
#import "UINavigationController+Theme.h"
#import <QuartzCore/QuartzCore.h>

@interface QueueListViewController ()<UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate>

@property(weak, nonatomic) IBOutlet UITableView *queueTableView;

@property(nonatomic, strong) NSArray<Queue *> *queueList;

@property(nonatomic, strong) UIView *previousModeViewSnapshot;

@property(nonatomic, strong) CAShapeLayer *snapshotMaskLayer;

@end

@implementation QueueListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
        
    UIBarButtonItem *setting = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"setting"] style:UIBarButtonItemStylePlain target:self action:@selector(setting:)];
    self.navigationItem.leftBarButtonItem = setting;
    
    // top 20px space
    self.queueTableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);
    
    // refresh
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    [refresh addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    self.queueTableView.refreshControl = refresh;
    
    // add pangesture
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognizer:)];
    panGesture.minimumNumberOfTouches = 2;
    panGesture.maximumNumberOfTouches = 2;
    panGesture.delegate = self;
    [self.queueTableView addGestureRecognizer:panGesture];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // refresh UI
    [self refreshUI];
}

#pragma mark - touch event

- (void)setting:(UIBarButtonItem *)sender
{
    if (ModeShifter.themeMode == ThemeModeDay) {
        ModeShifter.themeMode = ThemeModeNight;
    } else {
        ModeShifter.themeMode = ThemeModeDay;
    }
    
    // refresh UI
    [self refreshUI];
    
    // refresh StatusBar
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)refreshUI
{
    self.queueTableView.backgroundColor = [UIColor clearColor];
    self.view.backgroundColor = ModeShifter.viewBkgColor;
    [self.navigationController.navigationBar setBackgroundImage:[self createImageWithColor:ModeShifter.navigationColor] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTintColor:ModeShifter.navigationTintColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : ModeShifter.navigationTintColor}];
    [self.queueTableView reloadData];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    if (ModeShifter.themeMode == ThemeModeNight) {
        return UIStatusBarStyleLightContent;
    } else {
        return UIStatusBarStyleDefault;
    }
}

- (void)refresh:(UIRefreshControl *)sender
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [sender endRefreshing];
    });
}

- (void)panGestureRecognizer:(UIPanGestureRecognizer *)panGesture
{
    switch (panGesture.state) {
        case UIGestureRecognizerStateBegan:
            [self beginInteractiveTransitionWithPanGesture:panGesture];
            break;
        case UIGestureRecognizerStateChanged:
            [self adjustMaskLayerBasedOnPanGesture:panGesture];
            break;
        case UIGestureRecognizerStateEnded:
//        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed:
            [self endInteractiveTransitionWithPanGesture:panGesture];
            break;
            
        default:
            break;
    }
}

#pragma mark - private methods
- (void)beginInteractiveTransitionWithPanGesture:(UIPanGestureRecognizer *)panGesture
{
    UIWindow *window = self.queueTableView.window;
    
    NSAssert(!!window, @"unexpected error: table view has no window");
    
    // get previous snapshot
    self.previousModeViewSnapshot = [window snapshotViewAfterScreenUpdates:NO];
    [window addSubview:self.previousModeViewSnapshot];
    [window bringSubviewToFront:self.previousModeViewSnapshot];
    
    // create new mask
    self.snapshotMaskLayer = [CAShapeLayer layer];
    self.snapshotMaskLayer.path = [UIBezierPath bezierPathWithRect:window.bounds].CGPath;
    self.snapshotMaskLayer.fillColor = [UIColor blackColor].CGColor;
    self.previousModeViewSnapshot.layer.mask = self.snapshotMaskLayer;
    
    // shift mode
    [self setting:nil];
    
    // first adjust mask layer
    [self adjustMaskLayerBasedOnPanGesture:panGesture];
}

- (void)adjustMaskLayerBasedOnPanGesture:(UIPanGestureRecognizer *)panGesture
{
    [self adjustMaskLayerPositionBasedOnPanGesture:panGesture];
    [self adjustMaskLayerPathBasedOnPanGesture:panGesture];
}

- (void)adjustMaskLayerPositionBasedOnPanGesture:(UIPanGestureRecognizer *)panGesture
{
    UIWindow *window = self.queueTableView.window;
    if (!window) return;
    
    [CATransaction begin];
    [CATransaction setDisableActions:NO];
    
    CGFloat verticalTranslation = [panGesture translationInView:window].y;
    if (verticalTranslation < 0) {
        [panGesture setTranslation:CGPointZero inView:window];
        self.snapshotMaskLayer.frame = CGRectMake(self.snapshotMaskLayer.frame.origin.x, 0, self.snapshotMaskLayer.frame.size.width, self.snapshotMaskLayer.frame.size.height);
    } else {
        self.snapshotMaskLayer.frame = CGRectMake(self.snapshotMaskLayer.frame.origin.x, verticalTranslation, self.snapshotMaskLayer.frame.size.width, self.snapshotMaskLayer.frame.size.height);
    }
    [CATransaction commit];
}

- (void)adjustMaskLayerPathBasedOnPanGesture:(UIPanGestureRecognizer *)panGesture
{
    UIWindow *window = self.queueTableView.window;
    if (!window) return;
    
    UIBezierPath *maskingPath = [UIBezierPath bezierPath];
    [maskingPath moveToPoint:CGPointZero];
    
    CGFloat damping = 45.0f;
    
    
    CGFloat verticalOffset = [panGesture velocityInView:window].y / damping;
    [maskingPath addQuadCurveToPoint:CGPointMake(CGRectGetMaxX(window.bounds), 0) controlPoint:CGPointMake(CGRectGetMidX(window.bounds), verticalOffset)];
    
    [maskingPath addLineToPoint:CGPointMake(CGRectGetMaxX(window.bounds), CGRectGetMaxY(window.bounds))];
    
    [maskingPath addLineToPoint:CGPointMake(0, CGRectGetMaxY(window.bounds))];
    
    [maskingPath closePath];
    
    self.snapshotMaskLayer.path = maskingPath.CGPath;
    
}

- (void)endInteractiveTransitionWithPanGesture:(UIPanGestureRecognizer *)panGesture
{
    UIWindow *window = self.queueTableView.window;
    if (!window) return;
    
    CGPoint velocity = [panGesture velocityInView:window];
    CGPoint transition = [panGesture translationInView:window];
    
    BOOL isMovingDownwards = velocity.y > 0;
    BOOL hasPassedThreshold = transition.y > CGRectGetMidY(window.bounds);
    
    BOOL shouldCompleteTransition = isMovingDownwards || hasPassedThreshold;
    
    if (shouldCompleteTransition) {
        [self completeInteractiveTransitionWithVelocity:velocity];
    } else {
        [self cancelInteractiveTransitionWithVelocity:velocity];
    }
}

- (void)cancelInteractiveTransitionWithVelocity:(CGPoint)velocity
{
    if (!self.snapshotMaskLayer) return;
    
    [self animateOfLayer:self.snapshotMaskLayer toTargetPoint:CGPointZero withVelocity:velocity completion:^{
        [self setting:nil];
        [self cleanupAfterInteractiveTransition];
    }];
    
}

- (void)completeInteractiveTransitionWithVelocity:(CGPoint)velocity
{
    UIWindow *window = self.queueTableView.window;
    if (!window || !self.snapshotMaskLayer) return;
    
    CGPoint targetPoint = CGPointMake(0, CGRectGetMaxY(window.bounds));
    [self animateOfLayer:self.snapshotMaskLayer toTargetPoint:targetPoint withVelocity:velocity completion:^{
        [self cleanupAfterInteractiveTransition];
    }];
}
- (void)cleanupAfterInteractiveTransition
{
    [self.previousModeViewSnapshot removeFromSuperview];
    self.previousModeViewSnapshot = nil;
    self.snapshotMaskLayer = nil;
}

- (void)animateOfLayer:(CALayer *)layer toTargetPoint:(CGPoint)targetPoint withVelocity:(CGPoint)velocity completion:(nullable void (^)(void))completion
{
    CGPoint startPoint = layer.position;
    layer.position = targetPoint;
    
    CABasicAnimation *positionAnimation = [CABasicAnimation animationWithKeyPath:@"postion"];
    positionAnimation.duration = MIN(3.0, [self timeRequiredToMoveFromPoint:startPoint toPoint:targetPoint withVelocity:velocity]);
    positionAnimation.fromValue = [NSValue valueWithCGPoint:startPoint];
    positionAnimation.toValue = [NSValue valueWithCGPoint:targetPoint];
    
    [CATransaction begin];
    [CATransaction setCompletionBlock:completion];
    
    [layer addAnimation:positionAnimation forKey:@"position"];
    
    [CATransaction commit];
}

- (NSTimeInterval)timeRequiredToMoveFromPoint:(CGPoint)fromPoint toPoint:(CGPoint)toPoint withVelocity:(CGPoint)velocity
{
    CGFloat distance = sqrt(powf(toPoint.x - fromPoint.x, 2) + powf(toPoint.y - fromPoint.y, 2));
    CGFloat velocityMagnitude = sqrt(powf(velocity.x, 2) + powf(velocity.y, 2));
    NSTimeInterval requiredTime = fabs(distance / velocityMagnitude);
    return requiredTime;
}


#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    UIPanGestureRecognizer *panGesture = (UIPanGestureRecognizer *)gestureRecognizer;
    CGPoint transition = [panGesture translationInView:self.queueTableView.window];
    return transition.y > 0;
}

#pragma mark - table view data source

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
    [cell refreshUI];
    return cell;
}

#pragma mark - table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - getter
- (NSArray<Queue *> *)queueList
{
    if (!_queueList) {
        Queue *queue0 = [[Queue alloc] initWithArtworkImageName:@"bo" artworkTitle:@"#126.求助：你听到专门为博物馆展览谱写的氛围音乐吗？" andArtworkLength:@"44m remaining"];
        Queue *queue1 = [[Queue alloc] initWithArtworkImageName:@"ux" artworkTitle:@"#63：世上最难画的不是喜怒哀乐，而是生活（小崽子表情作者脏小白）" andArtworkLength:@"40m"];
        Queue *queue2 = [[Queue alloc] initWithArtworkImageName:@"mie" artworkTitle:@"文学者（ぶんがくしゃ）[Bungakusha]" andArtworkLength:@"2h"];
        Queue *queue3 = [[Queue alloc] initWithArtworkImageName:@"fan" artworkTitle:@"129《找到你》（5.8分）：民粹时代的『现实主义』" andArtworkLength:@"20m remaining"];
        Queue *queue4 = [[Queue alloc] initWithArtworkImageName:@"hard" artworkTitle:@"Episode 74: 美国的文化西部与真实西部：Red Dead Redemption 2" andArtworkLength:@"44m"];
        
        _queueList = @[queue0, queue1, queue2, queue3, queue4];
    }
    return _queueList;
}

- (UIImage *)createImageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 5.0f, 5.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resultImage;
}

@end
