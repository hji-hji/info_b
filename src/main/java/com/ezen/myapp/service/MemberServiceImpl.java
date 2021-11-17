package com.ezen.myapp.service;

import java.util.ArrayList;
import java.util.HashMap;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.ezen.myapp.domain.BoardVo;
import com.ezen.myapp.domain.CommentVo;
import com.ezen.myapp.domain.MemberVo;
import com.ezen.myapp.domain.SearchCriteria;
import com.ezen.myapp.persistence.BoardService_Mapper;
import com.ezen.myapp.persistence.MemberService_Mapper;

@Service("memberServiceImpl")
public class MemberServiceImpl implements MemberService  {

	@Autowired
	SqlSession sqlSession;

	@Override
	public MemberVo memberLogin(String id, String pwd) {
		
		MemberService_Mapper msm = sqlSession.getMapper(MemberService_Mapper.class);
		MemberVo mv = msm.memberLogin(id, pwd);
		
		
		return mv;
	}
	
	



}
