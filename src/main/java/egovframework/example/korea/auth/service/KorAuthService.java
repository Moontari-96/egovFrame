package egovframework.example.korea.auth.service;


public interface KorAuthService {
	// 회원가입
	int joinAuth(KorAuthVO authVO) throws Exception;
	// 로그인 유호성
	KorAuthVO loginValid(String userId, String userPw) throws Exception;
}
