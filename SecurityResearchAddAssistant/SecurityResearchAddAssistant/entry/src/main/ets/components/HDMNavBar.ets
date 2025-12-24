// import { AppSafeArea } from "../viewmodels"
import { AppStorageV2, router } from "@kit.ArkUI"

@Preview
@ComponentV2
export struct HDMNavBar {
  // 引入安全区高度
  // appSafe: AppSafeArea = AppStorageV2.connect(AppSafeArea, () => new AppSafeArea())!
  @Param
  title: string = "标题"
  @Param
  leftIcon: ResourceStr = $r("app.media.back")
  @Param
  rightIcon: ResourceStr = ''
  @Param
  showLeftIcon: boolean = true
  @Param
  showRightIcon: boolean = true
  @Param
  color: ResourceColor = ''
  @Param
  bgColor: ResourceColor =''
  @Event
  onLeftClick: () => void = () => {
    router.back()
  }
  @Event
  onRightClick: () => void = () => {
  }
  @BuilderParam
  customTitle: () => void = this.defaultBuilder

  @Builder
  defaultBuilder() {
  }

  build() {
    RelativeContainer() {
      if (this.showLeftIcon) {
        Image(this.leftIcon)
          .fillColor(this.color)
          .width(30)
          .aspectRatio(1)
          .alignRules({
            center: {
              anchor: "__container__",
              align: VerticalAlign.Center
            }
          })
          .onClick(() => {
            this.onLeftClick()
          })
      }
      if (this.showRightIcon) {
        Image(this.rightIcon)
          .width(30)
          .aspectRatio(1)
          .fillColor(this.color)
          .alignRules({
            center: {
              anchor: "__container__",
              align: VerticalAlign.Center
            },
            right: {
              anchor: "__container__",
              align: HorizontalAlign.End
            }
          })
          .onClick(() => {
            this.onRightClick()
          })
      }
      if (this.title) {
        Text(this.title)
          .fontColor(this.color)
          .alignRules({
            center: {
              anchor: "__container__",
              align: VerticalAlign.Center
            },
            middle: {
              anchor: "__container__",
              align: HorizontalAlign.Center
            }
          })
          .fontWeight(FontWeight.Bold)
      }
      if (this.customTitle) {
        this.customTitle() // 传入的UI结构
      }
    }
    .padding({
      // top: this.appSafe.topHeight,
      left: 10,
      right: 10
    })
    .width("100%")
    .height(50 )
    .backgroundColor(this.bgColor)

  }
}