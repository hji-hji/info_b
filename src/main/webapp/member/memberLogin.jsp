<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script type="text/javascript">

function check(){
	alert("test");

	var fm = document.frm;
	
	if (fm.memberid.value == ""){
		alert("아이디");
	    fm.memberid.focus();
	    return false;		
	}else if (fm.memberpwd.value ==""){
		alert("비밀번호");
		fm.memberpwd.focus();
		return false;
	}
	
	fm.action="<%=request.getContextPath()%>/member/memberLoginAction.do";
	fm.method="post";
	fm.submit();	
	return;
}
</script>
</head>
<body>
<form name="frm">
<table border=1 style="width:300px">
<tr>
<td>아이디</td>
<td>비밀번호</td>
</tr>
<tr>
<td><input type="text" name="memberid"></td>
<td><input type="password" name="memberpwd"></td>
</tr>
<tr>
<td colspan=2 style="text-align:center"><button onclick="check(); return false;">로그인</button> </td>
</tr>
</table>
</form>
</body>
</html>