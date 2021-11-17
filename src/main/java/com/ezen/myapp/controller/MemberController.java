package com.ezen.myapp.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.ezen.myapp.domain.MemberVo;
import com.ezen.myapp.service.MemberService;

@Controller
public class MemberController {
	
	@Autowired
	MemberService ms;
	
	
	@RequestMapping(value="/member/memberLogin.do")
	public String memberLogin() {				
		
		return "member/memberLogin";
	}
	
	
	@RequestMapping(value="/member/memberLoginAction.do")
	public String memberLoginAction(
			@RequestParam("memberid") String memberid,
			@RequestParam("memberpwd") String memberpwd,
			Model model) {
		
		MemberVo mv = ms.memberLogin(memberid, memberpwd);
	//	System.out.println("id:"+mv.getMemberid());
				
		String path =null;
		if (mv == null) {
			path = "redirect:/member/memberLogin.do";
		}else {
			model.addAttribute("memberId", mv.getMemberid());
			
		//	HttpSession session = request.getSession();
		//	session.setAttribute("id", mv.getMemberid());
			path ="redirect:/board/boardList.do";
		}
		return path;
	}
	
	
	
}
