//
//  ViewController.m
//  JTabViewControllerExample
//
//  Created by Pramod Jadhav on 20/06/16.
//  Copyright © 2016 pramod. All rights reserved.
//

#import "ViewController.h"
#import <JTabViewController.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(NSArray *)dummyViewControllers{
    
    NSArray * colors = @[[UIColor redColor],[UIColor purpleColor],[UIColor orangeColor],[UIColor blueColor]];
    NSMutableArray * vcs = [NSMutableArray new];
    for (UIColor * color in colors) {
        
        UIViewController * vc = [[UIViewController alloc] init];
        vc.view.backgroundColor = color;
        [vcs addObject:vc];
    }
    return [NSArray arrayWithArray:vcs];
}

-(void)viewDidAppear:(BOOL)animated{
    JTabViewController * jtc = [[JTabViewController alloc]
                                initWitViewControllers:[self dummyViewControllers]
                                tabTitles:@[@"First",@"Second",@"Third",@"Four"]];
    UINavigationController * navVC = [[UINavigationController alloc] initWithRootViewController:jtc];
    [self presentViewController:navVC animated:YES completion:^{
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
