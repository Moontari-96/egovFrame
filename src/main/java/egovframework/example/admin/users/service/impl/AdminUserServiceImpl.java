package egovframework.example.admin.users.service.impl;

import javax.annotation.Resource;

import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;
import org.springframework.stereotype.Service;

import egovframework.example.admin.users.service.AdminUserService;
import egovframework.example.admin.users.service.AdminUserVO;
import egovframework.example.cmmn.util.sha256Util;

import java.util.HashMap;
import java.util.Map;

@Service("UserService")
public class AdminUserServiceImpl extends EgovAbstractServiceImpl implements AdminUserService {

	@Resource(name="adminUserMapper")
	adminUserMapper userMapper;
	
	@Override
    public AdminUserVO selectAdminUserById(String id, String password) throws Exception {
        // 비밀번호 SHA-256 암호화
        String encryptedPassword = sha256Util.encrypt(password);

        Map<String, String> param = new HashMap<>();
        param.put("id", id);
        param.put("password", encryptedPassword);
        System.out.println(param + "확인용");
        return userMapper.loginAdminCheck(param); // MyBatis에서 검증
    }
}
