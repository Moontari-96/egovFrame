package egovframework.example.admin.users.service;

import java.time.LocalDateTime;
import java.util.Date;

import lombok.Data;

@Data
public class AdminUserVO {
    private Long id;
    private String user_id;         // user_id
    private String user_name;
    private String user_pw;
    private String user_email;
    private Long role_id;
    private String role_name;
    private String user_status;
    private LocalDateTime create_at;
    private LocalDateTime update_at;
}
