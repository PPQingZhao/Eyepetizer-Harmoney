import  authTest  from './AuthTest.test';
import localUnitTest from './LocalUnit.test';

export default function testsuite() {
  localUnitTest();
  authTest()
}