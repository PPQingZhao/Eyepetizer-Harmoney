import { AppStorageV2 } from '@kit.ArkUI';

@ObservedV2
export class WindowArea {
  @Trace statusBarHeight: number = 0
  @Trace navigationHeight: number = 0
}

export function getWindowAreaByAppStorage(): WindowArea {
  return AppStorageV2.connect<WindowArea>(WindowArea, "key_windowArea", () => new WindowArea())!;
}
