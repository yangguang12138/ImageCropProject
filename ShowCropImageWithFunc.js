import React,{useState,useEffect} from 'react';
import { View,Image,StyleSheet,Dimensions,Text,NativeModules} from 'react-native';

const resolveAssetSource = require('react-native/Libraries/Image/resolveAssetSource');
const {width,height} = Dimensions.get('screen');
const imageHeight = (height - 180)/3.0;

const styles = StyleSheet.create({
    container: {
        alignItems:'center',
      },
      imageStyle:{
          width:imageHeight,
          height:imageHeight,
          alignItems:'center'
      },
      maskStyle:{
          width:imageHeight,
          height:imageHeight,
          marginTop:10,
      }
});

const ShowCropImageWithFunc = ()=> {
    const [imageUrl,setImageUrl] = useState('');
    const origin = require("./assets/origin.png")
    let originImage = resolveAssetSource(origin);
    const mask = require("./assets/mask.jpeg");
    let maskImage = resolveAssetSource(mask);

    useEffect(()=>{
        NativeModules.JSToNativeBridgeModule.drawImageWithOriginPath( originImage.uri, maskImage.uri,(msg)=>{
            setImageUrl(msg.path);
            }
        )
    })
  
    return(
        <View style={styles.container}>
            <Image style={styles.imageStyle} source={origin}/>
            <Image style={styles.maskStyle} source={mask}/>
            <Image style={styles.maskStyle} source={{uri:imageUrl}}/>
        </View>
    )
}

export default ShowCropImageWithFunc;