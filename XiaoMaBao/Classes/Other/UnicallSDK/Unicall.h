//
//  Unicall.h
//  UnicallSDK
//
//  Created by Wang Meng on 4/11/16.
//  Copyright © 2016 Unicall Ltd. of Beijing. All rights reserved.
//
#import <UIKit/UIKit.h>
@protocol UnicallDelegate <NSObject>
@required
- (UIViewController*) currentViewController;
@optional
- (void) messageArrived:(NSDictionary*) data;
- (void) messageCountUpdated:(NSNumber*) data;
//- (void) beforeClosingView:(NSDictionary*) data;
//- (void) afterClosingView:(NSDictionary*) data;
- (void) acquireValidation;
@end

@interface Unicall : NSObject
{
    id <UnicallDelegate> _delegate;
}
@property (nonatomic,strong) id delegate;

+(Unicall*)singleton;

-(void) attach:(id) parent appKey:(NSString*) theKey tenantId:(NSString*) theTenantId;
-(void) UnicallUpdateValidation:(NSDictionary*) data;
-(void) UnicallSendValidation;
-(void) UnicallUpdateUserInfo:(NSDictionary*) data;
-(void) UnicallShowView:(NSDictionary*)data;
-(void) UnicallHideView:(NSDictionary*)data;
@end
