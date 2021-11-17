package com.ezen.myapp.persistence;

import java.util.ArrayList;
import java.util.HashMap;

import com.ezen.myapp.domain.BoardVo;
import com.ezen.myapp.domain.CommentVo;
import com.ezen.myapp.domain.MemberVo;
import com.ezen.myapp.domain.SearchCriteria;

public interface MemberService_Mapper {
	
	//마이바티스의 사용할 메소드를 정의한다
	
	public MemberVo memberLogin(String id, String pwd);
		

}
