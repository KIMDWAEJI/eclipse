package kr.board.controller;

import java.io.File;
import java.io.IOException;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.oreilly.servlet.MultipartRequest;
import com.oreilly.servlet.multipart.DefaultFileRenamePolicy;

import kr.board.entity.Member;
import kr.board.mapper.MemberMapper;

@Controller
public class MemberController {

	@Autowired
	MemberMapper memberMapper;
	
	@RequestMapping("/memJoin.do")
	public String memJoin() {
		
		return "member/memJoin";
	}
	
	// 아이디 중복확인
	@RequestMapping("/memRegisterCheck.do")
	public @ResponseBody int memRegisterCheck(@RequestParam("memID") String memID) {
		Member m = memberMapper.registerCheck(memID);
		if(m != null || memID.equals("")) {
			return 0;	// 중복존재, 사용불가
		}
		return 1;	// 사용가능
	}
	
	// 회원가입 처리
	@RequestMapping("/memRegister.do")
	public String memRegister(Member m, String memPW01, String memPW02, RedirectAttributes rttr, HttpSession session) {
		
		if(m.getMemID() == null || m.getMemID().equals("") ||
			memPW01 == null || memPW01.equals("") ||
			memPW02 == null || memPW02.equals("") ||
			m.getMemName() == null || m.getMemName().equals("") ||
			m.getMemAge() == 0 || m.getMemName().equals("") ||
			m.getMemGender() == null || m.getMemGender().equals("") ||
			m.getMemEmail() == null || m.getMemEmail().equals("")	) {
			
			// 누락 메시지를 가지고 감, RedirectAttributes(redirect 객체 전달) => 객체 바인딩 (Model, HttpServletRequest, HttpSession)
			rttr.addFlashAttribute("msgType", "실패 메시지");
			rttr.addFlashAttribute("msg", "모든 정보를 입력해주세요.");
			
			return "redirect:/memJoin.do";	// ${msgType}, ${msg}
		}
		
		if(!memPW01.equals(memPW02)) {
			rttr.addFlashAttribute("msgType", "실패 메시지");
			rttr.addFlashAttribute("msg", "비밀번호를 확인해주세요.");
			
			return "redirect:/memJoin.do";
		}
		
		m.setMemProfile("");	// 프로필 사진 X
		// 회원을 테이블에 저장
		int result = memberMapper.register(m);
		if(result==1) {
			//회원가입 성공 메시지
			rttr.addFlashAttribute("msgType", "성공 메시지");
			rttr.addFlashAttribute("msg", "회원가입이 완료되었습니다.");
			
			// 회원가입 성공 시 자동 로그인
			session.setAttribute("mvo", m);	// ${empty m}
			
			return "redirect:/";
		} else {
			rttr.addFlashAttribute("msgType", "실패 메시지");
			rttr.addFlashAttribute("msg", "이미 가입되어있습니다.");
			
			return "redirect:/memJoin.do";
		}
	}
	
	// 로그아웃 처리
	@RequestMapping("/memLogout.do")
	public String memLogout(HttpSession session) {
		session.invalidate();
		
		return "redirect:/";
	}
	
	//로그인 화면으로 이동
	@RequestMapping("/memLoginForm.do")
	public String memLoginForm() {
		return "member/memLoginForm";
	}
	
	// 로그인 기능 구현
	@RequestMapping("/memLogin.do")
	public String memLogin(Member m, RedirectAttributes rttr, HttpSession session) {
		if(m.getMemID() == null || m.getMemID().equals("") ||
			m.getMemPW() == null || m.getMemPW().equals("")) {
				rttr.addFlashAttribute("msgType", "실패 메시지");
				rttr.addFlashAttribute("msg", "아이디 혹은 비밀번호가 입력되지 않았습니다.");
				
				return "redirect:/memLoginForm.do";
		}
		
		Member mvo = memberMapper.memLogin(m);
		if(mvo != null) {
			// 로그인 성공
			rttr.addFlashAttribute("msgType", "성공 메시지");
			rttr.addFlashAttribute("msg", "로그인이 완료되었습니다.");
			session.setAttribute("mvo", mvo);	// ${!empty mvo}
			
			return "redirect:/";
		} else {
			// 로그인 실패
			rttr.addFlashAttribute("msgType", "실패 메시지");
			rttr.addFlashAttribute("msg", "아이디 혹은 비밀번호를 확인해주세요.");

			return "redirect:/memLoginForm.do";
		}
	}
	
	// 회원정보 수정 페이지
	@RequestMapping("/memUpdateForm.do")
	public String memUpdateForm() {
		
		return "member/memUpdateForm";
	}
	
	//회원정보 수정
	@RequestMapping("/memUpdate.do")
	public String memUpdate(Member m, String memPW01, String memPW02, RedirectAttributes rttr, HttpSession session) {
		if(m.getMemID() == null || m.getMemID().equals("") ||
			memPW01 == null || memPW01.equals("") ||
			memPW02 == null || memPW02.equals("") ||
			m.getMemName() == null || m.getMemName().equals("") ||
			m.getMemAge() == 0 || m.getMemName().equals("") ||
			m.getMemGender() == null || m.getMemGender().equals("") ||
			m.getMemEmail() == null || m.getMemEmail().equals("")	) {
				
			// 누락 메시지를 가지고 감, RedirectAttributes(redirect 객체 전달) => 객체 바인딩 (Model, HttpServletRequest, HttpSession)
			rttr.addFlashAttribute("msgType", "실패 메시지");
			rttr.addFlashAttribute("msg", "모든 정보를 입력해주세요.");
				
				return "redirect:/memUpdateForm.do";	// ${msgType}, ${msg}
		}
			
		if(!memPW01.equals(memPW02)) {
			rttr.addFlashAttribute("msgType", "실패 메시지");
			rttr.addFlashAttribute("msg", "비밀번호를 확인해주세요.");
				
			return "redirect:/memUpdateForm.do";
		}

		// 회원 정보 수정
		int result = memberMapper.memUpdate(m);
		if(result==1) {
			//수정 성공 메시지
			rttr.addFlashAttribute("msgType", "성공 메시지");
			rttr.addFlashAttribute("msg", "회원 정보가 수정되었습니다.");
				
			// 회원가입 성공 시 자동 로그인
			session.setAttribute("mvo", m);	// ${empty m}
				
			return "redirect:/";
		} else {
			rttr.addFlashAttribute("msgType", "실패 메시지");
			rttr.addFlashAttribute("msg", "입력하신 정보를 확인해주세요.");
			
			return "redirect:/memUpdateForm.do";
		}
	}
	
	// 프로필 사진 등록 화면
	@RequestMapping("/memImageForm.do")
	public String memImageForm() {
		
		return "member/memImageForm";
	}
	
	// 프로필 사진 등록(사진 업로드, DB저장)
	@RequestMapping("/memImageUpdate.do")
	public String memImageUpdate(HttpServletRequest request,HttpSession session, RedirectAttributes rttr) throws IOException {
		// 파일업로드 API(cos.jar)
		MultipartRequest multi=null;
		int fileMaxSize=40*1024*1024; // 10MB		
		String savePath=request.getRealPath("resources/upload");
		try {
			// 이미지 업로드
			multi=new MultipartRequest(request, savePath, fileMaxSize, "UTF-8",new DefaultFileRenamePolicy());

		} catch (Exception e) {
			e.printStackTrace();
			rttr.addFlashAttribute("msgType", "실패 메세지");
			rttr.addFlashAttribute("msg", "등록 가능한 최대 용량은 10MB 입니다.");			
			return "redirect:/memImageForm.do";
		}
		// 데이터베이스 테이블에 이미지 업데이트
		String memID=multi.getParameter("memID");
		String newProfile="";
		File file = multi.getFile("memProfile");
		if(file != null) { // 업로드가 된 상태
			// 파일의 확장자 확인
			String ext=file.getName().substring(file.getName().lastIndexOf(".")+1);
			ext=ext.toLowerCase();	// 확장자명을 소문자로 변환
			if(ext.equals("png") || ext.equals("gif") || ext.equals("jpg")){
				// 이미지 갱신
				String oldProfile=memberMapper.getMember(memID).getMemProfile();
				File oldFile = new File(savePath+"/"+oldProfile);
				if(oldFile.exists()) {
					oldFile.delete();
				}
				newProfile=file.getName();
			}else {
				// 이미지 파일이 아닐 경우 삭제
				if(file.exists()) {
					file.delete();
				}
				rttr.addFlashAttribute("msgType", "실패 메세지");
				rttr.addFlashAttribute("msg", "이미지 파일이 아닙니다.");
				
				return "redirect:/memImageForm.do";
			}
		}
		// 새로 갱신한 이미지를 테이블에 업데이트
		Member mvo=new Member();
		mvo.setMemID(memID);
		mvo.setMemProfile(newProfile);
		memberMapper.memProfileUpdate(mvo); // 이미지 업데이트 성공
		Member m=memberMapper.getMember(memID);
		// 새로운 세션 생성
		session.setAttribute("mvo", m);
		rttr.addFlashAttribute("msgType", "성공 메세지");
		rttr.addFlashAttribute("msg", "프로필 사진이 변경되었습니다.");	
		return "redirect:/";
	}
	
}