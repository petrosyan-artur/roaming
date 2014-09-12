//
//  ErrorObject.h
//  Rouming
//
//  Created by Karen Ghandilyan on 9/11/14.
//  Copyright (c) 2014 telasco. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ResponseObject;

@interface ErrorObject : NSError
-(id)initWithResponseObjec:(ResponseObject *)response;
@end
