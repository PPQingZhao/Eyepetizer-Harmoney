import { LifecycleComponent } from 'ui/src/main/ets/components/LifecycleComponent';
import { ItemType } from 'ui/src/main/ets/utils/Item';
import { RecommendViewModel } from '../viewModel/RecommendViewModel';
import { MetroLargeVideoItemView, MetroVideoItemViewModel } from 'ui/src/main/ets/view/MetroLargeVideoItemView';
import { MetroSmallVideoItemView } from 'ui/src/main/ets/view/MetroSmallVideoItemView';
import { MetroSwiperItemView, MetroSwiperItemViewModel } from 'ui/src/main/ets/view/MetroSwiperItemView';
import { LengthMetrics } from '@kit.ArkUI';

@ComponentV2
export struct Recommend {
  private viewModel: RecommendViewModel = new RecommendViewModel()
  @Param @Require theme: CustomTheme

  @Builder
  private ContentBuilder() {
    WaterFlow() {
      LazyForEach(this.viewModel.dataSources, (item: ItemType, index: number) => {
        FlowItem() {
          if ('large' === item.getItemType() && item instanceof MetroVideoItemViewModel) {
            MetroLargeVideoItemView({ theme: this.theme, viewModel: item as MetroVideoItemViewModel })
          } else if ('small' === item.getItemType() && item instanceof MetroVideoItemViewModel) {
            MetroSmallVideoItemView({ theme: this.theme, viewModel: item as MetroVideoItemViewModel })
              .padding({ start: LengthMetrics.vp(10), end: LengthMetrics.vp(10) })
          } else if ('swiper' === item.getItemType() && item instanceof MetroSwiperItemViewModel) {
            MetroSwiperItemView({ theme: this.theme, viewModel: item as MetroSwiperItemViewModel })
          }
        }
        .width('100%')
        .height('auto')
      })
    }.width('100%')
    .height('100%')

  }

  build() {
    LifecycleComponent({
      contentView: () => {
        this.ContentBuilder()
      },
      lifecycle: this.viewModel
    })
  }
}