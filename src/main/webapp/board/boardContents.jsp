<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.ezen.myapp.domain.*" %>    
<%BoardVo bv = (BoardVo)request.getAttribute("bv");%>    
  
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>${msg}</title>
<!-- jquery 3.3.1 라이브러리 활용 -->
<script src="https://code.jquery.com/jquery-3.3.1.min.js"></script>
<script type="text/javascript">
var msg = '${msg}';
if (msg){
	alert(msg);
}
</script>
<script type="text/javascript">

$(function(){

	$.boardCommentList();	

	
	$("#save").click(function(){   // 저장버튼을 클릭하면
		var c_contents = $("#c_contents").val(); 
		var c_subject = $("#c_subject").val();
		var c_writer = $("#c_writer").val();
		var bidx = "<%=bv.getBidx()%>";
		var midx = "1";
	//	alert(bidx);
		$.ajax({
			
			type : "POST",
			url :  "<%=request.getContextPath() %>/board/comments.do", 
			header :  { "Content-Type" : "application/json",
				"X-HTTP-Method-Override" : "POST" },
			dataType :  "json",
			data : {"bidx" : bidx,
					"midx" : midx,
					"c_writer" : c_writer,
					"c_subject" : c_subject,
					"c_contents" : c_contents
			},
			cache : false,
			success : function(data){
				if (data.length == 0){
			//		alert("데이터없음");
				}else {				
				//	alert("결과값은"+data.result);
					$.boardCommentList();	
					$("#c_writer").val("");
					$("#c_contents").val("");
					$("#c_subject").val("");
				}
			},
			error : function(){
				alert("에러입니다.");
			}
			
		});	
	});	
	
});
$.boardCommentList = function(){
	var str;
	var tstr="";
	$.ajax({
		type : "GET",		
		url : "<%=request.getContextPath() %>/board/commentsAll.do?bidx=<%=bv.getBidx()%>",
		contentType : "application/json;charset=UTF-8",
		dataType : "json",
		cache : false,
		error : function(){
			alert("에러입니다.111");	
		},
		success : function(data){
			if (data.length ==0){
			//	alert("데이터가 없습니다.");
			}else {
			//	alert(data.length);	
				$(data).each(function(){
					
				str = "<tr><td width=100>"+this.c_writer+"</td>"
						+"<td width=100>"+this.c_subject+"</td>"
						+"<td width=200>"+this.c_contents+"</td>"
						+"<td width=70><input type='button' name='del' id='del"+this.cidx+"' onclick='$.check("+this.cidx+");'  value='삭제'>"
						+"<input type='hidden' name='cidx' id='cidx' value='"+this.cidx+"'>"
						+"</td>"
						+"</tr>";		
				
				tstr = tstr+str;					
				});
			$("#tbl").html("<table border=1>"+tstr+"</table>");					
				
			}
		} 
	});		

}	
$.check = function(cidx){
	var cidx = cidx;
//	alert(cidx);

	$.ajax({
		url : "<%=request.getContextPath()%>/board/"+cidx+"/commentDelete.do",
		type : "get",
		dataType: "json",		
		success : function(data){
			if (data.length == 0){
				alert("데이터가 없습니다.");
			}else
			//	alert(data.result);	
				$.boardCommentList();	
		},
		error : function(){
			alert("에러입니다.");
		}			
	});
}
$.more = function(){
	   var page = $("#page").val();
	   alert(page);

	   var bidx = "<%=bv.getBidx()%>";
	   var str;
	   var tstr="";

	   $.ajax({
	      url : "<%=request.getContextPath()%>/board/"+bidx+"/"+page+"/commentMore.do",
	      type : "get",
	      dataType: "json",      
	      success : function(data){
	         if (data.length == 0){
	            alert("데이터가 없습니다.");
	         }else {
	         
	         //   alert(data.nextpage);
	            $("#page").val(data.nextpage);
	         
	            if (data.nextpage == 9999){
	               $("#more").css("display","none");
	            
	            }   	            
	      
	            $(data.ja).each(function(){
	               str = "<tr><td width=100>"+this.c_writer+"</td>"
	               +"<td width=100>"+this.c_subject+"</td>"
	               +"<td width=200>"+this.c_contents+"</td>"
	               +"<td width=70><input type='button' name='del' id='del"+this.cidx+"' onclick='$.check("+this.cidx+");'  value='삭제'>"
	               +"<input type='hidden' name='cidx' id='cidx' value='"+this.cidx+"'>"
	               +"</td>"
	               +"</tr>";      
	         
	               tstr = tstr+str;      
	               });
	            $("#tbl").html("<table border=1>"+tstr+"</table>");               
	         }            
	      },
	      error : function(){
	         alert("에러입니다.");
	      }         
	   });
	}
</script>
</head>
<body>
내용보기 화면
<table border="1" style="width:500px;">
<tr>
<td style="width:100px;">제목</td>
<td><%=bv.getSubject() %></td>
</tr>
<tr>
<td>내용</td>
<td style="height:300px;">
<a href="<%=request.getContextPath()%>/board/fileDownload.do?fileName=<%=bv.getFilename() %>"><%=bv.getFilename() %></a>

<img src='<%=request.getContextPath()%>/board/displayFile.do?fileName=<%=bv.getFilename() %>'>

<%=bv.getContents()%>

</td>
</tr>
<tr>
<td>작성자</td>
<td><%=bv.getWriter() %></td>
</tr>
</table>
<table  style="width:500px;text-align:right">
<tr>
<td>
<button class="btn" onclick="document.location.href='<%=request.getContextPath()%>/board/boardModify.do?bidx=<%=bv.getBidx()%>' ">수정</button>
<button class="btn" onclick="document.location.href='<%=request.getContextPath()%>/board/boardDelete.do?bidx=<%=bv.getBidx()%>' ">삭제</button>
<button class="btn" onclick="document.location.href='<%=request.getContextPath()%>/board/boardReply.do?bidx=<%=bv.getBidx()%>&originbidx=<%=bv.getOriginbidx()%>&depth=<%=bv.getDepth()%>&nlevel=<%=bv.getNlevel()%>' ">답변</button>
<button class="btn">목록</button>
</td>
</tr>
</table>

<table>
<tr>
<td colspan=2>작성자:<input type="text" name="c_writer" id="c_writer" maxlength=10  size=10>
제   목:<input type="text" name="c_subject" id="c_subject" maxlength=10 size=10></td>
</tr>
<tr>
<td>내&nbsp;&nbsp;&nbsp;용:<textarea name="c_contents"  id="c_contents"  cols=50 rows=2> </textarea> </td>
<td><input type="button"  name="save" id="save" value="저장"></td>
</tr>
</table>
<div id="tbl"></div>
<table><tr><td>
<input type='button'  name='more'  id='more'  value='더보기'  onclick='$.more();'>
<input type="hidden" name="page"  id ="page"  value="2">

</td></tr></table>
<br>
<br>
<br>
<br>
</body>
</html>