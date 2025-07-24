package egovframework.example.korea.auth.service.impl;

import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;

import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;
import org.springframework.stereotype.Service;

import egovframework.example.cmmn.util.sha256Util;
import egovframework.example.korea.auth.service.KorAuthService;
import egovframework.example.korea.auth.service.KorAuthVO;

@Service("authService")
public class KorAuthServiceImpl extends EgovAbstractServiceImpl implements KorAuthService {
	@Resource(name="authMapper")
	KorAuthMapper authMapper;
	@Override
    public int joinAuth(KorAuthVO authVO) throws Exception {
        // 비밀번호 SHA-256 암호화
	    String encryptedPassword = sha256Util.encrypt(authVO.getUser_pw());
	    authVO.setUser_pw(encryptedPassword);
	    // DB Insert
	    return authMapper.joinAuth(authVO);
    }
	
	@Override
	public KorAuthVO loginValid(String userId, String userPw) throws Exception {
        // 비밀번호 SHA-256 암호화
        String encryptedPassword = sha256Util.encrypt(userPw);
	    Map<String, String> param = new HashMap<>();
	    param.put("userId", userId);
        param.put("password", encryptedPassword);
	    // DB Insert
	    return authMapper.loginValid(param);
	}
	
}
