package egovframework.example.cmmn.util;
import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.UUID;

import javax.annotation.Resource;

import org.egovframe.rte.fdl.property.EgovPropertyService;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import org.springframework.web.multipart.MultipartFile;

@Component
public class FileUtil {
	// 파일 경로
    private final String fileStorePath;

    public FileUtil(
        @Value("#{propertiesService.getString('Globals.fileStorePath')}")
        String fileStorePath
    ) {
        this.fileStorePath = fileStorePath;
        System.out.println(">> fileStorePath = " + this.fileStorePath);
    }
    
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
     * 파일 경로를 받아 물리적인 파일을 삭제합니다.
     * @param filePath 삭제할 파일의 상대 경로 (DB에 저장된 경로)
     */
    public void deleteFile(String filePath) {
        if (filePath == null || filePath.isEmpty()) {
            return;
        }

        try {
            // DB에 저장된 상대 경로를 물리적 경로로 변환
            // 예시: /uploads/파일명.jpg -> C:/upload-dir/파일명.jpg
            Path fileToDelete = Paths.get(fileStorePath, new File(filePath).getName());
            
            // 파일이 존재하면 삭제합니다.
            if (Files.exists(fileToDelete) && !Files.isDirectory(fileToDelete)) {
                Files.delete(fileToDelete);
            }
        } catch (IOException e) {
            // 파일 삭제 중 오류가 발생해도 예외를 던지기보다 로깅만 하는 경우가 많습니다.
            // (파일이 이미 삭제되었을 수도 있기 때문)
            // 에러 로깅
            // e.printStackTrace();
        }
    }
}
