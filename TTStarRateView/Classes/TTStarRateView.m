//
//  TTStarRateView.m
//  Tiaooo
//
//  Created by ClaudeLi on 2018/9/19.
//  Copyright © 2018年 ClaudeLi. All rights reserved.
//

#import "TTStarRateView.h"

NSBundle *TTStarResources(){
    static NSBundle *bundle = nil;
    if (bundle == nil) {
        // 这里不使用mainBundle是为了适配pod 1.x和0.x
        bundle = [NSBundle bundleWithPath:[[NSBundle bundleForClass:[TTStarRateView class]] pathForResource:@"TTStarResources" ofType:@"bundle"]];
    }
    return bundle;
}

static NSString *starImageNormal        = @"img_icon_star_gray";
static NSString *starImageHighlighted   = @"img_icon_star_yellow";

static NSInteger starsCount = 5;

typedef void(^CompleteBlock)(CGFloat currentScore);

@interface TTStarRateView()

@property (nonatomic, strong) UIView    *foregroundStarView;
@property (nonatomic, strong) UIView    *backgroundStarView;

@property (nonatomic, assign) NSInteger numberOfStars;
@property (nonatomic, assign) CGFloat   currentScore;     // 当前评分：0-5  默认0
@property (nonatomic, strong) CompleteBlock complete;

@end

@implementation TTStarRateView

- (instancetype)init{
    return [super init];
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self createStarView];
        [self addTapGesture];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame finish:(finishedHelper)finish{
    if (self = [super initWithFrame:frame]) {
        _complete = ^(CGFloat currentScore){
            finish(currentScore);
        };
        [self createStarView];
        [self addTapGesture];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame delegate:(id<TTStarRateViewDelegate>)delegate{
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = delegate;
        [self addTapGesture];
    }
    return self;
}

- (void)setDelegate:(id<TTStarRateViewDelegate>)delegate{
    if (_delegate != delegate) {
        _delegate = delegate;
        [self createStarView];
    }else{
        if (delegate == nil && !_foregroundStarView) {
            [self createStarView];
        }
    }
}

#pragma mark -
#pragma mark -- Private Method --
- (void)addTapGesture{
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userTapRateView:)];
    tapGesture.numberOfTapsRequired = 1;
    [self addGestureRecognizer:tapGesture];
}

-(void)createStarView{
    if (_foregroundStarView) {
        [_foregroundStarView removeFromSuperview];
        _foregroundStarView = nil;

        [_backgroundStarView removeFromSuperview];
        _backgroundStarView = nil;
    }
    self.foregroundStarView = [self createStarViewWithHighlighted:YES];
    self.backgroundStarView = [self createStarViewWithHighlighted:NO];
    self.foregroundStarView.frame = CGRectMake(0, 0, self.bounds.size.width*_currentScore/self.numberOfStars, self.bounds.size.height);
    
    [self addSubview:self.backgroundStarView];
    [self addSubview:self.foregroundStarView];
}

- (UIView *)createStarViewWithHighlighted:(BOOL)highlighted{
    UIView *view = [[UIView alloc] initWithFrame:self.bounds];
    view.clipsToBounds = YES;
    view.backgroundColor = [UIColor clearColor];
    _numberOfStars = starsCount;
    if (_delegate && [_delegate respondsToSelector:@selector(numberOfStarsInStarRateView:)]) {
        _numberOfStars = [_delegate numberOfStarsInStarRateView:self];
    }
    for (NSInteger i = 0; i < self.numberOfStars; i ++){
        UIImage *img = nil;
        if (_delegate && [_delegate respondsToSelector:@selector(starRateView:imageAtIndex:highlighted:)]) {
            img = [_delegate starRateView:self imageAtIndex:i highlighted:highlighted];
        }else{
            if (highlighted) {
                img = [UIImage imageNamed:starImageHighlighted inBundle:TTStarResources() compatibleWithTraitCollection:nil];
            }else{
                img = [UIImage imageNamed:starImageNormal inBundle:TTStarResources() compatibleWithTraitCollection:nil];
            }
        }
        UIImageView *imageView = [[UIImageView alloc] initWithImage:img];
        imageView.frame = CGRectMake(i * self.bounds.size.width / self.numberOfStars, 0, self.bounds.size.width / self.numberOfStars, self.bounds.size.height);
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [view addSubview:imageView];
    }
    return view;
}

- (void)userTapRateView:(UITapGestureRecognizer *)gesture {
    CGPoint tapPoint = [gesture locationInView:self];
    CGFloat offset = tapPoint.x;
    CGFloat realStarScore = offset / (self.bounds.size.width / self.numberOfStars);
    switch (_rateStyle) {
        case TTStarRateStyleWhole:
        {
            self.currentScore = ceilf(realStarScore);
            break;
        }
        case TTStarRateStyleHalf:
            self.currentScore = roundf(realStarScore)>realStarScore ? ceilf(realStarScore):(ceilf(realStarScore)-0.5);
            break;
        case TTStarRateStyleIncomplete:
            self.currentScore = realStarScore;
            break;
        default:
            break;
    }
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    __weak TTStarRateView *weakSelf = self;
    CGFloat animationTimeInterval = self.isAnimation ? 0.2 : 0;
    [UIView animateWithDuration:animationTimeInterval animations:^{
        weakSelf.foregroundStarView.frame = CGRectMake(0, 0, weakSelf.bounds.size.width * weakSelf.currentScore/self.numberOfStars, weakSelf.bounds.size.height);
    }];
}

- (void)setIsAnimation:(BOOL)isAnimation{
    if (_isAnimation == isAnimation) {
        return;
    }
    _isAnimation = isAnimation;
    [self setNeedsLayout];
}

-(void)setCurrentScore:(CGFloat)currentScore {
    if (_currentScore == currentScore) {
        return;
    }
    if (currentScore < 0) {
        _currentScore = 0;
    } else if (currentScore > _numberOfStars) {
        _currentScore = _numberOfStars;
    } else {
        _currentScore = currentScore;
    }
    
    if ([self.delegate respondsToSelector:@selector(starRateView:currentScore:)]) {
        [self.delegate starRateView:self currentScore:_currentScore];
    }
    
    if (self.complete) {
        _complete(_currentScore);
    }
    [self setNeedsLayout];
}

- (void)setScore:(CGFloat)score{
    if (_score == score) {
        return;
    }
    _score = score;
    if (score < 0) {
        _currentScore = 0;
    } else if (score > _numberOfStars) {
        _currentScore = _numberOfStars;
    } else {
        _currentScore = score;
    }
    [self setNeedsLayout];
}

@end
