## 微信环境h5页面登录实现流程
#### 一、unionid和openId

在了解微信环境登录流程之前，先讲俩个概念：unionid和openId。

unionid表示某一个用户在某一个公司或者商家下的用户id(某公司或商家的身份证）；

openid表示某一个用户在某一个公司或者商家下的某一个应用或者公众平台下的用户id(某一个应用或者公众平台的身份证）

所以，某一个公司或者商家下会有多个应用或者公众平台，那么就通过unionid来关联某一个用户在不同应用或者不同平台的关系。

#### 二、静默授权和非静默授权

我们在平时开发中，总会听到产品要求是静默授权和非静默授权。那么二者之前有什么区别呢？

静默授权的意思是用户无感知的获取用户信息，不需要用户有任何的操作动作，注意静默授权只能获取到用户的openId。并不能获取到用户的其他信息。

非静默授权的意思是需要用户去操作，点击同意按钮，也就是说，如果产品要求是非静默授权，那么前端会弹起用户授权的按钮，待用户同意之后，就可以获取到用户的openId,个人信息，关注信息等相关内容。

注：静默授权和非静默授权的区别在于调用的接口的scope字段是snsapi_base还是snsapi_userinfo

#### 三、登录流程

明白了unionid和openid、静默授权和非静默授权，我们也是时候该看看登录的流程了。
<img src="/Users/tangh/yuki/ios_project/YLNote/YLNote/LocalFiles/markdown/images/WeChatAuthon.png" alt="img" style="zoom:67%;" />


从上图中我们可以看到，过程并不复杂：

* 首先，前端会访问微信的授权地址：

```html
https://open.weixin.qq.com/connect/oauth2/authorize？appid=$appid&redirect_uri=$redirect_uri&response_type=code&scope=snsapi_base&state=1#wechat_redirect
```

> 其中：
>
> appid：是应用的appid
> redirect_uri：是指回跳的url
> response_type：只写code
> scope：表示授权的作用域，多个可以用逗号隔开，snsapi_base表示静默授权，snsapi_userinfo表示非静默授权
> state:用于保持请求和回调的状态，授权请求后原样带回给第三方。该参数可用于防止csrf攻击（跨站请求伪造攻击），建议第三方带上该参数，可设置为简单的随机数加session进行校验

* 第二步：这样我们在跳转回来的url就可以截取到回传的参数code，这时我们就可以用这个code去获取access_token和openid

```html
// 请求url(Get)
https://api.weixin.qq.com/sns/oauth2/access_token?appid=APPID&secret=SECRET&code=CODE&grant_type=authorization_code	
```

> 其中：
>
> appid：应用的appid,
> secret: 应用密钥AppSecret,
> code：上一步中获取到的code
> grant_type：值为authorization_code
> 这样返回值中，我们可以拿到access_token和openid等信息。返回的数据如下：
>
> 名称    类型    说明
> access_token    String    access_token
> expires_in    int    access_token有效时间
> refresh_token    String    refresh_token
> openid    String    open_id
> scope    String    授权作用域

* 第三步：我们有了access_token和openid就可以去获取用户信息了。

  ```html
  // 请求url(Get)
  https://api.weixin.qq.com/sns/userinfo?access_token=ACCESS_TOKEN&openid=OPENID&lang=zh_CN
  ```

  >  其中：
  >
  > access_token：上一步的access_token
  > openid:上一步的openid
  > 返回值包括有用户手机号等：
  >
  > 名称    类型    说明
  > openid    String    open_id
  > unionid    String    union_id
  > nickname    String    用户昵称
  > sex    int    性别
  > province    String    省
  > city    String    城市
  > country    String    国家
  > headimgurl    String    用户头像
  > privilege    Array    用户权限



**到此登录主流程走完。为什么说是主流程呢？因为登录的方式不同，但是主要是这样的，比如说pc端的扫码登录也是这样，不过是要把所扫的二维码的地址配置成获取code链接。**
