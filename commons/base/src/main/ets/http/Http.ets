import { rcp } from '@kit.RemoteCommunicationKit';
import { BusinessError } from '@kit.BasicServicesKit';

/**
 * GET 请求
 * @param url
 * @param config
 * @returns
 */
export function httpGet<Response>(url: rcp.URLOrString, config?: rcp.SessionConfiguration,
  destination?: rcp.ResponseBodyDestination): Promise<Response> {
  return httpRequest((session: rcp.Session) => {
    return session.get(url, destination)
  }, config)
}

/**
 *  POST 请求
 * @param url
 * @param config
 * @param content
 * @returns
 */
export function httpPost<Response>(
  url: rcp.URLOrString,
  config?: rcp.SessionConfiguration,
  content?: rcp.RequestContent, destination?: rcp.ResponseBodyDestination): Promise<Response> {
  return httpRequest((session: rcp.Session) => {
    return session.post(url, content, destination)
  }, config)
}

function httpRequest<Response>(
  request: (session: rcp.Session) => Promise<rcp.Response>,
  config?: rcp.SessionConfiguration
): Promise<Response> {
  return new Promise<Response>((resolve, reject) => {
    const session = rcp.createSession(config)
    request(session).then(res => {
      const result = JSON.parse(res.toString()!!) as Response
      resolve(result)
      session.close()
    }).catch((err: BusinessError) => {
      reject(err)
      session.close()
    })
  })
}
