package egovframework.example.korea.auth.service.impl;

import java.util.Map;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;

import egovframework.example.korea.auth.service.KorAuthVO;

@Mapper("authMapper")
public interface KorAuthMapper {
	// 회원가입
	int joinAuth(KorAuthVO authVO);
	// 로그인 유효성체크
	KorAuthVO loginValid(Map<String, String>params);
}

