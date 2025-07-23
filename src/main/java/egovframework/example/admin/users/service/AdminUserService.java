package egovframework.example.admin.users.service;

public interface AdminUserService {
	AdminUserVO selectAdminUserById(String id, String password) throws Exception;
}
