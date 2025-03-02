import { BreakpointModel } from 'base/src/main/ets/constans/BreakpointModel';
import { BreakpointConstants } from './BreakpointConstants';

export class BreakpointType<T> {
  sm: T;
  md: T;
  lg: T;

  constructor(sm: T, md: T, lg: T) {
    this.sm = sm;
    this.md = md;
    this.lg = lg;
  }

  getValue2(currentBreakpoint: BreakpointModel): T {
    return this.getValue(currentBreakpoint.breakpoint)
  }

  getValue(currentBreakpoint: string): T {
    if (currentBreakpoint === BreakpointConstants.BREAKPOINT_MD) {
      return this.md;
    }
    if (currentBreakpoint === BreakpointConstants.BREAKPOINT_LG) {
      return this.lg;
    } else {
      return this.sm;
    }
  }
}