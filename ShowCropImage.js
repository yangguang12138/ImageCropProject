import React,{PureComponent,useState}  from 'react';
import { Text,Image, View,StyleSheet, NativeModules,Dimensions} from 'react-native';

const resolveAssetSource = require('react-native/Libraries/Image/resolveAssetSource');
const {width,height} = Dimensions.get('screen');
const imageHeight = (height - 180)/3.0;

class ShowCropImage extends PureComponent {

    constructor(props) {
        super(props);
        this.state={
            imageUrl:'',
        }
    }

    componentDidMount() {
        const origin = require("./assets/origin.png")
        let originImage = resolveAssetSource(origin);
        const mask = require("./assets/mask.jpeg");
        let maskImage = resolveAssetSource(mask);
        NativeModules.JSToNativeBridgeModule.drawImageWithOriginPath( originImage.uri, maskImage.uri,(msg)=>{
                this.setState({
                   imageUrl:msg.path,
                }
                );
            }
        )
    }

    render () {
        const imageUrl = this.state.imageUrl;
        return(
            <View style={styles.container}>
                <Image style={styles.imageStyle} source={require("./assets/origin.png")}/>
                <Image style={styles.maskStyle} source={require("./assets/mask.jpeg")}/>
                <Image style={styles.maskStyle} source={{uri:imageUrl}}/>
            </View>
        )
    }
}

const styles = StyleSheet.create({
    container: {
      alignItems:'center'
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

export default ShowCropImage;