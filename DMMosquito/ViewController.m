//
//  ViewController.m
//  DMMosquito
//
//  Created by Master on 2014/06/16.
//  Copyright (c) 2014年 jp.co.mappy. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    //Slider
    slider.maximumValue = 20000.0f;
    slider.minimumValue = 0.0f;
    slider.value = 10000.0f;
    label.text = [NSString stringWithFormat:@"%.1f", slider.value];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)changeFrequency:(UISlider *)sender
{
    //周波数（音程）
    _frequency = sender.value;
    label.text = [NSString stringWithFormat:@"%.1f", _frequency];
}

-(IBAction)playSound{
    if (!aU) {
        //Sampling rate
        _sampleRate = 44100.0f;
        
        //Bit rate
        bitRate = 8;  // 8bit
        
        //AudioComponentDescription
        AudioComponentDescription aCD;
        aCD.componentType = kAudioUnitType_Output;
        aCD.componentSubType = kAudioUnitSubType_RemoteIO;
        aCD.componentManufacturer = kAudioUnitManufacturer_Apple;
        aCD.componentFlags = 0;
        aCD.componentFlagsMask = 0;
        
        //AudioComponent
        AudioComponent aC = AudioComponentFindNext(NULL, &aCD);
        AudioComponentInstanceNew(aC, &aU);
        AudioUnitInitialize(aU);
        
        //コールバック
        AURenderCallbackStruct callbackStruct;
        callbackStruct.inputProc = renderer;
        callbackStruct.inputProcRefCon = (__bridge void*)self;
        AudioUnitSetProperty(aU,
                             kAudioUnitProperty_SetRenderCallback,
                             kAudioUnitScope_Input,
                             0,
                             &callbackStruct,
                             sizeof(AURenderCallbackStruct));
        
        //AudioStreamBasicDescription
        AudioStreamBasicDescription aSBD;
        aSBD.mSampleRate = _sampleRate;
        aSBD.mFormatID = kAudioFormatLinearPCM;
        aSBD.mFormatFlags = kAudioFormatFlagsAudioUnitCanonical;
        aSBD.mChannelsPerFrame = 2;
        aSBD.mBytesPerPacket = sizeof(AudioUnitSampleType);
        aSBD.mBytesPerFrame = sizeof(AudioUnitSampleType);
        aSBD.mFramesPerPacket = 1;
        aSBD.mBitsPerChannel = bitRate * sizeof(AudioUnitSampleType);
        aSBD.mReserved = 0;
        
        //AudioUnit
        AudioUnitSetProperty(aU,
                             kAudioUnitProperty_StreamFormat,
                             kAudioUnitScope_Input,
                             0,
                             &aSBD,
                             sizeof(aSBD));
        
        //再生
        AudioOutputUnitStart(aU);
    }
}

static OSStatus renderer(void *inRef,
                         AudioUnitRenderActionFlags *ioActionFlags,
                         const AudioTimeStamp* inTimeStamp,
                         UInt32 inBusNumber,
                         UInt32 inNumberFrames,
                         AudioBufferList *ioData) {
    
    //キャスト
    ViewController *def = (__bridge ViewController*)inRef;
    
    //サイン波
    float freq = def.frequency*2.0*M_PI/def.sampleRate;
    
    //値を書き込むポインタ
    AudioUnitSampleType *outL = ioData->mBuffers[0].mData;
    AudioUnitSampleType *outR = ioData->mBuffers[1].mData;
    
    for (int i = 0; i < inNumberFrames; i++) {
        // 周波数を計算
        float wave = sin(def.phase);
        AudioUnitSampleType sample = wave * (1 << kAudioUnitSampleFractionBits);
        *outL++ = sample;
        *outR++ = sample;
        def.phase += freq;
    }
    
    return noErr;
};

- (IBAction)stopSound
{
    AudioOutputUnitStop(aU);
    aU = nil;
}

- (void)hoge
{
    //hogehoge
}

@end
