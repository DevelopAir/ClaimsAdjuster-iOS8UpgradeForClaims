// ----------------------------------------------------------------------
//
//  WIPList.m
//  ClaimsAdjuster
//
//  Created by Paul Duncanson.
//  Copyright (c) 2012__Invigorate_Software_For_Topa_Insurance__. All rights reserved.
//
// Rev. History:
//
// ----------------------------------------------------------------------

#import "WIPList.h"

@implementation WIPList

@synthesize name, cause, dol, policy, listID, premCodes, notes, toAddress, toName, imageNames;

-(id) : (NSString *)
        edtName : (NSString *)
        edtCause : (NSString *) 
        edtDol : (NSString *)
        edtPolicy : (NSString *) 
        edtPremCodes : (NSString *)
        edtNotes : (NSString *)
        edtToAddress : (NSString *)
        edtToName : (NSString *)
        edtImageNames
{
    
    self = [super init];
    if (self) {
        self.name = edtName;        
        self.cause = edtCause;
        self.dol = edtDol;
        self.policy = edtPolicy;
        self.premCodes = edtPremCodes;
        self.notes = edtNotes;
        self.toAddress = edtToAddress;
        self.toName = edtToName;
        self.imageNames = edtImageNames;
    }
    return self;
}

@end
