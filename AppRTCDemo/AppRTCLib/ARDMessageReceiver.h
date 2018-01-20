//
//  ARDMessageReceiver.h
//  AppRTCDemo
//
//  Created by Maksim Kita on 1/18/18.
//  Copyright © 2018 Maksim Kita. All rights reserved.
//

@protocol ARDDataMessageReceiverDelegate <NSObject>

- (void)didReceiverMessage:(ARDSignalingMessage *)message;

@end

