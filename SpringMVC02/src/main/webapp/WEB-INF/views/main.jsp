<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="en">

<head>
	<title>Spring MVC02</title>
	<meta charset="utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<link rel="stylesheet"
		href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">
	<script
		src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.4/jquery.min.js"></script>
	<script
		src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>
	<script type="text/javascript">
		$(document).ready(function(){
			loadList();
		});
		
		function loadList(){
			// 서버와의 통신으로 게시판 리스트 호출
			$.ajax({
/* 				url : "boardList.do", */
				url : "board/all",
				type: "get",
				dataType : "json",
				success : makeView,
				error : function(){ alert("error"); }
			});
			
			// 인서트 후 폼 저장기록 초기화
		/*	$("#title").val("");
			$("#content").val("");
			$("#writer").val("");	*/
			$("#fclear").trigger("click");
		}
		
		function makeView(data){
			var listHtml = "<table class='table table-bordered'>";
			listHtml += "<tr>";
			listHtml += "<td>번호</td>";
			listHtml += "<td>제목</td>";
			listHtml += "<td>작성자</td>";
			listHtml += "<td>작성일</td>";
			listHtml += "<td>조회수</td>";
			listHtml += "</tr>";
			$.each(data, function(index, obj){	// obj = { "idx":n, "title":"제목", ... }
				listHtml += "<tr>";				
				listHtml += "<td>"+obj.idx+"</td>";
				listHtml += "<td id='t"+obj.idx+"'><a href='javascript:goContent("+obj.idx+")'>"+obj.title+"</a></td>";
				listHtml += "<td>"+obj.writer+"</td>";
				listHtml += "<td>"+obj.indate.split(' ')[0]+"</td>";
				listHtml += "<td id='cnt"+obj.idx+"'>"+obj.count+"</td>";
				listHtml += "</tr>";
				
				listHtml += "<tr id='c"+obj.idx+"' style='display:none'>";
				listHtml += "<td>내용</td>";
				listHtml += "<td colspan='4'>";
				listHtml += "<textarea id='ta"+obj.idx+"' rows='7' class='form-control' readonly></textarea>";
				listHtml += "<br/>";
				listHtml += "<span id='ub"+obj.idx+"'><button class='btn btn-success btn-sm' onclick='goUpdateForm("+obj.idx+")'>수정</button></span>&nbsp;";
				listHtml += "<button class='btn btn-warning btn-sm' onclick='goDelete("+obj.idx+")'>삭제</button>";
				listHtml += "</td>";
				listHtml += "</tr>";
			});
			listHtml += "<tr>";
			listHtml += "<td colspan='5'>";
			listHtml += "<button class='btn btn-primary btn-sm' onclick='goForm()'>글쓰기</button>";
			listHtml += "</td>";
			listHtml += "</tr>";
			listHtml += "</table>";
			$("#view").html(listHtml);

			$("#view").css("display", "block");
			$("#wform").css("display", "none");			
		}
		
		function goForm() {
			$("#view").css("display", "none");
			$("#wform").css("display", "block");			
		}
		
		function goList() {			
			$("#view").css("display", "block");
			$("#wform").css("display", "none");			
		}
		
		function goInsert() {
			var fData = $("#frm").serialize();
		//	alert(fData);
		$.ajax({
/* 			url : "boardInsert.do", */
			url : "board/new",
			type : "post",
 			data : fData,
			success : loadList,
			error : function() { alert("error"); }
		});
			
		/*	var title = $("title").val();
			var content = $("content").val();
			var writer = $("writer").val();	*/
		}
		
		function goContent(idx) {
			if($("#c"+idx).css("display")=="none") {
				
				// 상세보기
				$.ajax({
/* 					url : "boardContent.do", */
					url : "board/"+idx,
					type : "get",
/* 					data : { "idx":idx }, */
					dataType : "json",
					success : function(data) {
						$("#ta"+idx).val(data.content);
					},
					error : function() { alert("error"); }
				});
				
				$("#c"+idx).css("display", "table-row");
				$("#ta"+idx).attr("readonly", true);
				
				// 조회수
				$.ajax({
					url : "board/count/"+idx,
/* 					type : "get", */
					type : "put",
/* 					data : { "idx":idx }, */
					dataType : "json",
					success : function(data) {
						$("#cnt"+idx).text(data.count);
					},
					error : function() { alert("error"); }
				});
				
			} else {				
				$("#c"+idx).css("display", "none");
			}
		}
		
		function goDelete(idx) {
			$.ajax({
/* 				url : "boardDelete.do", */
				url : "board/"+idx,
/* 				type : "get", */
				type : "delete",
/* 				data : { "idx":idx }, */
				success : loadList,
				error : function() { alert("error"); }
			});
		}
		
		function goUpdateForm(idx) {
			$("#ta"+idx).attr("readonly", false);
			
			var title = $("#t"+idx).text();
			var newInput="<input type='text' id='nt"+idx+"' class='form-control' value='"+title+"'/>";
			$("#t"+idx).html(newInput);
			
			var newButton="<button class='btn btn-info btn-sm' onclick='goUpdate("+idx+")'>완료</button>";
			$("#ub"+idx).html(newButton);
		}
		
		function goUpdate(idx) {
			var title = $("#nt"+idx).val();
			var content = $("#ta"+idx).val();
			$.ajax({
/* 				url : "boardUpdate.do", */
				url : "board/update",
/* 				type : "post", */
				type : "put",
				contentType : 'application/json;charset=utf-8',
 				data : JSON.stringify({ "idx":idx, "title":title, "content":content }),
				success : loadList,
				error : function() { alert("error"); }
			});
		}
		
	</script>
</head>

<body>

	<div class="container">
		<h2>Spring MVC02</h2>
		<div class="panel panel-default">
			<div class="panel-heading">Board</div>
			<div class="panel-body" id="view">Panel Content</div>
			<div class="panel-body" id="wform" style="display: none">
				<form id="frm">
					<table class="table">
						<tr>
							<td>제목</td>
							<td><input type="text" id="title" name="title" class="form-control" /></td>
						</tr>
						<tr>
							<td>내용</td>
							<td><textarea rows="7" id="content" name="content" class="form-control"></textarea></td>
						</tr>
						<tr>
							<td>작성자</td>
							<td><input type="text" id="writer" name="writer" class="form-control" /></td>
						</tr>
						<tr>
							<td colspan="2" align="center">
								<button type="button" class="btn btn-success btn-sm" onclick="goInsert()">등록</button>
								<button type="reset" id="fclear" class="btn btn-warning btn-sm">취소</button>
								<button type="button" class="btn btn-info btn-sm" onclick="goList()">목록</button>
							</td>
						</tr>						
					</table>
				</form>
			</div>
			<div class="panel-footer">Panel Footer</div>
		</div>
	</div>

</body>

</html>
