import { cryptoFramework } from '@kit.CryptoArchitectureKit';

export function genSymKeyByData(symKeyData: Uint8Array) {
  let symKeyBlob: cryptoFramework.DataBlob = { data: symKeyData };
  let aesGenerator = cryptoFramework.createSymKeyGenerator('AES256');
  let symKey = aesGenerator.convertKeySync(symKeyBlob);
  // console.info('convertKeySync success');
  return symKey;
}

export function genIvParamsSpec(ivData: Uint8Array): cryptoFramework.IvParamsSpec {
  return {
    algName: "IvParamsSpec",
    iv: { data: ivData }
  };
}

export function encryptMessage(symKey: cryptoFramework.SymKey, plainText: cryptoFramework.DataBlob,
  ivParamsSpec: cryptoFramework.IvParamsSpec) {
  let cipher = cryptoFramework.createCipher('AES256|CBC|NoPadding');
  cipher.initSync(cryptoFramework.CryptoMode.ENCRYPT_MODE, symKey, ivParamsSpec);
  let cipherData = cipher.doFinalSync(plainText);
  return cipherData;
}