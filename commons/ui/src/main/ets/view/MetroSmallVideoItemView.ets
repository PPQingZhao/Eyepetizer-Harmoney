import { LengthMetrics } from '@kit.ArkUI'
import { MetroVideoItemViewModel } from 'ui/src/main/ets/view/MetroLargeVideoItemView'
import { BreakpointModel, getBreakpointModelByAppStorage } from 'base/src/main/ets/constans/BreakpointModel'
import { BreakpointType } from 'base/src/main/ets/constans/BreakpointType'


@Preview
@ComponentV2
export struct MetroSmallVideoItemView {
  private id_img_cover: string = 'cover'
  private id_img_play1: string = 'play1'
  private id_text_title: string = 'title'
  private id_text_tag: string = 'tag'
  @Param viewModel: MetroVideoItemViewModel = new MetroVideoItemViewModel('', '',
    '范德萨会更加开放的是个JFK很多时间开个会的功夫撒海空军的施工计划开发的话就赶快个人佛第四个家里',
    '全球广告精选', '#广告', '04:25')
  @Param theme?: CustomTheme = undefined
  @Local curBreakpoint: BreakpointModel = getBreakpointModelByAppStorage()

  build() {
    RelativeContainer() {

      // cover
      Image(this.viewModel.cover)
        .objectFit(ImageFit.Cover)
        .id(this.id_img_cover)
        .width('50%')
        .aspectRatio(new BreakpointType(14 / 9, 1, 1).getValue2(this.curBreakpoint))
        .backgroundColor(Color.Gray)

      // play btn
      Image($r('sys.media.ohos_ic_public_play'))
        .objectFit(ImageFit.Fill)
        .id(this.id_img_play1)
        .width('5%')
        .height('auto')
        .aspectRatio(1)
        .fillColor(Color.White)
        .alignRules({
          top: { anchor: this.id_img_cover, align: VerticalAlign.Top },
          start: { anchor: this.id_img_cover, align: HorizontalAlign.Start },
          bottom: { anchor: this.id_img_cover, align: VerticalAlign.Bottom },
          end: { anchor: this.id_img_cover, align: HorizontalAlign.End }
        })

      // title
      Text(this.viewModel.title)
        .maxLines(2)
        .id(this.id_text_title)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .fontSize(15)
        .fontColor(this.theme?.colors?.fontPrimary)
        .fontWeight(FontWeight.Bold)
        .alignRules({
          start: { anchor: this.id_img_cover, align: HorizontalAlign.End },
          top: { anchor: this.id_img_cover, align: VerticalAlign.Top },
          end: { anchor: '__container__', align: HorizontalAlign.End }
        })
        .margin({ start: LengthMetrics.vp(12), top: LengthMetrics.vp(12), end: LengthMetrics.vp(12) })

      //tag
      Text(this.viewModel.tag)
        .id(this.id_text_tag)
        .fontSize(12)
        .fontColor(this.theme?.colors?.fontPrimary)
        .alignRules({
          start: { anchor: this.id_img_cover, align: HorizontalAlign.End },
          bottom: { anchor: this.id_img_cover, align: VerticalAlign.Bottom },
        })
        .margin({ bottom: LengthMetrics.vp(12), start: LengthMetrics.vp(12) })

      //duration
      Text(this.viewModel.duration)
        .fontSize(12)
        .fontColor(this.theme?.colors?.fontPrimary)
        .height('auto')
        .padding({
          left: px2vp(12),
          right: px2vp(12),
          top: px2vp(5),
          bottom: px2vp(5)
        })
        .backgroundColor(Color.Gray)
        .clip(true)
        .borderRadius('15%')
        .alignRules({
          end: { anchor: this.id_text_title, align: HorizontalAlign.End },
          top: { anchor: this.id_text_tag, align: VerticalAlign.Top },
          bottom: { anchor: this.id_text_tag, align: VerticalAlign.Bottom }
        })

    }
    .width('100%')
    .height('auto')
    .border({ radius: 10, width: 0.1, color: Color.Gray })
    .clip(true)
  }
}
