//
//  ObjC.m
//  CalmMoney
//
//  Created by Oleg Kubrakov on 4/1/2017.
//  Copyright © 2017 Oleg Kubrakov. All rights reserved.
//

#import "ObjC.h"

@implementation ObjC

+ (BOOL)catchException:(void(^)())tryBlock error:(__autoreleasing NSError **)error {
	@try {
		tryBlock();
		return YES;
	}
	@catch (NSException *exception) {
		*error = [[NSError alloc] initWithDomain:exception.name code:0 userInfo:exception.userInfo];
	}
}

@end
