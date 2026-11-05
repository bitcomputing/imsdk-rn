
import React from 'react';
import {
    requireNativeComponent,
    ViewProps,
    Platform,
    View
} from 'react-native';


export interface SurfaceViewProps extends ViewProps {
    zOrderMediaOverlay?: boolean;
    zOrderOnTop?: boolean;
}

const ZegoSurfaceViewManager = Platform.OS === 'ios'
    ? requireNativeComponent<SurfaceViewProps>('ZegoSurfaceView')
    : requireNativeComponent<SurfaceViewProps>('RCTZegoSurfaceView'); // * android.view.SurfaceView


export const ZegoSurfaceView = React.forwardRef<React.ComponentRef<typeof ZegoSurfaceViewManager>, SurfaceViewProps>((props, ref) => {
    return <ZegoSurfaceViewManager {...props} ref={ref} />;
});
