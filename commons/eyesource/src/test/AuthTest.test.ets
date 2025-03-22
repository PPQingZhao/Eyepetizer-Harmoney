import { describe, it } from '@ohos/hypium';
import { getSignString } from 'eyesource/src/main/ets/utils/AuthUtil';
import { getTs } from 'eyesource/src/main/ets/utils/TimeMillisUtil';

export default function authTest() {
  describe('authTest', () => {
    it('assertContain', 0, () => {
      const ts = getTs()
      let signString = getSignString('get_token', ts.toString())
      console.log('signString:' + signString)
    });
  })
}