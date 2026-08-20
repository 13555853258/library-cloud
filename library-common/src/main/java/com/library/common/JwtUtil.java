package com.library.common;
import java.nio.charset.StandardCharsets; import java.time.Instant; import java.util.Base64; import javax.crypto.Mac; import javax.crypto.spec.SecretKeySpec;
public final class JwtUtil {
 private static final String SECRET="library-cloud-2026-secret-key";
 private JwtUtil(){}
 public static String create(Long id,String username,String role){ long exp=Instant.now().getEpochSecond()+86400; String payload=id+"|"+username+"|"+role+"|"+exp; return enc(payload)+"."+sign(payload); }
 public static String[] parse(String token){ try {String payload=new String(Base64.getUrlDecoder().decode(token.split("\\.")[0]),StandardCharsets.UTF_8); if(!sign(payload).equals(token.split("\\.")[1])) return null; String[] p=payload.split("\\|"); return Long.parseLong(p[3])>Instant.now().getEpochSecond()?p:null;}catch(Exception e){return null;} }
 private static String enc(String value){return Base64.getUrlEncoder().withoutPadding().encodeToString(value.getBytes(StandardCharsets.UTF_8));}
 private static String sign(String value){try{Mac mac=Mac.getInstance("HmacSHA256");mac.init(new SecretKeySpec(SECRET.getBytes(StandardCharsets.UTF_8),"HmacSHA256"));return enc(new String(mac.doFinal(value.getBytes(StandardCharsets.UTF_8)),StandardCharsets.ISO_8859_1));}catch(Exception e){throw new IllegalStateException(e);}}
}

