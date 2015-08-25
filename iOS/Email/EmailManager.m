//
//  EmailManager.m
//  ParentApp
//
//  Created by Justin Makaila on 7/15/15.
//  Copyright (c) 2015 Facebook. All rights reserved.
//

#import "EmailManager.h"

#import <MessageUI/MessageUI.h>

@interface EmailManager () <MFMailComposeViewControllerDelegate>

@property (strong, nonatomic) RCTResponseSenderBlock completion;

@end

@implementation EmailManager

- (UIViewController *)rootViewController {
  return [[[[UIApplication sharedApplication] delegate] window] rootViewController];
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
  if (self.completion) {
    id errorObject = (error == nil) ? [NSNull null] : error;
    self.completion(@[errorObject, @(result)]);
  }
  
  self.completion = nil;
  
  [[self rootViewController] dismissViewControllerAnimated:YES completion:nil];
}

RCT_EXPORT_MODULE()

/**
 composeEmailToRecipients(recipients: Array<String>, ccRecipients: Array<String>, bccRecipients: Array<String>)
 */
RCT_EXPORT_METHOD(composeEmailToRecipients:(NSArray *)recipients ccRecipients:(NSArray *)ccRecipients bccRecipients:(NSArray *)bccRecipients completion:(RCTResponseSenderBlock)completion) {
  [self composeEmailTo:recipients ccRecipients:ccRecipients bccRecipients:bccRecipients subject:nil body:nil completion:completion];
}

/**
 composeEmailToRecipientsWithSubject(recipients: Array<String>, ccRecipients: Array<String>, bccRecipients: Array<String>, subject: String)
 */
RCT_REMAP_METHOD(composeEmailToRecipientsWithSubject, composeEmailToRecipients:(NSArray *)recipients ccRecipients:(NSArray *)ccRecipients bccRecipients:(NSArray *)bccRecipients subject:(NSString *)subject completion:(RCTResponseSenderBlock)completion) {
  [self composeEmailToRecipients:recipients ccRecipients:ccRecipients bccRecipients:bccRecipients subject:subject completion:completion];
}

/**
 composeEmailToRecipientsWithSubjectAndBody(recipients: Array<String>, ccRecipients: Array<String>, bccRecipients: Array<String>, subject: String, body: String)
 */
RCT_REMAP_METHOD(composeEmailToRecipientsWithSubjectAndBody, composeEmailTo:(NSArray *)recipients ccRecipients:(NSArray *)ccRecipients bccRecipients:(NSArray *)bccRecipients subject:(NSString *)subject body:(NSString *)body completion:(RCTResponseSenderBlock)completion) {
  if ([MFMailComposeViewController canSendMail]) {
    self.completion = completion;
    
    MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc] init];
    mailController.mailComposeDelegate = self;
    [mailController setToRecipients:recipients];
    [mailController setCcRecipients:ccRecipients];
    [mailController setBccRecipients:bccRecipients];
    [mailController setSubject:subject];
    [mailController setMessageBody:body isHTML:NO];
    
    [[self rootViewController] presentViewController:mailController animated:YES completion:nil];
  }
  else {
    if (completion) {
      completion(@[@"This device does not support sending email"]);
    }
  }

}

@end
