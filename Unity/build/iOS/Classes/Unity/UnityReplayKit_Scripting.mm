#import <TargetConditionals.h> // Modified by PostBuild.cs
#if !TARGET_OS_SIMULATOR // Modified by PostBuild.cs
//==============================================================================
//
//  ReplayKit Unity Interface


#import "UnityReplayKit.h"

extern "C"
{
#if UNITY_REPLAY_KIT_AVAILABLE

    int UnityReplayKitAPIAvailable()
    {
        return [UnityReplayKit sharedInstance].apiAvailable ? 1 : 0;
    }

    int UnityReplayKitRecordingAvailable()
    {
        return [UnityReplayKit sharedInstance].recordingPreviewAvailable ? 1 : 0;
    }

    int UnityReplayKitIsCameraEnabled()
    {
        return [UnityReplayKit sharedInstance].cameraEnabled != NO ? 1 : 0;
    }

    int UnityReplayKitSetCameraEnabled(bool yes)
    {
        BOOL value = yes ? YES : NO;
        [UnityReplayKit sharedInstance].cameraEnabled = value;
        return [UnityReplayKit sharedInstance].cameraEnabled == value;
    }

    int UnityReplayKitIsMicrophoneEnabled()
    {
        return [UnityReplayKit sharedInstance].microphoneEnabled != NO ? 1 : 0;
    }

    int UnityReplayKitSetMicrophoneEnabled(bool yes)
    {
        printf_console("Apple removed possibility to change microphoneEnabled during recording.\n");
        return 0;
    }

    const char* UnityReplayKitLastError()
    {
        NSString* err = [UnityReplayKit sharedInstance].lastError;
        if (err == nil)
        {
            return NULL;
        }
        const char* error = [err cStringUsingEncoding: NSUTF8StringEncoding];
        if (error != NULL)
        {
            error = strdup(error);
        }
        return error;
    }

    int UnityReplayKitStartRecording(int enableMicrophone)
    {
        bool enableMic = enableMicrophone != 0;
        return [[UnityReplayKit sharedInstance] startRecording: enableMic] ? 1 : 0;
    }

    int UnityReplayKitIsRecording()
    {
        return [UnityReplayKit sharedInstance].isRecording ? 1 : 0;
    }

    int UnityReplayKitShowCameraPreviewAt(float x, float y)
    {
        float q = 1.0f / UnityScreenScaleFactor([UIScreen mainScreen]);
        float h = [[UIScreen mainScreen] bounds].size.height;
        return [[UnityReplayKit sharedInstance] showCameraPreviewAt: CGPointMake(x * q, h - y * q)] ? 1 : 0;
    }

    void UnityReplayKitHideCameraPreview()
    {
        [[UnityReplayKit sharedInstance] hideCameraPreview];
    }

    int UnityReplayKitStopRecording()
    {
#if !PLATFORM_TVOS
        UnityReplayKitHideCameraPreview();
        UnityReplayKitSetCameraEnabled(false);
#endif
        return [[UnityReplayKit sharedInstance] stopRecording] ? 1 : 0;
    }

    int UnityReplayKitDiscard()
    {
        return [[UnityReplayKit sharedInstance] discardPreview] ? 1 : 0;
    }

    int UnityReplayKitPreview()
    {
        return [[UnityReplayKit sharedInstance] showPreview] ? 1 : 0;
    }

    int UnityReplayKitBroadcastingAPIAvailable()
    {
        return [[UnityReplayKit sharedInstance] broadcastingApiAvailable] ? 1 : 0;
    }

    void UnityReplayKitStartBroadcasting(void* callback)
    {
        [[UnityReplayKit sharedInstance] startBroadcastingWithCallback: callback];
    }

    void UnityReplayKitStopBroadcasting()
    {
#if !PLATFORM_TVOS
        UnityReplayKitHideCameraPreview();
#endif
        [[UnityReplayKit sharedInstance] stopBroadcasting];
    }

    int UnityReplayKitIsBroadcasting()
    {
        return [[UnityReplayKit sharedInstance] isBroadcasting] ? 1 : 0;
    }

    const char* UnityReplayKitGetBroadcastURL()
    {
        NSURL *url = [[UnityReplayKit sharedInstance] broadcastURL];
        if (url != nil)
        {
            return [[url absoluteString] UTF8String];
        }
        return nullptr;
    }

    void UnityReplayKitCreateOverlayWindow()
    {
        [[UnityReplayKit sharedInstance] createOverlayWindow];
    }

    extern "C" float UnityScreenScaleFactor(UIScreen* screen);

#else

// Impl when ReplayKit is not available.

    int UnityReplayKitAPIAvailable()        { return 0; }
    int UnityReplayKitRecordingAvailable()  { return 0; }
    const char* UnityReplayKitLastError()   { return NULL; }
    int UnityReplayKitStartRecording(int enableMicrophone) { return 0; }
    int UnityReplayKitIsRecording()         { return 0; }
    int UnityReplayKitStopRecording()       { return 0; }
    int UnityReplayKitDiscard()             { return 0; }
    int UnityReplayKitPreview()             { return 0; }

    int UnityReplayKitIsCameraEnabled() { return 0; }
    int UnityReplayKitSetCameraEnabled(bool) { return 0; }
    int UnityReplayKitIsMicrophoneEnabled() { return 0; }
    int UnityReplayKitSetMicrophoneEnabled(bool) { return 0; }
    int UnityReplayKitShowCameraPreviewAt(float x, float y) { return 0; }
    void UnityReplayKitHideCameraPreview() {}
    void UnityReplayKitCreateOverlayWindow() {}

    void UnityReplayKitTriggerBroadcastStatusCallback(void*, bool, const char*);
    int UnityReplayKitBroadcastingAPIAvailable() { return 0; }
    void UnityReplayKitStartBroadcasting(void* callback) { UnityReplayKitTriggerBroadcastStatusCallback(callback, false, "ReplayKit not implemented."); }
    void UnityReplayKitStopBroadcasting() {}
    int UnityReplayKitIsBroadcasting() { return 0; }
    const char* UnityReplayKitGetBroadcastURL() { return nullptr; }

#endif  // UNITY_REPLAY_KIT_AVAILABLE
}  // extern "C"
#endif // Modified by PostBuild.cs
