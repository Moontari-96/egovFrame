package egovframework.example.cmmn.util;
import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.nio.file.LinkOption;
import java.util.Objects;
import java.util.UUID;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.egovframe.rte.fdl.property.EgovPropertyService;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import org.springframework.web.multipart.MultipartFile;

import static java.nio.file.LinkOption.NOFOLLOW_LINKS;

/**
 * 파일 저장/삭제 유틸리티.
 *
 * - 저장: 저장소 루트(Globals.fileStorePath) 아래에 UUID.확장자 형태로 저장
 * - 삭제: 항상 저장소 루트 내부에서만 수행(경로 탈출 방지)
 */
@Component
public class FileUtil {
    private static final Logger log = LoggerFactory.getLogger(FileUtil.class);
    /** 환경설정에서 주입받은 저장소 루트(문자열 원본). 예: C:/eGovFrameDev-4.3.1-64bit/fileCloud */
    private final String fileStorePath;

    /** 정규화된 저장소 루트 Path. 모든 파일 연산의 기준 디렉터리 */
    private final Path base;

    public FileUtil(
        // eGovFrame의 propertiesService를 쓰는 기존 방식 (대안: @Value("${Globals.fileStorePath}"))
        @Value("#{propertiesService.getString('Globals.fileStorePath')}")
        String fileStorePath
    ) {
        this.fileStorePath = Objects.requireNonNull(fileStorePath, "Globals.fileStorePath must not be null");
        // 절대경로 + normalize로 표준화 (경로탈출 방지 검사에서 중요)
        this.base = Paths.get(this.fileStorePath).toAbsolutePath().normalize();
        log.info(">> fileStorePath(raw) = {}", this.fileStorePath);
        log.info(">> base(normalized)  = {}", this.base);
        try {
            // 최초 1회: 저장소 루트 디렉터리 보장
            Files.createDirectories(this.base);
        } catch (IOException e) {
            // 저장소 루트를 만들 수 없다면 서비스 전체가 의미가 없으므로 런타임 예외로
            throw new IllegalStateException("Failed to create base directory: " + this.base, e);
        }
    }

    /** 설정에 등록된 저장소 루트 문자열(원본) 반환 */
    public String getFileStorePath() {
        return fileStorePath;
    }

    /**
     * MultipartFile을 지정된 경로에 저장하고, 저장된 파일의 경로를 반환합니다.
     * @param file 업로드할 MultipartFile 객체
     * @return 저장된 파일의 상대 경로
     * @throws IOException 파일 저장 실패 시 예외 발생
     */
    public String saveFile(MultipartFile file) throws IOException {
        // 1. 저장할 디렉토리 경로가 없으면 생성합니다.
        Path uploadPath = Paths.get(fileStorePath).toAbsolutePath().normalize();
        Files.createDirectories(uploadPath);

        // 2. 파일명 중복을 피하기 위해 UUID를 사용합니다.
        String originalFileName = file.getOriginalFilename();
        String fileExtension = "";
        if (originalFileName != null && originalFileName.contains(".")) {
            fileExtension = originalFileName.substring(originalFileName.lastIndexOf("."));
        }
        String fileName = UUID.randomUUID().toString() + fileExtension;
        
        // 3. 파일의 전체 경로를 생성합니다.
        Path targetPath = uploadPath.resolve(fileName);
        
        // 4. 파일을 저장합니다.
        Files.copy(file.getInputStream(), targetPath);

        // 5. 저장된 파일의 상대 경로를 반환합니다. (DB 저장을 위해)
        return fileName; // 예시: /uploads/파일명.jpg
    }

    /**
     * 물리 파일 삭제 (DB에 디렉터리와 시스템명을 따로 저장했을 때 권장)
     *
     * @param dbDir   DB에 저장된 상대 디렉터리(옵션) 예: "/uploads/2025/09" 또는 null/빈 문자열
     * @param sysName DB에 저장된 파일 시스템명(필수)   예: "7e2a-...-a5d2.png"
     * @return 실제 파일이 존재해서 삭제되면 true, 그 외 false(없음/디렉터리/에러)
     */
    public boolean deleteFile(String dbDir, String sysName) {
        if (sysName == null || sysName.trim().isEmpty()) return false;

        // 업로드중 역슬래시가 섞여 들어오는 케이스 방어
        Path rel = (dbDir == null || dbDir.trim().isEmpty())
                ? Paths.get("")
                : Paths.get(dbDir.replace('\\', '/'));

        // dbDir이 절대경로면 그대로 normalize, 아니면 base 밑으로 붙여서 normalize
        Path target = (rel.isAbsolute() ? rel : base.resolve(stripLeadingSlashes(rel.toString())))
                        .resolve(Paths.get(sysName).getFileName()) // sysName에 슬래시가 들어와도 파일명만 사용
                        .normalize();

        // 경로 탈출 방지: 항상 base 하위여야 함
        if (!target.startsWith(base)) {
            log.warn("Refusing to delete outside base. target={}", target);
            return false;
        }

        try {
            // 일반 파일만 삭제 (심볼릭 링크는 따라가지 않음)
            if (Files.isRegularFile(target, NOFOLLOW_LINKS)) {
                return Files.deleteIfExists(target);
            } else {
                log.debug("Not a regular file (or not exists): {}", target);
                return false;
            }
        } catch (Exception e) {
            log.error("deleteFile failed. target={}", target, e);
            return false;
        }
    }

    private static String stripLeadingSlashes(String p) {
        if (p == null) return "";
        while (p.startsWith("/") || p.startsWith("\\")) {
            p = p.substring(1);
        }
        return p;
    }
}
