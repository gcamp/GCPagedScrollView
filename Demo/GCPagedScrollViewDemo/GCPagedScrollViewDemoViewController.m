//
//  GCPagedScrollViewDemoViewController.m
//  GCPagedScrollViewDemo
//
//  Created by Guillaume Campagna on 11-04-30.
//  Copyright 2011 LittleKiwi. All rights reserved.
//

#import "GCPagedScrollViewDemoViewController.h"
#import "GCPagedScrollView.h"

@interface GCPagedScrollViewDemoViewController ()

@property (nonatomic, readonly) GCPagedScrollView* scrollView;

- (UIView*) createViewAtIndex:(NSUInteger) index;

@end

@implementation GCPagedScrollViewDemoViewController

#pragma mark - View lifecycle

- (void)loadView {
    [super loadView];
    
    GCPagedScrollView* scrollView = [[GCPagedScrollView alloc] initWithFrame:self.view.frame];
    scrollView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    self.view = scrollView;
    [scrollView release];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.scrollView.backgroundColor = [UIColor blackColor];
    
    for (NSUInteger index = 0; index < 5; index ++) {
        //You add your content views here
        [self.scrollView addContentSubview:[self createViewAtIndex:index]];
    }
}

#pragma mark -
#pragma mark Getters

- (GCPagedScrollView *)scrollView {
    return (GCPagedScrollView*) self.view;
}

#pragma mark -
#pragma mark Helper methods

- (UIView *)createViewAtIndex:(NSUInteger)index {
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width - 20, 
                                                            self.view.frame.size.height - 50)];
    view.backgroundColor = [UIColor whiteColor];
    UILabel* numberLabel = [[UILabel alloc] initWithFrame:view.bounds];
    numberLabel.text = [NSString stringWithFormat:@"%d", index];
    numberLabel.textAlignment = UITextAlignmentCenter;
    numberLabel.font = [UIFont boldSystemFontOfSize:50.0];
    [view addSubview:numberLabel];
    [numberLabel release];
    
    return [view autorelease];
}

@end
