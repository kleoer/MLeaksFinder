/**
 * Tencent is pleased to support the open source community by making MLeaksFinder available.
 *
 * Copyright (C) 2017 THL A29 Limited, a Tencent company. All rights reserved.
 *
 * Licensed under the BSD 3-Clause License (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at
 *
 * https://opensource.org/licenses/BSD-3-Clause
 *
 * Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
 */

#import "MLeaksMessenger.h"

static __weak UIAlertController *alertController;

@implementation MLeaksMessenger

+ (void)alertWithTitle:(NSString *)title message:(NSString *)message {
    [self alertWithTitle:title message:message additionalButtonTitle:nil handler:nil];
}

+ (void)alertWithTitle:(NSString *)title message:(NSString *)message additionalButtonTitle:(NSString *)additionalButtonTitle handler:(void (^)(NSInteger buttonIndex))handler {
    
    [alertController dismissViewControllerAnimated:YES completion:nil];
    
    alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        !handler ?: handler(0);
    }];
    [alertController addAction:cancelAction];
    
    if (additionalButtonTitle.length > 0) {
        UIAlertAction *otherAcntion = [UIAlertAction actionWithTitle:additionalButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            !handler ?: handler(1);
        }];
        [alertController addAction:otherAcntion];
    }
    
    [[self rootViewController] presentViewController:alertController animated:YES completion:nil];
    
    NSLog(@"%@: %@", title, message);
}

+ (UIViewController *)rootViewController {
    if (@available(iOS 13, *)) {
        __block UIWindow *keyWindow = nil;
        [[UIApplication sharedApplication].connectedScenes enumerateObjectsUsingBlock:^(UIScene * _Nonnull obj, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[UIWindowScene class]]) {
                UIWindowScene *windowScene = (UIWindowScene *)obj;
                [windowScene.windows enumerateObjectsUsingBlock:^(UIWindow * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if (obj.isKeyWindow) {
                        keyWindow = obj;
                        *stop = YES;
                    }
                }];
                if (keyWindow) {
                    *stop = YES;
                }
            }
        }];
        return keyWindow.rootViewController;
    } else {
        return [UIApplication sharedApplication].keyWindow.rootViewController;
    }
}

@end
