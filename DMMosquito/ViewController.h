//
//  ViewController.h
//  DMMosquito
//
//  Created by Master on 2014/06/16.
//  Copyright (c) 2014年 jp.co.mappy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>

static OSStatus renderer(void *inRef,
                         AudioUnitRenderActionFlags *ioActionFlags,
                         const AudioTimeStamp* inTimeStamp,
                         UInt32 inBusNumber,
                         UInt32 inNumberFrames,
                         AudioBufferList *ioData);


@interface ViewController : UIViewController
{
    AudioUnit aU;
    UInt32 bitRate;
    
    IBOutlet UILabel *label;
    IBOutlet UISlider *slider;
}

@property (nonatomic) double phase;
@property (nonatomic) Float64 sampleRate;
@property (nonatomic) Float64 frequency;


- (IBAction)playSound;
- (IBAction)stopSound;

@end


//==========================
//①AudioToolboxを追加
//②OSStatus変数を定義(OS版NSErrorみたいなもの)
//③OSStatusから状態コールバックしてあとは音を鳴らす。
//==========================

