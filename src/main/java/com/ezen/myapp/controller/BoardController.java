package com.ezen.myapp.controller;

import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;
import java.net.InetAddress;
import java.net.UnknownHostException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Locale;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.io.IOUtils;
import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.springframework.web.servlet.support.RequestContextUtils;

import com.ezen.myapp.service.BoardService;
import com.ezen.myapp.util.MediaUtils;
import com.ezen.myapp.util.UploadFileUtiles;
import com.ezen.myapp.domain.BoardVo;
import com.ezen.myapp.domain.CommentVo;
import com.ezen.myapp.domain.PageMaker;
import com.ezen.myapp.domain.SearchCriteria;


@Controller
public class BoardController  {
	
	@Autowired
	BoardService bs;
	
	//@Autowired
	//SqlSession sqlsession;
	
	@Autowired
	PageMaker pm;
	
	@Resource(name="uploadPath")
	private String uploadPath;	
	
	@RequestMapping(value="/board/boardWrite.do")
	public String boardWrite() {		
		//System.out.println("sqlsession"+sqlsession);
		return "board/boardWrite";
	}	
	
	@RequestMapping(value="/board/boardWriteAction.do")
	public String boardWriteAction(
			@RequestParam("subject") String subject,
			@RequestParam("contents") String contents,
			@RequestParam("writer") String writer,
			@RequestParam("pwd") String pwd,
			@RequestParam("uploadfile") String uploadfile
			) {		
		String ip= null;
		try {
			ip = InetAddress.getLocalHost().getHostAddress();
		} catch (UnknownHostException e) {			
			e.printStackTrace();
		}
		int midx = 1;
		
		int result = bs.boardInsert(subject, contents, writer, pwd, ip, midx, uploadfile);
				
		return "redirect:/board/boardList.do";
	}
	
	@RequestMapping(value="/board/boardList.do")
	public String boardList(SearchCriteria scri, Model model) {
		
		// serviceimpl 처리
		// 전체 개수를 뽑아내고
		// 전체리스트 뽑아내고
		// 페이지 메이커에 담고
		// Model에 담아서 화면에 넘긴다
	int cnt = bs.boardTotalCount(scri);
	System.out.println("cnt"+cnt);
	ArrayList<BoardVo> alist = 	bs.boardSelectAll(scri);
	System.out.println("alist"+alist);	
	
	pm.setScri(scri);
	pm.setTotalCount(cnt);
	
	model.addAttribute("alist", alist);
	model.addAttribute("pm", pm);
		
	return "board/boardList";
	}
	
	@RequestMapping(value="/board/boardContents.do")
	public String boardContents(
			@RequestParam("bidx") int bidx,		
			Model model) {		
		
		//bidx를 넘겨주고 한행의 데이터를 가져오기
		BoardVo bv = bs.boardSelectOne(bidx);
		//모델에 담아가지고 화면으로 넘겨준다
		model.addAttribute("bv", bv);
	
		
		return "board/boardContents";
	}
	
	@RequestMapping(value="/board/boardModify.do")
	public String boardModify(
			@RequestParam("bidx") int bidx, 
			Model model) {
		
		//boardService에 있는 메소드 호출
		BoardVo bv = bs.boardSelectOne(bidx);
		model.addAttribute("bv", bv);		
		
		return "board/boardModify";
	}
	
	@RequestMapping(value="/board/boardModifyAction.do")
	public String boardModifyAction(
			@RequestParam("bidx") int bidx,
			@RequestParam("subject") String subject,
			@RequestParam("contents") String contents,
			@RequestParam("writer") String writer,
			@RequestParam("pwd") String pwd,
			RedirectAttributes rttr
			) {
		
			//메소드 호출한다
		int value = bs.boardModify(bidx, subject, contents, writer, pwd);
		
		String movelocation = null;
		if (value ==0) {			
			movelocation = "redirect:/board/boardModify.do?bidx="+bidx;			
		}else {
			rttr.addFlashAttribute("msg", "수정되었습니다.");
			movelocation = "redirect:/board/boardContents.do?bidx="+bidx;			
		}
		
		return movelocation;
	}
	
	@RequestMapping(value="/board/boardDelete.do")
	public String boardDelete(
			@ModelAttribute("bidx") int bidx,Model model) {
		
		//boardService에 있는 메소드 호출
		BoardVo bv = bs.boardSelectOne(bidx);
		model.addAttribute("bv", bv);		
		
		return "board/boardDelete";
	}
	
	@RequestMapping(value="/board/boardDeleteAction.do")
	public String boardDeleteAction(
			@RequestParam("bidx") int bidx,			
			@RequestParam("pwd") String pwd,
			RedirectAttributes rttr
			) {
		
			//메소드 호출한다
		int value = bs.boardDelete(bidx, pwd);
		rttr.addFlashAttribute("msg", "삭제되었습니다.");
		
		
		return "redirect:/board/boardList.do";
	}
	
	
	@RequestMapping(value="/board/boardReply.do")
	public String boardReply(BoardVo bv, Model model) {	
				
		model.addAttribute("bv", bv);
		
		return "board/boardReply";
	}	
	
	@RequestMapping(value="/board/boardReplyAction.do")
	public String boardReplyAction(BoardVo bv, Model model) {	
		
		int midx= 1;
		String ip= null;
		try {
			ip = InetAddress.getLocalHost().getHostAddress();
		} catch (UnknownHostException e) {			
			e.printStackTrace();
		}
	
		int value = bs.boardReply(bv.getOriginbidx(), bv.getDepth(), bv.getNlevel(), bv.getSubject(), bv.getContents(), bv.getWriter(),ip,midx,bv.getPwd());
		
		
		return "redirect:/board/boardList.do";
	}
	
	@ResponseBody
	@RequestMapping(value="/board/uploadAjax.do",method=RequestMethod.POST,produces="text/plain;charset=UTF-8")
	public ResponseEntity<String> uploadAjax(MultipartFile file) throws Exception{
		
		System.out.println("원본이름:"+file.getOriginalFilename());		
	
		String uploadedFileName = UploadFileUtiles.uploadFile(uploadPath, 
				file.getOriginalFilename(), 
				file.getBytes());
		
		
		ResponseEntity<String> entity = null;
		entity = new ResponseEntity<String>(uploadedFileName,HttpStatus.CREATED);
		
		//  /2018/05/30/s-dfsdfsdf-dsfsff.jsp
		return entity;
	}
	
	@ResponseBody
	@RequestMapping(value="/board/displayFile.do", method=RequestMethod.GET)
	public ResponseEntity<byte[]> displayFile(String fileName) throws Exception{
		
	//	System.out.println("fileName:"+fileName);
		
		InputStream in = null;		
		ResponseEntity<byte[]> entity = null;
		
	//	logger.info("FILE NAME :"+fileName);
		
		try{
			String formatName = fileName.substring(fileName.lastIndexOf(".")+1);
			MediaType mType = MediaUtils.getMediaType(formatName);
			
			HttpHeaders headers = new HttpHeaders();		
			 
			in = new FileInputStream(uploadPath+fileName);
			
			
			if(mType != null){
				headers.setContentType(mType);
			}else{
				
				fileName = fileName.substring(fileName.indexOf("_")+1);
				headers.setContentType(MediaType.APPLICATION_OCTET_STREAM);
				headers.add("Content-Disposition", "attachment; filename=\""+
						new String(fileName.getBytes("UTF-8"),"ISO-8859-1")+"\"");				
			}
			entity = new ResponseEntity<byte[]>(IOUtils.toByteArray(in),
					headers,
					HttpStatus.CREATED);
			
		}catch(Exception e){
			e.printStackTrace();
			entity = new ResponseEntity<byte[]>(HttpStatus.BAD_REQUEST);
		}finally{
			in.close();
		}
		return entity;
	} 
	
	
//	@RequestMapping(value="/board/commentsAll.do")
//	@ResponseBody
//	public ArrayList<CommentVo> commentAll(@RequestParam("bidx") int bidx) {
//		
//		ArrayList<CommentVo> clist = null;
//		clist = bs.commentSelectAll(bidx);
//		
//		
//		return clist;
//	}
//	
//	@ResponseBody
//	@RequestMapping(value="/board/comments.do")
//	public HashMap<String,Integer> commentWrite(CommentVo cv) {
//		int value= 0;
//		
//		value = bs.commentInsert(cv);
//		
//		HashMap<String,Integer> hm = new HashMap<String,Integer>();
//		hm.put("result", value);
//		
//		return hm;
//	}
//	
//	@ResponseBody   // 리턴값으로 객체를 가진다
//	@RequestMapping(value="/board/{cidx}/commentDelete.do")
//	public HashMap<String,Integer> commentDelete(@PathVariable("cidx") int cidx) {
//		int value=0;	
//		System.out.println("cidx:"+cidx);
//						
//		value = bs.commentDel(cidx);		
//		
//		//해시맵을 사용해서 객체를 반환 
//		HashMap<String,Integer> hm = new HashMap<String,Integer>();
//		hm.put("result", value);
//		
//		return hm;
//	}
//	
//	@ResponseBody
//	@RequestMapping(value="/board/{bidx}/{page}/commentMore.do")
//	public HashMap<String,Object> commentMore(@PathVariable("bidx") int bidx, @PathVariable("page") int page){
//		int nextpage = 0;
//		ArrayList<CommentVo> clist = null;
//		
//		int commentTotalPage = bs.commentTotalPage(bidx);
//		if (page < commentTotalPage) {
//	        nextpage = page+1;
//	    }else {
//	        nextpage = 9999;
//	    }	     
//		clist = bs.commentMo(bidx, page);
//				
//		HashMap<String,Object> hm = new HashMap<String,Object>();
//        hm.put("nextpage", nextpage);
//        hm.put("ja", clist);
//		
//        return hm;
//	}
	
	
	
	
	
}
