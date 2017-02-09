//
//  EXRecorderController.h
//  Excellent
//
//  Created by lijia on 09/02/2017.
//  Copyright © 2017 Li Jia. All rights reserved.
//

#import <Foundation/Foundation.h>
@class THMemo;

@interface EXRecorderController : NSObject
-(BOOL)record;
-(BOOL)pause;
-(BOOL)playbackMemo:(THMemo*)memo;
@end
