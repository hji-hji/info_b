<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
 <!-- jQuery 3.3.1 -->
    <script src="https://code.jquery.com/jquery-3.3.1.min.js"></script>
    
<style>
.fileDrop {
width: 100%;
height:200px;
border:1px dotted blue;
}

small {
margin-left:3px;
font-weight:bold;
color:gray;
}
</style>
<script type="text/javascript">
function check(){
	var fm = document.frm;
	
	if (fm.subject.value == ""){
		alert("제목을 입력하세요");
		fm.subject.focus();
		return false;
	}else if (fm.contents.value == ""){
		alert("내용을 입력하세요");
		fm.contents.focus();
		return false;
	}else if (fm.writer.value == ""){
		alert("작성자를 입력하세요");
		fm.writer.focus();
		return false;
	}else if (fm.pwd.value == ""){
		alert("비번을 입력하세요");
		fm.pwd.focus();
		return false;
	}	
	
	fm.action="<%=request.getContextPath()%>/board/boardWriteAction.do";
	fm.method="post";
//	fm.enctype="multipart/form-data"
	fm.submit();
	
	return;
}


function addFilePath(msg){
	alert(msg);	
}

function checkImageType(fileName){
	
	var pattern = /jpg$|gif$|png$|jpeg$/i;
	alert(fileName.match(pattern));
	
	return fileName.match(pattern);
}

function getOriginalName(fileName){
//	alert(fileName);
	//이미지파일이면 원본이름 안쓴다
	if (checkImageType(fileName)) {
		return;
	}
	
	var idx = fileName.lastIndexOf("_")+1;
	
	alert(idx);
	return fileName.substr(idx);
}

//파일이 이미지일경우
function getImageLink(fileName){
	if (!checkImageType(fileName)) {
		return;
	}
	//위치 폴더뽑기
	var front = fileName.substr(0,12);
	//파일이름뽑기
	//_는 빼고
	var end = fileName.substr(14);
	
	return front+end;	
}
</script>
<script>
$(document).ready(function(){
	
	$(".fileDrop").on("dragenter dragover",function(event){
	
		event.preventDefault();		
	});
	
	$(".fileDrop").on("drop",function(event){
		
		event.preventDefault();
		
		var files = event.originalEvent.dataTransfer.files;
		var file = files[0];
		
		var formData = new FormData();
		
		formData.append("file",file);
	//	alert("file"+file);
		
		$.ajax({
			url:'<%=request.getContextPath()%>/board/uploadAjax.do',
			data: formData,
			dataType:'text',
			processData:false,
			contentType:false,
			type:'POST',
			error: function(){
				alert("에러입니다.");
			},
			success : function(data){
				
				//  /2018/05/30/s-sdsdsd-ssd22q.jpg
				alert(data);
			
				// input--> sdsdsd-ssd22q.jpg
				$("#uploadfile").val(data.replace("s-",""));		
				
				var str ="";
				
				if(checkImageType(data)){
					str ="<div>"
					+ "<a href='<%=request.getContextPath()%>/board/displayFile.do?fileName="+getImageLink(data)+"'>"
					+ "<img src='<%=request.getContextPath()%>/board/displayFile.do?fileName="+data+"' />"
					+ getImageLink(data) 
					+ "</a>"
					+ "</div>";
				}else{
					str = "<div>"
						+ "<a href='<%=request.getContextPath()%>/board/displayFile.do?fileName="+data+"'>"
						+ getOriginalName(data) 
						+ "</a>"
						+ "</div>";
				}
				
				$(".uploadedList").append(str);
				
			}		
			
		});	
		
	});	
	
});


</script>
</head>
<body>
<form name="frm">
<table border=1 style="width:500px">
<tr>
<td>제목</td>
<td><input type="text" name="subject"></td>
</tr>
<tr>
<td>내용</td>
<td><textarea name="contents"></textarea></td>
</tr>
<tr>
<td>작성자</td>
<td><input type="text" name="writer"></td>
</tr>
<tr>
<td>비밀번호</td>
<td><input type="password" name="pwd"></td>
</tr>
<tr>
<td>파일</td>
<td><input type="hidden" id ="uploadfile" name="uploadfile"></td>
</tr>


<tr>
<td colspan=2>
<button name="btn1" onclick="check();return false;">확인</button>
<button name="btn2" onclick="reset();">리셋</button>
</td>
</tr>
</table>
</form>
<div class="fileDrop"></div>
<div class="uploadedList"></div>
</body>
</html>