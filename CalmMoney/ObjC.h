//
//  ObjC.h
//  CalmMoney
//
//  Created by Oleg Kubrakov on 4/1/2017.
//  Copyright © 2017 Oleg Kubrakov. All rights reserved.
//

#ifndef ObjC_h
#define ObjC_h


#endif /* ObjC_h */


#import <Foundation/Foundation.h>

@interface ObjC : NSObject

+ (BOOL)catchException:(void(^)())tryBlock error:(__autoreleasing NSError **)error;

@end
