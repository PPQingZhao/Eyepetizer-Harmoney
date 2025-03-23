import { ArrayList, buffer, util } from '@kit.ArkTS';
import { encryptMessage, genIvParamsSpec, genSymKeyByData } from 'eyesource/src/main/ets/utils/CipherUtil';


export function getSignString(paramString1: string, paramString2: string): string {
  return `${paramString1}|ahpagrcrf2p7m6rg|android|7.5.10||${paramString2}`
}


// 字符串转成字节流
function stringToUint8Array(str: string) {
  // console.info(`ste: ${str}`)
  const res = new Uint8Array(buffer.from(str, 'utf-8').buffer)
  // console.info('字符串转成字节流:' + res);
  return res;
}

export function getSign(paramString: string): Promise<string> {
  const b = new B('DmA1G5g5jq27L6OWbxapKln3CJ7HlyNBB6yOClNAMN6')
  return b.b(paramString)
}

class B {
  private a: Uint8Array = new Uint8Array()

  constructor(paramString: string) {
    if (paramString.length == 43) {
      paramString = `${paramString}=`
    }
    const base64 = new util.Base64Helper()

    this.a = base64.decodeSync(paramString, util.Type.MIME_URL_SAFE)
  }

  b(paramString: string) {
    const arrayList: ArrayList<number> = new ArrayList()
    const arrayOfByte2: Uint8Array = stringToUint8Array(paramString)
    let j = arrayOfByte2.length
    let i: number
    i = 0
    while (i < j) {
      arrayList.add(arrayOfByte2[i])
      i++
    }
    j = arrayList.length
    i = 32
    j = i - j % i
    if (j != 0) {
      i = j
    }
    const c = String.fromCharCode(i & 0xFF) //'\u000B' 11
    let str = String()
    j = 0
    while (j < i) {
      str = `${str}${c}`
      j++
    }
    let arrayOfByte1: Uint8Array = stringToUint8Array(str.toString())
    j = arrayOfByte1.length
    i = 0
    while (i < j) {
      arrayList.add(arrayOfByte1[i])
      i++
    }
    arrayOfByte1 = new Uint8Array(arrayList.length)
    i = 0
    while (i < arrayList.length) {
      arrayOfByte1[i] = arrayList[i]
      i++
    }

    const key = genSymKeyByData(this.a)
    const data = this.a.subarray(0, 16)
    const ivParamsSpec = genIvParamsSpec(data)

    const cipherData = encryptMessage(key, { data: arrayOfByte1 }, ivParamsSpec)
    const base64 = new util.Base64Helper()
    return base64.encodeToString(cipherData.data, util.Type.BASIC)
  }
}


