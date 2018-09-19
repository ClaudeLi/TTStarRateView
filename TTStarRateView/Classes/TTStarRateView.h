//
//  TTStarRateView.h
//  Tiaooo
//
//  Created by ClaudeLi on 2018/9/19.
//  Copyright © 2018年 ClaudeLi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TTStarRateView;

typedef void(^finishedHelper)(CGFloat currentScore);

typedef NS_ENUM(NSInteger, TTStarRateStyle){
    TTStarRateStyleWhole        = 0, // 只能整星评论
    TTStarRateStyleHalf         = 1, // 允许半星评论
    TTStarRateStyleIncomplete   = 2  // 允许不完整星评论
};

@protocol TTStarRateViewDelegate <NSObject>

@required
@optional

// stars count, default 5
-(NSInteger)numberOfStarsInStarRateView:(TTStarRateView *)starRateView;

// return star image at index
-(UIImage *)starRateView:(TTStarRateView *)starRateView imageAtIndex:(NSInteger)index highlighted:(BOOL)highlighted;

// current score
-(void)starRateView:(TTStarRateView *)starRateView currentScore:(CGFloat)currentScore;

@end

@interface TTStarRateView : UIView

@property (nonatomic, assign) BOOL              isAnimation;        // 是否动画显示，默认NO
@property (nonatomic, assign) TTStarRateStyle   rateStyle;          // 评分样式
@property (nonatomic, assign) CGFloat           score;              // 设置初始score
@property (nonatomic, weak)   id<TTStarRateViewDelegate>delegate;


-(instancetype)initWithFrame:(CGRect)frame;
-(instancetype)initWithFrame:(CGRect)frame finish:(finishedHelper)finish;
-(instancetype)initWithFrame:(CGRect)frame delegate:(id<TTStarRateViewDelegate>)delegate;

-(instancetype)init __deprecated_msg("Used initWithFrame: ");

@end
