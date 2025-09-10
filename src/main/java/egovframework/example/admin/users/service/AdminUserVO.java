package egovframework.example.admin.users.service;

import java.time.LocalDateTime;
import java.util.Date;

import lombok.Data;

@Data
public class AdminUserVO {
	  private Long id;
	  private String userId;
	  private String userName;
	  private String userEmail;
	  private Long roleId;
	  private String roleName;
	  private String userStatus;
	  private LocalDateTime createAt;
	  private LocalDateTime updateAt;
}
