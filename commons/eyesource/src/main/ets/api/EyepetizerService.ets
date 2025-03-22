import { authHeaderInterceptor } from 'eyesource/src/main/ets/interceptor/AuthHeaderInterceptor'
import { httpPost } from 'base/src/main/ets/http/Http'

const URL_BASE = 'http://api.eyepetizer.net/'
/**
 *用户密码登录
 *http://api.eyepetizer.net/v1/user/oauth/password_login?username=178255777&password=zphgjgj5555&user_type=ugc
 */
const BASE_URL_PASSWORD_LOGIN = `${URL_BASE}v1/user/oauth/password_login`

/**
 * 获取用户信息:http://api.eyepetizer.net/v1/user/center/get_user_info?uid=304922815
 */
const BASE_URL_GET_USER_INFO = `${URL_BASE}v1/user/center/get_user_info`

/**
 * 日报
 */
export function dailyIssue() {
  httpPost('http://api.eyepetizer.net/v1/card/page/get_page',
    { interceptors: [authHeaderInterceptor] },
    { 'page_label': 'daily_issue', 'page_type': 'card' })
}

/**
 * 推荐
 */
export function recommend() {
  httpPost('http://api.eyepetizer.net/v1/card/page/get_page',
    { interceptors: [authHeaderInterceptor] },
    { 'page_label': 'recommend', 'page_type': 'card' })
}

// 关注
export function follow() {
  httpPost('http://api.eyepetizer.net/v1/card/page/get_page',
    { interceptors: [authHeaderInterceptor] },
    { 'page_label': 'follow', 'page_type': 'card' })
}

/**
 * 发现
 */
export function discoverV2() {
  httpPost('http://api.eyepetizer.net/v1/card/page/get_page',
    { interceptors: [authHeaderInterceptor] },
    { 'page_label': 'discover_v2', 'page_type': 'card' })
}

/**
 * 广场
 */
export function community() {
  httpPost('http://api.eyepetizer.net/v1/card/page/get_page',
    { interceptors: [authHeaderInterceptor] },
    { 'page_label': 'community', 'page_type': 'card' })
}