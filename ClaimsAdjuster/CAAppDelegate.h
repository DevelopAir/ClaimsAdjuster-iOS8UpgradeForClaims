// ----------------------------------------------------------------------
//
//  CAAppDelegate.h
//  ClaimsAdjuster
//
//  Created by Paul Duncanson.
//  Copyright (c) 2012 __Invigorate_Software__. All rights reserved.
//
// Rev. History:
//
// ----------------------------------------------------------------------

#import <UIKit/UIKit.h>

@interface CAAppDelegate : UIResponder <UIApplicationDelegate>
  
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSMutableArray *listArray;
@property (strong, nonatomic) UINavigationController *navigationController;

@end
