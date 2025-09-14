package egovframework.example.admin.users.service;

import java.time.LocalDateTime;

import lombok.Data;

@Data
public class RolesVO {
	  private Long id;
	  private String roleName;
	  private String roleDescription;
	  private LocalDateTime createAt;
	  private LocalDateTime updateAt;
}
