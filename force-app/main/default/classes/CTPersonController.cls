/**
 * @description       : 
 * @author            : argenis.dominguez@argenis.dominguez.com
 * @group             : 
 * @last modified on  : 02-28-2025
 * @last modified by  : argenis.dominguez@argenis.dominguez.com
**/
public with sharing class CTPersonController {

    /**
    * @description 
    * @author argenis.dominguez@argenis.dominguez.com | 02-28-2025 
    * @param mobile 
    * @return String 
    **/
    public static String getToken(String mobile) {
        Blob obj = Blob.valueOf(mobile);
        Blob hash = Crypto.generateDigest('MD5', obj);
        String result = EncodingUtil.base64Encode(hash);

        return result;
    }
}
