//
//  UIActionSheet+Blocks.h
//
//  Created by Shai Mishali on 9/26/13.
//  Copyright (c) 2013 Shai Mishali. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface UIActionSheet (Blocks) <UIActionSheetDelegate>


+(UIActionSheet *)presentOnView: (UIView *)view
                      withTitle: (NSString *)title
                   otherButtons: (NSArray *)otherStrings
                       onCancel: (void (^)(UIActionSheet *))cancelBlock
                onClickedButton: (void (^)(UIActionSheet *, NSUInteger))clickBlock;


+(UIActionSheet *)presentOnView: (UIView *)view
                      withTitle: (NSString *)title
                   cancelButton: (NSString *)cancelString
              destructiveButton: (NSString *)destructiveString
                   otherButtons: (NSArray *)otherStrings
                       onCancel: (void (^)(UIActionSheet *))cancelBlock
                  onDestructive: (void (^)(UIActionSheet *))destroyBlock
                onClickedButton: (void (^)(UIActionSheet *, NSUInteger))clickBlock;
@end
