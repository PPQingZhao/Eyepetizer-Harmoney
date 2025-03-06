import { LengthMetrics, Theme } from '@kit.ArkUI'

@ObservedV2
export class MetroLargeVideoItemViewModel {
  cover: string
  avatar: string
  title: string
  nickName: string
  tag: string
  duration: string

  constructor(cover: string = '', avatar: string = '', title: string = '', nickName: string = '', tag: string = '',
    duration: string = '') {
    this.cover = cover
    this.avatar = avatar
    this.title = title
    this.nickName = nickName
    this.tag = tag
    this.duration = duration
  }
}

@Preview
@ComponentV2
export struct MetroLargeVideoItemView {
  private id_img_cover: string = 'cover'
  private id_img_play1: string = 'play1'
  private id_img_avatar: string = 'avatar'
  private id_text_title: string = 'title'
  private id_text_nickName: string = 'nickName'
  private id_img_play2: string = 'play2'
  private id_text_tag: string = 'tag'
  @Param viewModel: MetroLargeVideoItemViewModel = new MetroLargeVideoItemViewModel('', '',
    '范德萨会更加开放的是个JFK很多时间开个会的功夫撒海空军的施工计划开发的话就赶快个人佛第四个家里',
    '全球广告精选', '#广告', '04:25')
  private theme?: CustomTheme

  onWillApplyTheme(theme: Theme): void {
    this.theme = this.theme
  }

  build() {
    RelativeContainer() {
      // cover
      Image(this.viewModel.cover)
        .objectFit(ImageFit.Cover)
        .id(this.id_img_cover)
        .width('100%')
        .aspectRatio(16 / 9)
        .backgroundColor(Color.Gray)

      // play btn
      Image($r('sys.media.ohos_ic_public_play'))
        .objectFit(ImageFit.Fill)
        .id(this.id_img_play1)
        .width('10%')
        .height('auto')
        .aspectRatio(1)
        .fillColor(Color.White)
        .alignRules({
          top: { anchor: this.id_img_cover, align: VerticalAlign.Top },
          start: { anchor: this.id_img_cover, align: HorizontalAlign.Start },
          bottom: { anchor: this.id_img_cover, align: VerticalAlign.Bottom },
          end: { anchor: this.id_img_cover, align: HorizontalAlign.End }
        })
        .margin({ start: LengthMetrics.vp(20), top: LengthMetrics.vp(15) })

      // avatar
      Image(this.viewModel.avatar)
        .objectFit(ImageFit.Fill)
        .id(this.id_img_avatar)
        .width('10%')
        .height('auto')
        .aspectRatio(1)
        .backgroundColor(Color.Gray)
        .alignRules({
          top: { anchor: this.id_img_cover, align: VerticalAlign.Bottom },
          start: { anchor: this.id_img_cover, align: HorizontalAlign.Start }
        })
        .margin({ start: LengthMetrics.vp(20), top: LengthMetrics.vp(15) })
        .border({ radius: '50%', color: Color.Gray, width: 1 })

      // title
      Text(this.viewModel.title)
        .maxLines(1)
        .id(this.id_text_title)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .fontSize(18)
        .fontColor(this.theme?.colors?.fontPrimary)
        .fontWeight(FontWeight.Bold)
        .alignRules({
          start: { anchor: this.id_img_avatar, align: HorizontalAlign.End },
          top: { anchor: this.id_img_avatar, align: VerticalAlign.Top },
          end: { anchor: '__container__', align: HorizontalAlign.End }
        })
        .margin({ start: LengthMetrics.vp(15), end: LengthMetrics.vp(20) })

      //nickName
      Text(this.viewModel.nickName)
        .id(this.id_text_nickName)
        .fontSize(14)
        .fontColor(this.theme?.colors?.fontPrimary)
        .alignRules({
          start: { anchor: this.id_text_title, align: HorizontalAlign.Start },
          top: { anchor: this.id_text_title, align: VerticalAlign.Bottom },
        })
        .margin({ top: LengthMetrics.vp(10) })

      //tag
      Text(this.viewModel.tag)
        .id(this.id_text_tag)
        .fontSize(14)
        .fontColor(this.theme?.colors?.fontPrimary)
        .alignRules({
          start: { anchor: this.id_text_nickName, align: HorizontalAlign.End },
          top: { anchor: this.id_text_title, align: VerticalAlign.Bottom },
        })
        .margin({ top: LengthMetrics.vp(10), start: LengthMetrics.vp(10) })

      // play btn
      Image($r('sys.media.ohos_ic_public_play'))
        .width('4%')
        .height('auto')
        .aspectRatio(1)
        .id(this.id_img_play2)
        .alignRules({
          start: { anchor: this.id_text_tag, align: HorizontalAlign.End },
          top: { anchor: this.id_text_nickName, align: VerticalAlign.Top },
          bottom: { anchor: this.id_text_nickName, align: VerticalAlign.Bottom }
        })
        .margin({ start: LengthMetrics.vp(10) })

      //duration
      Text(this.viewModel.duration)
        .fontSize(14)
        .fontColor(this.theme?.colors?.fontPrimary)
        .alignRules({
          start: { anchor: this.id_img_play2, align: HorizontalAlign.End },
          top: { anchor: this.id_text_nickName, align: VerticalAlign.Top },
        })
        .margin({ start: LengthMetrics.vp(2) })

    }.width('100%')
    .height('auto')
    .backgroundColor(this.theme?.colors?.backgroundPrimary)
  }
}
