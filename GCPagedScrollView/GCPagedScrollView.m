//
//  GCPagedScrollView.m
//  GCLibrary
//
//  Created by Guillaume Campagna on 10-11-10.
//  Copyright (c) 2010 LittleKiwi. All rights reserved.
//

#import "GCPagedScrollView.h"
#import <QuartzCore/CATransaction.h>

NSString * const GCPagedScrollViewContentOffsetKey = @"contentOffset";
const CGFloat GCPagedScrollViewPageControlHeight = 36.0;

@interface GCPagedScrollView ()

@property (nonatomic, readonly) NSMutableArray* views;
@property (nonatomic, readonly) UIPageControl* pageControl;

- (void) updateViewPositionAndPageControl;

- (void) changePage:(UIPageControl*) aPageControl;

@end

@implementation GCPagedScrollView

@synthesize views;
@synthesize pageControl;

#pragma mark -
#pragma mark Subclass

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        self.pagingEnabled = YES;
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.scrollsToTop = NO;
        
        //Place page control
        CGRect frame = CGRectMake(self.contentOffset.x, 0, self.frame.size.width, GCPagedScrollViewPageControlHeight);
        UIPageControl* aPageControl = [[UIPageControl alloc] initWithFrame:frame];
        [aPageControl addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
        aPageControl.defersCurrentPageDisplay = YES;
        aPageControl.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin);
        [self addSubview:aPageControl];
        pageControl = aPageControl;  
    }
    return self;
}

- (void) setPagingEnabled:(BOOL) pagingEnabled {
    if (pagingEnabled) [super setPagingEnabled:pagingEnabled];
    else {
        [NSException raise:@"Disabling pagingEnabled" format:@"Paging enabled should not be disabled in GCPagedScrollView"];
    }
}

#pragma mark -
#pragma mark Add/Remove content

- (void) addContentSubview:(UIView *)view {
    [self addContentSubview:view atIndex:[self.views count]];
}

- (void) addContentSubview:(UIView *)view atIndex:(NSUInteger)index {
    [self insertSubview:view atIndex:index];
    [self.views insertObject:view atIndex:index];
    [self updateViewPositionAndPageControl];
    self.contentOffset = CGPointMake(0, - self.scrollIndicatorInsets.top);
}

- (void)addContentSubviewsFromArray:(NSArray *)contentViews {
    for (UIView* contentView in contentViews) {
        [self addContentSubview:contentView];
    }
}

- (void) removeContentSubview:(UIView *)view {
    [view removeFromSuperview];
    
    [self.views removeObject:view];
    [self updateViewPositionAndPageControl];
}

- (void)removeContentSubviewAtIndex:(NSUInteger)index {
    [self removeContentSubview:[self.views objectAtIndex:index]];
}

- (void) removeAllContentSubviews {
    for (UIView* view in self.views) {
        [view removeFromSuperview];
    }
    
    [self.views removeAllObjects];
    [self updateViewPositionAndPageControl];
}

#pragma mark -
#pragma mark Layout

- (void) updateViewPositionAndPageControl {
    [self.views enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIView* view = (UIView*) obj;
        view.center = CGPointMake(self.frame.size.width * idx + self.frame.size.width / 2, 
                                  (self.frame.size.height - GCPagedScrollViewPageControlHeight) / 2);
    }];
    
    UIEdgeInsets inset = self.scrollIndicatorInsets;
    CGFloat heightInset = inset.top + inset.bottom;
    self.contentSize = CGSizeMake(self.frame.size.width * [self.views count], self.frame.size.height - heightInset);
    
    self.pageControl.numberOfPages = self.views.count;
}

- (void) layoutSubviews {
    [super layoutSubviews];
    
    //Avoid that the pageControl move
    [CATransaction begin];
    [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
    
    CGRect frame = self.pageControl.frame;
    frame.origin.x = self.contentOffset.x;
    frame.origin.y = self.frame.size.height - GCPagedScrollViewPageControlHeight - self.scrollIndicatorInsets.bottom - self.scrollIndicatorInsets.top;
    frame.size.width = self.frame.size.width;
    self.pageControl.frame = frame;
    
    [CATransaction commit];
}

#pragma mark -
#pragma mark Getters/Setters

- (void) setFrame:(CGRect) newFrame {
    [super setFrame:newFrame];
    [self updateViewPositionAndPageControl];
}

- (void) changePage:(UIPageControl*) aPageControl {
    [self setPage:aPageControl.currentPage animated:YES];
}

- (void) setContentOffset:(CGPoint) new {
    new.y = -self.scrollIndicatorInsets.top;
    [super setContentOffset:new];
    
    self.pageControl.currentPage = self.page; //Update the page number
}

- (NSMutableArray*) views {
    if (views == nil) {
        views = [[NSMutableArray alloc] initWithCapacity:1];
    }
    return views;
}

- (NSUInteger) page {
    return (self.contentOffset.x + self.frame.size.width / 2) / self.frame.size.width;
}

- (void) setPage:(NSUInteger)page {
    [self setPage:page animated:NO];
}

- (void) setPage:(NSUInteger)page animated:(BOOL) animated {
    [self setContentOffset:CGPointMake(page * self.frame.size.width, - self.scrollIndicatorInsets.top) animated:animated];
}

#pragma mark -
#pragma mark Dealloc

- (void)dealloc {    
    [views release];
    [pageControl release];
    
    [super dealloc];
}


@end
