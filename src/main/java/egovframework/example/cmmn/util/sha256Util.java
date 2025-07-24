package egovframework.example.cmmn.util;

import java.security.MessageDigest;

public class sha256Util {
	public static String encrypt(String text) throws Exception {
        MessageDigest md = MessageDigest.getInstance("SHA-256");
        byte[] hash = md.digest(text.getBytes("UTF-8"));

        StringBuilder sb = new StringBuilder();
        for (byte b : hash) {
            sb.append(String.format("%02x", b)); // 2자리 hex 문자열
        }
        return sb.toString();
    }
}
