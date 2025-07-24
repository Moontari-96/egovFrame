package egovframework.example.cmmn.util;

import java.security.Key;
import java.util.Date;

import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import io.jsonwebtoken.security.Keys;

public class JwtUtil {
	
	// 비밀 키 ( 서비스에 맞게 길고 복잡하게 생성할 것 )
	private static final Key key = Keys.secretKeyFor(SignatureAlgorithm.HS256);
	
	// 토큰 유효 시간 (예: 1시간) 
	private static final long EXPIRATION_TIME = 1000 * 60 * 60;
	
	public static String generateToken(String userId) {
		return Jwts.builder()
				.setSubject(userId)
				.setIssuedAt(new Date()) // 발급 시간
                .setExpiration(new Date(System.currentTimeMillis() + EXPIRATION_TIME)) // 만료 시간
				.signWith(key)
				.compact();
	}
	
	public static String getUserIdFromToken(String token) {
		return Jwts.parserBuilder()
				.setSigningKey(key)
				.build()
				.parseClaimsJws(token)
				.getBody()
				.getSubject();
	}
	
	public static boolean validateToken(String token) {
		try {
			Jwts.parserBuilder().setSigningKey(key).build().parseClaimsJwt(token);
			return true;
		} catch (Exception e) {
			return false;
		}
		
	}
}
