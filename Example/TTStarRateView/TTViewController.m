//
//  TTViewController.m
//  TTStarRateView
//
//  Created by claudeli@yeah.net on 09/19/2018.
//  Copyright (c) 2018 claudeli@yeah.net. All rights reserved.
//

#import "TTViewController.h"
#import <TTStarRateView/TTStarRateView.h>

@interface TTViewController ()<TTStarRateViewDelegate>

@property (nonatomic, strong) TTStarRateView *starView;

@end

@implementation TTViewController

- (TTStarRateView *)starView{
    if (!_starView) {
        _starView = [[TTStarRateView alloc] initWithFrame:CGRectMake(50, 100, 210, 30) delegate:self];
        _starView.rateStyle =  TTStarRateStyleIncomplete;
        [self.view addSubview:_starView];
    }
    return _starView;
}

// stars count, default 5
//-(NSInteger)numberOfStarsInStarRateView:(TTStarRateView *)starRateView;

//// return custom star image at index
//-(UIImage *)starRateView:(TTStarRateView *)starRateView imageAtIndex:(NSInteger)index highlighted:(BOOL)highlighted;

// current score
-(void)starRateView:(TTStarRateView *)starRateView currentScore:(CGFloat)currentScore{
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.starView.hidden = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
