import React, {Component,useState,useEffect}  from 'react'
import { View } from 'react-native'


class TestView extends Component {
    constructor(props) {
        super(props);
        this.state = {};
    }

    componentWillMount() {

    }

    componentDidMount() {

    }

    render() {
        return (
            <View style={{backgroundColor:'red',height:60,width:60}}/>
        )
    }

    componentWillReceiveProps() {
        
    }

    shouldComponentUpdate() {
        return true;
    }

    componentWillUpdate() {

    }

    componentDidUpdate() {

    }

    
}

export default TestView;