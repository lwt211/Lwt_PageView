//
//  Lwt_PageView.m
//  PageScrollViewDemo
//
//  Created by 李文韬 on 16/4/22.
//  Copyright © 2016年 秀软. All rights reserved.
//

#import "Lwt_PageView.h"



#define KWIDHT CGRectGetMaxX(self.frame)

#define KHEIGHT CGRectGetMaxY(self.frame)

#define IMGVIEW_TAG 100000

@interface Lwt_PageView ()<UIScrollViewDelegate>
{
    UIPageControl *_pageControl;
    BOOL _showsHorizontal;
    BOOL _repeat;
    NSMutableArray *_imageS;
    NSInteger _currentPage;
    UIScrollView *_scrollView;
    CurrentPageBlock _currentPageblock;
    ClickBlock _clickBlock;
    NSTimer *_timer;
    NSTimeInterval _animationDuration;
    
}

@end


@implementation Lwt_PageView

- (void)dealloc
{
    if (_timer)
    {
        [_timer invalidate];
        _timer = nil;
    }
    
    _scrollView.delegate = nil;
    _scrollView = nil;
    
}

- (instancetype)initWithFrame:(CGRect)frame withImages:(NSArray *)imageS repeat:(BOOL)repeat showHorizontal:(BOOL)showHorizontal
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        _imageS = [[NSMutableArray alloc] initWithArray:imageS];
        _showsHorizontal = showHorizontal;
        _repeat = repeat;
        [self setScrollView];
        
        //水平方向才有滚轮
        if (_showsHorizontal&&_imageS.count>1)
        {
            [self setPageControl];
        }
        
    }
    
    return self;
}

- (void)setScrollView
{
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KWIDHT,KHEIGHT)];
    _scrollView.delegate = self;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;
    [self addSubview:_scrollView];
    
    if (_repeat)
    {
        [self confinRepeatContent];
    }else
    {
        [self confinNotRepeatContent];
    }
    
}

- (void)setPageControl
{
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0,KHEIGHT-20,KWIDHT, 20)];
    _pageControl.numberOfPages = _imageS.count;
    _pageControl.currentPage = 0;
    [self addSubview:_pageControl];
}


- (void)confinRepeatContent
{
    if (_imageS.count == 0) return;

    UIImageView *firstImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,KWIDHT, KHEIGHT)];
    firstImageView.image = [_imageS lastObject];
    [_scrollView addSubview:firstImageView];
    
    UIImageView *lastImageView = [[UIImageView alloc] initWithFrame:CGRectMake(_showsHorizontal?(_imageS.count+1)*KWIDHT:0, _showsHorizontal?0:(_imageS.count+1)*KHEIGHT , KWIDHT, KHEIGHT)];
    lastImageView.image = [_imageS firstObject];
    [_scrollView addSubview:lastImageView];
    
    int i = 0;
    for (UIImage *image in _imageS)
    {
       
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.userInteractionEnabled = YES;
        imageView.frame = CGRectMake(_showsHorizontal?(i+1)*KWIDHT:0, _showsHorizontal?0:(i+1)*KHEIGHT, KWIDHT, KHEIGHT);
        imageView.tag = i+IMGVIEW_TAG;
        imageView.image = image;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickImage)];
        [imageView addGestureRecognizer:tap];
        [_scrollView addSubview:imageView];
        i++;

    }
    
    _scrollView.contentSize = CGSizeMake(_showsHorizontal?(_imageS.count+2)*KWIDHT:KWIDHT, _showsHorizontal?KHEIGHT:(_imageS.count+2)*KHEIGHT);
    _scrollView.contentOffset = CGPointMake(_showsHorizontal?KWIDHT:0,_showsHorizontal?0:KHEIGHT);
    
    
    
}

- (void)confinNotRepeatContent
{
    if (_imageS.count == 0)return;
    
    int i = 0;
    for (UIImage *image in _imageS)
    {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.userInteractionEnabled = YES;
        imageView.frame = CGRectMake(_showsHorizontal?i*KWIDHT:0, _showsHorizontal?0:i*KHEIGHT, KWIDHT, KHEIGHT);
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickImage)];
        [imageView addGestureRecognizer:tap];
        imageView.tag = i+IMGVIEW_TAG;
        [_scrollView addSubview:imageView];
        i++;
    }
    _scrollView.contentSize = CGSizeMake(_showsHorizontal?_imageS.count*KWIDHT:KWIDHT, _showsHorizontal?KHEIGHT:_imageS.count*KHEIGHT);
}

- (void)setCurrentPageColor:(UIColor *)currentPageColor
{
    _currentPageColor = currentPageColor;
    
    if (_pageControl)
    {
        _pageControl.currentPageIndicatorTintColor = _currentPageColor;
    }
    
}

- (void)setTintPageColor:(UIColor *)tintPageColor
{
   _tintPageColor = tintPageColor;
    
    if (_pageControl)
    {
        _pageControl.pageIndicatorTintColor = _tintPageColor;
    }
}

- (void)pageHidden:(BOOL)hidden
{
    if (_pageControl)
    {
        _pageControl.hidden = hidden;
    }
}



- (void)setPageContolFrame:(CGRect)frame
{
    if (_pageControl)
    {
        _pageControl.frame = frame;
    }
}



- (void)currentPageViewBlock:(CurrentPageBlock)currentPageblock
{
    if (currentPageblock)
    {
        _currentPageblock = currentPageblock;
    }
}

- (void)clickBlock:(ClickBlock)clickBlock
{
    if (clickBlock)
    {
        _clickBlock = clickBlock;
    }
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (_timer)
    {
        [self pauseTimer];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (_timer)
    {
        [self resumeTimerAfterTimeInterval];
    }
}



- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
 
    //这个函数会执行多次，这里做个判断
    int a = scrollView.contentOffset.x/KWIDHT;
    double b = scrollView.contentOffset.x/KWIDHT;
    if (b != a)return;
    
    //不循环滚动或者只有一页
    if (!_repeat||_imageS.count < 2)
    {
        _currentPage = _showsHorizontal?scrollView.contentOffset.x/KWIDHT:scrollView.contentOffset.y/KHEIGHT;
    }else
    {
        //水平方向
        if (_showsHorizontal)
        {
            if (scrollView.contentOffset.x/KWIDHT == 0)
            {
                [scrollView scrollRectToVisible:CGRectMake(_imageS.count*KWIDHT, 0, KWIDHT, KHEIGHT) animated:NO];
                
            }else if (scrollView.contentOffset.x/KWIDHT == _imageS.count+1)
            {
                [scrollView scrollRectToVisible:CGRectMake(KWIDHT, 0, KWIDHT, KHEIGHT) animated:NO];
            }
            _currentPage = scrollView.contentOffset.x/KWIDHT - 1;
        }else
        {
            //竖直方向
            if (scrollView.contentOffset.y/KHEIGHT == 0)
            {
                [scrollView scrollRectToVisible:CGRectMake(0, _imageS.count*KHEIGHT, KWIDHT, KHEIGHT) animated:NO];
                
            }else if (scrollView.contentOffset.y/KHEIGHT == _imageS.count+1)
            {
                [scrollView scrollRectToVisible:CGRectMake(0, KHEIGHT, KWIDHT, KHEIGHT) animated:NO];
            }
            _currentPage = scrollView.contentOffset.y/KHEIGHT-1;
        }
        
    }
    
  
    
    if (_pageControl)
    {
        _pageControl.currentPage = _currentPage;
    }
    
    if (_currentPageblock)
    {
        _currentPageblock([self currentImageView],_currentPage);
    }
  
 
}


#pragma park - clickImage

- (void)clickImage
{
    if (_clickBlock)
    {
        _clickBlock([self currentImageView],_currentPage);
    }
}



- (UIImageView *)currentImageView
{
    UIImageView *currenImageView = (UIImageView *)[_scrollView viewWithTag:_currentPage];
    
    return currenImageView;
}



#pragma mark - 定时器操作

- (void)startRepeatScroll:(NSTimeInterval)animationDuration
{
    if (animationDuration <=0||_repeat == NO)
    {
        return;
    }
        
    _animationDuration = animationDuration;
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:_animationDuration target:self selector:@selector(animationTimerDidFired) userInfo:nil repeats:YES];

    
//    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    

}

- (void)animationTimerDidFired
{
    [_scrollView setContentOffset:CGPointMake(_showsHorizontal?_scrollView.contentOffset.x+KWIDHT:_scrollView.contentOffset.x,_showsHorizontal?_scrollView.contentOffset.y:_scrollView.contentOffset.y+KHEIGHT) animated:YES];
    
}

//暂停
-(void)pauseTimer
{
    if (![_timer isValid]) {
        return ;
    }
    [_timer setFireDate:[NSDate distantFuture]];
}

//继续

- (void)resumeTimerAfterTimeInterval
{
    if (![_timer isValid]) {
        return ;
    }
    [_timer setFireDate:[NSDate dateWithTimeIntervalSinceNow:_animationDuration]];
}

//停止
- (void)stopRepeatScroll
{
    if (_timer == nil) return;
    
    [_timer invalidate];
    _timer = nil;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
