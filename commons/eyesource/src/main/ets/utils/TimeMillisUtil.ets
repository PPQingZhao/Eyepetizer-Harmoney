import { systemDateTime } from '@kit.BasicServicesKit'

let tsDiff = -2147483648

export function getTs(): number {

  const curTime = systemDateTime.getTime()
  const i = Math.trunc(curTime / 1000)
  return getTsDiff() + i
}

function getTsDiff(): number {
  let tempTsDiff = tsDiff
  if (tsDiff == -2147483648) {
    tempTsDiff = 0
  }
  return tempTsDiff
}