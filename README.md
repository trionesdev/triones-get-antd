# Antd Flutter 组件库的 Getx扩展
> 像使用MaterialApp一样在Getx中使用AntApp

## 使用方法
像使用MaterialApp一样在Getx中使用AntApp即可，将MaterialApp替换为GetAntApp，
ThemeData换成AntThemeData。

示例代码如下：
```dart
  runApp(GetAntApp(
    title: 'XXX',
    theme: AntThemeData(),
    getPages: Routes.routes,
    home: const HomeLayout(),
    onInit: ()  async {

    },
    onReady: () {},
  ));
```

#### 互相吹捧，共同进步
> 留意回复不及时，可以通过关注公众号联系我们
<div style="width: 100%;text-align: center;">
   <img src="images/shuque_wx.jpg" width="200px" alt="">
</div>
