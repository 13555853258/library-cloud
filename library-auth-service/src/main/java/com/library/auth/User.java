package com.library.auth;
import com.baomidou.mybatisplus.annotation.*; import lombok.Data; import java.time.LocalDateTime;
@Data @TableName("sys_user") public class User{ @TableId(type=IdType.AUTO) private Long id; private String username; private String password; private String realName; private String phone; private String email; private String avatar; private String roleCode; private Integer status; private LocalDateTime createdAt; private LocalDateTime updatedAt; @TableLogic private Integer deleted; }

