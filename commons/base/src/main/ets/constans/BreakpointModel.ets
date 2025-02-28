import { BreakpointConstants } from 'base/src/main/ets/constans/BreakpointConstants';
import { AppStorageV2 } from '@kit.ArkUI';

@ObservedV2
export class BreakpointModel {
  @Trace breakpoint: string = BreakpointConstants.BREAKPOINT_SM
}

export function getBreakpointModelByAppStorage(): BreakpointModel {
  return AppStorageV2.connect<BreakpointModel>(BreakpointModel, "currentBreakpoint", () => new BreakpointModel())!;
}

export function updateBreakpointModel(curBp: string) {
  getBreakpointModelByAppStorage().breakpoint = curBp
}