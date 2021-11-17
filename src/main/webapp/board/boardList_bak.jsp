<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.ArrayList" %> 
<%@ page import ="com.ezen.myapp.domain.*" %>   
<%ArrayList<BoardVo> alist = (ArrayList<BoardVo>) request.getAttribute("alist"); %>    
 <%PageMaker pm  = (PageMaker)request.getAttribute("pm"); %>   
    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>${msg}</title>
<script type="text/javascript">
var msg = '${msg}';
if (msg){
	alert(msg);	
}
</script>
</head>
<body>
게시판 리스트 입니다.
<form name="frm" action="<%=request.getContextPath() %>/board/boardList.do" method="post">
<table  style="width:300px;">
<tr>
<td>
<select name="searchType">
<option value="subject">제목</option>
<option value="writer">작성자</option>
</select></td>
<td>
<input type="text" name="keyword" size="10">
</td>
<td><input type="submit" name="submit" value="검색" ></td>
</tr>
</table>
</form>

<table border=1>
<tr>
<td>게시물번호</td>
<td>제목</td>
<td>작성자</td>
<td>날짜</td>
</tr>
<% for(BoardVo bv : alist) { %>
<tr>
<td><%=bv.getBidx() %></td>
<td>
<%
for(int i=1;i<=bv.getNlevel();i++){
	out.print("&nbsp;&nbsp;");
	if(i == bv.getNlevel()){
		out.print("ㄴ");
	}
}

%>
<a href="<%=request.getContextPath()%>/board/boardContents.do?bidx=<%=bv.getBidx()%>"><%=bv.getSubject() %></a>


</td>
<td><%=bv.getWriter() %></td>
<td><%=bv.getWriteday() %></td>
</tr>
<%} %>
</table>
<table  style="width:400px;Text-align:center">
<tr>
<td>
<% if (pm.isPrev() == true){%>
<a href="<%=request.getContextPath()%>/board/boardList.do?page=<%=pm.getStartPage()-1 %>&keyword=<%=pm.encoding(pm.getScri().getKeyword())%>">이전</a>
<%} %>
</td>
<td>
<% for (int i =pm.getStartPage(); i<=pm.getEndPage(); i++){%>
<a href="<%=request.getContextPath()%>/board/boardList.do?page=<%=i%>&keyword=<%=pm.encoding(pm.getScri().getKeyword())%>"><%=i %></a>
<% } %>

</td>
<td>
<%if (pm.isNext() && pm.getEndPage() >0) {%>
<a href="<%=request.getContextPath()%>/board/boardList.do?page=<%=pm.getEndPage()+1 %>&keyword=<%=pm.encoding(pm.getScri().getKeyword())%>">다음</a>

<%} %>
</td>
</tr>
</table>
<a href="<%=request.getContextPath() %>/board/boardWrite.do">글쓰기</a>








</body>
</html>