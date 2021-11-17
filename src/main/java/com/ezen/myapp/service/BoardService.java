package com.ezen.myapp.service;

import java.util.ArrayList;

import com.ezen.myapp.domain.BoardVo;
import com.ezen.myapp.domain.CommentVo;
import com.ezen.myapp.domain.SearchCriteria;

public interface BoardService {
	
	
	public int boardInsert(String subject,String contents, String writer, String pwd, String ip, int midx, String fileName);

	public int boardTotalCount(SearchCriteria scri);
	
	public ArrayList<BoardVo> boardSelectAll(SearchCriteria scri);

	public BoardVo boardSelectOne(int bidx);
	
	public ArrayList<CommentVo> commentSelectAll(int bidx);

	public int commentInsert(CommentVo cv);
	
	public int commentDel(int cidx);
	
	public ArrayList<CommentVo> commentMo(int bidx, int page);
	
	public int commentTotalPage(int bidx);
	
	public int boardModify(int bidx,String subject,String contents,String writer,String pwd);
	
	public int boardDelete(int bidx, String pwd);
		
	public int boardReply(int originbidx, int depth, int nlevel, String subject, String contents, String writer,String ip,int midx,String pwd);
}
