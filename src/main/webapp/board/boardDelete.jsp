<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.ezen.myapp.domain.*" %>    
<%BoardVo bv = (BoardVo)request.getAttribute("bv");%>
<%int bidx = (int)request.getAttribute("bidx");%>  
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script type="text/javascript">
function check(){
	var fm = document.frm;
	
	if (fm.pwd.value == ""){
		alert("비밀번호를 입력하세요");
		fm.pwd.focus();
		return false;
	}
	
	fm.action="<%=request.getContextPath()%>/board/boardDeleteAction.do";
	fm.method="post";
	fm.submit();
	
	return;
}
</script>
</head>
<body>
<form name="frm">
<table border=1 style="width:500px">
<input type="hidden" name="bidx" value="<%=bidx%>">
<tr>
<td>제목</td>
<td><%=bv.getSubject()%></td>
</tr>
<tr>
<td>비밀번호</td>
<td><input type="password" name="pwd"></td>
</tr>
<tr>
<td colspan=2>
<button name="btn1" onclick="check();return false;">확인</button>
<button name="btn2" onclick="reset();">리셋</button>
</td>
</tr>
</table>
</form>
</body>
</html>