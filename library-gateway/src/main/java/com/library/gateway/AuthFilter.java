package com.library.gateway;
import com.library.common.JwtUtil; import org.springframework.cloud.gateway.filter.GatewayFilterChain; import org.springframework.cloud.gateway.filter.GlobalFilter; import org.springframework.core.Ordered; import org.springframework.http.HttpStatus; import org.springframework.stereotype.Component; import org.springframework.web.server.ServerWebExchange; import reactor.core.publisher.Mono; import java.util.List;
@Component public class AuthFilter implements GlobalFilter, Ordered {
 private final List<String> white=List.of("/api/auth/login","/api/auth/register","/api/books/public","/api/system/announcements/public");
 public Mono<Void> filter(ServerWebExchange e, GatewayFilterChain c){ String path=e.getRequest().getURI().getPath(); if(white.stream().anyMatch(path::startsWith)) return c.filter(e); String h=e.getRequest().getHeaders().getFirst("Authorization"); String[] p=h!=null&&h.startsWith("Bearer ")?JwtUtil.parse(h.substring(7)):null; if(p==null){e.getResponse().setStatusCode(HttpStatus.UNAUTHORIZED);return e.getResponse().setComplete();} ServerWebExchange next=e.mutate().request(e.getRequest().mutate().header("X-User-Id",p[0]).header("X-Username",p[1]).header("X-Role",p[2]).build()).build(); return c.filter(next); }
 public int getOrder(){return -100;}
}

