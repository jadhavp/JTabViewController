//
//  JTabViewController.m
//  Pods
//
//  Created by Pramod Jadhav on 20/06/16.
//
//

CGFloat DEFAULT_TAB_BAR_HEIGHT = 44.0f;
CGFloat WIDTH = 140;
CGFloat SELECTOR_HEIGHT = 4.0;


#import "JTabViewController.h"

@interface JTabViewController()<UIPageViewControllerDelegate,UIPageViewControllerDataSource,UIScrollViewDelegate>

@property (nonatomic, strong) NSArray *viewControllerArray;
@property (nonatomic, strong) UIView *selectionBar;
@property (nonatomic, strong) UIPageViewController *pageController;
@property (nonatomic, strong) UIScrollView *navigationView;
@property (nonatomic, strong) NSArray *buttonText;
@property (nonatomic) UIScrollView *pageScrollView;
@property (nonatomic) NSInteger currentPageIndex;
@property (nonatomic) BOOL isPageScrollingFlag;

@end

@implementation JTabViewController

-(void)defaultSetup{

    _tabBarHeight = DEFAULT_TAB_BAR_HEIGHT;
    _tabBarButtonFont = [UIFont systemFontOfSize:16.f];
    _tabBarButtonBgColor = [UIColor groupTableViewBackgroundColor];
    _tabBarButtonTextColor = [UIColor blackColor];
    _selectionBarColor = [UIColor blackColor];
}

- (instancetype)initWitViewControllers:(NSArray *)viewControllers tabTitles:(NSArray *)tabTitles{
    
    if ([viewControllers count]!=[tabTitles count]) {
        return nil;
    }
    self = [super init];
    if(self){
        
        [self defaultSetup];
        self.viewControllerArray = viewControllers;
        self.buttonText = tabTitles;
    }
    return self;
}

-(void)loadView{
    
    [super loadView];
    self.pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    CGRect rect = self.view.bounds;
    rect.origin.y = _tabBarHeight;
    rect.size.height-=_tabBarHeight;
    [self displayContentController:self.pageController adnFrame:rect];
    [self setupPageViewController];
    [self setupSegmentButtons];

}

- (void)viewDidLoad{
    
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.currentPageIndex = 0;
    self.isPageScrollingFlag = NO;
}

- (void) displayContentController: (UIViewController*) content adnFrame:(CGRect)frame{
    
    [content willMoveToParentViewController:self];
    [self addChildViewController:content];
    content.view.frame = frame;
    [self.view addSubview:content.view];
    [self didMoveToParentViewController:self];
    
}

-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

-(void)setupSegmentButtons {
    
    UIScreen * screen = [UIScreen mainScreen];
    CGFloat width = WIDTH;
    self.navigationView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,0,screen.bounds.size.width,_tabBarHeight)];
    self.navigationView.bounces = NO;
    self.navigationView.showsHorizontalScrollIndicator = NO;
    [self.navigationView setDirectionalLockEnabled:YES];
    
    NSInteger numControllers = [self.viewControllerArray count];
    
    if(numControllers<=3){
        
        width = screen.bounds.size.width/numControllers;
    }
    
    for (int i = 0; i<numControllers; i++) {

        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(width*i, 0, width, _tabBarHeight)];
        [button.titleLabel setFont:_tabBarButtonFont];
        [button setTitleColor:_tabBarButtonTextColor forState:UIControlStateNormal];
        [button setBackgroundColor:_tabBarButtonBgColor];
        button.tag = i;
        [button addTarget:self action:@selector(tapSegmentButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        button.titleLabel.numberOfLines = 0;
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        [button setTitle:[self.buttonText objectAtIndex:i] forState:UIControlStateNormal];
        [self.navigationView addSubview:button];

    }
    
    self.navigationView.contentSize = CGSizeMake(width*numControllers, _tabBarHeight);
    [self.view addSubview:self.navigationView];

    self.selectionBar = [[UIView alloc]initWithFrame:CGRectMake(0, 40,width, SELECTOR_HEIGHT)];
    self.selectionBar.backgroundColor = _selectionBarColor;
    self.selectionBar.alpha = 0.8;
    [self.navigationView addSubview:self.selectionBar];
}

-(void)setupPageViewController {

    self.pageController.delegate = self;
    self.pageController.dataSource = self;
    [self.pageController setViewControllers:@[[self.viewControllerArray objectAtIndex:0]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    [self syncScrollView];
}

-(void)syncScrollView {
    for (UIView* view in self.pageController.view.subviews){
        if([view isKindOfClass:[UIScrollView class]]) {
            self.pageScrollView = (UIScrollView *)view;
            self.pageScrollView.delegate = self;
        }
    }
}

-(void)tapSegmentButtonAction:(UIButton *)button {
    
    if (!self.isPageScrollingFlag) {
        
        NSInteger tempIndex = self.currentPageIndex;
        
        __weak typeof(self) weakSelf = self;
        
        if (button.tag > tempIndex) {
            
            for (int i = (int)tempIndex+1; i<=button.tag; i++) {
                [self.pageController setViewControllers:@[[self.viewControllerArray objectAtIndex:i]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:^(BOOL complete){
                    
                    if (complete) {
                        [weakSelf updateCurrentPageIndex:i];
                    }
                }];
            }
        }
        
        else if (button.tag < tempIndex) {
            for (int i = (int)tempIndex-1; i >= button.tag; i--) {
                [self.pageController setViewControllers:@[[self.viewControllerArray objectAtIndex:i]] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:^(BOOL complete){
                    if (complete) {
                        [weakSelf updateCurrentPageIndex:i];
                    }
                }];
            }
        }
    }
}

- (void)navigateToIndex:(NSInteger)index{
    
    if(index>=[self.viewControllerArray count]) {return;}
    __weak typeof(self) weakSelf = self;
    
    [self.pageController setViewControllers:@[[self.viewControllerArray objectAtIndex:index]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:^(BOOL complete){
        if (complete) {
            [weakSelf updateCurrentPageIndex:(int)index];
        }
    }];
    
}

-(void)updateCurrentPageIndex:(int)newIndex {
    self.currentPageIndex = newIndex;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat xFromCenter = self.view.frame.size.width-scrollView.contentOffset.x;
    NSInteger xCoor = self.selectionBar.frame.size.width*self.currentPageIndex;
    
    CGRect newRect  = CGRectMake(xCoor-xFromCenter/[self.viewControllerArray count], self.selectionBar.frame.origin.y, self.selectionBar.frame.size.width, self.selectionBar.frame.size.height);
    
    [self.navigationView scrollRectToVisible:newRect animated:YES];
    self.selectionBar.frame = newRect;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    NSInteger index = [self indexOfController:viewController];
    
    if ((index == NSNotFound) || (index == 0)) {
        return nil;
    }
    
    index--;
    return [self.viewControllerArray objectAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    NSInteger index = [self indexOfController:viewController];
    
    if (index == NSNotFound) {
        return nil;
    }
    index++;
    
    if (index == [self.viewControllerArray count]) {
        return nil;
    }
    return [self.viewControllerArray objectAtIndex:index];
}

-(void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed {
    if (completed) {
        self.currentPageIndex = [self indexOfController:[pageViewController.viewControllers lastObject]];
    }
}

-(NSInteger)indexOfController:(UIViewController *)viewController {
    for (int i = 0; i<[self.viewControllerArray count]; i++) {
        if (viewController == [self.viewControllerArray objectAtIndex:i])
        {
            return i;
        }
    }
    return NSNotFound;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.isPageScrollingFlag = YES;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.isPageScrollingFlag = NO;
}

@end
