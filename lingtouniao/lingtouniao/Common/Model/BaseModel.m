//
//  LTNModel.m
//  lingtouniao
//
//  Created by  mathe on 15/12/17.
//  Copyright © 2015年 lingtouniao. All rights reserved.
//

#import "BaseModel.h"

@implementation BaseModel

MJExtensionLogAllProperties
MJExtensionCodingImplementation

-(id)init
{
    if(self=[super init])
    {
        [BaseModel mj_referenceReplacedKeyWhenCreatingKeyValues:YES];
    }
    return self;
}


- (id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property
{
    if (oldValue == nil &&property.type.typeClass == [NSString class]) return @"";
    else if (property.type.typeClass == [NSDate class])
    {
        
        
//         NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
//         fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
//         return [fmt dateFromString:oldValue];
        
    }
    
    /*
     if ([property.name isEqualToString:@"publisher"]) {
     if (oldValue == nil) return @"";
     } else if (property.type.typeClass == [NSDate class]) {
     NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
     fmt.dateFormat = @"yyyy-MM-dd";
     return [fmt dateFromString:oldValue];
     }
     */
    
    return oldValue;
}

- (id)valueForUndefinedKey:(NSString *)key {
    
    //for load more keyword
    if ([key isEqualToString:@"totalCount"]) {
        return @0;
    }
    
    return nil;
}

@end
