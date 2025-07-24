package egovframework.example.korea.auth.service;

import java.time.LocalDateTime;

import lombok.Data;

@Data
public class KorAuthVO {
    private Long id;
    private String user_id;         // user_id
    private String user_name;
    private String user_pw;
    private String user_email;
    private Long role_id;
    private String role_name;
    private String user_status;
    private String post_code;
    private String address;
    private String address_detail;
    private LocalDateTime create_at;
    private LocalDateTime update_at;
}
