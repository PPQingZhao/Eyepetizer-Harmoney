import { rcp } from '@kit.RemoteCommunicationKit'
import { JSON } from '@kit.ArkTS'
import { getTs } from 'eyesource/src/main/ets/utils/TimeMillisUtil'
import { getSign, getSignString } from 'eyesource/src/main/ets/utils/AuthUtil'
import { EyeResponse } from 'eyesource/src/main/ets/bean/EyeResponse'
import { TokenBean } from 'eyesource/src/main/ets/bean/TokenBean'

/**
 * eye服务器私有header
 */
class AuthHeaderInterceptor implements rcp.Interceptor {
  private readonly AUTH_TOKEN_URL: string = 'http://api.eyepetizer.net/v1/system/auth/token'
  private readonly HOST: string = "api.eyepetizer.net"
  private readonly X_API_KEY: string = "0530ee4341324ce2b26c23fcece80ea2"
  private readonly X_THEFAIR_APP_ID: string = "ahpagrcrf2p7m6rg"
  private readonly UDID: string = "46207311041046a5bb1c1cfa2fda20a03526f750"
  private readonly COOKIE: string = `ky_udid=46207311041046a5bb1c1cfa2fda20a03526f750;ky_auth=;APPID=ahpagrcrf2p7m6rg`
  private readonly DEFAULT_USER_AGENT: string =
    'EYEPETIZER/7051000 (MI 5X;android;8.1.0;zh_CN;android;7.5.10;cn-bj;testflight;;WIFI;1080*1920) native/1.0'
  private readonly DEVICE_INFO =
    `{"imei":"android_id","udid":"f064ad98cdec411992c1716022faa789740d079a","mac":"02:00:00:00:00:00","imsi":"0","android_id": "2b8f1eda3511ac4a","screen":"1080*1920"}`
  private xTHEFAIRCID: string = ''
  private xTHEFAIRUA: string = ''
  private xTHEFAIRAUTH: string = ''
  private userAgent: string = ''
  private cookie: string = ''

  async intercept(context: rcp.RequestContext, next: rcp.RequestHandler): Promise<rcp.Response> {
    // ① 开始网络请求: 成功则返回结果,失败则进一步判断是否token失效
    const response = await this.processOriginalRequest(context, next)
    // 请求成功返回结果
    if (response.statusCode == 200) {
      return response
    }

    // ② token失效则获取token
    const jsonObj = JSON.parse(response.toString())
    let eyeResponse: EyeResponse<undefined> = jsonObj as EyeResponse<undefined>
    // code = 60000 表示无效token
    if (eyeResponse.code != 60000) {
      return response
    }

    // 获取并更新token
    await this.processAuthTokenRequest(context.session, next)

    // ③ 更新token后,再次请求数据
    return this.processOriginalRequest(context, next)
  }

  async processOriginalRequest(context: rcp.RequestContext, next: rcp.RequestHandler) {
    context.request.headers = {
      'x-api-key': this.X_API_KEY,
      'X-THEFAIR-APPID': this.X_THEFAIR_APP_ID,
      'Host': this.HOST,
      'X-THEFAIR-CID': this.xTHEFAIRCID,
      'X-THEFAIR-AUTH': this.xTHEFAIRAUTH,
      'X-THEFAIR-UA': this.xTHEFAIRUA,
      'User-Agent': this.userAgent,
      'Cookie': this.cookie,
    }

    return next.handle(context)
  }

  /**
   * 获取token 更新私有header
   */
  async processAuthTokenRequest(session: rcp.Session, next: rcp.RequestHandler) {
    const curTs = getTs()
    const signString = getSignString('get_token', curTs.toString())
    const sign: string = await getSign(signString)

    const context: rcp.RequestContext = {
      session: session,
      request: new rcp.Request(this.AUTH_TOKEN_URL)
    }

    context.request.method = 'POST'
    context.request.content = new rcp.Form({
      'device_info': this.DEVICE_INFO,
      'grant_type': 'get_token',
      'ts': curTs.toString(),
      'sign': sign,
      'refresh_token': '',
    })

    context.request.headers = {
      'x-api-key': this.X_API_KEY,
      'X-THEFAIR-APPID': this.X_THEFAIR_APP_ID,
      'X-THEFAIR-CID': '',
      'X-THEFAIR-AUTH': '',
      'X-THEFAIR-UA': this.DEFAULT_USER_AGENT,
      'User-Agent': this.DEFAULT_USER_AGENT,
      'Cookie': this.COOKIE,
      'Host': this.HOST,
    }

    const response = await next.handle(context)

    const jsonObj = JSON.parse(response.toString())
    if (jsonObj) {
      const eyeResponse: EyeResponse<TokenBean> = jsonObj as EyeResponse<TokenBean>
      const tokenBean = eyeResponse.result

      // 更新私有header
      this.xTHEFAIRCID = tokenBean.device_id
      this.xTHEFAIRAUTH = tokenBean.access_token
      this.cookie = `ky_udid=${this.UDID};ky_auth=;APPID=ahpagrcrf2p7m6rg`
      this.xTHEFAIRUA =
        `EYEPETIZER/7051000 (MI 5X;android;8.1.0;zh_CN;android;7.5.10;cn-bj;testflight;${tokenBean.device_id};WIFI;1080*1920) native/1.0`
      this.userAgent =
        `EYEPETIZER/7051000 (MI 5X;android;8.1.0;zh_CN;android;7.5.10;cn-bj;testflight;${tokenBean.device_id};WIFI;1080*1920) native/1.0`
    }

    return response
  }
}

export const authHeaderInterceptor = new AuthHeaderInterceptor()