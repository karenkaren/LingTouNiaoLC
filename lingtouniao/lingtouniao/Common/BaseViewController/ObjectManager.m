//
//  ObjectManager.m
//  lingtouniao
//
//  Created by peijingwu on 12/30/15.
//  Copyright © 2015 lingtouniao. All rights reserved.
//

#import "ObjectManager.h"
#import <MessageUI/MessageUI.h>

@interface ObjectManager () <MFMessageComposeViewControllerDelegate>

@property (nonatomic) UIViewController *vc;

@end

@implementation ObjectManager

+ (instancetype)sharedInstance {
    static ObjectManager *sharedObj;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedObj = [[ObjectManager alloc] init];
    });
    
    return sharedObj;
}

- (void)sendSMSMsg:(NSString *)body recipients:(NSArray *)recipients onVC:(UIViewController *)vc {

    if(![MFMessageComposeViewController canSendText]) {
        [Utility showMessage:locationString(@"no_send_message")];
        return;
    }
    
    self.vc = vc;
    
    MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
    messageController.messageComposeDelegate = self;
    messageController.body = body;
    messageController.recipients = recipients;
    
    // Present message view controller on screen
    [self.vc presentViewController:messageController animated:YES completion:nil];
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    switch (result) {
        case MessageComposeResultCancelled:
            break;
            
        case MessageComposeResultFailed:
        {
            [Utility showMessage:locationString(@"send_failure")];
            break;
        }
            
        case MessageComposeResultSent:
            break;
            
        default:
            break;
    }
    
    [self.vc dismissViewControllerAnimated:YES completion:nil];
}

@end
