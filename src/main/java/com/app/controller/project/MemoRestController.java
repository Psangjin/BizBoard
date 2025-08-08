package com.app.controller.project;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.app.dto.project.Memo;
import com.app.service.project.MemoService;

@RestController
@RequestMapping("/memo")
public class MemoRestController {

    @Autowired
    private MemoService memoService;

    // ✅ 메모 생성
    @PostMapping("/create")
    public ResponseEntity<Void> create(@RequestBody Memo memo) {
        System.out.println("✅ [create] memo: " + memo);
        memoService.insertMemo(memo);
        return ResponseEntity.ok().build();
    }

    // ✅ 메모 수정
    @PostMapping("/update")
    public ResponseEntity<Void> update(@RequestBody Memo memo) {
        System.out.println("✅ [update] memo: " + memo);
        memoService.updateMemo(memo);
        return ResponseEntity.ok().build();
    }

    @PostMapping("/delete")
    public ResponseEntity<String> delete(@RequestBody Map<String, Object> payload) {
        Object rawIdObj = payload.get("id");
        System.out.println("🔔 [POST delete] 전달된 rawId = " + rawIdObj);

        if (rawIdObj == null) {
            return ResponseEntity.badRequest().body("❌ ID가 전송되지 않았습니다.");
        }

        Long id;
        try {
            id = Long.parseLong(rawIdObj.toString().trim());
        } catch (NumberFormatException e) {
            System.out.println("❌ ID 파싱 실패: " + e.getMessage());
            return ResponseEntity.badRequest().body("❌ ID 형식이 올바르지 않습니다.");
        }

        System.out.println("🗑️ 삭제할 ID: " + id);
        memoService.deleteMemo(id);
        return ResponseEntity.ok("✅ 삭제 성공 (id = " + id + ")");
    }


    // ✅ 프로젝트별 메모 목록 조회
    @GetMapping("/list")
    public List<Memo> getMemoList(@RequestParam Long projectId) {
        System.out.println("📥 [list] projectId = " + projectId);
        return memoService.getMemosByProjectId(projectId);
    }
}
