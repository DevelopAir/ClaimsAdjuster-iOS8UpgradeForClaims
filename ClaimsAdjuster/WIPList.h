// ----------------------------------------------------------------------
//
//  WIPList.h
//  ClaimsAdjuster
//
//  Created by Paul Duncanson.
//  Copyright (c) 2012__Invigorate_Software_For_Topa_Insurance__. All rights reserved.
//
// Rev. History:
//
// ----------------------------------------------------------------------

#import <Foundation/Foundation.h>

@interface WIPList : NSObject

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *cause;
@property (nonatomic, retain) NSString *dol;
@property (nonatomic, retain) NSString *policy;
@property (nonatomic, retain) NSString *premCodes;
@property (nonatomic, retain) NSString *notes;
@property (nonatomic, retain) NSString *toAddress;
@property (nonatomic, retain) NSString *toName;
@property (nonatomic, retain) NSString *imageNames;

@property (nonatomic, readwrite) NSInteger listID;

@end
