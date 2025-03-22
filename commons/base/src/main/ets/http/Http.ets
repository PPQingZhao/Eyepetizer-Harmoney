import { rcp } from '@kit.RemoteCommunicationKit';
import { BusinessError } from '@kit.BasicServicesKit';

export function httpGet(url: rcp.URLOrString, config?: rcp.SessionConfiguration) {
  const session = rcp.createSession(config)
  session.get(url).then((response) => {
    console.info(`httpGet succeed: ${response.statusCode} ${response}`)
    session.close()
  }).catch((err: BusinessError) => {
    console.error(`httpGet error:  ${err.code}  ${err.message}`)
    session.close()
  })
}

export function httpPost(url: rcp.URLOrString, config?: rcp.SessionConfiguration, content?: rcp.RequestContent) {
  const session = rcp.createSession(config)
  session.post(url, content).then((response) => {
    console.info(`httpPost succeed: ${response.statusCode} ${response}`)
    session.close()
  }).catch((err: BusinessError) => {
    console.error(`httpPost error:  ${err.code}  ${err.message}`)
    session.close()
  })
}