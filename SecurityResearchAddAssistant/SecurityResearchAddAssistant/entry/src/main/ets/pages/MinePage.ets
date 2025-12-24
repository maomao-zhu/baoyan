@Entry
@Component
export struct MinePage {

  build() {
    Column() {
      //头像
      Row(){
        Row(){
          //头像
          Image($r('app.media.HacKer'))
            .width(60)
            .height(60)
            .borderRadius(30)


          //名字
          Column({space:8}){
            Text('虾大XXX')
              .fontWeight(700)
              .fontSize(14)

            // Image($r('app.media.xz777'))
            //   .width(50)
            //   .borderRadius(10)
            Text('学号：22920246666666')
              .fontSize(10)
              .fontColor('#6B7280')
          }
          .padding(10)
          .alignItems(HorizontalAlign.Start)
          .justifyContent(FlexAlign.Start)
          // .backgroundColor('#ffeddf')
          .height('100%')
          .width(150)


          Row()
            .width(50)

          Row(){
            // Text('个人信息')
            //   .fontSize(9)
            //   .fontColor('#ff5a5656')
            Image($r('app.media.shez'))
              .width(15)
            // Image($r('app.media.sahndian777'))
            //   .width(10)
            //   .offset({
            //     x:-2,
            //     y:-24
            //   })
          }
          .justifyContent(FlexAlign.Center)
          .height('100%')
          .width(100)

          // Image($r('app.media.sahndian777'))
          //   .width(10)
        }
        // .borderRadius(10)
        .backgroundColor('#f1f1f1')
        .height('85%')
        // .border({width:1,color:'#f1cd11'})
        .width('100%')


      }
      .padding(10)
      .height(90)
      .width('100%')

      Column(){
        Column(){
            Row(){
              Row({space:5}){
                Image($r('app.media.shenqingjindu'))
                  .width(13)
                Text('申请进度')
                  .fontWeight(700)
                  .fontSize(15)
              }

              Row({space:5}){
                Text('查看详情')
                  .fontSize(12)
                  .fontColor('#767676')
                Image($r('app.media.jinru'))
                  .width(15)
              }

            }
            .justifyContent(FlexAlign.SpaceBetween)
            .width('100%')

          Row(){
            Column(){

              Row()
                .width(14)
                .height(14)
                .borderRadius(7)
                .backgroundColor('#767676')
                .offset({
                  y:-90
                })

              Row()
                .width(14)
                .height(14)
                .borderRadius(7)
                .backgroundColor('#767676')
                .offset({
                  y:-10
                })
              Row()
                .width(14)
                .height(14)
                .borderRadius(7)
                .backgroundColor('#D1D5DB')
                .offset({
                  y:60
                })

                // .zIndex(0)
            }
            .justifyContent(FlexAlign
              .Center)
            .alignItems(
              HorizontalAlign.Center
            )
            // .backgroundColor(Color.Blue)
            .height('100%')
            .width(50)

            Row()
              .width(3)
              .height(250)
              .backgroundColor('#f3f4f6')
              .offset({
                x:-26
              })



            Column(){
              //1
              Column({space:8}){
                Row({space:15}){
                  Text('材料提交完成')
                    .fontSize(13)
                    .fontWeight(700)
                  Text('已完成')
                    .fontSize(11)
                    .fontColor('#767676')
                }
                .justifyContent(FlexAlign.Start)
                .width('100%')

                Row(){
                  Text('2025-12-15 14：30')
                    .fontSize(10)
                    .fontColor('#6B7280')
                }
                .justifyContent(FlexAlign.Start)
                .width('100%')

                Row(){
                  Text('已成功提交所有申请材料，等待审核')
                    .fontSize(10)
                    .fontColor('#6B7280')
                }
                .justifyContent(FlexAlign.Start)
                .width('100%')
              }
              // .backgroundColor(Color.Pink)
              .height(70)
              .width(200)
              .margin({
                bottom:5
              })

              //2
              Column({space:8}){
                Row({space:15}){
                  Text('面试进行中')
                    .fontSize(13)
                    .fontWeight(700)
                  Text('进行中')
                    .fontSize(11)
                    .fontColor('#767676')
                }
                .justifyContent(FlexAlign.Start)
                .width('100%')

                Row(){
                  Text('2025-12-20 09：00')
                    .fontSize(10)
                    .fontColor('#6B7280')
                }
                .justifyContent(FlexAlign.Start)
                .width('100%')

                Row(){
                  Text('面试地点：计算机学院A312')
                    .fontSize(10)
                    .fontColor('#6B7280')
                }
                .justifyContent(FlexAlign.Start)
                .width('100%')
                Row(){
                  Text('面试时长：约30分钟')
                    .fontSize(10)
                    .fontColor('#6B7280')
                }
                .justifyContent(FlexAlign.Start)
                .width('100%')
              }
              // .backgroundColor(Color.Pink)
              .height(90)
              .width(200)
              .margin({
                bottom:10
              })

              //3
              Column({space:8}){
                Row({space:15}){
                  Text('等待录取结果')
                    .fontSize(13)
                    .fontWeight(700)
                  Text('待完成')
                    .fontSize(11)
                    .fontColor('#767676')
                }
                .justifyContent(FlexAlign.Start)
                .width('100%')

                Row(){
                  Text('2026-01-10')
                    .fontSize(10)
                    .fontColor('#6B7280')
                }
                .justifyContent(FlexAlign.Start)
                .width('100%')

                Row(){
                  Text('请耐心等待结果公布')
                    .fontSize(10)
                    .fontColor('#6B7280')
                }
                .justifyContent(FlexAlign.Start)
                .width('100%')
              }
              // .backgroundColor(Color.Pink)
              .height(70)
              .width(200)
            }
            .padding({top:10})
            // .backgroundColor(Color.Orange)
            .height(250)
            .width(250)
          }
          // .backgroundColor(Color.Pink)
          .height('90%')
          .width('100%')
        }
        .padding({left:10,right:10,top:15})
        .borderRadius(15)
        .backgroundColor(Color.White)
        .height(300)
        .width('100%')
      }
      .padding({left:10,right:10})
      .width('100%')
      .margin({bottom:10})



      Column(){
        Column(){
          Row(){
            Row({space:7}){
              Row(){
                Image($r('app.media.tongzhi'))
                  .width(15)
              }
              .justifyContent(FlexAlign.Center)
              .height(26)
              .backgroundColor('#f3f4f6')
              .borderRadius(13)
              .width(26)

              Text('通知设置')
                .fontSize(13)
                .fontColor('#1F2937')
            }

            Image($r('app.media.jinru'))
              .width(15)
          }
          .height(45)
          .border({width:{bottom:1},color:'#ccc'})
          .justifyContent(FlexAlign.SpaceBetween)
          .width('100%')

          //隐私设置
          Row(){
            Row({space:7}){
              Row(){
                Image($r('app.media.yingshi'))
                  .width(15)
              }
              .justifyContent(FlexAlign.Center)
              .height(26)
              .backgroundColor('#f3f4f6')
              .borderRadius(13)
              .width(26)

              Text('隐私设置')
                .fontSize(13)
                .fontColor('#1F2937')
            }

            Image($r('app.media.jinru'))
              .width(15)
          }
          .height(45)
          .border({width:{bottom:1},color:'#ccc'})
          .justifyContent(FlexAlign.SpaceBetween)
          .width('100%')

          //账号
          Row(){
            Row({space:7}){
              Row(){
                Image($r('app.media.zhanghao'))
                  .width(15)
              }
              .justifyContent(FlexAlign.Center)
              .height(26)
              .backgroundColor('#f3f4f6')
              .borderRadius(13)
              .width(26)

              Text('账号与安全')
                .fontSize(13)
                .fontColor('#1F2937')
            }

            Image($r('app.media.jinru'))
              .width(15)
          }
          .height(45)
          .border({width:{bottom:1},color:'#ccc'})
          .justifyContent(FlexAlign.SpaceBetween)
          .width('100%')

          //关于
          Row(){
            Row({space:7}){
              Row(){
                Image($r('app.media.guanyu'))
                  .width(15)
              }
              .justifyContent(FlexAlign.Center)
              .height(26)
              .backgroundColor('#f3f4f6')
              .borderRadius(13)
              .width(26)

              Text('关于我们')
                .fontSize(13)
                .fontColor('#1F2937')
            }

            Image($r('app.media.jinru'))
              .width(15)
          }
          .height(45)
          .border({width:{bottom:1},color:'#ccc'})
          .justifyContent(FlexAlign.SpaceBetween)
          .width('100%')

          //退出
          Row(){
            Row({space:7}){
              Row(){
                Image($r('app.media.tuichu'))
                  .width(15)
              }
              .justifyContent(FlexAlign.Center)
              .height(26)
              .backgroundColor('#f3f4f6')
              .borderRadius(13)
              .width(26)

              Text('退出登录')
                .fontSize(13)
                .fontColor('#1F2937')
            }

            Image($r('app.media.jinru'))
              .width(15)
          }
          .height(45)
          .border({width:{bottom:1},color:'#ccc'})
          .justifyContent(FlexAlign.SpaceBetween)
          .width('100%')
        }
        .padding({left:10,right:10,top:15})
        .borderRadius(15)
        .backgroundColor(Color.White)
        .height(300)
        .width('100%')
      }
      .padding({left:10,right:10})
      .width('100%')

    }
    .backgroundColor('#f1f1f1')
    .height('100%')
    .width('100%')
    .expandSafeArea([SafeAreaType.SYSTEM],[SafeAreaEdge.TOP,SafeAreaEdge.BOTTOM])
  }
}