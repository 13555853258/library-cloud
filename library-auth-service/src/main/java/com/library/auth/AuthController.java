package com.library.auth;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper; import com.baomidou.mybatisplus.extension.plugins.pagination.Page; import com.library.common.*; import jakarta.validation.constraints.NotBlank; import lombok.Data; import lombok.RequiredArgsConstructor; import org.springframework.validation.annotation.Validated; import org.springframework.web.bind.annotation.*; import java.util.*;
@RestController @RequiredArgsConstructor @Validated public class AuthController{
 private final UserMapper mapper;
 @PostMapping("/api/auth/login") public Result<Map<String,Object>> login(@RequestBody LoginDto d){ User u=mapper.selectOne(new LambdaQueryWrapper<User>().eq(User::getUsername,d.username).eq(User::getDeleted,0)); if(u==null||!Objects.equals(u.getPassword(),d.password)) throw new BusinessException("用户名或密码错误"); if(u.getStatus()!=1) throw new BusinessException("账号已被停用"); Map<String,Object> data=new LinkedHashMap<>(); data.put("token",JwtUtil.create(u.getId(),u.getUsername(),u.getRoleCode())); u.setPassword(null);data.put("user",u);return Result.ok(data); }
 @GetMapping("/api/users") public Result<PageResult<User>> page(@RequestParam(defaultValue="1") long page,@RequestParam(defaultValue="10") long size,@RequestParam(required=false) String keyword){LambdaQueryWrapper<User>w=new LambdaQueryWrapper<User>().eq(User::getDeleted,0).and(keyword!=null&&!keyword.isBlank(),x->x.like(User::getUsername,keyword).or().like(User::getRealName,keyword)).orderByDesc(User::getCreatedAt);Page<User>p=mapper.selectPage(Page.of(page,size),w);p.getRecords().forEach(x->x.setPassword(null));return Result.ok(new PageResult<>(p.getTotal(),p.getRecords()));}
 @PostMapping("/api/users") public Result<Void> add(@RequestBody User u){if(mapper.exists(new LambdaQueryWrapper<User>().eq(User::getUsername,u.getUsername())))throw new BusinessException("用户名已存在");u.setStatus(1);u.setDeleted(0);mapper.insert(u);return Result.ok();}
 @PutMapping("/api/users/{id}") public Result<Void> update(@PathVariable Long id,@RequestBody User u){u.setId(id);u.setPassword(null);mapper.updateById(u);return Result.ok();}
 @DeleteMapping("/api/users/{id}") public Result<Void> delete(@PathVariable Long id){mapper.deleteById(id);return Result.ok();}
 @Data public static class LoginDto{@NotBlank(message="请输入用户名")String username;@NotBlank(message="请输入密码")String password;}
}

