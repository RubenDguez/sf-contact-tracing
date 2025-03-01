public with sharing class CTPersonController {

    public static String getToken(String mobile) {
        Blob obj = Blob.valueOf(mobile);
        Blob hash = Crypto.generateDigest('MD5', obj);
        String result = EncodingUtil.base64Encode(hash);

        return result;
    }
}
