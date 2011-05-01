//
//  GCPagedScrollViewDemoAppDelegate.h
//  GCPagedScrollViewDemo
//
//  Created by Guillaume Campagna on 11-04-30.
//  Copyright 2011 LittleKiwi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GCPagedScrollViewDemoViewController;

@interface GCPagedScrollViewDemoAppDelegate : NSObject <UIApplicationDelegate> 

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet GCPagedScrollViewDemoViewController *viewController;

@end
